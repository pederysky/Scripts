function Get-SecurityReport {
    $ReportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $ComputerName = $env:COMPUTERNAME
    
    Write-Host "Reporte de Seguridad para $ComputerName - $ReportDate" -ForegroundColor Cyan
    Write-Host "------------------------------------------------" -ForegroundColor Cyan
    
    # Verificar Firewall
    $FirewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled
    Write-Host "Estado del Firewall:" -ForegroundColor Yellow
    $FirewallStatus | Format-Table -AutoSize
    
    # Verificar antivirus
    $AntivirusProduct = Get-WmiObject -Namespace "root\SecurityCenter2" -Class AntiVirusProduct -ErrorAction SilentlyContinue
    if ($AntivirusProduct) {
        Write-Host "Productos Antivirus:" -ForegroundColor Yellow
        $AntivirusProduct | Select-Object displayName, productState | Format-Table -AutoSize
    } else {
        Write-Host "No se pudo detectar información del antivirus" -ForegroundColor Red
    }
    
    # Últimas 5 autenticaciones fallidas
    Write-Host "Últimos 5 intentos de autenticación fallidos:" -ForegroundColor Yellow
    Get-WinEvent -FilterHashtable @{LogName='Security'; ID=4625} -MaxEvents 5 -ErrorAction SilentlyContinue |
    Select-Object TimeCreated, @{Name='Usuario';Expression={$_.Properties[5].Value}} |
    Format-Table -AutoSize
}
