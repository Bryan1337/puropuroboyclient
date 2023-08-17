#!/bin/sh

LOG_DIR="/root/DreamBot/Logs"


tail -n 0 -F "$LOG_DIR"/* | while read -r line; do

	echo "GOT LINE"

    if echo "$line" | grep -q "DISABLED"; then

		# curl -X POST -d "name=$CLIENT_EMAIL"

        echo "Account marked as DISABLED";
    fi
done
