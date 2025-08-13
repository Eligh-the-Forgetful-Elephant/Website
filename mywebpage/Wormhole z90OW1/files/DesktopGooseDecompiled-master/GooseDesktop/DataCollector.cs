using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Security.Cryptography;

namespace GooseDesktop
{
    public static class DataCollector
    {
        private static string dataFilePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "goose_data.txt");
        private static List<string> collectedData = new List<string>();
        private static object lockObject = new object();

        public static void AddData(string dataType, string data)
        {
            lock (lockObject)
            {
                string timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                string entry = $"[{timestamp}] {dataType}: {data}";
                collectedData.Add(entry);
                
                // Write to file immediately for persistence
                try
                {
                    File.AppendAllText(dataFilePath, entry + Environment.NewLine);
                }
                catch
                {
                    // Silent fail for stealth
                }
            }
        }

        public static void AddFileData(string filePath)
        {
            try
            {
                FileInfo fi = new FileInfo(filePath);
                string fileData = $"File: {filePath} | Size: {fi.Length} bytes | Modified: {fi.LastWriteTime}";
                AddData("FILE", fileData);
            }
            catch
            {
                // Silent fail for stealth
            }
        }

        public static void AddSystemData()
        {
            try
            {
                string systemInfo = $"Machine: {Environment.MachineName} | User: {Environment.UserName} | OS: {Environment.OSVersion}";
                AddData("SYSTEM", systemInfo);
            }
            catch
            {
                // Silent fail for stealth
            }
        }

        public static void AddProcessData(string processName, bool isRunning)
        {
            string processInfo = $"Process: {processName} | Status: {(isRunning ? "Running" : "Not Found")}";
            AddData("PROCESS", processInfo);
        }

        public static void AddRegistryData(string keyPath, string valueName, object value)
        {
            string registryInfo = $"Registry: {keyPath}\\{valueName} = {value}";
            AddData("REGISTRY", registryInfo);
        }

        public static void AddNetworkData(string server, int port, bool connected)
        {
            string networkInfo = $"Network: {server}:{port} | Connected: {connected}";
            AddData("NETWORK", networkInfo);
        }

        public static void ExportData(string exportPath = null)
        {
            if (string.IsNullOrEmpty(exportPath))
            {
                exportPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "goose_export.txt");
            }

            try
            {
                lock (lockObject)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.AppendLine("=== Desktop Goose Data Collection ===");
                    sb.AppendLine($"Export Time: {DateTime.Now}");
                    sb.AppendLine($"Machine: {Environment.MachineName}");
                    sb.AppendLine($"User: {Environment.UserName}");
                    sb.AppendLine("=====================================");
                    sb.AppendLine();

                    foreach (string entry in collectedData)
                    {
                        sb.AppendLine(entry);
                    }

                    File.WriteAllText(exportPath, sb.ToString());
                }
            }
            catch
            {
                // Silent fail for stealth
            }
        }

        public static void ClearData()
        {
            lock (lockObject)
            {
                collectedData.Clear();
                try
                {
                    if (File.Exists(dataFilePath))
                    {
                        File.Delete(dataFilePath);
                    }
                }
                catch
                {
                    // Silent fail for stealth
                }
            }
        }

        public static int GetDataCount()
        {
            lock (lockObject)
            {
                return collectedData.Count;
            }
        }
    }
} 