. ".\Helpers.ps1"

Function openNPO1(){
  if(sendCommand 1){
    stopNonStreaming

      Write-Host "Done through streaming interface"
  } else {

      toBackground

      openChromeSelenium npo1
  }
  writeCurrentChannel 1
}

Function openNPO2(){
  if(sendCommand 2){
      stopNonStreaming

      Write-Host "Done through streaming interface"
  } else {

      toBackground

      openChromeSelenium npo2
  }
  writeCurrentChannel 2
}

Function openNPOZapp(){
  if(sendCommand 3){
      stopNonStreaming

      Write-Host "Done through streaming interface"
  } else {

      toBackground

      openChromeSelenium npo-zapp
  }
  writeCurrentChannel 3
}

Function openRadio4(){
  if(sendCommand 4){
    stopNonStreaming

      Write-Host "Done through streaming interface"
  } else {

    toBackground

     openChromeSelenium radio4
  }
  #writeCurrentChannel 4
}

Function openNetflix(){
  if(isAppActive "Netflix"){
      Write-Host "Already running. Terminating";
  } else {
    toBackground

    Start-Process "netflix:"
  }
  writeCurrentChannel 5
}

Function openYoutube(){
  #stopAll
  #openChrome "https://www.youtube.com/watch?v=RH3OxVFvTeg" false true
  if(sendCommand 6){
      stopNonStreaming
      
      Write-Host "Done through streaming interface"
  } else {

      toBackground

      openChromeSelenium youtube
  }
  writeCurrentChannel 6
}

Function openPlaynite(){
  if(isApplicationActive "PlayniteUI"){
    Write-Host "Playnite already running. Terminating"

  } else {

    toBackground

    Start-Process -FilePath "path\to\PlayniteUI.exe"
  }
  writeCurrentChannel 7
}

Function openGoogleMusic(){
  if(sendCommand 8){
      stopNonStreaming
      
      Write-Host "Done through streaming interface"
  } else {

      toBackground

      openChromeSelenium music
  }
  writeCurrentChannel 8
}


Function openChannel($number){
  switch($number){
     1 { openNPO1 }
     2 { openNPO2 }
     3 { openNPOZapp }
     4 { openRadio4 }
     5 { openNetflix }
     6 { openYoutube }
     7 { openPlaynite }
     8 { openGoogleMusic }
     default { openNetflix }
  }
}
