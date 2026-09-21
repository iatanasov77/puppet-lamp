##################################################################################
# mkcert is a simple tool for making locally-trusted development certificates.
# Manual: https://github.com/FiloSottile/mkcert
##################################################################################
class vs_lamp::mkcert (
    Hash $mkCert,
) {
    $sslHostsString = join( $mkCert['sslHosts'], " " )
    
    wget::fetch { "Install mkcert":
        source      => "https://github.com/FiloSottile/mkcert/releases/download/v${mkCert['version']}/mkcert-v${mkCert['version']}-linux-amd64",
        destination => '/usr/local/bin/mkcert',
        verbose     => true,
        mode        => '0777',
        cache_dir   => '/var/cache/wget',
    }
    
    -> file { 'MKCERT_OUTPUT_DIRECTORY':
        ensure  => directory,
        path    => $mkCert['caRoot'],
    }
    
    -> exec { 'Create a new local CA ':
        command => 'mkcert -install',
        environment => ["CAROOT=${mkCert['caRoot']}"],
    }
    
    -> exec { 'Create a new certificate valid for the following names':
        cwd     => $mkCert['caRoot'],
        command => "mkcert -key-file ${mkCert['caHost']}-key.pem -cert-file ${mkCert['caHost']}.pem ${sslHostsString}",
        environment => ["CAROOT=${mkCert['caRoot']}"],
    }
}