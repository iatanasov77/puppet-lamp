class vs_lamp::custom_extensions (
    Hash $customExtensions    = {},
) {
    $customExtensions.each |String $extKey, Hash $ext| {
        if ( $ext['enabled'] ) {
            class { "::vs_lamp::custom_extensions::${$extKey}":
                config  => $ext,
                require => [
                    Class['vs_lamp::php'], 
                    Class['vs_lamp::apache']
                ],
            }
        }
    }
}