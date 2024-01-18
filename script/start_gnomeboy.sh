#!/bin/sh

# Make folder for logs
mkdir -p /root/DreamBot/Logs/
# Make folder for scripts
mkdir -p /root/DreamBot/Scripts/
# Download GnomeRestaurantBoyManager
wget -qO /root/DreamBot/Scripts/GnomeRestaurantBoyManager.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/GnomeRestaurantBoyManager.jar
# Download GnomeRestaurantBoy
wget -qO /root/DreamBot/Scripts/GnomeRestaurantBoy.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/GnomeRestaurantBoy.jar

# Make folder for configs
mkdir -p /root/DreamBot/Scripts/Bun/AutomationTool
# Download automation script
wget -qO /root/DreamBot/Scripts/Bun/AutomationTool/gnomerestaurantautomation.cfg https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/gnomerestaurantautomation.cfg

# TODO replace ip with env variable

# Incoming mule (P2P)
nohup socat TCP-LISTEN:6565,fork,reuseaddr TCP:83.80.143.93:6565 >/dev/null 2>&1 &
# Outgoing mule (Needs to be F2P)
nohup socat TCP-LISTEN:6564,fork,reuseaddr TCP:83.80.143.93:6564 >/dev/null 2>&1 &
# Fetch the manager script
wget --no-cache -qO /root/manager.sh https://github.com/Bryan1337/puropuroboyclient/raw/master/script/manager.sh
# Make it executable
chmod +x /root/manager.sh

# Fetch latest dreambot client
timeout 15 xvfb-run -a java -jar DBLauncher.jar || :

# Run the manager in a different thread
nohup /root/manager.sh &

# Fetch latest dreambot client
timeout 15 xvfb-run -a java -jar DBLauncher.jar || :

# Start client
echo "Starting GnomeRestaurantBoyManager"

# Run script
xvfb-run -a java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -menuManipulation  -script "GnomeRestaurantBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -world-hop-on-login-error -render "none" -fps 5 -no-fresh -world "f2p"
