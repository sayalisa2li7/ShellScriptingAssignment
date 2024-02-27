#!/bin/bash

# Function to update the sig2.conf file
update_conf_file() {
    local component=$1
    local scale=$2
    local view=$3
    local count=$4

    # Create a temporary file for modification
    tmp_file="sig2_tmp.conf"

    # If the entry exists, replace the count value
    if grep -q "^$view ; $scale ; $component ; ETL ; vdopia-etl=" "sig2.conf"; then
        sed "/^$view ; $scale ; $component ; ETL ; vdopia-etl=/s/[0-9]\+/$count/" "sig2.conf" > "$tmp_file"
    else
        # If the entry doesn't exist, append the new entry
        echo "$view ; $scale ; $component ; ETL ; vdopia-etl=$count" > "$tmp_file"
    fi

    # Overwrite the original file with the modified content
    mv "$tmp_file" "sig2.conf"
}

# Prompt user for input
while true; do
    read -p "Enter View [Auction/Bid]: " view_input
    view_input=$(echo "$view_input" | tr '[:upper:]' '[:lower:]') # Convert input to lowercase
    case "$view_input" in
        "auction") view="vdopiasample" ;;
        "bid") view="vdopiasample-bid" ;;
        *)
            echo "Invalid input."
            continue
            
while true; do
    read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
    component=$(echo "$component" | tr '[:upper:]' '[:lower:]') # Convert input to lowercase
    case "$component" in
        "ingestor" | "joiner" | "wrangler" | "validator") break ;;
        *)
            echo "Invalid input."
            ;;
    esac
done

while true; do
    read -p "Enter Scale [MID/HIGH/LOW]: " scale
    scale=$(echo "$scale" | tr '[:upper:]' '[:lower:]') # Convert input to lowercase
    case "$scale" in
        "mid" | "high" | "low") break ;;
        *)
            echo "Invalid input."
            ;;
    esac
done

while true; do
    read -p "Enter Count [single digit number]: " count
    if [[ "$count" =~ ^[0-9]$ ]]; then
        break
    else
        echo "Invalid input."
    fi
done

# Update the conf file
update_conf_file "$component" "$scale" "$view" "$count"
echo "File updated successfully."
            ;;
    esac
    break
done
