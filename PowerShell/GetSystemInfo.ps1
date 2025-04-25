function Get-SystemInfo {
    $computerSystem = Get-CimInstance CIM_ComputerSystem
    $computerBIOS = Get-CimInstance CIM_BIOSElement
    $computerOS = Get-CimInstance CIM_OperatingSystem
    $computerCPU = Get-CimInstance CIM_Processor
    $computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

    Write-Host "Información del sistema:" -ForegroundColor Yellow
    Write-Host "Fabricante: $($computerSystem.Manufacturer)"
    Write-Host "Modelo: $($computerSystem.Model)"
    Write-Host "Nombre: $($computerSystem.Name)"
    Write-Host "BIOS: $($computerBIOS.Name)"
    Write-Host "Sistema Operativo: $($computerOS.Caption) Service Pack: $($computerOS.ServicePackMajorVersion)"
    Write-Host "Arquitectura: $($computerOS.OSArchitecture)"
    Write-Host "Procesador: $($computerCPU.Name)"
    Write-Host "Memoria RAM: $([Math]::Round($computerSystem.TotalPhysicalMemory / 1GB, 2)) GB"
    Write-Host "Espacio en Disco C: $([Math]::Round($computerHDD.Size / 1GB, 2)) GB"
    Write-Host "Espacio Libre: $([Math]::Round($computerHDD.FreeSpace / 1GB, 2)) GB"
}
