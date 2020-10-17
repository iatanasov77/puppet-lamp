
class vs_lamp::phpextensions (
    Array $phpModules                   = [],
    
    String $xdebugTraceOutputName       = 'trace.out',
    String $xdebugTraceOutputDir        = '/home/nickname/Xdebug',
    String $xdebugProfilerEnable        = '0',
    String $xdebugProfilerOutputName    = 'cachegrind.out',
    String $xdebugProfilerOutputDir     = '/home/nickname/Xdebug',
) {
	if ( 'intl' in $phpModules )
    {
    	# I don't know why this extension is not installed by voxpopuli/php module on CentOs 7
    	########################################################################################
        if ! defined(Package['php-intl']) {
            Package { 'php-intl':
                ensure => present,
            }
        }
    }

    if ( 'apc' in $phpModules )
    {
        class { 'vs_lamp::phpapc':
            config  => {
                enable_opcode_cache => 1,
                shm_size            => '512M',
                stat                => 0
            }
        }
    }

    if ( 'xdebug' in $vsConfig['phpModules'] )
    {
        class { 'vs_lamp::xdebug':
            # Tracer default settings
            trace_output_name      => "${xdebugTraceOutputName}",
            trace_output_dir       => "${xdebugTraceOutputDir}",
            
            # Profiler default settings
            profiler_enable        => "${xdebugProfilerEnable}",
            profiler_output_name   => "${xdebugProfilerOutputName}",
            profiler_output_dir    => "${xdebugProfilerOutputDir}",
        }
        
        file { $xdebugTraceOutputDir:
		    ensure => 'directory',
		    owner  => 'vagrant',
		    group  => 'apache',
		    mode   => '0770',
		}
		
		if ( $xdebugTraceOutputDir != $xdebugProfilerOutputDir )
    	{
	        file { $xdebugProfilerOutputDir:
			    ensure => 'directory',
			    owner  => 'vagrant',
			    group  => 'apache',
			    mode   => '0770',
			}
		}
    }
    
    if ( 'mongodb' in $phpModules )
    {
        class { 'vs_lamp::mongodb':
            config  => {
                #enable_opcode_cache => 1,
                #shm_size            => '512M',
                #stat                => 0
            }
        }
    }
}
