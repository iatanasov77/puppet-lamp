define vs_lamp::apache_vhost (
    String $hostName,
    String $documentRoot,
    $customFragment             = undef,
    Boolean $needRewriteRules   = false,
    Array $aliases              = [],
    Array $directories          = [],
    String $logLevel            = 'debug',
) {

    apache::vhost { "${hostName}":
        serveraliases   => [
            "www.${hostName}",
        ],
        
        port            => '80',
        serveradmin     => "webmaster@${hostName}",
        docroot         => "${documentRoot}", 
        override        => 'all',
        
        aliases         => $aliases,
        directories     => $directories + [
            {
                'path'              => "${documentRoot}",
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
                'rewrites'          => vs_devenv::apache_rewrite_rules( $needRewriteRules )
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
