#!/bin/bash

# Function to display memory information
memory_info() {
    echo "=== Memory ==="
    free -h | awk '/^Mem:/ {
        print "Total: " $2
        print "Used: " $3
        print "Available: " $7
    }'
    echo
}

# Function to display CPU information
cpu_info() {
    echo "=== CPU ==="
    echo "Model: $(lscpu | grep "Model name" | cut -d: -f2 | sed 's/^ *//')"
    echo "Cores: $(nproc)"
    echo "Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')"
    echo
}

# Function to display load average
load_avg() {
    echo "=== Load Average ==="
    awk '{print $1, $2, $3}' /proc/loadavg
    echo
}

# Function to display top 5 processes by CPU usage
processes_info() {
    echo "=== Processes ==="
    echo "Top 5 processes by CPU usage:"
    ps aux --sort=-%cpu | head -n 6 | awk '{print $1, $2, $3"%", $4"%", $11}' | column -t
    echo
}

# Function to display open ports
open_ports() {
    echo "=== Open Ports ==="
    ss -tuln | awk 'NR==1 {print "Netid State Port"} NR>1 {split($5, a, ":"); print $1, $2, a[length(a)]}' | sort -nk3 | uniq | column -t
    echo
}

# Function to display logged-in users
users_info() {
    echo "=== Logged-in Users ==="
    who
    echo
}

# Function to display running services
services_info() {
    echo "=== Services ==="
    systemctl list-units --type=service --state=running
    echo
}

# Function to display disk information
disk_info() {
    echo "=== Disk ==="
    df -h --output=source,used,avail,target | grep -v "tmpfs"
    echo
}

# Function to display network information
network_info() {
    echo "=== Network ==="
    ip -o addr show | grep -v inet6 | awk '{print $2, $4}' | cut -d"/" -f1 | column -t
    echo
}

# Function to display uptime
uptime_info() {
    echo "=== Uptime ==="
    uptime -p
    echo
}

# Function to display system information
system_info() {
    echo "=== System ==="
    echo "Hostname: $(hostname)"
    echo "Kernel: $(uname -r)"
    echo "Distribution: $(lsb_release -d | cut -d: -f2 | sed 's/^ *//')"
    echo
}

# Function to display all information
display_all() {
    echo "=========================================="
    echo "          System Information          "
    echo "=========================================="
    system_info
    memory_info
    cpu_info
    load_avg
    disk_info
    network_info
    processes_info
    open_ports
    users_info
    uptime_info
    services_info
    echo "=========================================="
}

# Function to display menu
show_menu() {
    while true; do
        echo "=========================================="
        echo "             System Info Menu             "
        echo "=========================================="
        echo "1) System Information"
        echo "2) Memory Information"
        echo "3) CPU Information"
        echo "4) Load Average"
        echo "5) Disk Usage"
        echo "6) Network Information"
        echo "7) Running Processes"
        echo "8) Open Ports"
        echo "9) Logged-in Users"
        echo "10) System Uptime"
        echo "11) Active Services"
        echo "12) Display All"
        echo "0) Exit"
        echo "=========================================="
        read -p "Choose an option: " choice

        case $choice in
            1) system_info ;;
            2) memory_info ;;
            3) cpu_info ;;
            4) load_avg ;;
            5) disk_info ;;
            6) network_info ;;
            7) processes_info ;;
            8) open_ports ;;
            9) users_info ;;
            10) uptime_info ;;
            11) services_info ;;
            12) display_all ;;
            0) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option, please try again." ;;
        esac

        echo ""
        read -p "Press Enter to continue..."
    done
}

# Execute the menu
show_menu
