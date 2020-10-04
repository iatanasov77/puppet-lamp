class vs_lamp::xdebug (
	$service                   = "httpd",
	$ini_file_path             = $vs_lamp::params::xdebug::ini_file_path,
	$default_enable            = $vs_lamp::params::xdebug::default_enable,
	$remote_enable             = $vs_lamp::params::xdebug::remote_enable,
	$remote_handler            = $vs_lamp::params::xdebug::remote_handler,
	$remote_host               = $vs_lamp::params::xdebug::remote_host,
	$remote_port               = $vs_lamp::params::xdebug::remote_port,
	$remote_autostart          = $vs_lamp::params::xdebug::remote_autostart,
	$remote_connect_back       = $vs_lamp::params::xdebug::remote_connect_back,
	$remote_log                = $vs_lamp::params::xdebug::remote_log,
	$idekey                    = $vs_lamp::params::xdebug::idekey,
	
    $trace_format               = $vs_lamp::params::xdebug::trace_format,
    $trace_enable_trigger       = $vs_lamp::params::xdebug::trace_enable_trigger,
    $trace_output_name          = $vs_lamp::params::xdebug::trace_output_name,
    $trace_output_dir           = $vs_lamp::params::xdebug::trace_output_dir,
    
    $profiler_enable            = $vs_lamp::params::xdebug::profiler_enable,
    $profiler_enable_trigger    = $vs_lamp::params::xdebug::profiler_enable_trigger,
    $profiler_output_name       = $vs_lamp::params::xdebug::profiler_output_name,
    $profiler_output_dir        = $vs_lamp::params::xdebug::profiler_output_dir,
) inherits vs_lamp::params::xdebug 
{
	$zend_extension_module = $vs_lamp::params::xdebug::zend_extension_module

	package { "$vs_lamp::params::xdebug::package":
		ensure	=> "installed",
		require => Package[$vs_lamp::params::xdebug::php],
		notify	=> File[$ini_file_path],
		configfiles => "replace"
	}

	file { "$original_ini_file_path" :
		ensure  => absent,
		require => Package[$vs_lamp::params::xdebug::package],
	} ->
	
	file { "$ini_file_path" :
		content => template('vs_lamp/xdebug_ini.erb'),
		ensure  => present,
		require => Package[$vs_lamp::params::xdebug::package],
		notify  => Service[$service],
	}
}
