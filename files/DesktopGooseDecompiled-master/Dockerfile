# Use Windows Server Core with .NET Framework 4.0
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Install .NET Framework 4.0
RUN powershell -Command \
    Invoke-WebRequest -Uri "https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe" -OutFile "dotNetFx40_Full_x86_x64.exe" ; \
    Start-Process -FilePath "dotNetFx40_Full_x86_x64.exe" -ArgumentList "/q /norestart" -Wait ; \
    Remove-Item "dotNetFx40_Full_x86_x64.exe"

# Install Visual Studio Build Tools
RUN powershell -Command \
    Invoke-WebRequest -Uri "https://aka.ms/vs/17/release/vs_buildtools.exe" -OutFile "vs_buildtools.exe" ; \
    Start-Process -FilePath "vs_buildtools.exe" -ArgumentList "--quiet", "--wait", "--norestart", "--nocache", "--installPath", "C:\BuildTools", "--add", "Microsoft.VisualStudio.Workload.MSBuildTools", "--add", "Microsoft.VisualStudio.Workload.VCTools", "--add", "Microsoft.VisualStudio.Workload.NetCoreBuildTools" -Wait ; \
    Remove-Item "vs_buildtools.exe"

# Set environment variables
ENV PATH="C:\BuildTools\MSBuild\Current\Bin;${PATH}"

# Set working directory
WORKDIR /src

# Copy source code
COPY . .

# Build the solution
RUN msbuild GooseDesktop.sln /p:Configuration=Release /p:Platform=AnyCPU /verbosity:minimal

# Copy configuration file
RUN copy config.goos bin\Release\

# Copy assets
RUN if exist "bin\Debug\Assets" xcopy "bin\Debug\Assets" "bin\Release\Assets\" /E /I /Y

# Create output directory
VOLUME /output

# Copy built executable to output
RUN copy "bin\Release\*" /output\

# Default command
CMD ["cmd", "/c", "echo", "Build complete! Check the mounted volume for the executable."] 