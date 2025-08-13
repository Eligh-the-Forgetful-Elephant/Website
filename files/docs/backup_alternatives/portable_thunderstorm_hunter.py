#!/usr/bin/env python3
"""
Portable ThunderStorm Hunter for PVJ CTF
Cross-platform ThunderStorm C2 detection
No external dependencies required - uses only standard library
"""

import os
import sys
import time
import json
import subprocess
import hashlib
from datetime import datetime
from pathlib import Path

class ThunderStormHunter:
    def __init__(self):
        self.log_dir = Path("defense_logs")
        self.log_dir.mkdir(exist_ok=True)
        self.is_windows = os.name == 'nt'
        
        # ThunderStorm indicators based on analysis
        self.thunderstorm_indicators = {
            'processes': [
                'bolt', 'cirrus', 'flurry', 'guardian', 'doppler',
                'jetstream', 'cloudseed', 'thunderstorm', 'c2server',
                'implant', 'beacon', 'agent'
            ],
            'files': [
                # Linux paths
                '/tmp/bolt', '/tmp/cirrus', '/tmp/flurry', '/tmp/guardian',
                '/var/tmp/bolt', '/var/tmp/cirrus', '/var/tmp/flurry',
                '/home/*/bolt', '/root/bolt', '/root/cirrus',
                '/etc/systemd/system/bolt.service',
                '/etc/systemd/system/cirrus.service',
                '/etc/cron.d/bolt', '/etc/cron.d/cirrus',
                
                # Windows paths
                'C:\\temp\\bolt.exe', 'C:\\temp\\cirrus.exe',
                'C:\\temp\\flurry.exe', 'C:\\temp\\guardian.exe',
                'C:\\Windows\\Temp\\bolt.exe', 'C:\\Windows\\Temp\\cirrus.exe',
                'C:\\Users\\*\\AppData\\Local\\Temp\\bolt.exe',
                'C:\\Users\\*\\AppData\\Local\\Temp\\cirrus.exe',
                'C:\\ProgramData\\bolt.exe', 'C:\\ProgramData\\cirrus.exe'
            ],
            'ports': [8080, 8443, 9000, 9001, 4444, 1337, 4443, 8443],
            'registry_keys': [
                'HKEY_CURRENT_USER\\Software\\ThunderStorm',
                'HKEY_LOCAL_MACHINE\\SOFTWARE\\ThunderStorm',
                'HKEY_CURRENT_USER\\Software\\Microsoft\\Windows\\CurrentVersion\\Run',
                'HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run'
            ],
            'strings': [
                'thunderstorm', 'bolt', 'cirrus', 'flurry', 'guardian',
                'doppler', 'jetstream', 'cloudseed', 'c2server',
                'implant', 'beacon', 'agent', 'persistence'
            ]
        }
    
    def check_processes(self):
        """Check for ThunderStorm processes"""
        findings = []
        
        try:
            if self.is_windows:
                result = subprocess.run(
                    ['tasklist', '/FO', 'CSV'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            else:
                result = subprocess.run(
                    ['ps', 'aux'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            
            if result.returncode == 0:
                output = result.stdout.lower()
                for indicator in self.thunderstorm_indicators['processes']:
                    if indicator in output:
                        findings.append({
                            'type': 'suspicious_process',
                            'indicator': indicator,
                            'timestamp': datetime.now().isoformat()
                        })
                        
        except Exception as e:
            print(f"[{datetime.now()}] Error checking processes: {e}")
            
        return findings
    
    def check_files(self):
        """Check for ThunderStorm files"""
        findings = []
        
        for file_path in self.thunderstorm_indicators['files']:
            # Handle wildcards in paths
            if '*' in file_path:
                try:
                    if self.is_windows:
                        # Windows glob
                        import glob
                        matches = glob.glob(file_path)
                    else:
                        # Linux glob
                        import glob
                        matches = glob.glob(file_path)
                    
                    for match in matches:
                        if os.path.exists(match):
                            findings.append({
                                'type': 'suspicious_file',
                                'path': match,
                                'timestamp': datetime.now().isoformat()
                            })
                except Exception as e:
                    print(f"[{datetime.now()}] Error checking file pattern {file_path}: {e}")
            else:
                # Direct file check
                if os.path.exists(file_path):
                    findings.append({
                        'type': 'suspicious_file',
                        'path': file_path,
                        'timestamp': datetime.now().isoformat()
                    })
        
        return findings
    
    def check_network_connections(self):
        """Check for ThunderStorm network activity"""
        findings = []
        
        try:
            if self.is_windows:
                result = subprocess.run(
                    ['netstat', '-an'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            else:
                result = subprocess.run(
                    ['netstat', '-tuln'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            
            if result.returncode == 0:
                output = result.stdout
                for port in self.thunderstorm_indicators['ports']:
                    if f":{port}" in output:
                        findings.append({
                            'type': 'suspicious_connection',
                            'port': port,
                            'timestamp': datetime.now().isoformat()
                        })
                        
        except Exception as e:
            print(f"[{datetime.now()}] Error checking network connections: {e}")
            
        return findings
    
    def check_registry(self):
        """Check Windows registry for ThunderStorm persistence"""
        findings = []
        
        if not self.is_windows:
            return findings
        
        try:
            for reg_key in self.thunderstorm_indicators['registry_keys']:
                # Use reg query to check registry
                result = subprocess.run(
                    ['reg', 'query', reg_key], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
                
                if result.returncode == 0:
                    output = result.stdout.lower()
                    for indicator in self.thunderstorm_indicators['strings']:
                        if indicator in output:
                            findings.append({
                                'type': 'suspicious_registry',
                                'key': reg_key,
                                'indicator': indicator,
                                'timestamp': datetime.now().isoformat()
                            })
                            
        except Exception as e:
            print(f"[{datetime.now()}] Error checking registry: {e}")
            
        return findings
    
    def check_services(self):
        """Check for ThunderStorm services"""
        findings = []
        
        try:
            if self.is_windows:
                result = subprocess.run(
                    ['sc', 'query'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            else:
                result = subprocess.run(
                    ['systemctl', 'list-units', '--type=service'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            
            if result.returncode == 0:
                output = result.stdout.lower()
                for indicator in self.thunderstorm_indicators['processes']:
                    if indicator in output:
                        findings.append({
                            'type': 'suspicious_service',
                            'indicator': indicator,
                            'timestamp': datetime.now().isoformat()
                        })
                        
        except Exception as e:
            print(f"[{datetime.now()}] Error checking services: {e}")
            
        return findings
    
    def check_cron_jobs(self):
        """Check for ThunderStorm cron jobs (Linux)"""
        findings = []
        
        if self.is_windows:
            return findings
        
        try:
            # Check system crontab
            result = subprocess.run(
                ['crontab', '-l'], 
                capture_output=True, 
                text=True,
                timeout=10
            )
            
            if result.returncode == 0:
                output = result.stdout.lower()
                for indicator in self.thunderstorm_indicators['strings']:
                    if indicator in output:
                        findings.append({
                            'type': 'suspicious_cron',
                            'indicator': indicator,
                            'timestamp': datetime.now().isoformat()
                        })
            
            # Check /etc/cron.d/
            cron_files = ['/etc/cron.d/bolt', '/etc/cron.d/cirrus']
            for cron_file in cron_files:
                if os.path.exists(cron_file):
                    findings.append({
                        'type': 'suspicious_cron_file',
                        'file': cron_file,
                        'timestamp': datetime.now().isoformat()
                    })
                        
        except Exception as e:
            print(f"[{datetime.now()}] Error checking cron jobs: {e}")
            
        return findings
    
    def scan_binary_strings(self, file_path):
        """Scan binary file for ThunderStorm strings"""
        try:
            with open(file_path, 'rb') as f:
                content = f.read()
            
            findings = []
            for indicator in self.thunderstorm_indicators['strings']:
                if indicator.encode() in content:
                    findings.append({
                        'type': 'suspicious_string',
                        'file': file_path,
                        'indicator': indicator,
                        'timestamp': datetime.now().isoformat()
                    })
            
            return findings
        except Exception as e:
            return []
    
    def run_hunt(self):
        """Run complete ThunderStorm hunt"""
        print(f"[{datetime.now()}] 🔍 Starting ThunderStorm hunt...")
        
        all_findings = []
        
        # Check all categories
        all_findings.extend(self.check_processes())
        all_findings.extend(self.check_files())
        all_findings.extend(self.check_network_connections())
        all_findings.extend(self.check_registry())
        all_findings.extend(self.check_services())
        all_findings.extend(self.check_cron_jobs())
        
        # Save findings
        if all_findings:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = self.log_dir / f"thunderstorm_findings_{timestamp}.json"
            
            try:
                with open(filename, 'w') as f:
                    json.dump(all_findings, f, indent=2)
                print(f"[{datetime.now()}] ⚠️  THUNDERSTORM ACTIVITY DETECTED!")
                print(f"[{datetime.now()}] Findings saved to: {filename}")
                
                for finding in all_findings:
                    print(f"  - {finding['type']}: {finding}")
                    
            except Exception as e:
                print(f"[{datetime.now()}] Error saving findings: {e}")
        else:
            print(f"[{datetime.now()}] ✅ No ThunderStorm activity detected")
        
        return all_findings
    
    def run_continuous(self, interval=30):
        """Run continuous monitoring"""
        print(f"[{datetime.now()}] Starting continuous ThunderStorm monitoring (interval: {interval}s)")
        print(f"[{datetime.now()}] Platform: {'Windows' if self.is_windows else 'Linux'}")
        
        try:
            while True:
                findings = self.run_hunt()
                
                if findings:
                    print(f"[{datetime.now()}] 🚨 ALERT: {len(findings)} ThunderStorm indicators found!")
                
                time.sleep(interval)
                
        except KeyboardInterrupt:
            print(f"\n[{datetime.now()}] ThunderStorm hunter stopped by user")
        except Exception as e:
            print(f"[{datetime.now()}] Error in monitoring loop: {e}")

def main():
    """Main entry point"""
    print("=" * 60)
    print("PORTABLE THUNDERSTORM HUNTER - PVJ CTF DEFENSE TOOLKIT")
    print("=" * 60)
    
    hunter = ThunderStormHunter()
    
    # Parse command line arguments
    if len(sys.argv) > 1:
        if sys.argv[1] == '--continuous':
            interval = 30
            if len(sys.argv) > 2:
                try:
                    interval = int(sys.argv[2])
                except ValueError:
                    print(f"Invalid interval: {sys.argv[2]}. Using default 30 seconds.")
            hunter.run_continuous(interval)
        else:
            # Single hunt
            hunter.run_hunt()
    else:
        # Default: single hunt
        hunter.run_hunt()

if __name__ == "__main__":
    main() 