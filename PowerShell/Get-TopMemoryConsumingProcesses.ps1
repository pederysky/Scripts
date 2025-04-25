function Get-TopMemoryProcesses {
    Get-Process | Sort-Object -Property WS -Descending | Select-Object -First 10 ProcessName, ID, 
    @{Name="Memory Usage (MB)";Expression={[Math]::Round($_.WS / 1MB, 2)}}, CPU | Format-Table -AutoSize
}
