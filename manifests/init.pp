class vs_lamp (
    Array $apacheModules                = [],
    String $phpVersion                  = '7.2',
    
    String $mysqllRootPassword          = 'vagrant',
    $mySqlProvider						= false,
    
    Hash $phpModules                    = {},
    Hash $phpSettings                   = {},
    Boolean $phpunit                    = false,
    Boolean $phpManageRepos             = true,
    Hash $phpMyAdmin					= {},
    Hash $databases						= {}
) {
	class { '::vs_lamp::apache':
        apacheModules   => $apacheModules,
    }
	
	class { '::vs_lamp::mysql':
        rootPassword    => $mysqllRootPassword,
        mySqlProvider	=> $mySqlProvider,
        databases		=> $databases,
    }
	
	class { '::vs_lamp::php':
        phpManageRepos  => $phpManageRepos,
        phpVersion      => $phpVersion,
        phpModules      => $phpModules,
        phpunit         => $phpunit,
        phpSettings     => $phpSettings,
    } ->
    class { '::vs_lamp::setup_mod_php':
        phpVersion  => "${phpVersion}",
        require     => [ Class['vs_lamp::php'] ],
        notify      => Service['httpd'],
    }
	
	if $phpMyAdmin['source'] {
		class { '::vs_lamp::phpmyadmin':
		    source			=> $phpMyAdmin['source'],
		    targetDirName	=> $phpMyAdmin['targetDirName'],
		    require			=> [ Class['vs_lamp::php'] ],
		}
	}
}
