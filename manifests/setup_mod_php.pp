class vs_lamp::setup_mod_php (
    String $phpVersion,
) {
    $modPhpVersionLib       = "/usr/lib64/httpd/modules/libphp${$phpVersion[0]}.so"
    $modPhpVersionLibExists = find_file( $modPhpVersionLib )
    
    if ( $phpVersion ) {
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            path         => "modules/libphp${phpVersion}.so",
        }
        
        if ( $modPhpVersionLibExists )  {
            file { "/usr/lib64/httpd/modules/libphp${phpVersion}.so":
                ensure => 'link',
                target => "/usr/lib64/httpd/modules/libphp${$phpVersion[0]}.so",
                require => Class['apache::mod::php'],
            }
        } else {
            file { "/usr/lib64/httpd/modules/libphp${phpVersion}.so":
                ensure => 'link',
                target => "/usr/lib64/httpd/modules/libphp.so",
                require => Class['apache::mod::php'],
            }
        }
    } else {
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            path         => "modules/libphp.so",
        }
    }
}
