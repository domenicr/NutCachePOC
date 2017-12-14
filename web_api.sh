#!/bin/bash

ENVIRONMENT="$1"
URI="$2"
APP_ID="9G6KcE5ESOUYcFi6i8kL"
APP_KEY="sFGz4IemQJRHpWTeQOwQVNuEhuHUrx5ttOi0JzUc"
BASIC_AUTH_STAGING="YWRtaW5AbnV0Y2FjaGUuY29tOkR5bmFjb20xMjM="
BASIC_AUTH_PROD="YWRtaW5AbnV0Y2FjaGUuY29tOk51dGNAY2hlV2ViXzk5"
METHOD="GET"
TIMESTAMP=$(date +'%s')
NONCE=$(uuidgen)
AUTHENTICATION_SCHEME="nut"

if [ "$ENVIRONMENT" == "PROD" ]
then
	BASIC_AUTH="$BASIC_AUTH_PROD"
else
	BASIC_AUTH="$BASIC_AUTH_STAGING"
fi

function main {	
    URI=$(python2 -c "import sys, urllib as ul; print ul.quote_plus('$URI')")
    
    SIGNATURE=$(printf "%s%s%s%s%s%s" "$BASIC_AUTH" "$APP_ID" "$METHOD" "${URI,,}" "$TIMESTAMP" "$NONCE")	
    REQUEST_SIGNATURE=$(dotnet /var/nutcache/webapi.core/bin/Debug/netcoreapp1.0/webapi.core.dll $SIGNATURE)    
    AUTH_STRING=$(printf "%s %s:%s:%s:%s:%s" "$AUTHENTICATION_SCHEME" "$BASIC_AUTH" "$APP_ID" "$REQUEST_SIGNATURE" "$NONCE" "$TIMESTAMP")        
    echo $AUTH_STRING    
}

main