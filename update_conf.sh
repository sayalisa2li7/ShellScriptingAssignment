#!/bin/bash

# Function to validate user input
validate_input() {
    local input=$1
    local options=$2
    for option in ${options//\// }; do
        if [[ "$input" == "$option" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to update the sig.conf file
update_conf_file() {
    local component=$1
    local scale=$2
    local view=$3
    local count=$4

    sed -i "/^$view ; $scale ; $component ; ETL ; vdopia-etl=/s/[0-9]\+/$count/" "sig.conf"
}

# Loop until all inputs are valid
while true; do
    read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
    validate_input "$component" "INGESTOR/JOINER/WRANGLER/VALIDATOR" && break
    echo "Invalid input."
done

while true; do
    read -p "Enter Scale [MID/HIGH/LOW]: " scale
    validate_input "$scale" "MID/HIGH/LOW" && break
    echo "Invalid input."
done

while true; do
    read -p "Enter View [Auction/Bid]: " view
    validate_input "$view" "Auction/Bid" && break
    echo "Invalid input."
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
