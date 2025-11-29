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
            }
		} elsif ( "${value}" == "wsgi" and defined( 'vs_django::dependencies') ) {
			if ( $facts['os']['name'] == 'CentOS' or $facts['os']['name'] == 'AlmaLinux' ) {
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
