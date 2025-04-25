function Get-CriticalEvents {
    param([int]$Hours = 24)
    
    $StartTime = (Get-Date).AddHours(-$Hours)
    $Events = Get-WinEvent -FilterHashtable @{
        LogName = 'System', 'Application'
        Level = 1,2,3
        StartTime = $StartTime
    } -ErrorAction SilentlyContinue
    
    $Events | Select-Object TimeCreated, LogName, ProviderName, Id, LevelDisplayName, Message |
    Format-Table -AutoSize -Wrap
}
