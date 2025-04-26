#!/bin/bash

DOMAIN_NAME="<Your domain/sub-domain>"
TAG_NAME="<Your tag of the machine>"
SUB_DOMAIN_PREFIX="<Your Subdomain Prefix>"
ROUTE53_MAIN_DOMAIN_ID=$(aws route53 list-hosted-zones | jq -r --arg domain "$DOMAIN_NAME" '.HostedZones[] | select(.Name==$domain) | .Id')
FULL_DOMAIN="${SUB_DOMAIN_PREFIX}.${DOMAIN_NAME}"


TOKEN=$(curl -s -X PUT -H "X-aws-ec2-metadata-token-ttl-seconds: 3600" http://169.254.169.254/latest/api/token)

IP_PUBLIC=$(curl http://169.254.169.254/latest/meta-data/public-ipv4 -H "X-aws-ec2-metadata-token: $TOKEN")

CURRENT_ROUTE53_IP=$(aws route53 list-resource-record-sets --hosted-zone-id "$ROUTE53_MAIN_DOMAIN_ID" \
  | jq -r --arg name "$FULL_DOMAIN" '.ResourceRecordSets[] | select(.Name==$name) | .ResourceRecords[].Value')

if [[ "$IP_PUBLIC" != "$CURRENT_ROUTE53_IP" && -n "$IP_PUBLIC" ]]; then
  aws route53 change-resource-record-sets --hosted-zone-id "$ROUTE53_MAIN_DOMAIN_ID" --change-batch "$(
    cat <<EOF
{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "${FULL_DOMAIN}",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "$IP_PUBLIC"
          }
        ]
      }
    }
  ]
}
EOF
  )"
else
  echo "No update needed."
fi
