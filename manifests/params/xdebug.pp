class vs_lamp::params::xdebug
{
    case $operatingsystem 
    {
        'RedHat', 'CentOS', 'Fedora': 
        {
            $original_ini_file_path  = '/etc/php.d/15-xdebug.ini'
            $ini_file_path           = '/etc/php.d/xdebug.ini'
            $package                 = 'php-pecl-xdebug'
            $php                     = 'php-cli'
            $zend_extension_module   = 'xdebug.so'
        }
        'Debian', 'Ubuntu':
        {
            #$original_ini_file_path  = '/etc/php.d/15-xdebug.ini'
            #$ini_file_path           = "/etc/php/${vsConfig['phpVersion']}/mods-available/xdebug.ini"
            #$package                 = 'php-xdebug'
            #$php                     = "php${vsConfig['phpVersion']}"
            #$zend_extension_module   = 'xdebug.so'
        }
    }

    $default_enable      = '1'
    $remote_enable       = '1'
    $remote_handler      = 'dbgp'
    $remote_host         = 'localhost'
    $remote_port         = '9000'
    $remote_autostart    = '0'
    $remote_connect_back = '1'
    $remote_log          = false
    $idekey              = ''
    
    # Tracer default settings
    $trace_format           = '1'
    $trace_enable_trigger   = '1'
    $trace_output_name      = 'trace.out'
    $trace_output_dir       = '/home/nickname/Xdebug'
    
    # Profiler default settings
    $profiler_enable        = '0'
    $profiler_enable_trigger= '1'
    $profiler_output_name   = 'cachegrind.out'
    $profiler_output_dir    = '/home/nickname/Xdebug'
}