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
        phpVersion      => $phpVersion,
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
    }
    
	/* Used in vs_devenv::subsystems
    class { '::composer':
        command_name => 'composer',
        target_dir   => '/usr/bin',
        auto_update => true
    }
	*/
	
	if $phpMyAdmin['source'] {
		class { '::vs_lamp::phpmyadmin':
		    source			=> $phpMyAdmin['source'],
		    targetDirName	=> $phpMyAdmin['targetDirName'],
		    require			=> [ Class['vs_lamp::php'] ],
		}
	}
}
