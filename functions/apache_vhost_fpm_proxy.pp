# @summary
#   Return rewrite rules used in apache virtual hosts.
#
#########################################################################
function vs_lamp::apache_vhost_fpm_proxy( String? $fpmSocket ) {

    if ( $fpmSocket ) {
        [
            {
                comment      => 'Standart Rewrite Rules',
                rewrite_base => '/',
                rewrite_rule => ['^index\.html$ - [L]'],
            },
            {
                comment      => 'Application Rewrite Rules',                
                rewrite_cond => ['%{REQUEST_FILENAME} !-f', '%{REQUEST_FILENAME} !-d'],
                rewrite_rule => ['. /index.html [L]'],
            }
        ]
    }
    
}
