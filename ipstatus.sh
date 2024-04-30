#!/bin/bash

# Function to display usage instructions
display_usage() {
    echo "Usage: $0 START_IP END_IP [OUTPUT_FILE]"
    echo "  START_IP    The starting IP address (e.g., 192.168.1.1)"
    echo "  END_IP      The ending IP address (e.g., 192.168.1.254)"
    echo "  OUTPUT_FILE The output CSV file (default: ip_status.csv)"
}

# Check if the number of arguments is less than 2
if [ $# -lt 2 ]; then
    display_usage
    exit 1
fi

# Read command-line arguments
START_IP="$1"
END_IP="$2"
OUTPUT_FILE="${3:-ip_status}"

# Validate START_IP and END_IP
if ! [[ "$START_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || ! [[ "$END_IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid IP address format. Please provide IP addresses in the format 'x.x.x.x'."
    display_usage
    exit 1
fi

# Convert IP addresses to integer values
IFS='.' read -r -a start_ip_octets <<< "$START_IP"
IFS='.' read -r -a end_ip_octets <<< "$END_IP"
start_ip_int=$((start_ip_octets[0] * 256**3 + start_ip_octets[1] * 256**2 + start_ip_octets[2] * 256 + start_ip_octets[3]))
end_ip_int=$((end_ip_octets[0] * 256**3 + end_ip_octets[1] * 256**2 + end_ip_octets[2] * 256 + end_ip_octets[3]))

# Check if END_IP is greater than START_IP
if [ "$end_ip_int" -le "$start_ip_int" ]; then
    echo "Error: END_IP must be greater than START_IP."
    display_usage
    exit 1
fi

# Count the number of IP addresses in the range
num_ips=$((end_ip_int - start_ip_int - 1))

# Initialize progress counter
progress=0

# Function to display progress bar
draw_progress_bar() {
    local completed="$1"
    local total="$2"
    local width=50
    local percentage=$((completed * 100 / total))
    local completed_length=$((completed * width / total))
    local remaining_length=$((width - completed_length))

    printf "\r["
    printf "%${completed_length}s" "#" | tr ' ' '#'
    printf "%${remaining_length}s" " " | tr ' ' ' '
    printf "] %d%% (%d/%d)" "$percentage" "$completed" "$total"
}

# Create or truncate the output file and write headers
echo "IP Address,Status" > "$OUTPUT_FILE.csv"

# Loop through each IP address in the range
for ((ip_int=start_ip_int + 1; ip_int<=end_ip_int - 1; ip_int++)); do
    # Convert the integer IP address back to dotted-decimal format
    ip_address="$(printf "%d.%d.%d.%d\n" "$((ip_int >> 24 & 255))" "$((ip_int >> 16 & 255))" "$((ip_int >> 8 & 255))" "$((ip_int & 255))")"

    # Ping the IP address with a single packet and a timeout of 1 second
    ping -c 1 -W 1 "$ip_address" > /dev/null 2>&1

    # Check the exit status of the ping command and write to CSV
    if [ $? -eq 0 ]; then
        echo "$ip_address,Used" >> "$OUTPUT_FILE.csv"
    else
        echo "$ip_address,Available" >> "$OUTPUT_FILE.csv"
    fi

    # Increment progress counter and update progress bar
    progress=$((progress + 1))
    draw_progress_bar "$progress" "$num_ips"
done

echo ""  # Print a newline after the progress bar
