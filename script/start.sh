#!/bin/bash

# Fetch the client credentials from the API and export them as environment variables
$(wget -qO- https://api.overdu.in/client/inactive | awk -F':' "{printf \"export CLIENT_EMAIL=%s\\nexport CLIENT_PASSWORD=%s\\n\", \$1, \$2}")

echo "----CLIENT CREDENTIALS----"
echo $CLIENT_EMAIL
echo $CLIENT_PASSWORD
echo "----DB CREDENTIALS----"
echo $DB_USERNAME
echo $DB_PASSWORD
echo "--------"

# Make folder for scripts
mkdir -p /root/DreamBot/Scripts/
# Download PuroPuroBoyManager
wget -qO /root/DreamBot/Scripts/PuroPuroBoyManager.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroBoyManager.jar
# Download PuroPuroBoy
wget -qO /root/DreamBot/Scripts/PuroPuroBoy.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroBoy.jar

# Make folder for configs
mkdir -p /root/DreamBot/Scripts/Bun/AutomationTool
# Download automation script
wget -qO /root/DreamBot/Scripts/Bun/AutomationTool/puropuroautomation.cfg https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/puropuroautomation.cfg

# echo xvfb-run java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "PuroPuroBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "f2p"

# Forward local port to mule server
# TODO replace ip with env variable
nohup socat TCP-LISTEN:6565,fork,reuseaddr TCP:172.31.30.227:6565 >/dev/null 2>&1 &

# Start client
echo "Starting PuroPuroBoyManager"
xvfb-run java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "PuroPuroBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "f2p"
