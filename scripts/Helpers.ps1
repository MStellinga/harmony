
Function stopApplication($name){
    Get-Process -ea silentlycontinue $name | where {$_.MainWindowHandle -ne [System.IntPtr]::Zero} | foreach {$_.CloseMainWindow()}
}

Function stopApp($name){
    $apps = Get-WmiObject Win32_Process | ? {$_.name -eq "WWAHost.exe"} | Select-Object Commandline,ProcessID
    foreach ($app in $apps)
    {
       # Write-Host $app.Commandline
        if($app.Commandline -like "*$name*"){
            Stop-Process -Id $app.ProcessID
        }
    }
}

Function FixChromeCrashes() {
  $c = Get-Content "$($env:localAppData)\Google\Chrome\User Data\Default\Preferences"
  if ($c.IndexOf('"exit_type":"Crashed"') -gt 0) {
    #Write-Host "Chrome Crashed -- fooling startup to think it didn't"
    $c.Replace('"exit_type":"Crashed"', '"exit_type":"Normal"') | Set-Content "$($env:localAppData)\Google\Chrome\User Data\Default\Preferences" -NoNewLine
  }
}

Function isAppActive($name){
  $apps = Get-WmiObject Win32_Process | ? {$_.name -eq "WWAHost.exe"} | Select-Object Commandline,ProcessID
  foreach ($app in $apps)
  {
  #    Write-Host $app.Commandline
      if($app.Commandline -like "*$name*"){     
          return $true
      }
  }
  return $false
}

function isApplicationActive($name)
{
    return @(get-process -ea silentlycontinue $name).count -gt 0
}

Function stopAll(){
    # Stop Chrome
    stopApplication Chrome 
   
    # kill Chrome
    Get-Process -ea silentlycontinue "Chrome" | stop-process
    
    # Fix messages on re-open
    FixChromeCrashes

    # Stop selenium-controlled Chrome
    Get-Process -ea silentlycontinue "Chromedriver" | stop-process
      # Stop running java client
      Get-Process -ea silentlycontinue "java" | stop-process

    # Stop Playnite
    stopApplication PlayniteUI

    # Find and stop Netflix
    stopApp Netflix
    
}

Function stopNonStreaming(){
    $processes=Get-Process -Name Chrome -ea silentlycontinue
    if($processes){
       $processes.MainWindowHandle | foreach { Set-WindowStyle SHOWMAXIMIZED $_ } 
       $processes |  foreach {(New-Object -ComObject WScript.Shell).AppActivate($_.MainWindowTitle)}
    }

    # Stop Playnite
    stopApplication PlayniteUI

    # Find and stop Netflix
    stopApp Netflix
}

Function toBackground(){
    #if(isApplicationActive Chrome){    
    #  $processes=Get-Process -Name Chrome -ea silentlycontinue
    #  if($processes){
    #     $processes.MainWindowHandle | foreach { Set-WindowStyle MINIMIZE $_ } 
    #  }
    #}
    #} else {
      # Stop Chrome
      stopApplication Chrome 
   
      # kill Chrome
      Get-Process -ea silentlycontinue "Chrome" | stop-process
    
      # Fix messages on re-open
      FixChromeCrashes

      # Stop selenium-controlled Chrome
      # Get-Process -ea silentlycontinue "Chromedriver" | stop-process
      # Stop running java client
      #Get-Process -ea silentlycontinue "java" | stop-process
    #}

    # Stop Playnite
    stopApplication PlayniteUI

    # Find and stop Netflix
    stopApp Netflix
}

Function openChrome($url,$nofullscreen, $maximized){
    if($maximized){
       start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "--start-maximized","$url"
    } elseif($nofullscreen){
        start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "$url"
    } else {
        start-Process "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" -ArgumentList "--start-fullscreen","--app=$url"
    }
}

Function openChromeSelenium($target){
  Start-Process -FilePath "C:\harmony\selenium\jdk-12.0.1\bin\javaw" -WorkingDirectory "C:\harmony\selenium" -ArgumentList "-classpath","client-combined-3.141.59.jar;guava-23.0.jar;okhttp-3.14.2.jar;byte-buddy-1.8.15.jar;commons-exec-1.3.jar;okio-1.14.0.jar;C:\harmony\selenium","ChromeStarter",$target
}

Function sendCommand($commandId){
  [int] $Port = 8642
  $IP = "127.0.0.1"
  $Address = [system.net.IPAddress]::Parse($IP) 

  # Create IP Endpoint 
  $End = New-Object System.Net.IPEndPoint $address, $port 

  # Create Socket 
  $Saddrf = [System.Net.Sockets.AddressFamily]::InterNetwork 
  $Stype = [System.Net.Sockets.SocketType]::Stream 
  $Ptype = [System.Net.Sockets.ProtocolType]::TCP
  $Sock = New-Object System.Net.Sockets.Socket $saddrf, $stype, $ptype 
  $Sock.TTL = 26 

  Try
  {
    # Connect to socket 
    $sock.Connect($end)
  
    [Byte[]] $Message = $commandId 
    # Send the byte array 
    $Sent = $Sock.Send($Message)
    $buffer = new-object System.Byte[] 8
    $errorCode = 0
    $sock.Receive($buffer,0,1,0,[ref] $errorCode)
    $sock.Close 
    return $buffer[0] -eq 1
  }
  Catch [System.Net.Sockets.SocketException]
  {
    Write-Host "Failed to write command"
    return $false  
  }
  return $true
}

Function writeCurrentChannel($channel) {
    $channel | Out-File ".\channel.txt"
}

Function readCurrentChannel() {
    return Get-Content -Path ".\channel.txt"
}

Function Set-WindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
                 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
                 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'SHOW',
    [Parameter()]
    $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
    $WindowStates = @{
        FORCEMINIMIZE   = 11; HIDE            = 0
        MAXIMIZE        = 3;  MINIMIZE        = 6
        RESTORE         = 9;  SHOW            = 5
        SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
        SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
        SHOWNA          = 8;  SHOWNOACTIVATE  = 4
        SHOWNORMAL      = 1
    }
    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type –memberDefinition @” 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}

$wsh = New-Object -ComObject WScript.Shell
$wsh.SendKeys('{NUMLOCK}')