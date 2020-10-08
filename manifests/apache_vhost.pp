class vs_lamp::apache_vhost (
    String $hostName,
    String $documentRoot,
    String $fpmSocket           = '',
    Boolean $needRewriteRules   = false,
    Array $aliases              = [],
) {

    $directories    = [
        {
            path            => "${documentRoot}",
            allow_override  => ['All'],
            'Require'       => 'all granted',
            rewrites        => vs_devenv::apache_rewrite_rules( $needRewriteRules )
        }
    ]
    
    $aliases.each|Hash $alias| {
        $directories << {
            'path'              => $alias['path'],
            'allow_override'    => ['All'],
            'Require'           => 'all granted',
        }
    }
    
    apache::vhost { "${hostName}":
        serveraliases   => [
            "www.${hostName}",
        ],
        
        port            => '80',
        serveradmin     => "webmaster@${hostName}",
        docroot         => "${documentRoot}", 
        override        => 'all',
        
        aliases         => $aliases,
        directories     => $directories,
        
        custom_fragment => vs_lamp::apache_vhost_fpm_proxy( $fpmSocket ),
        
        log_level       => 'debug',
    }
    
    # Create cache/log dir
    file { "/var/www/${hostName}":
        ensure => 'directory',
        owner  => 'apache',
        group  => 'root',
        mode   => '0777',
    }
}
