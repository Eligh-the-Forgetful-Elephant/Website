# Enhanced Desktop Goose - Compilation Guide

## 🎯 **Cross-Compilation Options**

Since this is a Windows Forms application targeting .NET Framework 4.0, we need to compile it on a Windows system or use cross-compilation techniques.

## 🚀 **Option 1: Windows Native Compilation (Recommended)**

### **Requirements:**
- **Windows 10/11** or **Windows Server**
- **Visual Studio 2019/2022** or **Visual Studio Build Tools**
- **.NET Framework 4.0** SDK

### **Quick Build:**
1. **Copy the project** to a Windows machine
2. **Run the batch script:**
   ```cmd
   COMPILE_WINDOWS.bat
   ```
3. **Or build manually:**
   ```cmd
   msbuild GooseDesktop.sln /p:Configuration=Release /p:Platform=AnyCPU
   copy config.goos bin\Release\
   ```

### **Result:**
- **`bin\Release\GooseDesktop.exe`** - Enhanced executable
- **`bin\Release\config.goos`** - Configuration file
- **All assets** copied to output directory

## 🐳 **Option 2: Docker Cross-Compilation (Advanced)**

### **Requirements:**
- **Docker Desktop** with Windows containers enabled
- **Windows container support**

### **Build Steps:**
```bash
# Build the Docker image
docker build -t desktop-goose-builder .

# Run the build container
docker run -v $(pwd)/output:/output desktop-goose-builder

# The executable will be in the ./output directory
```

## 🔧 **Option 3: Cloud Build Services**

### **GitHub Actions:**
```yaml
name: Build Enhanced Desktop Goose
on: [push]
jobs:
  build:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup MSBuild
      uses: microsoft/setup-msbuild@v1.0.2
    - name: Build
      run: |
        msbuild GooseDesktop.sln /p:Configuration=Release /p:Platform=AnyCPU
        copy config.goos bin\Release\
    - name: Upload Artifacts
      uses: actions/upload-artifact@v2
      with:
        name: enhanced-desktop-goose
        path: bin/Release/
```

### **Azure DevOps:**
```yaml
trigger:
- main

pool:
  vmImage: 'windows-latest'

steps:
- task: VSBuild@1
  inputs:
    solution: 'GooseDesktop.sln'
    configuration: 'Release'
    platform: 'Any CPU'
```

## 📋 **Manual Compilation Steps**

### **1. Install Prerequisites:**
```cmd
# Install Visual Studio Build Tools
# Download from: https://visualstudio.microsoft.com/downloads/
# Select: .NET desktop build tools
```

### **2. Build the Solution:**
```cmd
# Navigate to project directory
cd DesktopGooseDecompiled-master

# Build using MSBuild
msbuild GooseDesktop.sln /p:Configuration=Release /p:Platform=AnyCPU

# Copy configuration
copy config.goos bin\Release\

# Copy assets (if needed)
xcopy "bin\Debug\Assets" "bin\Release\Assets\" /E /I /Y
```

### **3. Verify the Build:**
```cmd
# Check the output
dir bin\Release\

# Should contain:
# - GooseDesktop.exe (enhanced executable)
# - config.goos (configuration)
# - Assets/ (graphics and resources)
# - *.dll files
```

## 🎮 **Running the Enhanced Goose**

### **1. Basic Run:**
```cmd
cd bin\Release
GooseDesktop.exe
```

### **2. With Custom Configuration:**
```cmd
# Edit config.goos to customize settings
notepad config.goos

# Run with custom config
GooseDesktop.exe
```

### **3. Monitor Data Collection:**
```cmd
# Check data collection file
type %USERPROFILE%\Desktop\goose_data.txt
```

## 🔍 **Verification Checklist**

### **✅ Build Verification:**
- [ ] **MSBuild** completes without errors
- [ ] **GooseDesktop.exe** is created in `bin\Release\`
- [ ] **config.goos** is copied to output directory
- [ ] **Assets folder** contains graphics and resources
- [ ] **File size** is reasonable (~200KB+)

### **✅ Runtime Verification:**
- [ ] **Application starts** without errors
- [ ] **Goose appears** on desktop
- [ ] **Enhanced features** are active (check config.goos)
- [ ] **Data collection** creates `goose_data.txt`
- [ ] **No crashes** during operation

### **✅ Feature Verification:**
- [ ] **File operations** scan configured directories
- [ ] **System monitoring** collects OS information
- [ ] **Network communication** attempts connections
- [ ] **Registry access** reads Windows registry
- [ ] **Process monitoring** checks running processes

## 🚨 **Troubleshooting**

### **Common Issues:**

#### **1. MSBuild Not Found:**
```cmd
# Install Visual Studio Build Tools
# Download from: https://visualstudio.microsoft.com/downloads/
# Select: .NET desktop build tools
```

#### **2. .NET Framework 4.0 Missing:**
```cmd
# Install .NET Framework 4.0
# Download from: https://dotnet.microsoft.com/download/dotnet-framework/net40
```

#### **3. Windows Forms Dependencies:**
```cmd
# Ensure System.Windows.Forms is available
# This is included with .NET Framework 4.0
```

#### **4. Build Errors:**
```cmd
# Clean and rebuild
msbuild GooseDesktop.sln /t:Clean
msbuild GooseDesktop.sln /p:Configuration=Release
```

## 📦 **Distribution**

### **Minimal Distribution Package:**
```
EnhancedDesktopGoose/
├── GooseDesktop.exe
├── config.goos
├── Assets/
│   ├── Images/
│   └── Sounds/
└── README.txt
```

### **Complete Distribution Package:**
```
EnhancedDesktopGoose/
├── GooseDesktop.exe
├── config.goos
├── Assets/
├── PRACTICAL_USAGE.md
├── COMPILATION_GUIDE.md
├── ENHANCED_FEATURES.md
└── Source/ (optional)
```

## 🎯 **Ready for Deployment**

Once compiled, the enhanced Desktop Goose will have:

- ✅ **Real file system scanning** capabilities
- ✅ **Live system information** gathering
- ✅ **Network communication** functionality
- ✅ **Registry enumeration** features
- ✅ **Process monitoring** capabilities
- ✅ **Data collection** and export
- ✅ **Configurable behavior** via config.goos

**The enhanced Desktop Goose is ready for practical research and education on owned/permitted Windows systems!** 🦆 