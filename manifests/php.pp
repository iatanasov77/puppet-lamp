
class vs_lamp::php (
    String $phpVersion,
    Array $phpModules,
    Hash $phpSettings,
    Boolean $phpunit,
    Boolean $phpManageRepos,
) {

    # PHP Modules
    $modules = {}
    $phpModules.each |String $value| {
    
        notify { "INSTALLING PHP MUDULE: ${value}":
    		withpath => false,
		}
		
        if ( $value == 'apc' or $value == 'xdebug' or $value == 'mongodb' ) {
            next()
        }
        
    	$modules = merge( $modules, {
            "${value}"  => {}
        })
    }

    class { '::php':
        ensure       => latest,
        manage_repos => $phpManageRepos,
        fpm          => true,
        dev          => true,
        composer     => true,
        pear         => true,
        phpunit      => $phpunit,
        
        #package_prefix => 'php72-php-',
        
        settings   => $phpSettings,
        
        extensions => $modules
    }
    
    ########################################
    # Php Build Tool PHING
    ########################################
    notify { "INSTALLING PHING ( PHP BUILD TOOL )":
        withpath => false,
    }
    wget::fetch { 'https://www.phing.info/get/phing-latest.phar':
        destination => "/usr/share/php/",
        timeout     => 0,
        verbose     => true,
    } ->
    file { '/usr/local/bin/phing':
        ensure  => link,
        target  => '/usr/share/php/phing-latest.phar',
        mode    => '0777',
    }
}
