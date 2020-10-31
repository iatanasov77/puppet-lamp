class vs_lamp::mysql (
    String $rootPassword	= 'vagrant',
    $mysqlPackageName		= false,
) {
	# May some bug on CentOS7 only but i dont know
	exec { "Create path: '/var/log/mariadb'":
        command => 'mkdir -p /var/log/mariadb'
	}
	
	if $mysqlPackageName == 'mariadb-server' {
		$mysqlService	= 'mariadb'
	} else {
		$mysqlService	= 'mysqld'
	}
	
	if $mysqlPackageName {
		class { 'mysql::server':
		   create_root_user    => true,
	       root_password       => $rootPassword,
		   package_name        => $mysqlPackageName,
		   service_name        => $mysqlService,
		}
	} else {
		class { 'mysql::server':
		   create_root_user    => true,
	       root_password       => $rootPassword,
		}
	}
}
