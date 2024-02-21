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

# Ask for user inputs
read -p "Enter Component Name [INGESTOR/JOINER/WRANGLER/VALIDATOR]: " component
validate_input "$component" "INGESTOR/JOINER/WRANGLER/VALIDATOR" || { echo "Invalid input."; exit 1; }

read -p "Enter Scale [MID/HIGH/LOW]: " scale
validate_input "$scale" "MID/HIGH/LOW" || { echo "Invalid input."; exit 1; }

read -p "Enter View [Auction/Bid]: " view
validate_input "$view" "Auction/Bid" || { echo "Invalid input."; exit 1; }

read -p "Enter Count [single digit number]: " count
if ! [[ "$count" =~ ^[0-9]$ ]]; then
    echo "Invalid input."
    exit 1
fi

# Temporarily store the modified lines
modified_lines=()
while IFS= read -r line; do
    if [[ "$line" == "$view ; $scale ; $component ; ETL ; vdopia-etl="* ]]; then
        modified_line=$(echo "$line" | sed "s/vdopia-etl=[0-9]\+/vdopia-etl=$count/")
        modified_lines+=("$modified_line")
    else
        modified_lines+=("$line")
    fi
done < "sig.conf"

# Write the modified lines back to the file
printf "%s\n" "${modified_lines[@]}" > "sig.conf"

echo "File updated successfully."
