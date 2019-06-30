. ".\ChannelHelpers.ps1"

try {
  $current = readCurrentChannel
  $current = [int] $current
  $current++
  if($current -gt 6){
    $current = 0
  }
  Write-Host "Switching to $current"
} catch {
    $current = 0
}
openChannel $current