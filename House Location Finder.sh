#!/usr/bin/env bash
# Kali Linux additional tools installation script
. helper.sh
. postinstall.sh

install_pentest(){

    if ask "Do you want to install Army Plugin?" Y; then
        print_status "Installing ArmyPlugin, Include, CMA,WOP,Anonymous,TheSteven13333"
        apt-get -y install armitage mimikatz unicornscan zenmap
        check_success
        print_notification "English: Installed, Turkish : Guncellendi Efendim."

        #This is a simple git pull of the Cortana .cna script repository available on github.
        if ! [ -d /opt/cortana ]; then
            print_status "Grabbing Armitage Cortana Scripts via github..";
            git clone http://www.github.com/rsmudge/cortana-scripts.git /opt/cortana;
            check_success;
            print_notification "Cortana scripts installed under /opt/cortana.";
        fi
    fi

    if ask "Do you want to install, TheBroundic Plugin?" Y; then
        apt-get -y install beef-xss arachni w3af
    fi

    if ask "Do you want to install, FuckerPlugin?" Y; then
        apt-get install -y veil-*
    fi

    if ask  "Do you want to install WorldWide Hacking? By Steven13333" Y; then
        apt-get install -y zaproxy owasp-mantra-ff
    fi

    if ask "Do you want to install BOOMPlugin?" Y; then
        git clone https://github.com/7a/owtf/ /tmp/owtf
        python /tmp/owtf/install/install.py
    fi



    if ask "Do you want to install TOR?, FB Like Auto Plugin To Ahmet, By Steven13333" N; then
        apt_add_source "tor"

        gpg --keyserver keys.gnupg.net --recv 886DDD89
        gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | sudo apt-key add -

        apt-get update
        apt-get install -y deb.torproject.org-keyring tor tor-geoipdb polipo vidalia privoxy
        mv /etc/polipo/config /etc/polipo/config.orig
        wget https://gitweb.torproject.org/torbrowser.git/blob_plain/ae4aa49ad9100a50eec049d0a419fac63a84d874:/build-scripts/config/polipo.conf -O /etc/polipo/config

        service tor restart
        service polipo restart

        update-rc.d tor enable
        update-rc.d polipo enable
    fi

    if ask "Install SVN version of fuzzdb?" Y; then
        print_status "Installing SVN version of fuzzdb in /usr/share/fuzzdb and keeping it updated."
        if [ -d /usr/share/fuzzdb ]; then
            cd /usr/share/fuzzdb
            svn up
        else
            print_notification "Fuzzdb not found, installing at /usr/share/fuzzdb."
            cd /usr/share
            svn co http://fuzzdb.googlecode.com/svn/trunk fuzzdb
        fi
        print_good "Installed or updated Fuzzdb to /usr/share/fuzzdb."
    fi

}

install_mitm(){
    print_notification "Installing MITM tools.."
    apt-get install -y hamster-sidejack ferret-sidejack dsniff snarf ngrep ghost-phisher mitmf fruity-wifi bettercap

    if ask "Do you want to install Intercepter-NG?" Y; then
        print_notification "Installing dependencies"
        #install_32bit
        apt-get install unzip wget lib32ncurses5-dev -y

        print_notification "Download & unpack"
        cd /tmp
        wget http://sniff.su/Intercepter-NG.CE.05.zip
        unzip Intercepter-NG.CE.05.zip
        mv intercepter_linux /usr/bin/intercepter
        chmod +x /usr/bin/intercepter
    fi
}

# Main
if [ "${0##*/}" = "pentest.sh" ]; then
    if ask "Do you want install pentest tools?" Y; then
        install_pentest
    fi

    if ask "Do you want install MITM tools?" Y; then
        install_mitm
    fi
fi
