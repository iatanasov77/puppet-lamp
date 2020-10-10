class vs_lamp (
    Array $apacheModules                = [],
    String $phpVersion                  = '7.2',
    
    String $mysqllRootPassword          = 'vagrant',
    String $mysqlPackageName            = '',
    String $mysqlService                = '',
    
    Array $phpModules                   = [],
    Hash $phpSettings                   = {},
    Boolean $phpunit                    = false,
    Boolean $phpManageRepos             = true,
    
    String $xdebugTraceOutputName       = 'trace.out',
    String $xdebugTraceOutputDir        = '/home/nickname/Xdebug',
    String $xdebugProfilerEnable        = '0',
    String $xdebugProfilerOutputName    = 'cachegrind.out',
    String $xdebugProfilerOutputDir     = '/home/nickname/Xdebug',
) {
	class { '::vs_lamp::apache':
        apacheModules   => $apacheModules,
        phpVersion      => $phpVersion,
    }
	
	class { '::vs_lamp::mysql':
        rootPassword            => $mysqllRootPassword,
        mysqlPackageName        => $mysqlPackageName,
        mysqlService            => $mysqlService,
    }
	
	class { '::vs_lamp::php':
        phpManageRepos  => $phpManageRepos,
        phpVersion      => $phpVersion,
        phpModules      => $phpModules,
        phpunit         => $phpunit,
        phpSettings     => $phpSettings,
    }
	
	class { '::vs_lamp::phpextensions':
        phpModules                  => $phpModules,
        xdebugTraceOutputName       => $xdebugTraceOutputName,
        xdebugTraceOutputDir        => $xdebugTraceOutputDir,
        xdebugProfilerEnable        => $xdebugProfilerEnable,
        xdebugProfilerOutputName    => $xdebugProfilerOutputName,
        xdebugProfilerOutputDir     => $xdebugProfilerOutputDir,
    }

    class { '::composer':
        command_name => 'composer',
        target_dir   => '/usr/bin',
        auto_update => true
    }

	class { '::phpmyadmin': 
	   require  => [ Class['vs_lamp::php'] ],
	}
}
