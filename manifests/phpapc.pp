class vs_lamp::phpapc (
	$config       	= $vs_lamp::params::phpapc::config
) inherits vs_lamp::params::phpapc {

	
	package { "$vs_lamp::params::phpapc::package":
		ensure	=> "installed",
		require => Package[$vs_lamp::params::phpapc::php],
		notify	=> File[$vs_lamp::params::phpapc::config_file],
	}

	file { "$vs_lamp::params::phpapc::config_file" :
		content => template('vs_lamp/phpapc_ini.erb'),
		ensure  => present,
		require => Package[$vs_lamp::params::phpapc::package],
		notify  => Service[$vs_lamp::params::phpapc::service],
	}
}
