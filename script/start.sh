#!/bin/bash

# Fetch the client credentials from the API and export them as environment variables
$(wget -qO- https://api.overdu.in/client/inactive | awk -F':' "{printf \"export CLIENT_EMAIL=%s\\nexport CLIENT_PASSWORD=%s\\n\", \$1, \$2}")

# Start client

cd /root

echo "----CLIENT CREDENTIALS----"
echo $CLIENT_EMAIL
echo $CLIENT_PASSWORD
echo "----DB CREDENTIALS----"
echo $DB_USERNAME
echo $DB_PASSWORD
echo "--------"

echo xvfb-run -a java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "BNY Automation Tool - Lifetime" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "f2p" -params config=puropuroautomation

xvfb-run -a java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "BNY Automation Tool - Lifetime" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "f2p" -params config=puropuroautomation

echo 13337
echo 13337
echo 13337
echo 13337
echo 13337
echo 13337