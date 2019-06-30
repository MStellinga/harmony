. ".\ChannelHelpers.ps1"

# Not currently assigned
try {
  $current = readCurrentChannel
  $current = [int] $current
  Write-Host "Switching to $current"
} catch {
    $current = 0
}
openChannel $current