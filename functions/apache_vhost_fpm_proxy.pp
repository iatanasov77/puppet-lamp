# @summary
#   Return rewrite rules used in apache virtual hosts.
#
#########################################################################
function vs_lamp::apache_vhost_fpm_proxy( String $fpmSocket ) {

    if ( ! empty( $fpmSocket ) ) {
        <Proxy \"unix:${fpmSocket}|fcgi://php-fpm\">
           ProxySet disablereuse=off
        </Proxy>
    
        <FilesMatch \.php$>
            SetHandler proxy:fcgi://php-fpm
        </FilesMatch>
    }
    
}
