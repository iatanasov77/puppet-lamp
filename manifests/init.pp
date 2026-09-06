class vs_lamp (
    Array $apacheModules         = [],
    String $apacheVersion        = 'installed',   # Latest Version
    
    String $remiRepo            = '',
    String $phpVersion          = '7.2',
    Hash $phpModules            = {},
    Hash $phpSettings           = {},
    Boolean $phpunit            = false,
    Boolean $phpManageRepos     = true,
    
    String $mysqllRootPassword  = 'vagrant',
    String $mySqlProvider       = 'mariadb',
    String $mysqlVersion        = '10.11',
    
    Hash $phpMyAdmin            = {},
    Hash $databases             = {},
    
    Hash $customExtensions      = {},
) {
	class { '::vs_lamp::apache':
        apacheVersion   => $apacheVersion,
        apacheModules   => $apacheModules,
    }
	
	class { '::vs_lamp::mysql':
        rootPassword    => $mysqllRootPassword,
        mySqlProvider	=> $mySqlProvider,
        mysqlVersion    => $mysqlVersion,
        databases		=> $databases,
    }
	
    class { '::vs_lamp::php':
        phpManageRepos  => $phpManageRepos,
        remiRepo        => $remiRepo,
        phpVersion      => $phpVersion,
        
        phpModules      => $phpModules,
        phpunit         => $phpunit,
        phpSettings     => $phpSettings,
    } ->
    class { '::vs_lamp::install_mod_php':
        phpVersion  => "${phpVersion}",
        require     => [ Class['vs_lamp::php'] ],
        notify      => Service['httpd'],
    }
	
	if $phpMyAdmin['source'] {
		class { '::vs_lamp::phpmyadmin':
		    source			=> $phpMyAdmin['source'],
		    targetDirName	=> $phpMyAdmin['targetDirName'],
		    require			=> [ Class['vs_lamp::apache'], Class['vs_lamp::php'], Class['vs_lamp::mysql'] ],
		}
	}
	
	class { '::vs_lamp::custom_extensions':
        customExtensions    => $customExtensions,
        require             => [
            Class['vs_lamp::php'], 
            Class['vs_lamp::apache']
        ],
    }
}
