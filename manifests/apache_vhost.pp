define vs_lamp::apache_vhost (
    String $hostName,
    String $documentRoot,
    $customFragment             = undef,
    Boolean $needRewriteRules   = false,
    Array $aliases              = [],
    Array $directories          = [],
    String $logLevel            = 'debug',
    Boolean $ssl				= false,
) {

	# Check for file don't work
	#$certExists = find_file( '/etc/pki/tls/certs/apache-selfsigned.crt' )
	if ( $ssl ) {	#  and $certExists
		apache::vhost { "${hostName}_ssl":
			servername 		=> "${hostName}",
	        serveraliases   => [
	            "www.${hostName}",
	        ],
	        
	        port            => '443',
	        ssl				=> true,
	        ssl_cert 		=> '/etc/pki/tls/certs/apache-selfsigned.crt',
  			ssl_key  		=> '/etc/pki/tls/private/apache-selfsigned.key',
	        
	        serveradmin     => "webmaster@${hostName}",
	        docroot         => "${documentRoot}", 
	        override        => 'all',
	        
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
