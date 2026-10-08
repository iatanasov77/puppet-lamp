class vs_lamp::custom_extensions::swoole (
    Hash $config = {},
) {
	if ( $config['extension'] == 'openswoole' ) {
	   php::extension { 'openswoole':
            ensure   => 'present',
            provider => 'pecl',
            settings => {
                # Тук можете да добавите специфични настройки за openswoole.ini
                'openswoole.use_fiber_context' => 'On',
            },
        }
	} else {
    	Package { "${config['swoole_package_name']}":
            ensure	=> 'present',
            notify	=> Service['httpd'],
        }
    }
}