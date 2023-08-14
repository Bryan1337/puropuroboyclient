#!/bin/sh

# Fetch the client credentials from the API and export them as environment variables
# This will block the script until a client is found
while true; do
    response=$(wget -qO- https://api.overdu.in/client/inactive?consume=1)

    echo "Fetching inactive client from API..."

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
wget -qO /root/DreamBot/Scripts/PuroPuroBoyManager.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroBoyManager.jar
# Download PuroPuroBoy
wget -qO /root/DreamBot/Scripts/PuroPuroBoy.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroBoy.jar

# Make folder for configs
mkdir -p /root/DreamBot/Scripts/Bun/AutomationTool
# Download automation script
wget -qO /root/DreamBot/Scripts/Bun/AutomationTool/puropuroautomation.cfg https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/puropuroautomation.cfg

# Forward local port to mule server
# TODO replace ip with env variable
nohup socat TCP-LISTEN:6565,fork,reuseaddr TCP:172.31.22.46:6565 >/dev/null 2>&1 &

# Start client
echo "Starting PuroPuroBoyManager"
# echo xvfb-run java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "PuroPuroBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "f2p"
xvfb-run java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -script "PuroPuroBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -no-fresh -world "memebers"
