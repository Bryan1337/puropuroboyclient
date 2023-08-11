FROM ubuntu:22.04

# Get latest updates
RUN apt-get update -y
# Install java
RUN apt-get install default-jre -y
# Install virtual screen
RUN apt-get install xvfb -y
# Install wget
RUN apt-get install wget -y
# Install git
RUN apt-get install git -y
# Download client
RUN wget https://dreambot.org/DBLauncher.jar
# Make client executable
RUN chmod u+x DBLauncher.jar
# Run initial client build and timeout after the files have been loaded
# Pipe command so exit codes are ignored (timeout returns ecode 124)
RUN timeout 15 xvfb-run java -jar DBLauncher.jar || :
# Make folder for configs
RUN mkdir -p /root/DreamBot/Data/Bun/AutomationToolEarlyAccess/
RUN mkdir -p /root/DreamBot/Data/Bun/Default/
# Copy automation script
COPY ./configs/auto_dhide_tanner.cfg /root/DreamBot/Data/Bun/AutomationToolEarlyAccess/auto_dhide_tanner.cfg
# Copy tanner script
COPY ./configs/green_dhide_tanner_config.cfg /root/DreamBot/Data/Bun/Default/green_dhide_tanner_config.cfg
# Bash startup script
COPY ./start.sh /root/start.sh
# Clone tools repository
RUN git clone https://gitlab.com/Overduin/osrsbotting_bot_tools.git
# CD into scripts folder
WORKDIR ./osrsbotting_bot_tools/bot_client_tools
# Install dependencies
RUN npm i
# Run script
CMD [".", "/root/start.sh"]