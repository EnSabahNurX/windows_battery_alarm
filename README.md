# Windows Battery Alarm - Running PowerShell Script Silently in the Background

This guide will help you set up Windows Battery Alarm, a PowerShell script, to run silently in the background using a scheduled task.

## Prerequisites

- Windows operating system.
- Administrator privileges.

## Steps

1. **Create Your PowerShell Script**:
   Save your PowerShell script as a `.ps1` file (Tip: Use Notepad to create it). Ensure that the script contains the functionality you want to run silently in the background.

2. **Open PowerShell as Administrator**:
   Right-click on the PowerShell icon and select "Run as administrator" to open PowerShell with elevated privileges.

3. **Create a Scheduled Task**:
   Use the following PowerShell command to create a scheduled task that runs your script silently in the background, replacing "C:\path\to\your\script.ps1" with the actual path to your PowerShell script.:
   ```powershell
    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-WindowStyle Hidden -File ""C:\path\to\your\script.ps1"""
    $trigger = New-ScheduledTaskTrigger -AtStartup
    $settings = New-ScheduledTaskSettingsSet -DisallowStartIfOnBatteries:$false
    Register-ScheduledTask -TaskName "BatteryMonitor" -Action $action -Trigger $trigger -Settings $settings -RunLevel Highest -Force
4. **Verify the Scheduled Task:**:
   You can verify that the task has been created by opening Task Scheduler. Search for "Task Scheduler" in the Start menu, and navigate to "Task Scheduler Library." You should see your task named "BatteryMonitor" listed there. Do not forget to go in properties on the 

5. **Test Your Setup:**:
   Restart your computer to test if the scheduled task runs your script silently in the background upon startup.

6. **Monitor the Script:**:
   Monitor your script's behavior to ensure it's running as expected. You can check for any log files or output generated by your script.

7. **Adjust as Needed:**:
   If you need to make changes to your script or the scheduled task, you can do so by accessing Task Scheduler and modifying the task properties.

   