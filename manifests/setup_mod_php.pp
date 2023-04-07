class vs_lamp::setup_mod_php (
    String $phpVersion,
) {
	notice( "SETUP MOD PHP FOR PHP_VERSION: ${phpVersion}" )
	
    $modPhpVersionLib       = "/usr/lib64/httpd/modules/libphp${$phpVersion[0]}.so"
	$modPhpVersionLibExists = find_file( $modPhpVersionLib )
    if ( $modPhpVersionLibExists )  {
        file { "/usr/lib64/httpd/modules/libphp${phpVersion}.so":
            ensure => 'link',
            target => "/usr/lib64/httpd/modules/libphp${$phpVersion[0]}.so",
        }
    } else {
        file { "/usr/lib64/httpd/modules/libphp${phpVersion}.so":
            ensure => 'link',
            target => "/usr/lib64/httpd/modules/libphp.so",
        }
    }
}
