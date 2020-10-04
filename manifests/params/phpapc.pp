class vs_lamp::params::phpapc
{
    case $operatingsystem 
    {
        'RedHat', 'CentOS', 'Fedora': 
        {
            $config_file    = '/etc/php.d/apc.ini'
            $package        = 'php-pecl-apc'
            $php            = 'php-cli'
            $service        = 'httpd'
        }
        'Debian', 'Ubuntu':
        {
            $config_file    = '/etc/php/7.2/mods-available/apc.ini'
            $package        = 'php-apcu'
            $php            = 'php7.2'
            $service        = apache2
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
    
    $config = {
        'enable_opcode_cache' => 1,
        'shm_size'            => '128M',
    }
}

