#!/usr/bin/env bash
wait-for-it db:3306
wait-for-it wordpress:80

wp core is-installed
if [ $? -ne 0 ]; then
    wp core install --url="$SITE_URL" --title="$SITE_TITLE" --admin_user="$SITE_ADMIN_USER" --admin_email="$SITE_ADMIN_EMAIL" --admin_password="$SITE_ADMIN_PASSWORD" --skip-email;
fi
if [[ -n "${SITE_PLUGINS}" ]]; then
    wp plugin install $SITE_PLUGINS --activate        
fi
wp plugin activate plugin-dev


wp_plugins="/var/www/html/wp-content/plugins"
for p in "$wp_plugins/plugin-dev/.devcontainer/plugins/*"; do
    destination="/var/www/html/wp-content/plugins/$(basename $p)";
    if [[ ! -d $destination ]]; then
        echo "adding local plugin $(basename $p) to wordpress"
        cp -r $p $destination
        wp plugin activate $(basename $p)
    fi    
done