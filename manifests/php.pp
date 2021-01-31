
class vs_lamp::php (
    String $phpVersion,
    Boolean $phpManageRepos,
    Boolean $phpunit	= false,
    Hash $phpModules	= {},
    Hash $phpSettings	= {},
) {

	if ( $phpVersion and $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' ) {
		/**
		 *	dnf module install php:remi-7.4
		 *  Require: dnf clean packages
		 *			 dnf module reset php
		 */
		Exec { 'Reset PHP Module':
			command	=> 'dnf module reset -y php',
		}
		-> Exec { 'Install PHP Module Stream':
			command	=> "dnf module install -y php:remi-${phpVersion}",
		}
		/* Ne Varshi Rabota
		-> Package { "php:remi-${phpVersion}":
            ensure 		=> present,
            provider	=> dnfmodule,
        }
        */
	}

	if ( $phpVersion ) {
		class { '::php::globals':
			php_version		=> "${phpVersion}",
			#config_root 	=> '/etc/php/7.0',
		}->
		class { '::php':
			manage_repos	=> $phpManageRepos,
	        fpm          	=> true,
	        dev          	=> true,
	        composer     	=> true,
	        pear         	=> true,
	        phpunit      	=> $phpunit,
	        
	        settings   	=> $phpSettings,
	        
	        extensions	=> $phpModules,
	        
	        notify  	=> Service['httpd'],
		}
	} else {
		class { '::php':
	        ensure       	=> latest,
	        manage_repos	=> $phpManageRepos,
	        fpm          	=> true,
	        dev          	=> true,
	        composer     	=> true,
	        pear         	=> true,
	        phpunit      	=> $phpunit,
	        
	        settings   	=> $phpSettings,
	        
	        extensions	=> $phpModules,
	        
	        notify  	=> Service['httpd'],
	    }
	}
}
