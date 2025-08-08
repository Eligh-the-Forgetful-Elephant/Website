# Essential Defense Toolkit for PVJ CTF

## Quick Start Guide

### What's Here
This folder contains the **essential tools** you need for Day 1 defense:

- **`windows_defense_tools.bat`** - Windows-specific ThunderStorm hunter
- **`linux_defense_tools.sh`** - Linux-specific ThunderStorm hunter  
- **`portable_toolkit_guide.md`** - Complete user guide
- **`thunderstorm_intel.md`** - Red Team intelligence

### How to Use

#### Windows Machine
```cmd
# Quick system check
windows_defense_tools.bat quickcheck

# Start monitoring (runs in background)
windows_defense_tools.bat monitor 30

# Comprehensive hunt
windows_defense_tools.bat hunt

# Clean up if ThunderStorm found
windows_defense_tools.bat cleanup
```

#### Linux Machine
```bash
# Make executable
chmod +x linux_defense_tools.sh

# Quick system check
./linux_defense_tools.sh quickcheck

# Start monitoring (runs in background)
./linux_defense_tools.sh monitor 30 &

# Comprehensive hunt
./linux_defense_tools.sh hunt

# Clean up if ThunderStorm found
./linux_defense_tools.sh cleanup
```

### Day 1 Strategy
1. **Identify your machine** (Windows/Linux)
2. **Run quick check** to assess current state
3. **Start monitoring** in background
4. **Run comprehensive hunt** for ThunderStorm
5. **Clean up** any findings
6. **Monitor continuously** for re-infection

### What These Tools Do
- **Detect ThunderStorm C2** processes, files, network connections
- **Remove persistence** mechanisms (registry, services, cron jobs)
- **Monitor continuously** for re-infection
- **Provide quick system** status checks

### Backup Files
If you need alternative approaches, check the `../backup_alternatives/` folder for:
- Python-based tools
- Additional scripts
- Alternative guides

**Remember: Keep it simple, focus on basics, and work as a team!** 