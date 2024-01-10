class vs_lamp::fix_php_modules (
    Hash $removeIniFiles         = {},
) {
    # Remove Duplicated PHP Extensions
    $removeIniFiles.each |String $module, Hash $options| {
        exec { "Remove: /etc/php.d/${options['prefix']}-${module}.ini":
            command => "rm -f /etc/php.d/${options['prefix']}-${module}.ini"
        }
    }
}