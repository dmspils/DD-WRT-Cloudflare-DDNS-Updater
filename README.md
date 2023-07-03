# DD-WRT-Cloudflare-DDNS-Updater
CloudFlare Dynamic DNS updater for DD-WRT

Pre-req:

Need the recordId from the CloudFlare API (zone ID comes from the gui):

curl -s -X GET "https://api.cloudflare.com/client/v4/zones/ZONEID/dns_records?type=A&name=FQDN" \
    -H "Authorization: Bearer API_TOKEN" \
    -H "Content-Type: application/json"

  

Cron job:

*/5 * * * * root /tmp/.rc_custom update-cf
