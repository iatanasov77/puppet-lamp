
class vs_lamp::php (
    String $phpVersion,
    Boolean $phpManageRepos,
    Boolean $phpunit	= false,
    Hash $phpModules	= {},
    Hash $phpSettings	= {},
) {
	if ( $phpVersion ) {
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
