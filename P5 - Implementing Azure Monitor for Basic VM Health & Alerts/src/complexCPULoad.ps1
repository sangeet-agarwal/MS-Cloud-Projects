function Start-CPUStress {
    param (
        [int]$TargetCpu = 80,
        [int]$DurationSeconds = 300 # 5 minutes
    )

    Write-Host "Starting CPU stress to target $TargetCpu% for $DurationSeconds seconds..."

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $endTime = $sw.Elapsed.TotalSeconds + $DurationSeconds

    while ($sw.Elapsed.TotalSeconds -lt $endTime) {
        $startTime = Get-Date

        # Work phase (high CPU usage)
        # Adjust this loop count based on your VM's CPU speed to achieve desired load
        # You might need to experiment with the number 10000000 for your specific VM
        for ($i = 0; $i -lt 10000000; $i++) {
            $null = [Math]::Sqrt($i) * [Math]::Sin($i)
        }

        $workDuration = (Get-Date) - $startTime

        # Sleep phase (low CPU usage) to average out to TargetCpu
        # This is a simplification; for precise control, you'd need more advanced techniques
        $sleepDuration = [System.TimeSpan]::FromMilliseconds(($workDuration.TotalMilliseconds * (100 - $TargetCpu) / $TargetCpu))

        if ($sleepDuration.TotalMilliseconds -gt 0) {
            Start-Sleep -Milliseconds $sleepDuration.TotalMilliseconds
        }
    }
    Write-Host "CPU stress finished."
}

# To run this function, call it with your desired target CPU and duration:
# Example: To target roughly 85% CPU for 10 minutes (600 seconds)
# Start-CPUStress -TargetCpu 85 -DurationSeconds 600

# For triggering an alert at >80%, you might just run the basic loop (Option 1) in multiple PowerShell windows,
# or experiment with a very high TargetCpu like 95 or 100 in this function if it effectively stresses your VM.
# Let's use a simple and direct approach for alert testing:
# Run Option 1 in 2-3 PowerShell windows to ensure sustained high load.
