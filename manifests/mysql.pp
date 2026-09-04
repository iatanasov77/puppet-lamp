class vs_lamp::mysql (
	String $mySqlProvider,
    String $rootPassword	= 'vagrant',
    Hash $databases			= {},
) {
	# May some bug on CentOS7 only but i dont know
	exec { "Create path: '/var/log/mariadb'":
        command => 'mkdir -p /var/log/mariadb'
	}
    
    case $mySqlProvider {
        mariadb: {
            $mysqlServerPackageName = 'mariadb-server'
            $mysqlClientPackageName = 'mariadb-client'
            $mysqlService           = 'mariadb'
            
            $manageCoonfigFile      = true
            $manageService          = true
            
            $createRootUser         = true
        }
        mariadb_new: {
            ###############################################################################################
            # Manual: https://truehost.com/support/knowledge-base/how-to-install-mariadb-on-almalinux/
            ###############################################################################################
            $mysqlServerPackageName = 'MariaDB-server'
            $mysqlClientPackageName = 'MariaDB-client'
            $mysqlService           = 'mariadb'
            
            $manageCoonfigFile      = true
            $manageService          = false
            
            $createRootUser         = false
    	}
        mysql: {
    		if (
    		  ( $facts['os']['name'] == 'centos' or $facts['os']['name'] == 'AlmaLinux' ) and
    		  Integer( $facts['os']['release']['major'] ) >= 8
    		) {
    			$mysqlServerPackageName	= 'mysql-server'
    		} else {
    			$mysqlServerPackageName	= 'mysql-community-server'
    		}
            
            $mysqlClientPackageName = 'mysql'
            $mysqlService		    = 'mysqld'
            
            $manageCoonfigFile	    = false
            $manageService          = true
            
            $createRootUser         = true
    	}
    }
	
	class { 'vs_lamp::mysql::repo':
       mySqlProvider => $mySqlProvider,
    }
    
	-> class { 'mysql::server':
        create_root_user    => $createRootUser,
        root_password       => $createRootUser ? { true => $rootPassword, default => 'UNSET' },
        
        package_name        => $mysqlServerPackageName,
        service_name        => $mysqlService,
        manage_config_file  => $manageCoonfigFile,
        
        #service_manage      => $manageService,
        service_enabled     => $manageService,
	}
	
	-> class {'mysql::client':
        package_name        => $mysqlClientPackageName,
		#bindings_enable	=> true,
	}
	
	# Create Databases
	$databases.each |String $key, Hash $db| {
	    mysql::db { $db['name']:
	        user     => 'root',
	        password => $rootPassword,
	        host     => 'myprojects.lh',
	        sql      => $db['dump'],
	    }
	}
}