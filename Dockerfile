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

# Make folder for configs
RUN mkdir -p /root/DreamBot/Data/Bun/AutomationTool/
# Download automation script
RUN wget https://raw.githubusercontent.com/Bryan1337/puropuroboyclient/master/automation/puropuroboyautomation.cfg
# Copy automation script
COPY ./puropuroboyautomation.cfg /root/DreamBot/Data/Bun/AutomationTool/puropuroboyautomation.cfg

# Make folder for scripts
RUN mkdir -p /root/DreamBot/Scripts/
# Download PuroPuroBoy
RUN wget https://github.com/Bryan1337/puropuroboyclient/raw/master/jar/PuroPuroBoy-1.0.0-dep-included.jar
# Copy jar
COPY ./PuroPuroBoy-1.0.0-dep-included.jar /root/DreamBot/Scripts/PuroPuroBoy-1.0.0-dep-included.jar

# Fetch the client credentials from the API
RUN /bin/sh -c 'response=$(wget -qO- https://api.overdu.in/client/inactive | awk -F":" "{printf \"export CLIENT_EMAIL=%s\\nexport CLIENT_PASSWORD=%s\\n\", \$1, \$2}"); eval "$response";'
# Make client executable
RUN chmod u+x DBLauncher.jar
# Run initial client build and timeout after the files have been loaded
# Pipe command so exit codes are ignored (timeout returns ecode 124)
RUN timeout 15 xvfb-run java -jar DBLauncher.jar || :