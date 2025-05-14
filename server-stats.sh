#!/bin/bash

echo "===== Server Performance Stats ====="
echo ""

# OS Version
echo ">> OS Version:"
cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '"'
echo ""

# Uptime
echo ">> Uptime:"
uptime -p
echo ""

# Load Average
echo ">> Load Average (1min, 5min, 15min):"
uptime | awk -F'load average:' '{ print $2 }'
echo ""

# Logged in Users
echo ">> Currently Logged-in Users:"
who | wc -l
echo ""

# Failed Login Attempts (last 24h)
echo ">> Failed Login Attempts (last 24h):"
journalctl _COMM=sshd --since "24 hours ago" | grep "Failed password" | wc -l
echo ""

# CPU Usage
echo ">> Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | awk '{print "Used: " $2 + $4 "%, Idle: " $8 "%"}'
echo ""

# Memory Usage
echo ">> Total Memory Usage:"
free -m | awk 'NR==2{printf "Used: %sMB / %sMB (%.2f%%)\n", $3,$2,$3*100/$2 }'
echo ""

# Disk Usage
echo ">> Disk Usage (Root Partition):"
df -h / | awk 'NR==2 {printf "Used: %s / %s (%s)\n", $3, $2, $5}'
echo ""

# Top 5 Processes by CPU usage
echo ">> Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
echo ""

# Top 5 Processes by Memory usage
echo ">> Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6
echo ""

echo "===== End of Report ====="

