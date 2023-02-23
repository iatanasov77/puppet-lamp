class vs_lamp::setup_mod_php (
    String $phpVersion,
) {
    $modPhpVersionLib       = "/usr/lib64/httpd/modules/libphp${$phpVersion[0]}.so"
    $modPhpVersionLibExists = find_file( $modPhpVersionLib )
    
    #if ( $modPhpVersionLibExists )  {
    if ( $phpVersion ) {
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            path         => "modules/libphp${phpVersion}.so",
        }->
        file { "/usr/lib64/httpd/modules/libphp${phpVersion}.so":
            ensure => 'link',
            target => "/usr/lib64/httpd/modules/libphp${$phpVersion[0]}.so",
        }
    } else {
        class {'::apache::mod::php':
            php_version  => "${phpVersion}",
            path         => "modules/libphp.so",
        }
    }
}