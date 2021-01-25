#!/usr/bin/env bash

printf "Setting Apache configuration before running this app ...\n\n\n"

# include ring web app virtual host in the official apache2 release configuration - Ubuntu
if [ -f /etc/apache2/apache2.conf ]
then
        printf "Setting configuration for official apache release - Ubuntu.....\n\n"
        if [ -L /etc/apache2/sites-enabled/ringwebapp.local.conf ]
        then
                printf "Removing previously set 'ringwebapp.local.conf' config file...\n\n"
                sudo rm /etc/apache2/sites-enabled/ringwebapp.local.conf
        fi
        printf "Setting new 'ringwebapp.local.conf' config file...\n\n"
        sudo ln -s "$1/ringwebapp.local.conf" /etc/apache2/sites-enabled
fi

# include ring web app virtual host in the official apache2 release configuration - Fedora
if [ -f /etc/httpd/conf/httpd.conf ]
then
        printf "Setting configuration for official apache release - Fedora.....\n\n"
        if [ -L /etc/httpd/conf.d/ringwebapp.local.conf ]
        then
                printf "Removing previously set 'ringwebapp.local.conf' config file...\n\n"
                sudo rm /etc/httpd/conf.d/ringwebapp.local.conf
        fi
        printf "Setting new 'ringwebapp.local.conf' config file...\n\n"
        sudo ln -s "$1/ringwebapp.local.conf" /etc/httpd/conf.d
fi

# include ring web app virtual host in the official apache2 release and XAMPP configurations - MacOSX
if [ -f /etc/apache2/httpd.conf ] ||  [ -f /Applications/XAMPP/xamppfiles/etc/httpd.conf ]
then
        printf "Setting configuration for apache - MacOSX.....\n\n"
        CONF_STR= 'Include /private/etc/apache2/vhosts/*.conf'
        if grep -q "$CONF_STR" /etc/apache2/httpd.conf; then
                if grep -q "#$CONF_STR" /etc/apache2/httpd.conf; then
                        printf "Reactivate inactivated vhosts inclusion in apache httpd.conf file - Official apache release...\n\n"
                        sudo sed -i '' "s/#$CONF_STR/$CONF_STR/g" /etc/apache2/httpd.conf
                fi
        else
                printf "Activate vhosts inclusion in apache httpd.conf file - Official apache release...\n\n"
                sudo sh -c 'printf "$CONF_STR" >> /etc/apache2/httpd.conf'
        fi
        if grep -q "$CONF_STR" /Applications/XAMPP/xamppfiles/etc/httpd.conf; then
                if grep -q "#$CONF_STR" /Applications/XAMPP/xamppfiles/etc/httpd.conf; then
                        printf "Reactivate inactivated vhosts inclusion in apache httpd.conf file - XAMPP apache...\n\n"
                        sudo sed -i '' "s/#$CONF_STR/$CONF_STR/g" /Applications/XAMPP/xamppfiles/etc/httpd.conf
                fi
        else
                printf "Activate vhosts inclusion in apache httpd.conf file - XAMPP apache...\n\n"
                sudo sh -c 'printf "$CONF_STR" >> /Applications/XAMPP/xamppfiles/etc/httpd.conf'
        fi
        if [ ! -d /private/etc/apache2/vhosts ]
        then
                printf "Create vhosts directory...\n\n"
                mkdir /etc/apache2/vhosts
        fi
        if [ -L /private/etc/apache2/vhosts/ringwebapp.local.conf ]
        then
                printf "Removing previously set 'ringwebapp.local.conf' config file...\n\n"
                rm /private/etc/apache2/vhosts/ringwebapp.local.conf
        fi
        printf "Setting new 'ringwebapp.local.conf' config file...\n\n"
        ln -s "$1/ringwebapp.local.conf" /private/etc/apache2/vhosts
fi

# add ringwebapp.local to /etc/hosts file
if ! grep -q 'ringwebapp.local' /etc/hosts; then
        sudo sh -c "printf '127.0.0.1   ringwebapp.local www.ringwebapp.local' >> /etc/hosts"
fi

# restart apache2 service to activate our ring web app
PS3='Do you run Apache official releases or XAMPP?'
options=("Apache official releases" "XAMPP")
select opt in "${options[@]}"
do
    case $opt in
        "Apache official releases")
            if [ -f /etc/apache2/apache2.conf ]
            then
                    printf "Restarting apache2 service - Ubuntu...\n\n"
                    sudo systemctl restart apache2
            fi
            if [ -f /etc/httpd/conf/httpd.conf ]
            then
                    printf "Reloading apache2 service - Fedora...\n\n"
                    sudo systemctl reload httpd.service
            fi
            if [ -f /etc/apache2/httpd.conf ]
            then
                    printf "Restarting apache2 service - MacOSX...\n\n"
                    sudo apachectl restart
            fi
            break
            ;;
        "XAMPP")
            if [ -f /opt/lampp/lampp ]
            then
                    printf "Restarting apache service - XAMPP in Linux...\n\n"
                    sudo /opt/lampp/lampp stop
                    sudo /opt/lampp/lampp start
            fi
            if [ -f /Applications/XAMPP/xamppfiles/xampp ]
            then
                    printf "Restarting apache service - XAMPP in MacOSX...\n\n"
                    sudo /Applications/XAMPP/xamppfiles/xampp stop
                    sudo /Applications/XAMPP/xamppfiles/xampp start
            fi
            break
            ;;
    esac
done

printf "Saving the path of the lastly set project folder\n\n"
printf "$2" > "$1/lastrundirpath.txt"

printf "Setting all '.ring' files to be executable in the project\n\n"
sudo find $2 -name "*.ring" -exec chmod 755 {} \;


printf '\n\nYou can run the app now\nPress enter to continue'
read enter

