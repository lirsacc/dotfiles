#! /usr/bin/env bash

# Populate host file with the ip of the running docker machines
# A machine with name `machine` will be aliased as `machine.docker`

running=($(docker-machine ls | grep Running | awk '{ print $1 }'))

# Ask for the administrator password upfront (/etc/hosts requires it)
sudo -v
# Keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

for i in "${running[@]}"; do
    ip=$(docker-machine ip $i)
    echo "Adding $ip for machine $i"
    sed -i '/'$ip'/d' /etc/hosts  # remove line matching ip
    echo "$ip $i.docker" | sudo tee -a /etc/hosts  #insert ip/host on last line
done
