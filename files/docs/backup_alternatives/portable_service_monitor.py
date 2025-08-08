#!/usr/bin/env python3
"""
Portable Service Monitor for PVJ CTF
Cross-platform service monitoring that works on Windows and Linux
No external dependencies required - uses only standard library
"""

import os
import sys
import time
import json
import subprocess
from datetime import datetime
from pathlib import Path

class ServiceMonitor:
    def __init__(self):
        self.log_dir = Path("defense_logs")
        self.log_dir.mkdir(exist_ok=True)
        self.is_windows = os.name == 'nt'
        
    def get_processes(self):
        """Get running processes cross-platform"""
        processes = {}
        
        try:
            if self.is_windows:
                # Windows: use tasklist
                result = subprocess.run(
                    ['tasklist', '/FO', 'CSV', '/V'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
                
                if result.returncode == 0:
                    lines = result.stdout.strip().split('\n')[1:]  # Skip header
                    for line in lines:
                        if line.strip():
                            parts = line.split('","')
                            if len(parts) >= 5:
                                process_name = parts[0].strip('"')
                                pid = parts[1].strip('"')
                                memory = parts[4].strip('"')
                                processes[pid] = {
                                    'name': process_name,
                                    'memory': memory,
                                    'platform': 'windows'
                                }
            else:
                # Linux: use ps
                result = subprocess.run(
                    ['ps', 'aux'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
                
                if result.returncode == 0:
                    lines = result.stdout.strip().split('\n')[1:]  # Skip header
                    for line in lines:
                        if line.strip():
                            parts = line.split()
                            if len(parts) >= 11:
                                user = parts[0]
                                pid = parts[1]
                                cpu = parts[2]
                                mem = parts[3]
                                command = ' '.join(parts[10:])
                                processes[pid] = {
                                    'name': parts[10] if len(parts) > 10 else 'unknown',
                                    'user': user,
                                    'cpu': cpu,
                                    'memory': mem,
                                    'command': command,
                                    'platform': 'linux'
                                }
                                
        except subprocess.TimeoutExpired:
            print(f"[{datetime.now()}] Timeout getting processes")
        except Exception as e:
            print(f"[{datetime.now()}] Error getting processes: {e}")
            
        return processes
    
    def get_network_connections(self):
        """Get network connections cross-platform"""
        connections = []
        
        try:
            if self.is_windows:
                # Windows: use netstat
                result = subprocess.run(
                    ['netstat', '-an'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            else:
                # Linux: use netstat
                result = subprocess.run(
                    ['netstat', '-tuln'], 
                    capture_output=True, 
                    text=True,
                    timeout=10
                )
            
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                for line in lines:
                    if line.strip() and not line.startswith('Proto'):
                        connections.append(line.strip())
                        
        except subprocess.TimeoutExpired:
            print(f"[{datetime.now()}] Timeout getting network connections")
        except Exception as e:
            print(f"[{datetime.now()}] Error getting network connections: {e}")
            
        return connections
    
    def check_suspicious_activity(self, processes, connections):
        """Check for suspicious activity patterns"""
        suspicious = []
        
        # ThunderStorm indicators
        thunderstorm_indicators = [
            'bolt', 'cirrus', 'flurry', 'guardian', 'doppler',
            'jetstream', 'cloudseed', 'thunderstorm'
        ]
        
        # Check processes for ThunderStorm
        for pid, proc_info in processes.items():
            proc_name = proc_info.get('name', '').lower()
            for indicator in thunderstorm_indicators:
                if indicator in proc_name:
                    suspicious.append({
                        'type': 'suspicious_process',
                        'pid': pid,
                        'name': proc_info.get('name'),
                        'indicator': indicator,
                        'timestamp': datetime.now().isoformat()
                    })
        
        # Check for unusual network activity
        suspicious_ports = [8080, 8443, 9000, 9001, 4444, 1337]
        for conn in connections:
            for port in suspicious_ports:
                if f":{port}" in conn:
                    suspicious.append({
                        'type': 'suspicious_connection',
                        'connection': conn,
                        'port': port,
                        'timestamp': datetime.now().isoformat()
                    })
        
        return suspicious
    
    def save_snapshot(self, processes, connections, suspicious):
        """Save current snapshot to file"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        snapshot = {
            'timestamp': datetime.now().isoformat(),
            'total_processes': len(processes),
            'total_connections': len(connections),
            'suspicious_activity': suspicious,
            'processes': processes,
            'connections': connections
        }
        
        filename = self.log_dir / f"service_snapshot_{timestamp}.json"
        try:
            with open(filename, 'w') as f:
                json.dump(snapshot, f, indent=2)
            print(f"[{datetime.now()}] Snapshot saved: {filename}")
        except Exception as e:
            print(f"[{datetime.now()}] Error saving snapshot: {e}")
    
    def run(self, interval=60):
        """Main monitoring loop"""
        print(f"[{datetime.now()}] Starting service monitor (interval: {interval}s)")
        print(f"[{datetime.now()}] Platform: {'Windows' if self.is_windows else 'Linux'}")
        
        try:
            while True:
                # Get current state
                processes = self.get_processes()
                connections = self.get_network_connections()
                suspicious = self.check_suspicious_activity(processes, connections)
                
                # Save snapshot
                self.save_snapshot(processes, connections, suspicious)
                
                # Report suspicious activity
                if suspicious:
                    print(f"[{datetime.now()}] ⚠️  SUSPICIOUS ACTIVITY DETECTED!")
                    for item in suspicious:
                        print(f"  - {item['type']}: {item}")
                
                # Wait for next check
                time.sleep(interval)
                
        except KeyboardInterrupt:
            print(f"\n[{datetime.now()}] Service monitor stopped by user")
        except Exception as e:
            print(f"[{datetime.now()}] Error in monitoring loop: {e}")

def main():
    """Main entry point"""
    print("=" * 60)
    print("PORTABLE SERVICE MONITOR - PVJ CTF DEFENSE TOOLKIT")
    print("=" * 60)
    
    # Parse command line arguments
    interval = 60  # Default 60 seconds
    if len(sys.argv) > 1:
        try:
            interval = int(sys.argv[1])
        except ValueError:
            print(f"Invalid interval: {sys.argv[1]}. Using default 60 seconds.")
    
    # Start monitoring
    monitor = ServiceMonitor()
    monitor.run(interval)

if __name__ == "__main__":
    main() 