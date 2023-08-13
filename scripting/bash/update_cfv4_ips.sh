# get ipv4 list from cloudflare, validate the subnets, create an nginx config file, test the nginx config, reload nginx

#!/bin/bash

CLOUDFLARE_IPSV4="https://www.cloudflare.com/ips-v4"
CLOUDFLARE_NGINX_CONFIG="/etc/nginx/conf.d/cloudflare_ipv4.txt"
TEMP_FILE_IPV4="/tmp/cloudflare-ipv4"

# validate IPv4 CIDR addresses
validateIPv4() {

regex="^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(\/([0-9]|[1-2][0-9]|3[0-2]))$"

echo -e "  \e[90m[\e[32m*\e[90m] \e[39mvalidating ips are valid ..."
while read ip
        do
                if [[ ! "$ip" =~ $regex ]]; then
                        echo -e "  \e[90m[\e[31m*\e[90m] \e[39mFAILED. Reason: Invalid IPv4 address [$ip]"
                exit 1
        fi
done < "$TEMP_FILE_IPV4"

}

# download the ipv4 file
if [ -f /usr/bin/curl ];
then
        echo -e "  \e[90m[\e[32m*\e[90m] \e[39mdownloading cloudflare ipv4 file ..."

HTTP_STATUS=$(curl -sw '%{http_code}' -o /tmp/cloudflare-ipv4 $CLOUDFLARE_IPSV4)
        if [ "$HTTP_STATUS" -ne 200 ]; then
                echo -e "  \e[90m[\e[31m*\e[90m] \e[39mFAILED. Reason: unable to download IPv4 list [Status code: $HTTP_STATUS]"
                exit 1
        fi
else
        echo -e "  \e[90m[\e[31m*\e[90m] \e[39mFAILED. Reason: curl wasn't found on this system."
        exit 1
fi


# run the function
validateIPv4

# generate new config file
echo -e "  \e[90m[\e[32m*\e[90m] \e[39mgenerating new config file ..."
echo "# cloudFlare IP addresses" > $CLOUDFLARE_NGINX_CONFIG
echo "# > IPv4" >> $CLOUDFLARE_NGINX_CONFIG
while read ip
do
        echo "set_real_ip_from $ip;" >> $CLOUDFLARE_NGINX_CONFIG
done< "$TEMP_FILE_IPV4"
        echo "real_ip_header CF-Connecting-IP;" >> $CLOUDFLARE_NGINX_CONFIG

# Clean-up temporary files
echo -e "  \e[90m[\e[32m*\e[90m] \e[39mremoving temporary file ..."
rm $TEMP_FILE_IPV4

# test the nginx config before attempting a reload
echo -e "  \e[90m[\e[32m*\e[90m] \e[39mupdated cloudflare ipv4 file, will attempt config test and reload"
if nginx -t &>/dev/null; then
        echo -e "  \e[90m[\e[32m*\e[90m] \e[39mtest successful, gracefully reloading nginx ..."
        /usr/bin/systemctl reload nginx
else
        echo -e "  \e[90m[\e[31m*\e[90m] \e[39mnginx config test failed! check cloudflare config and re-try!"
fi
