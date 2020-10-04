class vs_lamp::mongodb (
	$config       	= $vs_lamp::params::mongodb::config
) inherits vs_lamp::params::mongodb {

	package { "$vs_lamp::params::mongodb::package":
		ensure	=> "installed",
		require => Package[$vs_lamp::params::mongodb::php],
	}
}
