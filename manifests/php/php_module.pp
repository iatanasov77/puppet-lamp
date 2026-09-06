class vs_lamp::php::php_module (
    String $remiReleaseRpm  = '',
    String $phpVersion      = '7.4',
) {
    $phpVersionShort    = regsubst( sprintf( "%.1f", $phpVersion ), '[.]', '', 'G' )
    
    $yumrepoDefaults = {
        'ensure'   => 'present',
        'enabled'  => true,
        'gpgcheck' => false,
        'priority' => 50,
    }
    
    case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            $repo = sprintf( 'remi-php%s', "${phpVersionShort}" )
            
            class { 'vs_lamp::php::remi_repo':
                yumrepoDefaults => $yumrepoDefaults,
                remiReleaseRpm  => $remiReleaseRpm,
                stage           => 'install-dependencies',
            }
            
            if $facts['os']['release']['major'] == '7' {
                $repoMirrors        = "http://cdn.remirepo.net/enterprise/7/php${phpVersionShort}/mirror"
                $requiredPackages   = [ Package['remi-release'], Package['yum-plugin-priorities'] ]
            } elsif $facts['os']['release']['major'] == '8' {
                $repoMirrors        = "http://cdn.remirepo.net/enterprise/8/php${phpVersionShort}/x86_64/mirror"
                $requiredPackages   = [ Package['remi-release'] ]
            } else {
                $requiredPackages   = [ Package['remi-release'] ]
            }
            
            # PHP 8.2 Has Not Mirror
            if Integer( $phpVersionShort ) < 82  and Integer( $facts['os']['release']['major'] ) < 9 {
                yumrepo { $repo:
                    descr       => "Remi PHP ${phpVersion} RPM repository for Enterprise Linux",
                    mirrorlist  => $repoMirrors,
                    require     => $requiredPackages,
                    *           => $yumrepoDefaults,
                }
            }
            
            Exec { 'Reset PHP Module':
                command => 'dnf module reset -y php',
                require => $requiredPackages,
            }
            -> Exec { 'Install PHP Module Stream':
                command => "dnf module install -y php:remi-${phpVersion}",
                require => $requiredPackages,
            }
        }
    }
}