class vs_lamp (
    Array $apacheModules                = [],
    String $phpVersion                  = '7.2',
    
    String $mysqlService                = 'mysqld',
    String $mysqllRootPassword          = 'vagrant',
    
    Array $phpModules                   = [],
    Boolean $phpunit                    = false,
    Hash $phpSettings                   = {},
    Boolean $forcePhp7Repo              = true,
    
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
        mysqlService    => $mysqlService,
        rootPassword    => $mysqllRootPassword,
    }
	
	class { '::vs_lamp::php':
        phpVersion      => $phpVersion,
        phpModules      => $phpModules,
        phpunit         => $phpunit,
        phpSettings     => $phpSettings,
        forcePhp7Repo   => $forcePhp7Repo,
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

	class { '::phpmyadmin': }
}
