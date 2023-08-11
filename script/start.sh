#!/bin/bash

# Fetch the client credentials from the API and export them as environment variables
$(wget -qO- https://api.overdu.in/client/inactive | awk -F':' "{printf \"export CLIENT_EMAIL=%s\\nexport CLIENT_PASSWORD=%s\\n\", \$1, \$2}")

# Start client
xvfb-run -a java -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "BNY Automation Tool" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_USERNAME" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "members" -params config=puropuroboyautomation