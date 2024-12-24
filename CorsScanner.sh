#!/bin/bash

log_error() {
    echo "$1" >> corserrors.txt
}

scan_cors() {
    local url=$1
    echo -e "\nScanning $url..."

    response=$(curl -s --max-time 5 -D - -o /dev/null "$url" -H "Origin: evil.com" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:99.0) Gecko/20100101 Firefox/99.0")
    if [[ $? -ne 0 ]]; then
        message="[${url}] Error: Request timed out after 5 seconds."
        echo "$message"
        log_error "$message"
        return
    fi

    aca_origin=$(echo "$response" | grep -i "Access-Control-Allow-Origin" | awk '{print $2}' | tr -d '\r')
    aca_credentials=$(echo "$response" | grep -i "Access-Control-Allow-Credentials" | awk '{print $2}' | tr -d '\r')

    if [[ -n "$aca_origin" ]]; then
        echo "Access-Control-Allow-Origin: $aca_origin"
        if [[ "$aca_origin" == "evil.com" ]]; then
            message="[${url}] vulnerability: Access-Control-Allow-Origin allowed evil.com Origin."
            echo "$message"
            log_error "$message"
        fi
    else
        message="[${url}] Access-Control-Allow-Origin not found."
        echo "$message"
    fi

    if [[ "$aca_credentials" == "true" ]]; then
        message="[${url}] Vulnerability: Access-Control-Allow-Credentials is set to true."
        echo "$message"
        if [[ "$aca_origin" == "evil.com" ]]; then
            message="[${url}] Exploitable: Server accepts credentials from malicious origins."
            echo "$message"
            log_error "$message"
        fi
    else
        echo "[-] Access-Control-Allow-Credentials is not set or set to false."
    fi
}

if [[ "$1" == "-u" && -n "$2" ]]; then
    scan_cors "$2"
elif [[ "$1" == "-i" && -n "$2" ]]; then
    if [[ -f "$2" ]]; then
        while IFS= read -r url; do
            scan_cors "$url"
        done < "$2"
    else
        message="[Error] File '$2' not found."
        echo "$message"
        log_error "$message"
    fi
else
    echo "Usage:"
    echo "  $0 -u <URL>       Scan a single URL"
    echo "  $0 -i <file>      Scan multiple URLs from a file"
    exit 1
fi
