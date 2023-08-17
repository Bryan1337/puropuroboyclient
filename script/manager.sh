#!/bin/sh

LOG_DIR="/root/DreamBot/Logs"

for log_file in "$LOG_DIR"/*; do

    tail -n 0 -F "$log_file" | while read -r line; do

        echo "GOT LINE from $log_file"

        if echo "$line" | grep -q "DISABLED"; then

            echo "Account marked as DISABLED in $log_file"
            # curl -X POST -d "name=$CLIENT_EMAIL"
        fi
    done
done