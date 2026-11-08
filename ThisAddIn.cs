using System;
using System.Windows.Forms;
using ExcelAddIn2.Utils; // 引入你的工具类

namespace ExcelAddIn2
{
    public partial class ThisAddIn
    {
        private void ThisAddIn_Startup(object sender, System.EventArgs e)
        {
            // 【重点】挂载全局异常拦截
            // 注意：后台用 AppDomain，前台用 System.Windows.Forms.Application 防止和 Excel 的 Application 冲突
            AppDomain.CurrentDomain.UnhandledException += 全局异常处理;
            System.Windows.Forms.Application.ThreadException += 界面异常处理;
        }

        private void ThisAddIn_Shutdown(object sender, System.EventArgs e)
        {
            // 【好习惯】卸载插件时注销事件，防止内存泄漏
            AppDomain.CurrentDomain.UnhandledException -= 全局异常处理;
            System.Windows.Forms.Application.ThreadException -= 界面异常处理;
        }

        // 处理后台线程的报错
        private void 全局异常处理(object sender, UnhandledExceptionEventArgs e)
        {
            Exception ex = e.ExceptionObject as Exception;
            if (ex != null)
            {
                LogHelper.WriteLog("系统崩溃：" + ex.Message); // 调用你写的日志类
                MessageBox.Show("发生了一个严重错误，已记录日志。为了安全，请保存文件后重启 Excel。", "错误");
            }
        }

        // 处理 UI 线程的报错（最常用）
        private void 界面异常处理(object sender, System.Threading.ThreadExceptionEventArgs e)
        {
            LogHelper.WriteLog("操作报错：" + e.Exception.Message); // 调用日志类
            MessageBox.Show("操作出错啦：" + e.Exception.Message, "提示", MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }
    }
}