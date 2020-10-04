class vs_lamp::params::mongodb
{
    case $operatingsystem 
    {
        'RedHat', 'CentOS', 'Fedora': 
        {
            $package        = 'php-pecl-mongodb'
            $php            = 'php-cli'
            $service        = 'httpd'
        }
        'Debian', 'Ubuntu':
        {
            $package        = 'php-mongodb'
            $php            = 'php7.2'
            $service        = apache2
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
    
    $config = {
        #'enable_opcode_cache' => 1,
        #'shm_size'            => '128M',
    }
}
