#!/bin/sh

LOG_DIR="/root/DreamBot/Logs"

# Start watching for new files and changes in the directory
inotifywait -m -e create -e modify "$LOG_DIR" | while read -r event; do

    file_path=$(echo "$event" | awk '{print $3}')  # Get the path of the changed/created file

    if [ -f "$LOG_DIR/$file_path" ]; then  # Check if the path points to a regular file

        new_line=$(tail -n 1 "$LOG_DIR/$file_path")  # Read the last line of the file

        if echo "$new_line" | grep -q "DISABLED"; then

            echo "Found 'DISABLED' in logs"

			curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"$CLIENT_EMAIL\"}" "https://api.overdu.in/banned"

			echo "KILLING SCRIPT"

			java_pid=$(pidof java)

			kill "$java_pid"
        fi
    fi
done
