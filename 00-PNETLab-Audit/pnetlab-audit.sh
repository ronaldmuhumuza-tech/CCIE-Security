#!/bin/bash

OUTPUT="$HOME/pnetlab-audit-$(date +%F-%H%M).txt"

echo "Generating PNETLab audit..."

{
echo "========================================"
echo "          PNETLab Audit Report"
echo "========================================"
echo

echo "Generated:"
date

echo
echo "===== SYSTEM ====="
echo "Hostname: $(hostname)"
echo "Kernel:   $(uname -r)"
echo
cat /etc/os-release

echo
echo "===== CPU ====="
lscpu | grep -E 'Model name|Socket|Core|CPU\(s\)|Virtualization'

echo
echo "===== MEMORY ====="
free -h

echo
echo "===== DISK SPACE ====="
df -hT

echo
echo "===== ADDON DIRECTORY SIZES ====="
du -sh /opt/unetlab/addons/* 2>/dev/null

echo
echo "===== QEMU IMAGE DIRECTORIES ====="
if [ -d /opt/unetlab/addons/qemu ]; then
    find /opt/unetlab/addons/qemu \
        -mindepth 1 -maxdepth 1 -type d \
        -printf '%f\n' | sort
else
    echo "QEMU directory not found."
fi

echo
echo "===== QEMU IMAGE FILES ====="
if [ -d /opt/unetlab/addons/qemu ]; then
    find /opt/unetlab/addons/qemu \
        -maxdepth 2 -type f \
        -printf '%p | %s bytes\n' | sort
else
    echo "QEMU directory not found."
fi

echo
echo "===== IOL IMAGE FILES ====="
if [ -d /opt/unetlab/addons/iol ]; then
    find /opt/unetlab/addons/iol \
        -maxdepth 2 -type f \
        -printf '%p | %s bytes\n' | sort
else
    echo "IOL directory not found."
fi

echo
echo "===== DYNAMIPS IMAGE FILES ====="
if [ -d /opt/unetlab/addons/dynamips ]; then
    find /opt/unetlab/addons/dynamips \
        -maxdepth 2 -type f \
        -printf '%p | %s bytes\n' | sort
else
    echo "Dynamips directory not found."
fi

echo
echo "===== DOCKER DIRECTORY ====="
if [ -d /opt/unetlab/addons/docker ]; then
    find /opt/unetlab/addons/docker \
        -mindepth 1 -maxdepth 2 \
        -printf '%y %p\n' | sort
else
    echo "Docker addon directory not present."
fi

echo
echo "===== INSTALLED DOCKER IMAGES ====="
if command -v docker >/dev/null 2>&1; then
    docker image ls
else
    echo "Docker command not installed."
fi

echo
echo "===== PNETLAB NETWORKING ====="
ip -brief address

echo
echo "===== ROUTING TABLE ====="
ip route

echo
echo "===== PNETLAB SERVICES ====="
systemctl --no-pager --type=service --state=running \
    | grep -Ei 'apache|mysql|mariadb|docker|unetlab|pnet|qemu' \
    || echo "No matching running services found."

echo
echo "===== IMAGE PERMISSIONS SUMMARY ====="
find /opt/unetlab/addons \
    -maxdepth 3 -type f \
    -printf '%M %u:%g %p\n' 2>/dev/null | sort

echo
echo "===== IMAGE COUNTS ====="
printf "QEMU directories: "
find /opt/unetlab/addons/qemu \
    -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l

printf "QEMU files: "
find /opt/unetlab/addons/qemu \
    -type f 2>/dev/null | wc -l

printf "IOL files: "
find /opt/unetlab/addons/iol \
    -type f 2>/dev/null | wc -l

printf "Dynamips files: "
find /opt/unetlab/addons/dynamips \
    -type f 2>/dev/null | wc -l

echo
echo "========================================"
echo "             End of Report"
echo "========================================"

} > "$OUTPUT" 2>&1

echo "Audit completed."
echo "Report saved to:"
echo "$OUTPUT"
