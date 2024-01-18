#!/bin/sh

# Fetch the client credentials from the API and export them as environment variables
# This will block the script until a client is found
while true; do

    response=$(wget -qO- "https://api.overdu.in/client/inactive?consume=1&origin=$CLIENT_ORIGIN")

    echo "Fetching inactive client from API with origin $CLIENT_ORIGIN ..."

    if [ -n "$response" ]; then
        echo "Found inactive client, writing to environment variables..."

        CLIENT_EMAIL=$(echo "$response" | cut -d ':' -f 1)
        CLIENT_PASSWORD=$(echo "$response" | cut -d ':' -f 2)

        export CLIENT_EMAIL
        export CLIENT_PASSWORD

        break
    fi

    echo "No inactive clients found, waiting 5 seconds before retrying..."
    sleep 5  # Add a small delay before the next iteration
done

echo "----CLIENT CREDENTIALS----"
echo $CLIENT_EMAIL
echo $CLIENT_PASSWORD
echo "----DB CREDENTIALS----"
echo $DB_USERNAME
echo $DB_PASSWORD
echo "--------"

if [ "$SCRIPT_NAME" = "JAR_GENERATOR" ]; then
    wget --no-cache -O - https://github.com/Bryan1337/puropuroboyclient/raw/master/script/start_jargeneratorboy.sh | sh
elif [ "$SCRIPT_NAME" = "GNOME_BOY" ]; then
    wget --no-cache -O - https://github.com/Bryan1337/puropuroboyclient/raw/master/script/start_gnomeboy.sh | sh
elif [ "$SCRIPT_NAME" = "JAR_SWAPPER" ]; then
    wget --no-cache -O - https://github.com/Bryan1337/puropuroboyclient/raw/master/script/start_jarboy.sh | sh
else
    wget --no-cache -O - https://github.com/Bryan1337/puropuroboyclient/raw/master/script/start_hunterboy.sh | sh
fi
