class vs_lamp::apache (
    Array $apacheModules,
    String $phpVersion,
) {
	class { 'apache':
		default_vhost 	=> false,
		default_mods	=> false,
		mpm_module 		=> 'prefork',
	}
    
	# Apache modules
	$apacheModules.each |String $value| {
        notice( "APACHE MODULE: ${value}" )
        class { "apache::mod::${value}": }
    }
    
    # mod_php
    class {'::apache::mod::php':
        php_version  => "${phpVersion}",
        path         => "modules/libphp${phpVersion}.so",
    }
}
