class vs_lamp::custom_extensions::zmq (
    Hash $config    = {},
) {
    if ( $config['version'] == 'master' ) {
        $packageSource  = "https://github.com/zeromq/php-zmq/archive/refs/heads/master.tar.gz"
    } else {
        $packageSource  = "https://github.com/zeromq/php-zmq/archive/refs/tags/${config['version']}.tar.gz"
    }
    
    if ! defined( Package['zeromq-devel'] ) {
        Package { 'zeromq-devel':
            ensure   => 'present',
        }
    }
    
    -> archive { "/tmp/${config['version']}.tar.gz":
        ensure          => present,
        source          => $packageSource,
        extract         => true,
        extract_path    => '/usr/local/src',
        cleanup         => true,
    }
    
    -> Exec { 'Configure PHP ZMQ Extension Source Code':
        command     => "phpize && ./configure",
        cwd         => "/usr/local/src/php-zmq-${config['version']}",
    }
    
    -> Exec { 'Compile and Install PHP ZMQ Extension':
        command     => "make && make install",
        cwd         => "/usr/local/src/php-zmq-${config['version']}",
    }
    
    -> file { '/etc/php.d/zmq.ini':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/vs_lamp/zmq.ini',
        #require => File['/usr/lib64/php/modules/zmq.so'],
        notify  => Service['httpd'],
    }
}