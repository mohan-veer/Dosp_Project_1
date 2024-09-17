param (
    [Parameter(Mandatory=$true)]
    [string]$ProgramPath,
    
    [Parameter(Mandatory=$true)]
    [string]$Arguments
)

$process = Start-Process -FilePath $ProgramPath -ArgumentList $Arguments -PassThru -NoNewWindow -Wait

# Get process start time
$startTime = $process.StartTime

# Wait for process to exit
$process.WaitForExit()

# get the process end time
$endTime = $process.ExitTime

$realTime = $endTime - $startTime
$realTime = $realTime.TotalSeconds

$userTime   = $process.UserProcessorTime
$systemTime = $process.PrivilegedProcessorTime

$cpuTime = $userTime.TotalSeconds + $systemTime.TotalSeconds

Write-Host "User Time:    $($userTime.TotalSeconds) seconds"
Write-Host "System Time:  $($systemTime.TotalSeconds) seconds"
Write-Host "CPU Time:     $cpuTime seconds"
Write-Host "Real Time:    $realTime seconds"
Write-Host "`n"


if ($realTime -gt 0) {
    $cpuToRealRatio = $cpuTime / $realTime
    Write-Host "Cores used:   $cpuToRealRatio"
} else {
    Write-Host "Cores used: N/A (Real Time too small to measure)"
}