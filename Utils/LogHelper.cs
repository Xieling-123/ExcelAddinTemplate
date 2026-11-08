using System;
using System.IO;

namespace ExcelAddIn2.Utils
{
    public static class LogHelper
    {
        public static void WriteLog(string message)
        {
            try
            {
                // 日志存到你的下载文件夹里
                string logPath = @"C:\Users\20503\Downloads\ExcelAddIn_Log.txt";
                string logContent = $"[{DateTime.Now:yyyy-MM-dd HH:mm:ss}] {message}\r\n";
                File.AppendAllText(logPath, logContent);
            }
            catch
            {
                // 忽略写日志时的报错
            }
        }
    }
}