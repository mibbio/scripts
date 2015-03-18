#!/bin/bash

## Colors
RESET=$(tput sgr0)
BOLD=$(tput bold)
G=$(tput setaf 2)
B=$(tput setaf 4)

## Variables
location=$(curl -s ipinfo.io/country)
link='https://www.archlinux.org/mirrorlist/'
options="country=${location}&protocoll=http&protocoll=https&use_mirror_status=on"

echo "${BOLD}${B}>> ${G}Getting updated mirrorlist for '${location}' ...${RESET}"
curl -s ${link} --data ${options} | sed -e '/## Score/d; s/#S/S/g' | sudo tee ~/testlist > /dev/null
echo -e "\n${BOLD}${B}>> ${G}New mirrorlist:${RESET}"
cat /etc/pacman.d/mirrorlist
