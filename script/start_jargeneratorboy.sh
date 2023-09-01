#!/bin/sh

# Make folder for logs
mkdir -p /root/DreamBot/Logs/
# Make folder for scripts
mkdir -p /root/DreamBot/Scripts/
# Download PuroPuroBoyManager
wget --no-cache -qO /root/DreamBot/Scripts/PuroPuroJarGeneratorBoyManager.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroJarGeneratorBoyManager.jar
# Download PuroPuroBoy
wget --no-cache -qO /root/DreamBot/Scripts/PuroPuroJarGeneratorBoy.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroJarGeneratorBoy.jar

# Make folder for configs
mkdir -p /root/DreamBot/Scripts/Bun/AutomationTool
# Download automation script
wget --no-cache -qO /root/DreamBot/Scripts/Bun/AutomationTool/puropurojargeneratorautomation.cfg https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/puropurojargeneratorautomation.cfg

# Forward local port to mule server
# TODO replace ip with env variable
nohup socat TCP-LISTEN:6565,fork,reuseaddr TCP:83.80.143.93:6565 >/dev/null 2>&1 &

# Fetch the manager script
wget --no-cache -qO /root/manager.sh https://github.com/Bryan1337/puropuroboyclient/raw/master/script/manager.sh
# Make it executable
chmod +x /root/manager.sh

# Fetch latest dreambot client
timeout 15 xvfb-run java -jar DBLauncher.jar || :

# Run the manager in a different thread
nohup /root/manager.sh &

# Start client
echo "Starting PuroPuroJarGeneratorBoyManager"

# Run script
xvfb-run -a java --illegal-access=permit -jar /root/DreamBot/BotData/client.jar -lowDetail -noClickWalk -menuManipulation  -script "PuroPuroJarGeneratorBoyManager" -username "$DB_USERNAME" -password "$DB_PASSWORD" -covert -accountUsername "$CLIENT_EMAIL" -accountPassword "$CLIENT_PASSWORD" -render "none" -fps 5 -no-fresh -world "f2p"
