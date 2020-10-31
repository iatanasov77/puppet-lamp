
class vs_lamp::php (
    String $phpVersion,
    Boolean $phpManageRepos,
    Boolean $phpunit	= false,
    Hash $phpModules	= {},
    Hash $phpSettings	= {},
) {

    class { '::php':
        ensure       => latest,
        manage_repos => $phpManageRepos,
        fpm          => true,
        dev          => true,
        composer     => true,
        pear         => true,
        phpunit      => $phpunit,
        
        settings   	=> $phpSettings,
        
        extensions	=> $phpModules,
        
        notify  	=> Service['httpd'],
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
