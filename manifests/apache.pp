class vs_lamp::apache (
    Array $apacheModules,
    String $phpVersion,
) {
	class { 'apache':
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}
    
	# Apache modules
	$apacheModules.each |String $value| {
		notice( "APACHE MODULE: ${value}" )
		if ( "${value}" == "ssl" ) {
			class { "apache::mod::${value}": }
			
			########################################################################
			# Generate a Default SelfSigned Certificate to use from Dev Sites
			# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/pki/tls/private/apache-selfsigned.key -out /etc/pki/tls/certs/apache-selfsigned.crt
			# Example Values:
			########################################################################
			# Country Name (2 letter code) [XX]:BG
			# State or Province Name (full name) []:Sofia
			# Locality Name (eg, city) [Default City]:Sofia
			# Organization Name (eg, company) [Default Company Ltd]:VankoSoft
			# Organizational Unit Name (eg, section) []:Developement
			# Common Name (eg, your name or your server's hostname) []:myprojects.lh
			# Email Address []:i.atanasov77@gmail.com
			$command	= 'openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
							-keyout /etc/pki/tls/private/apache-selfsigned.key \
							-out /etc/pki/tls/certs/apache-selfsigned.crt \
							-subj "/C=BG/ST=Sofia/L=Sofia /O=VankoSoft/OU=Developement/CN=myprojects.lh/emailAddress=i.atanasov77@gmail.com"'
			
			exec { "OpenSsl_SelfSignedCertificate":
				command	=> $command,
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
        } else {
        	class { "apache::mod::${value}": }
        }
    }
    
    # mod_php
    class {'::apache::mod::php':
        php_version  => "${phpVersion}",
        path         => "modules/libphp${phpVersion}.so",
    }
}
