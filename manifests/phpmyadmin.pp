class vs_lamp::phpmyadmin (
	String $source,
	String $targetDirName,
) {
	$blowfishKey      = md5( "${::fqdn}${::ipaddress}" )
	
	#################################
    # Instalation
    #################################
	archive { '/tmp/phpMyAdmin-5.0.4-all-languages.zip':
		ensure        	=> present,
		source        	=> "${source}",
		extract       	=> true,
		extract_path  	=> '/usr/share',
		cleanup       	=> true,
	}
	
	-> file { "/usr/share/${targetDirName}":
		ensure	=> directory,
		owner	=> 'apache',
		group	=> 'apache',
		require	=> [ User['apache'], Group['apache'], ],
		recurse	=> true,
	}
	
	-> file { '/usr/share/phpMyAdmin':
        ensure  => link,
        target  => "/usr/share/${targetDirName}",
        owner  	=> 'apache',
    	group  	=> 'apache',
    }
    
    #################################
    # Configuration
    #################################
    -> file { '/usr/share/phpMyAdmin/config.inc.php':
        ensure  => 'present',
        owner  	=> 'apache',
    	group  	=> 'apache',
    	mode    => '0640',
	    content => template( 'vs_lamp/phpmyadmin_config.inc.php.erb' ),
    }

}