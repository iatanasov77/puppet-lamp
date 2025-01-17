class vs_lamp::apache (
    String $apacheVersion  = 'installed',   # Latest Version
    Array $apacheModules,
) {
	class { 'apache':
        package_ensure  => "${apacheVersion}",
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}
    
	# Apache modules
	$apacheModules.each |String $value| {
		notice( "APACHE MODULE: ${value}" )
		if ( "${value}" == "ssl" ) {
			class { "apache::mod::${value}": }
			
			file { '/usr/local/bin/OpenSsl_SelfSignedCertificate.sh':
                ensure  => 'present',
                mode    => '0777',
                content => template( 'vs_lamp/OpenSsl_SelfSignedCertificate.sh.erb' ),
                require => Class["apache::mod::${value}"]
            } ->
			exec { "OpenSsl_SelfSignedCertificate":
				command	=> '/usr/local/bin/OpenSsl_SelfSignedCertificate.sh',
				require	=> Class["apache::mod::${value}"]
			}
			
			# From Module: https://github.com/heini/puppet-wait-for
			#####################################################################
			$query	= '[ -f /etc/pki/tls/certs/apache-selfsigned.crt ] && echo "SelfSignedCertificate Found" || echo "Not found"'
			wait_for { 'OpenSsl_SelfSignedCertificate':
				query             => $query,
				regex             => 'SelfSignedCertificate Found',
				polling_frequency => 5,  # Wait up to 2 minutes (24 * 5 seconds).
				max_retries       => 24,
				refreshonly       => true,
			}
		} elsif ( "${value}" == "wsgi" and defined( 'vs_django::dependencies') ) {
			if ( $operatingsystem == 'CentOS' or $operatingsystem == 'AlmaLinux' ) {
				$packageName	= 'python3-mod_wsgi'
				$modPath		= '/etc/httpd/modules/mod_wsgi_python3.so'
				
				class { "apache::mod::${value}":
					package_name	=> $packageName,
					mod_path		=> $modPath,
					
					# Ne stava s 'require' kogato e zabranen django ot konfiga, no is sas chaining arrows ne stava
					#require     	=> Class['vs_django::dependencies'],
				}
			} else {
				class { "apache::mod::${value}": }
			}
		
        } else {
        	class { "apache::mod::${value}": }
        }
    }
}
