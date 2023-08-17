#!/bin/sh

LOG_DIR="/root/DreamBot/Logs"

# Start watching for new files and changes in the directory
inotifywait -m -e create -e modify "$LOG_DIR" | while read -r event; do

    file_path=$(echo "$event" | awk '{print $3}')  # Get the path of the changed/created file

    if [ -f "$LOG_DIR/$file_path" ]; then  # Check if the path points to a regular file

        new_line=$(tail -n 1 "$LOG_DIR/$file_path")  # Read the last line of the file

        if echo "$new_line" | grep -q "DISABLED"; then

            echo "Found 'DISABLED' in log: $new_line"

			exit 0
            # Perform further actions here if needed
        fi
    fi
done
