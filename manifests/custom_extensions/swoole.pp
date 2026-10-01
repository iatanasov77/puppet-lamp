class vs_lamp::custom_extensions::swoole (
    Hash $config = {},
) {
	Package { "${config['package_name']}":
        ensure	=> 'present',
        notify	=> Service['httpd'],
    }
}