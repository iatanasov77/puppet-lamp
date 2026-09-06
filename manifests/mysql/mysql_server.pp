class vs_lamp::mysql::mysql_server (
    String $mySqlProvider   = 'mariadb',
    String $mysqlVersion    = '10.11',
    String $rootPassword    = 'vagrant',
) {
    # May some bug on CentOS7 only but i dont know
    exec { "Create path: '/var/log/mariadb'":
        command => 'mkdir -p /var/log/mariadb'
    }
    
    if ( $mySqlProvider == 'mysql' ) {
        class { 'vs_lamp::mysql::mysql_comunity_repo':
            stage   => 'install-dependencies',
        }
        
        if (
              ( $facts['os']['name'] == 'centos' or $facts['os']['name'] == 'AlmaLinux' ) and
              Integer( $facts['os']['release']['major'] ) >= 8
        ) {
            $mysqlServerPackageName = 'mysql-server'
        } else {
            $mysqlServerPackageName = 'mysql-community-server'
        }
        
        $mysqlClientPackageName = 'mysql'
        $mysqlService           = 'mysqld'
        
        $manageCoonfigFile      = false
    } else {
        $mysqlServerPackageName = 'mariadb-server'
        $mysqlClientPackageName = 'mariadb-client'
        $mysqlService           = 'mariadb'
        
        $manageCoonfigFile      = true
        $manageService          = true
        
        $createRootUser         = true
    }
    
    class { 'mysql::server':
        create_root_user    => true,
        root_password       => $rootPassword,
        
        package_name        => $mysqlServerPackageName,
        service_name        => $mysqlService,
        manage_config_file  => $manageCoonfigFile,
    }
    
    -> class {'mysql::client':
        package_name        => $mysqlClientPackageName,
        #bindings_enable    => true,
    }
}