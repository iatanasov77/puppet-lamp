define vs_lamp::apache_vhost (
    String $hostName,
    String $documentRoot,
    $customFragment             = undef,
    Boolean $needRewriteRules   = false,
    Array $aliases              = [],
    Array $directories          = [],
    String $logLevel            = 'debug',
    Boolean $ssl				= false,
    String $sslHost             = 'myprojects.lh',
) {
    if ( $ssl ) {
        $certKey    = "/etc/pki/tls/private/${sslHost}.key"
        $certFile   = "/etc/pki/tls/certs/${sslHost}.crt"
        
        vs_lamp::create_ssl_certificate{ "CreateSelfSignedCertificate_${hostName}":
            hostName    => $hostName,
            sslHost     => $sslHost,
        } ->
		
		apache::vhost { "${hostName}_ssl":
			servername 		=> "${hostName}",
	        serveraliases   => [
	            "www.${hostName}",
	        ],
	        
	        port            => 443,
	        ssl				=> true,
	        ssl_cert 		=> "${certFile}",
  			ssl_key  		=> "${certKey}",
	        
	        serveradmin     => "webmaster@${hostName}",
	        docroot         => "${documentRoot}", 
	        override        => ['All'],
	        
	        aliases         => $aliases,
	        directories     => $directories + [
	            {
	                'path'              => "${documentRoot}",
	                'allow_override'    => ['All'],
	                'Require'           => 'all granted',
	                'rewrites'          => vs_lamp::apache_rewrite_rules( $needRewriteRules )
	            }
	        ],
	        
	        custom_fragment => $customFragment,
	        
	        log_level       => $logLevel,
	    }
	}
	
	apache::vhost { "${hostName}":
		servername 		=> "${hostName}",
        serveraliases   => [
            "www.${hostName}",
        ],
        
        port            => 80,
        serveradmin     => "webmaster@${hostName}",
        docroot         => "${documentRoot}", 
        override        => ['All'],
        
        aliases         => $aliases,
        directories     => $directories + [
            {
                'path'              => "${documentRoot}",
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
                'rewrites'          => vs_lamp::apache_rewrite_rules( $needRewriteRules )
            }
        ],
        
        custom_fragment => $customFragment,
        
        log_level       => $logLevel,
    }
    
    # Create cache/log dir
    file { "/var/www/${hostName}":
        ensure => 'directory',
        owner  => 'apache',
        group  => 'root',
        mode   => '0777',
    }
}
