#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^!#1::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenNPO1.ps1
return

^!#2::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenNPO2.ps1
return

^!#3::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenNPOZapp.ps1
return

^!#4::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenRadio4.ps1
return

^!#5::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenNetflix.ps1
return

^!#6::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenYoutube.ps1
return

^!#7::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenPlaynite.ps1
return

^!#8::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenGoogleMusic.ps1
return

^!#o::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenPrev.ps1
return

^!#p::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File OpenNext.ps1
return

^!#s::
Run, C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -windowstyle hidden -ExecutionPolicy Bypass -File Sleep.ps1
return