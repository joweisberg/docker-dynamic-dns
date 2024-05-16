#!/bin/bash

while true; do

  if [ -z "$SERVICE" ]; then
    echo "No service was set. Use -e=noip|dyndns|duckdns|google|freedns|ovh"
    exit 30
  fi
  if [ -z "$USER" ]; then
    echo "No user was set. Use -u=username"
    exit 10
  fi
  if [ -z "$PASSWORD" ]; then
    echo "No password was set. Use -p=password"
    exit 20
  fi
  if [ -z "$HOSTNAME" ]; then
    echo "No host name. Use -h=host.example.com"
    exit 30
  fi
  if [ -n "$DETECTIP" ]; then
    IP=$(wget -qO- "http://myexternalip.com/raw")

    if [ -n "$UPDATEIPV6" ]; then
      IPV6=$(wget -q --output-document - http://checkipv6.dyndns.com/ | grep -o "[0-9a-f\:]\{8,\}")
    fi
  fi
  if [ -n "$DETECTIP" ] && [ -z $IP ]; then
    RESULT="Could not detect external IP."
  fi
  if [[ $INTERVAL != [0-9]* ]]; then
    echo "Interval is not an integer."
    exit 35
  fi


  AUTHTOKEN=0
  case "$SERVICE" in
    noip)
      SERVICEURL="dynupdate.no-ip.com/nic/update?hostname=${HOSTNAME}&myip=${IP}"
      URL="https://$USER:$PASSWORD@$SERVICEURL"
      ;;
    dyndns)
      SERVICEURL="members.dyndns.org/v3/update?hostname=${HOSTNAME}&myip=${IP}"
      ;;
    duckdns)
      AUTHTOKEN=1
      SERVICEURL="www.duckdns.org/update?domains=${HOSTNAME}&token=${PASSWORD}&ip=${IP}"
      SERVICEURL_V6="www.duckdns.org/update?domains=${HOSTNAME}&token=${PASSWORD}&ip=${IP}&ipv6=${IPV6}"
      ;;
    google)
      SERVICEURL="domains.google.com/nic/update?hostname=${HOSTNAME}&myip=${IP}"
      ;;
    freedns)
      SERVICEURL="freedns.afraid.org/nic/update?hostname=${HOSTNAME}&myip=${IP}"
      ;;
    ovh)
      SERVICEURL="www.ovh.com/nic/update?system=dyndns&hostname=${HOSTNAME}&myip=${IP}"
      ;;
  esac
  

  USERAGENT="User-Agent: no-ip shell script/1.0 mail@mail.com"
  AUTHHEADER="Authorization: Basic $(echo -n "$USER:$PASSWORD" | base64)"
  
  [ -n "$URL" ] && URL="https://$SERVICEURL"
  if [ -n "$UPDATEIPV6" ]; then
    if [ -n "$SERVICEURL_V6" ]; then
      URL="https://$SERVICEURL_V6"
    else
      URL="${URL}&myipv6=$IPV6"
    fi
  fi


  if [ $AUTHTOKEN -eq 0 ]; then
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] curl -H \"$USERAGENT\" -H \"$AUTHHEADER\" $URL"
    RESULT=$(curl -sS -H "$USERAGENT" -H "$AUTHHEADER" $URL)
  else
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] curl $URL"
    RESULT=$(curl -sS $URL)
  fi
  echo $RESULT
  if [ $INTERVAL -eq 0 ]; then
    break
  else
    sleep "${INTERVAL}m"
  fi
done

exit 0
