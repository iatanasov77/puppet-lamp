class vs_lamp::install_mod_php (
    String $phpVersion,
) {
    if ( $phpVersion ) {
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            #path         => "modules/libphp${phpVersion[0]}.so",
            path         => "modules/libphp.so",
        }
        /* SETUP NOT WORK HOW ITS EXPECTED
	    -> class { '::vs_lamp::setup_mod_php':
	        phpVersion  => "${phpVersion}",
	        require 	=> Class['apache::mod::php'],
	    }
	    */
    } else {
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            path         => "modules/libphp.so",
        }
    }
}
