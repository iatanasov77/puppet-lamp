define vs_lamp::create_ssl_certificate (
    String $hostName,
    String $sslHost,
) {
    exec { "OpenSsl_SelfSignedCertificate_${hostName}":
        command => "/usr/local/bin/OpenSsl_SelfSignedCertificate.sh ${sslHost}",
    } ->
    exec { "CopySelfSignedCertificateToTrustSources_${hostName}":
        command => "cp /etc/pki/tls/certs/${sslHost}.crt /etc/pki/ca-trust/source/anchors/"
    }
}
