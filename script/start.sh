#!/bin/sh

# Fetch the client credentials from the API and export them as environment variables
# This will block the script until a client is found
while true; do

    response=$(wget -qO- "https://api.overdu.in/client/inactive?consume=1&origin=$CLIENT_ORIGIN")

    echo "Fetching inactive client from API... with origin $CLIENT_ORIGIN"

    if [ -n "$response" ]; then
        echo "Found inactive client, writing to environment variables..."

        CLIENT_EMAIL=$(echo "$response" | cut -d ':' -f 1)
        CLIENT_PASSWORD=$(echo "$response" | cut -d ':' -f 2)

        export CLIENT_EMAIL
        export CLIENT_PASSWORD

        break
    fi

    echo "No inactive clients found, waiting 5 seconds before retrying..."
    sleep 5  # Add a small delay before the next iteration
done

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
wget -qO /root/DreamBot/Scripts/PuroPuroBoyManager.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroJarBoyManager.jar
# Download PuroPuroBoy
wget -qO /root/DreamBot/Scripts/PuroPuroBoy.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroJarBoy.jar

# Make folder for configs
mkdir -p /root/DreamBot/Scripts/Bun/AutomationTool
# Download automation script
wget -qO /root/DreamBot/Scripts/Bun/AutomationTool/puropurojarautomation.cfg https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/puropurojarautomation.cfg

# Forward local port to mule server
# TODO replace ip with env variable
nohup socat TCP-LISTEN:6565,fork,reuseaddr TCP:83.80.143.93:6565 >/dev/null 2>&1 &

# Fetch the manager script
wget -qO /root/scripts/manager.sh https://github.com/Bryan1337/puropuroboyclient/raw/master/script/manager.sh

# Run the manager in a different thread
nohup /root/scripts/manager.sh >/dev/null 2>&1 &

# Fetch latest dreambot client
timeout 15 xvfb-run java -jar DBLauncher.jar || :

# Start client
echo "Starting PuroPuroJarBoyManager"

# Run script
xvfb-run java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -menuManipulation  -script "PuroPuroJarBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -fps 5 -no-fresh -world "f2p"
