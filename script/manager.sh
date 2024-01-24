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

		if echo "$new_line" | grep -q "Should World Hop on Login Error is active" && !echo "$new_line" | grep -q "MEMBERS_AREA"; then

            echo "Account login blocked. Adding 15 minute delay and killing script..."

			curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"$CLIENT_EMAIL\"}" "https://api.overdu.in/client/login-blocked"

			java_pid=$(pidof java)

			kill "$java_pid"
		fi

		if echo "$new_line" | grep -q "Not enough space"; then

			echo "Too much memory used. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"
		fi

		if echo "$new_line" | grep -q "error_game"; then

			echo "Client crashed. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"
		fi

		if echo "$new_line" | grep -q "You need to be logged in before starting a script!"; then

			echo "Client logged out. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"

		fi

		if echo "$new_line" | grep -q "MEMBERS_WORLD"; then

			echo "Client membership ran out. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"

		fi

		if echo "$new_line" | grep -q "java.lang.AssertionError"; then

			echo "Client crashed. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"
		fi

		if echo "$new_line" | grep -q "SERVER_UPDATED"; then

			  echo "System update! Adding random delay and killing script..."

			curl -X POST -H "Content-Type: application/json" -d "{\"email\":\"$CLIENT_EMAIL\"}" "https://api.overdu.in/client/system-update"

			java_pid=$(pidof java)

			kill "$java_pid"
		fi
    fi
done &

while true; do

    response=$(wget -qO- "https://api.overdu.in/client/activity?email=$CLIENT_EMAIL")

    echo "Fetching client activity from API..."

    if [ -n "$response" ]; then

        if echo "$response" | grep -q "INACTIVE"; then

			echo "Client has been inactive for 5 minutes, something must have gone wrong. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"
		fi

		if echo "$response" | grep -q "LOCKED"; then

			echo "Client is locked. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"
		fi

		if echo "$response" | grep -q "DISABLED"; then

			echo "Client is disabled. Killing script..."

			java_pid=$(pidof java)

			kill "$java_pid"
		fi
    fi

    sleep 30 # Add a small delay before the next iteration
done
