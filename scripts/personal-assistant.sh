#!/bin/bash

#===========================================
# Shell Personal Assistant
# Author: Your Name
# Version: 1.0.0
# License: MIT
#===========================================

# Script configuration
set -e  # Exit on error
set -u  # Exit on undefined variable

# Version
VERSION="1.0.0"

# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
show_banner() {
    echo -e "${BLUE}"
    echo "╔════════════════════════════════════════╗"
    echo "║      Shell Personal Assistant v$VERSION      ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check dependencies
check_dependencies() {
    local missing_deps=0
    
    # List of required commands
    local deps=("curl" "df" "free" "ip")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}Error: Required command '$dep' is not installed.${NC}"
            missing_deps=1
        fi
    done
    
    if [ $missing_deps -eq 1 ]; then
        echo -e "${RED}Please install missing dependencies and try again.${NC}"
        exit 1
    fi
}

# Error handling
error_handler() {
    echo -e "${RED}An error occurred in the script.${NC}"
    echo "Line: $1"
    echo "Exit code: $2"
}

trap 'error_handler ${LINENO} $?' ERR

# Function to show help
show_help() {
    echo -e "\n${BLUE}Available commands:${NC}"
    echo "1. system    - Show system information"
    echo "2. time      - Show current date and time"
    echo "3. files     - List files in current directory"
    echo "4. disk      - Show disk usage"
    echo "5. memory    - Show memory usage"
    echo "6. network   - Show network information"
    echo "7. weather   - Show weather (requires curl and wttr.in)"
    echo "8. calculator- Simple calculator"
    echo "9. help      - Show this help message"
    echo "10. exit     - Exit the assistant"
}

# Function to show system information
show_system_info() {
    echo -e "\n${GREEN}System Information:${NC}"
    echo -e "${YELLOW}OS Information:${NC}"
    uname -a
    echo -e "\n${YELLOW}CPU Information:${NC}"
    grep "model name" /proc/cpuinfo | head -n 1
    echo -e "\n${YELLOW}Kernel Version:${NC}"
    uname -r
}

# Function to show current time
show_time() {
    echo -e "\n${GREEN}Current Date and Time:${NC}"
    date "+%Y-%m-%d %H:%M:%S %Z"
}

# Function to list files
list_files() {
    echo -e "\n${GREEN}Files in current directory:${NC}"
    ls -lh --color=auto
}

# Function to show disk usage
show_disk_usage() {
    echo -e "\n${GREEN}Disk Usage:${NC}"
    df -h | grep -v "tmpfs"
}

# Function to show memory usage
show_memory_usage() {
    echo -e "\n${GREEN}Memory Usage:${NC}"
    free -h
}

# Function to show network information
show_network_info() {
    echo -e "\n${GREEN}Network Information:${NC}"
    echo -e "${YELLOW}IP Addresses:${NC}"
    ip -br addr show
    echo -e "\n${YELLOW}Network Interfaces:${NC}"
    ip link show
}

# Function to show weather
show_weather() {
    echo -e "\n${GREEN}Weather Information:${NC}"
    if curl -s wttr.in/?0 &> /dev/null; then
        curl -s wttr.in/?0
    else
        echo -e "${RED}Unable to fetch weather information. Please check your internet connection.${NC}"
    fi
}

# Function for calculator
calculator() {
    echo -e "\n${GREEN}Simple Calculator${NC}"
    echo -e "${YELLOW}Enter expression (e.g., 2 + 2):${NC}"
    read -r expression
    result=$(echo "$expression" | bc -l 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo -e "Result: $result"
    else
        echo -e "${RED}Invalid expression${NC}"
    fi
}

# Main loop
main() {
    show_banner
    check_dependencies
    
    while true; do
        show_help
        echo -e "\n${BLUE}Enter your choice:${NC} "
        read -r choice
        
        case $choice in
            1|system)    show_system_info ;;
            2|time)      show_time ;;
            3|files)     list_files ;;
            4|disk)      show_disk_usage ;;
            5|memory)    show_memory_usage ;;
            6|network)   show_network_info ;;
            7|weather)   show_weather ;;
            8|calculator) calculator ;;
            9|help)      show_help ;;
            10|exit)
                echo -e "\n${GREEN}Thank you for using Shell Personal Assistant. Goodbye!${NC}"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Invalid option. Please try again.${NC}"
                ;;
        esac
        
        echo -e "\n${YELLOW}Press Enter to continue...${NC}"
        read -r
        clear
        show_banner
    done
}

# Start the application
main
