# Harmony
My scripts for use with my Harmony remote (https://www.logitech.com/en-us/harmony-universal-remotes) 
and Flirc (https://flirc.tv)


## Installation
Copy the scripts folder to C:/harmony

Compile the Java code (with Maven) and store it in C:/harmony/selenium

Add the correct dependency jars to C:/harmony/selenium

Install AutoHotkey (https://www.autohotkey.com)

Start the Hotkeys.ahk script in the scripts folder (using the right mouse) 

## Keys
`Ctrl + Alt+ Win 1` *Channel 1*

...

`Ctrl + Alt+ Win 8` *Channel 8*

`Ctrl + Alt+ Win o` *prev channel*

`Ctrl + Alt+ Win p` *next channel*

`Ctrl + Alt+ Win s` *PC to sleep*

## Mouse
Use the KeysToMouse.ahk script in the scripts folder

## TODO

- Proper Maven assembly
- Proper properties in Java application
- Clean up some of the Powershell code
- Remove duplicates from KeysToMouse.ahk
- Unit tests? 
