class vs_lamp::install_mod_php (
    String $phpVersion,
) {
    if ( $phpVersion ) {
    
        if $phpVersion[0] == '7' {
            $modphpPath = 'modules/libphp7.so'
        } else {
            $modphpPath = 'modules/libphp.so'
        }
        
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            #path         => "modules/libphp${phpVersion[0]}.so",
            path         => "${modphpPath}",
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
