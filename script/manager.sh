#!/bin/sh

LOG_DIR="/root/DreamBot/Logs"

# Start watching for new files and changes in the directory
inotifywait -m -e create -e modify "$LOG_DIR" | while read -r event; do

	echo "NE $event"

    file_path=$(echo "$event" | awk '{print $3}')  # Get the path of the changed/created file

    if [ -f "$file_path" ]; then  # Check if the path points to a regular file

		echo "NL $new_line"

        new_line=$(tail -n 1 "$file_path")  # Read the last line of the file

        if echo "$new_line" | grep -q "BANNED"; then

            echo "Found 'BANNED' in log: $new_line"

            # Perform further actions here if needed
        fi
    fi
done
