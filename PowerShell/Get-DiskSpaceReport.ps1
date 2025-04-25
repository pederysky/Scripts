function Get-DiskSpace {
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | 
    Select-Object DeviceID, 
        @{Name="Size(GB)";Expression={[Math]::Round($_.Size/1GB,2)}},
        @{Name="FreeSpace(GB)";Expression={[Math]::Round($_.FreeSpace/1GB,2)}},
        @{Name="PercentFree";Expression={[Math]::Round(($_.FreeSpace/$_.Size)*100,2)}}
}
