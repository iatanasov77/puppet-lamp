class vs_lamp::mysql (
    String $rootPassword	= 'vagrant',
    $mysqlPackageName		= false,
    Hash $databases			= {},
) {
	# May some bug on CentOS7 only but i dont know
	exec { "Create path: '/var/log/mariadb'":
        command => 'mkdir -p /var/log/mariadb'
	}
	
	case $mysqlPackageName {
    	mariadb-server: {
    		$mysqlService		= 'mariadb'
    		$manageCoonfigFile	= true
    	}
    	mysql-server: {
    		$mysqlService		= 'mysqld'
    		$manageCoonfigFile	= false
    	}
    	mysql-community-server: {
    		$mysqlService		= 'mysqld'
    		$manageCoonfigFile	= false
    	}
    }
	
	if $mysqlPackageName {
		class { 'mysql::server':
		   create_root_user		=> true,
	       root_password		=> $rootPassword,
		   package_name			=> $mysqlPackageName,
		   service_name			=> $mysqlService,
		   manage_config_file	=> $manageCoonfigFile,
		}
		
		class {'mysql::client':
			package_name   	=> 'mysql'
			#bindings_enable	=> true,
		}
	} else {
		class { 'mysql::server':
		   create_root_user    => true,
	       root_password       => $rootPassword,
		}
	}
	
	# Create Databases
	$databases.each |String $key, Hash $db| {
	    mysql::db { $db['name']:
	        user     => 'root',
	        password => 'vagrant',
	        host     => 'myprojects.lh',
	        sql      => $db['dump'],
	    }
	}
}
