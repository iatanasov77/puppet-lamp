
class vs_lamp::php (
    String $remiRepo    = '',
    String $phpVersion  = '7.4',
    
    
    Boolean $phpManageRepos,
    Boolean $phpunit	= false,
    Hash $phpModules	= {},
    Hash $phpSettings	= {},
) {
    if ( $phpVersion ) {
        class { 'vs_lamp::php::php_module':
            remiReleaseRpm  => $remiRepo,
            phpVersion      => $phpVersion,
            stage           => 'install-dependencies',
        }
        
        class { '::php::globals':
        	php_version		=> "${phpVersion}",
        	#config_root 	=> '/etc/php/7.0',
        }->
        class { '::php':
            manage_repos    => $phpManageRepos,
            fpm             => true,
            dev          	=> true,
            composer     	=> true,
            pear         	=> true,
            phpunit      	=> $phpunit,
            
            settings        => $phpSettings,
            
            extensions	    => $phpModules,
        }
    } else {
        class { '::php':
            ensure          => latest,
            manage_repos    => $phpManageRepos,
            fpm             => true,
            dev             => true,
            composer        => true,
            pear            => true,
            phpunit         => $phpunit,
            
            settings        => $phpSettings,
            
            extensions      => $phpModules,
        }
	}
}
