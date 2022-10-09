#!/bin/bash
user="$(whoami)"
host="$(uname -n)"

case $1 in
    "full")     printf "$user@$host";;
    "name")     printf $user;;
    "host")     printf $host;;
    *)          printf "Rick Astley"
esac
