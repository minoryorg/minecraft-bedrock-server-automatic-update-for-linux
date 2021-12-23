#!/bin/bash
##
## Automated Minecraft Bedrock Server Updater for Linux
## Created by Minory, Jun 30, 2021
##

# The directory holding your Bedrock server files
cd /mnt/nas/bedrock-server

# Randomizer for user agent
RandNum=$(echo $((1 + $RANDOM % 5000)))

URL=`curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.33 (KHTML, like Gecko) Chrome/90.0.$RandNum.212 Safari/537.33" https://minecraft.net/en-us/download/server/bedrock/ 2>/dev/null | grep bin-linux | sed -e 's/.*<a href=\"\(https:.*\/bin-linux\/.*\.zip\).*/\1/'`

# Verify if the DOWNLOAD and SERVER destinations exist. Create if it doesn't
if [ -f ./${URL##*/} ]; then
  exit 1
else
  # Process kill
  pkill bedrock_server

  # Backup files
  cp ./server.properties ./backup/server.properties
  cp ./permissions.json ./backup/permissions.json
  cp ./whitelist.json ./backup/whitelist.json

  # Get new bedrock server from web site
  wget -q ${URL}
  unzip -o ${URL##*/} 2>&1 > /dev/null

  # Return files
  cp ./backup/server.properties ./server.properties
  cp ./backup/permissions.json ./permissions.json
  cp ./backup/whitelist.json .whitelist.json

  # Start process
  ./bedrock_server.sh
fi

exit 0
