FROM ubuntu:22.04

# Get latest updates
RUN apt-get update -y
# Install java
RUN apt-get install default-jre -y
# Install virtual screen
RUN apt-get install xvfb -y
# Install wget
RUN apt-get install wget -y
# Install socat
RUN apt-get install socat -y

# Download DreamBot client
RUN wget https://dreambot.org/DBLauncher.jar
# Make client executable
RUN chmod u+x DBLauncher.jar
# Run initial client build and timeout after the files have been loaded
# Pipe command so exit codes are ignored (timeout returns ecode 124)
RUN timeout 15 xvfb-run java -jar DBLauncher.jar || :

# Expose mule port
EXPOSE 6565

# Run start script on startup
CMD wget -O - https://github.com/Bryan1337/puropuroboyclient/raw/master/script/start.sh | sh
