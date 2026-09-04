class vs_lamp::mysql::repo (
    String $mySqlProvider = 'mariadb'
) {
    case $facts['os']['name'] {
    	'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            if $facts['os']['release']['major'] >= '8' {
		    	if $mySqlProvider == 'mysql' {
                    include vs_lamp::mysql::mysql_comunity_repo
                }
                
                if $mySqlProvider == 'mariadb_new' {
                    include vs_lamp::mysql::mariadb_repo
                }
		    }
	    }
	}
}