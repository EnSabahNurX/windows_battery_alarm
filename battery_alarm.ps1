# Set error action to stop script on errors
$ErrorActionPreference = "Stop"

# Function to check battery information using available APIs
function Get-BatteryInfo {
  $batteryInfo = $null
  # Check if Get-CimInstance is available
  if (Get-Command Get-CimInstance -ErrorAction SilentlyContinue) {
    $batteryInfo = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
  }
  # If Get-CimInstance is not available, check if Get-WmiObject is available
  elseif (Get-Command Get-WmiObject -ErrorAction SilentlyContinue) {
    $batteryInfo = Get-WmiObject Win32_Battery -ErrorAction SilentlyContinue
  }
  # If neither Get-CimInstance nor Get-WmiObject is available, use Get-BatteryReport if available
  elseif (Get-Command Get-BatteryReport -ErrorAction SilentlyContinue) {
    $batteryInfo = Get-BatteryReport
  }
  # If none of the APIs are available, return $null
  return $batteryInfo
}

# Function to display notification using dialog box with alarm sound
function Show-BatteryNotification {
  param(
    [string]$title,
    [string]$message
  )

  # Play the alarm sound if specified
  # Specify the path to the sound file
  $soundFile = "C:\Windows\Media\Alarm05.wav"
  if (Test-Path $soundFile) {
    # Start a background job to continuously play the sound file
    $alarmJob = Start-Job -ScriptBlock {
      param($soundFile)
      $soundPlayer = New-Object System.Media.SoundPlayer
      $soundPlayer.SoundLocation = $soundFile
      while ($true) {
        $soundPlayer.PlaySync()
      }
    } -ArgumentList $soundFile
  }
  else {
    Write-Host "Sound file not found at: $soundFile"
  }

  # Display dialog box
  $null = [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
  [Microsoft.VisualBasic.Interaction]::MsgBox($message, 'OKOnly, Information', $title)

  # Stop playing the alarm sound if it was started
  if ($alarmJob) {
    Stop-Job $alarmJob
    Remove-Job $alarmJob
  }
}

# Main loop to continuously check battery status
while ($true) {
  # Get battery information
  $battery = Get-BatteryInfo

  # Check if battery information is available
  if ($null -ne $battery) {
    # Check for low battery
    if ($battery.EstimatedChargeRemaining -le 20) {
      Show-BatteryNotification "Low Battery Alert" "Please plug in your device to charge."
    }
    # Check for full charge
    elseif ($battery.EstimatedChargeRemaining -eq 99) {
      Show-BatteryNotification "Battery Fully Charged" "Unplug your device to preserve battery health."
    }
    #else {
    #  Show-BatteryNotification "Battery Level" "$($battery.EstimatedChargeRemaining)%"
    #}
  }
  else {
    Write-Host "Failed to retrieve battery information."
  }

  # Wait for a specific interval before checking again (adjust in seconds)
  Start-Sleep -Seconds 60  # Check every 60 seconds
}