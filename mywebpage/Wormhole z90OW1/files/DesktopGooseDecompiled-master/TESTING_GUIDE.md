# Enhanced Desktop Goose - Testing Guide

## 🧪 **Comprehensive Testing Strategy**

### **Phase 1: Configuration Testing**

#### **Test 1.1: Backward Compatibility**
```cmd
# Test with original config format
echo Version=0 > config.goos
echo CanAttackAtRandom=true >> config.goos
echo MinWanderingTimeSeconds=20 >> config.goos
echo MaxWanderingTimeSeconds=40 >> config.goos
echo FirstWanderTimeSeconds=20 >> config.goos

# Run the application
GooseDesktop.exe

# Expected Result: Should work exactly like original
# - Goose appears and moves around
# - No enhanced features activated
# - No errors or crashes
```

#### **Test 1.2: Enhanced Configuration**
```cmd
# Test with enhanced config format
# Use the provided config.goos with Version=0 and enhanced features

# Run the application
GooseDesktop.exe

# Expected Result: Should work with enhanced features
# - Goose appears and moves around
# - Enhanced features should be disabled by default (Version=0)
# - No errors or crashes
```

### **Phase 2: Compilation Testing**

#### **Test 2.1: Windows Native Compilation**
```cmd
# On Windows machine with Visual Studio Build Tools
msbuild GooseDesktop.sln /p:Configuration=Debug /verbosity:detailed

# Expected Result: Successful compilation
# - No compilation errors
# - Executable created in bin\Debug\
# - All required assemblies referenced
```

#### **Test 2.2: Dependency Validation**
```cmd
# Check for missing dependencies
# The following assemblies should be available:
# - System.Net
# - System.Net.Sockets
# - System.Diagnostics
# - Microsoft.Win32
# - System.Security.Cryptography
# - System.Text

# If any are missing, add to .csproj file
```

### **Phase 3: Runtime Testing**

#### **Test 3.1: Basic Functionality**
```cmd
# Test basic goose behavior
GooseDesktop.exe

# Expected Results:
# ✅ Goose appears on desktop
# ✅ Goose moves around naturally
# ✅ Mouse interaction works
# ✅ Original tasks work (wander, nab mouse, collect window, track mud)
# ✅ No crashes or errors
```

#### **Test 3.2: Enhanced Features (Disabled)**
```cmd
# Test with enhanced features disabled (Version=0)
# Expected Results:
# ✅ Enhanced features should not activate
# ✅ No file operations
# ✅ No network communication
# ✅ No system monitoring
# ✅ No registry access
# ✅ No process monitoring
```

#### **Test 3.3: Enhanced Features (Enabled)**
```cmd
# Test with enhanced features enabled
# Modify config.goos to enable features:
# EnableFileOperations=true
# EnableNetworkOperations=true
# EnableSystemInfoCollection=true
# EnableProcessMonitoring=true
# EnableRegistryAccess=true

# Expected Results:
# ✅ Enhanced tasks should appear in task rotation
# ✅ File operations should work (if directories exist)
# ✅ System monitoring should collect data
# ✅ Network communication should attempt connections
# ✅ Registry access should work (with proper permissions)
# ✅ Process monitoring should enumerate processes
```

### **Phase 4: Error Handling Testing**

#### **Test 4.1: Missing Dependencies**
```cmd
# Simulate missing dependencies
# Remove or rename some DLLs
# Run the application

# Expected Result:
# ✅ Application should start
# ✅ Enhanced features should fail gracefully
# ✅ Should fall back to original behavior
# ✅ No crashes
```

#### **Test 4.2: Network Failures**
```cmd
# Test network communication with invalid server
# Set RemoteServer=invalid.server.com
# Set RemotePort=9999

# Expected Result:
# ✅ Network communication should fail silently
# ✅ Should not crash the application
# ✅ Should continue with other tasks
```

#### **Test 4.3: File System Errors**
```cmd
# Test file operations with invalid paths
# Set TargetDirectories=C:\NonExistent\Path

# Expected Result:
# ✅ File operations should fail gracefully
# ✅ Should not crash the application
# ✅ Should continue with other tasks
```

#### **Test 4.4: Registry Access Errors**
```cmd
# Test registry access with invalid keys
# Or run without administrator privileges

# Expected Result:
# ✅ Registry access should fail gracefully
# ✅ Should not crash the application
# ✅ Should continue with other tasks
```

### **Phase 5: Data Collection Testing**

