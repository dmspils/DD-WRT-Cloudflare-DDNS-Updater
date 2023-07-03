#! /bin/sh

PATH=/bin:/usr/bin:/sbin:/usr/sbin

CF_CACHE=/tmp/cached-ddns.txt
CF_API_KEY=APIKEY
CF_DOMAIN=FQDN
CF_ZONE_ID=ZONEID
CF_RECORD_ID=RECORDID

update_cf() {
    local my_ip="$(nvram get wan_ipaddr)"
    local cached_ip=
    if [ -f "${CF_CACHE}" ]; then
        cached_ip="$(cat "${CF_CACHE}")"
    fi

    if [ "${my_ip}" != "${cached_ip}" ]; then

        curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONE_ID}/dns_records/${CF_RECORD_ID}" -H "Authorization: Bearer ${CF_API_KEY}" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"${CF_DOMAIN}\",\"content\":\"${my_ip}\",\"ttl\":120,\"proxied\":false}" >/tmp/curl.out
        
        cat /tmp/curl.out
        if grep -Eq "^(true)" /tmp/curl.out; then
            printf "%s" "${my_ip}" >"${CF_CACHE}"
        fi
        rm -f /tmp/curl.out
    fi
}

case "${1}" in
    update-cf)
        update_cf
        ;;

    *)
        echo "Unknown command" 1>&2
        exit 1
        ;;
esac
