#!/bin/sh

LOG_DIR="/root/DreamBot/Logs"

# Start watching for new files and changes in the directory
inotifywait -m -e create -e modify "$LOG_DIR" | while read -r event; do

    file_path=$(echo "$event" | awk '{print $3}')  # Get the path of the changed/created file

    if [ -f "$LOG_DIR/$file_path" ]; then  # Check if the path points to a regular file

        new_line=$(tail -n 1 "$LOG_DIR/$file_path")  # Read the last line of the file

        if echo "$new_line" | grep -q "DISABLED"; then

            echo "Account banned! killing script..."

			curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"$CLIENT_EMAIL\"}" "https://api.overdu.in/banned"

			java_pid=$(pidof java)

			kill "$java_pid"
        fi

        if echo "$new_line" | grep -q "ACCOUNT_LOCKED"; then

            echo "Account locked! killing script..."

			curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"$CLIENT_EMAIL\"}" "https://api.overdu.in/client/locked"

			java_pid=$(pidof java)

			kill "$java_pid"
        fi

		if echo "$new_line" | grep -q "Should World Hop on Login Error is active"; then

            echo "Account login blocked. Adding 15 minute delay and killing script..."

			curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"$CLIENT_EMAIL\"}" "https://api.overdu.in/client/login-blocked"

			java_pid=$(pidof java)

			kill "$java_pid"
		fi



    fi
done
