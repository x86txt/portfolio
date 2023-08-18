#!/bin/bash

#
# brute force script to compile nginx with geoip2 module
# todo: add interactive download removal handler
#

latestVer=$1

# check if we got the desired nginx version as an argument and if not, exit
if [ $# -eq 0 ];
then
        echo -e ""
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mno arguments provided!"
        echo -e "usage:   compile-nginx.sh <nginx-version>"
        echo -e "example: compile-nginx.sh nginx-1.25.2"
        echo -e ""
        exit 1
fi

# download archive from nginx.org
echo -e "\e[90m[\e[32m*\e[90m] \e[39mdownloading ${latestVer}.tar.gz"
if /usr/bin/wget "http://nginx.org/download/${latestVer}.tar.gz" > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39marchive download successful, proceeding"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39marchive download failed, aborting!"
        exit 1
fi

# download signature from nginx.org
echo -e "\e[90m[\e[32m*\e[90m] \e[39mdownloading ${latestVer}.tar.gz.asc"
if /usr/bin/wget "http://nginx.org/download/${latestVer}.tar.gz.asc" > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39msignature download successful, proceeding"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39msignature download failed, aborting!"
        exit 1
fi

# verify integrity of archive
echo -e "\e[90m[\e[32m*\e[90m] \e[39mverifying archive integrity"
if /usr/bin/gpg --verify ${latestVer}.tar.gz.asc ${latestVer}.tar.gz > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mfile integrity is valid!"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mfile integrity failed!"
        exit 1
fi

# clone geoip2 git repository
echo -e "\e[90m[\e[32m*\e[90m] \e[39mcloning geoip2 git repository to /tmp"
if /usr/bin/git clone https://github.com/leev/ngx_http_geoip2_module.git /tmp/ngx_http_geoip2_module > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mclone of geoip2 repository successful!"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mclone of geoip2 repository failed!"
        exit 1
fi

# extract archive and enter extracted directory
echo -e "\e[90m[\e[32m*\e[90m] \e[39mextracting nginx archive and entering extracted directory"
if /usr/bin/tar zxf ${latestVer}.tar.gz && cd ${latestVer} > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mextraction successful!"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mextraction failed!"
        exit 1
fi

# run configure with desired modules
echo -e "\e[90m[\e[32m*\e[90m] \e[39mrunning configure"
if ./configure --with-compat --add-dynamic-module=/tmp/ngx_http_geoip2_module > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mconfiguration run successful!"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mconfiguration run failed!"
        exit 1
fi

# make and copy module to nginx modules folder
echo -e "\e[90m[\e[32m*\e[90m] \e[39mmaking geoip2 module"
if /usr/bin/make -j$(nproc) modules > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mmake successful!"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mmake failed!"
        exit 1
fi

# copy module to nginx modules folder
echo -e "\e[90m[\e[32m*\e[90m] \e[39mcopying geoip2 module to nginx folder"
if /usr/bin/cp -f objs/ngx_http_geoip2_module.so /etc/nginx/modules/ > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mcopy successful!"
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mcopy failed!"
        exit 1
fi

# test module and restart nginx
echo -e "\e[90m[\e[32m*\e[90m] \e[39mtesting nginx module"
if /usr/sbin/nginx -t > /dev/null 2>&1;
then
        echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mmodule test successful, restarting nginx!"
        if /usr/bin/systemctl restart nginx > /dev/null 2>&1;
        then
                echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mrestart successful!"
        else
                echo -e "\e[90m[\e[31mX\e[90m] \e[39mrestart failed!"
                exit 1
        fi
else
        echo -e "\e[90m[\e[31mX\e[90m] \e[39mmodule test failed!"
        exit 1
fi

# cleanup
echo -e "\e[90m[\e[32m\xE2\x9C\x94\e[90m] \e[39mplease remove the downloaded files manually!"
exit 0
