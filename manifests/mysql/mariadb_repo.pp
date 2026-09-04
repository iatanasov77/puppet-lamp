class vs_lamp::mysql::mariadb_repo (
    String $mariadbVersion = '10.11'
) {
    case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            if $facts['os']['release']['major'] >= '8' {
                file { '/etc/yum.repos.d/mariadb.repo':
                    ensure  => 'present',
                    owner   => 'root',
                    group   => 'root',
                    mode    => '0644',
                    content => template( 'vs_lamp/mariadb.repo.erb' ),
                }
            }
        }
    }
}