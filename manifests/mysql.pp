class vs_lamp::mysql (
    String $mySqlProvider   = 'mariadb',
    String $mysqlVersion    = '10.11',
    String $rootPassword    = 'vagrant',
    Hash $databases			= {},
) {
    if ( $mySqlProvider == 'mariadb_new' ) {
        ########################################################
        # Install From 'edestecd-mariadb' Module
        ########################################################
        class { 'mariadb::repo':
            repo_version    => $mysqlVersion,
            stage           => 'install-dependencies',
        }
        
        class { 'mariadb::server':
            manage_repo     => false,
            root_password   => $rootPassword,
        }
    } else {
        ########################################################
        # Install From 'puppetlabs-mysql' Module
        ########################################################
    	class { 'vs_lamp::mysql::mysql_server':
            mySqlProvider   => $mySqlProvider,
            mysqlVersion    => $mysqlVersion,
            rootPassword    => $rootPassword,
        }
    }
    
    #####################
    # Create Databases
    #####################
    $require = $mySqlProvider == 'mariadb_new' ? { true => Class['mariadb::server'], default => Class['vs_lamp::mysql::mysql_server'] }
    $databases.each |String $key, Hash $db| {
        mysql::db { $db['name']:
            #host        => 'myprojects.lh',
            user        => 'root',
            password    => $rootPassword,
            sql         => $db['dump'],
            require     => $require,
        }
    }
}