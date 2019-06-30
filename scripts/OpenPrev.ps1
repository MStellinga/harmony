. ".\ChannelHelpers.ps1"

try {
  $current = readCurrentChannel
  $current = [int] $current
  $current--
  if($current -lt 0){
    $current = 6
  }
  Write-Host "Switching to $current"
} catch {
    $current = 6
}
openChannel $current