#### **Test 5.1: Data File Creation**
```cmd
# Run the application with enhanced features enabled
# Check for data file creation

# Expected Result:
# ✅ goose_data.txt should be created on desktop
# ✅ File should contain collected data
# ✅ Data should be properly formatted
```

#### **Test 5.2: Data Content Validation**
```cmd
# Examine the contents of goose_data.txt
# Should contain:
# - File operation data
# - System information
# - Network communication data
# - Registry access data
# - Process monitoring data
```

### **Phase 6: Stealth Testing**

#### **Test 6.1: Silent Operation**
```cmd
# Run the application
# Check Task Manager

# Expected Result:
# ✅ Should not show obvious signs of enhanced features
# ✅ Should appear as normal Desktop Goose
# ✅ No error dialogs or popups
```

#### **Test 6.2: Error Suppression**
```cmd
# Trigger various error conditions
# - Invalid network connections
# - File access denied
# - Registry access denied

# Expected Result:
# ✅ All errors should be handled silently
# ✅ No error messages to user
# ✅ Application continues running
```

## 🔧 **Troubleshooting Guide**

### **Common Issues and Solutions**

#### **Issue 1: Compilation Errors**
```
Error: The reference assemblies for .NETFramework,Version=v4.0 were not found
Solution: Install .NET Framework 4.0 Developer Pack
```

#### **Issue 2: Missing Assemblies**
```
Error: Could not load file or assembly 'System.Net'
Solution: Add missing references to .csproj file
```

#### **Issue 3: Runtime Crashes**
```
Error: Application crashes on startup
Solution: Check for missing Assets folder or config.goos
```

#### **Issue 4: Enhanced Features Not Working**
```
Problem: Enhanced features don't activate
Solution: Check config.goos format and enable flags
```

#### **Issue 5: Data Collection Not Working**
```
Problem: No goose_data.txt file created
Solution: Check file permissions and DataCollector implementation
```

## 📋 **Testing Checklist**

### **Pre-Compilation Checks**
- [ ] **Source code compiles** without errors
- [ ] **All required references** are included
- [ ] **Configuration file** is properly formatted
- [ ] **Assets folder** exists and contains required files

### **Compilation Checks**
- [ ] **MSBuild completes** successfully
- [ ] **Executable is created** with reasonable size
- [ ] **No missing dependency** warnings
- [ ] **All assemblies** are properly referenced

### **Runtime Checks**
- [ ] **Application starts** without crashes
- [ ] **Goose appears** and moves around
- [ ] **Original features** work correctly
- [ ] **Configuration loads** properly
- [ ] **No unhandled exceptions**

### **Enhanced Features Checks**
- [ ] **File operations** work (when enabled)
- [ ] **System monitoring** collects data
- [ ] **Network communication** handles failures
- [ ] **Registry access** works (with permissions)
- [ ] **Process monitoring** enumerates processes
- [ ] **Data collection** creates output files

### **Error Handling Checks**
- [ ] **Missing dependencies** handled gracefully
- [ ] **Network failures** don't crash application
- [ ] **File system errors** handled silently
- [ ] **Registry access errors** don't cause crashes
- [ ] **All errors** are suppressed for stealth

### **Stealth Checks**
- [ ] **No error dialogs** appear
- [ ] **No obvious signs** of enhanced features
- [ ] **Application appears** as normal Desktop Goose
- [ ] **Silent operation** maintained

## 🎯 **Success Criteria**

### **Minimum Viable Product:**
- ✅ **Compiles successfully** on Windows
- ✅ **Runs without crashes** on Windows
- ✅ **Goose appears** and moves around
- ✅ **Original features** work correctly
- ✅ **Enhanced features** work with error handling
- ✅ **Data collection** creates output files

### **Full Success:**
- ✅ **All enhanced features** work reliably
- ✅ **No runtime errors** or crashes
- ✅ **Stealth operation** maintained
- ✅ **Comprehensive data collection** works
- ✅ **Cross-platform compilation** works
- ✅ **Easy deployment** and distribution

## 🚀 **Quick Test Commands**

```cmd
# Test compilation
msbuild GooseDesktop.sln /p:Configuration=Debug

# Test basic functionality
GooseDesktop.exe

# Test with enhanced features
# Edit config.goos to enable features, then run:
GooseDesktop.exe

# Check data collection
# Look for goose_data.txt on desktop

# Test error handling
# Remove some files/folders and run again
```

**The enhanced Desktop Goose must pass all tests for reliable practical use!** 🦆 