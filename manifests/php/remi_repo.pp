class vs_lamp::php::remi_repo (
    $yumrepoDefaults,
    String $remiReleaseRpm = '',
) {
    case $facts['os']['name'] {
        'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            if $facts['os']['release']['major'] == '7' {
                $remiSafeMirrors    = 'http://cdn.remirepo.net/enterprise/7/safe/mirror'
                $requiredPackages   = [ Package['epel-release'], Package['yum-plugin-priorities'] ]
            } elsif Integer( $facts['os']['release']['major'] ) >= 8 {
                $remiSafeMirrors    = "http://cdn.remirepo.net/enterprise/${facts['os']['release']['major']}/safe/x86_64/mirror"
                $requiredPackages    = [ Package['epel-release'] ]
            }
            
            if ! defined( Package['remi-release'] ) {
                if empty( $remiReleaseRpm ) {
                    $remiReleaseSource  = "http://rpms.remirepo.net/enterprise/remi-release-${facts['os']['release']['major']}.rpm"
                } else {
                    $remiReleaseSource  = $remiReleaseRpm
                }
                
                Package { 'remi-release':
                    ensure   => 'present',
                    name     => 'remi-release',
                    provider => 'rpm',
                    source   => $remiReleaseSource,
                    require  => $requiredPackages,
                }
            }
            
            yumrepo { 'remi-safe':
                descr       => 'Safe Remi RPM repository for Enterprise Linux',
                mirrorlist  => $remiSafeMirrors,
                require     => $requiredPackages,
                *           => $yumrepoDefaults,
            }
        }
    }
}