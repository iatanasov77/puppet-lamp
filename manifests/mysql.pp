class vs_lamp::mysql (
    String $rootPassword,
    String $mysqlPackageName,
    String $mysqlService,
) {
	# May some bug on CentOS7 only but i dont know
	exec { "Create path: '/var/log/mariadb'":
        command => 'mkdir -p /var/log/mariadb'
	}
	
	class { 'mysql::server':
	   create_root_user    => true,
       root_password       => $rootPassword,
	   package_name        => $mysqlPackageName,
	   service_name        => $mysqlService,
	}
}
