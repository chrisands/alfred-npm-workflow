#!/usr/bin/env bash

urlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<strlen ; pos++ )); do
       c=${string:$pos:1}
       case "$c" in
          [-_.~a-zA-Z0-9] ) o="$c" ;;
          * )               printf -v o '%%%02x' "'$c"
       ;; esac
       encoded+="$o"
    done
    echo "$encoded"
}


query="$(urlencode "$1")"

url="$npm_registry_url/-/v1/search?text=$query&size=$result_size"

curl "$url" | jq '{ items: [.objects[].package | { title: .name, subtitle: (.description // ""), arg: (.links.repository // .links.npm), quicklookurl: (.links.homepage // .links.npm) }] }'
