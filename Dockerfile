FROM ubuntu:22.04

# Get latest updates
RUN apt-get update -y
# Install java
RUN apt-get install default-jre -y
# Install virtual screen
RUN apt-get install xvfb -y
# Install wget
RUN apt-get install wget -y

# Download DreamBot client
RUN wget https://dreambot.org/DBLauncher.jar

# Make folder for scripts
RUN mkdir -p /root/DreamBot/Scripts/
# Download PuroPuroBoy
RUN wget -qO /root/DreamBot/Scripts/PuroPuroBoy-1.0.0-dep-included.jar https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroBoy-1.0.0-dep-included.jar

# Make folder for configs
RUN mkdir -p /root/DreamBot/Scripts/Bun/AutomationTool
# Download automation script
RUN wget -qO /root/DreamBot/Scripts/Bun/AutomationTool/puropuroboyautomation.cfg https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/puropuroboyautomation.cfg

# Make client executable
RUN chmod u+x DBLauncher.jar

# Run initial client build and timeout after the files have been loaded
# Pipe command so exit codes are ignored (timeout returns ecode 124)
RUN timeout 15 xvfb-run java -jar DBLauncher.jar || :

# Run start script on startup
CMD wget -O - https://github.com/Bryan1337/puropuroboyclient/raw/master/script/start.sh | sh
