# IP Status Checker

IP Status Checker is a Bash script that checks the availability of IP addresses within a specified range and generates a CSV file with the results.

## Features

- **Simple Command-Line Usage**: Specify the start and end IP addresses as command-line arguments.
- **Text-Based Progress Bar**: Displays a progress bar in the terminal as the script processes IP addresses.
- **Customizable Output File**: Specify the output CSV file name as an optional command-line argument. If not provided, the default file name `ip_status.csv` is used.

## Usage

### Requirements

- Bash
- ping utility (usually pre-installed on most Unix-like systems)

### Syntax

./ipstatus.sh START_IP END_IP [OUTPUT_FILE]

- `START_IP`: The starting IP address of the range (e.g., `192.168.1.1`).
- `END_IP`: The ending IP address of the range (e.g., `192.168.1.254`).
- `OUTPUT_FILE` (optional): The name of the output CSV file. If not provided, the default file name `ip_status.csv` is used.

### Example

./ipstatus.sh 192.168.1.1 192.168.1.10 ip_status_results.csv

This command will check the availability of IP addresses from `192.168.1.2` to `192.168.1.9` and save the results in a CSV file named `ip_status_results.csv`.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
