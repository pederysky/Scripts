# Obtener clave de BIOS
$key = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey
 
# Si no encuentra en BIOS, buscar en el registro
if ([string]::IsNullOrWhiteSpace($key)) {
    $key = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform").BackupProductKeyDefault
}
 
# Preparar datos
$computerName = $env:COMPUTERNAME
$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
 
# Guardar resultado
$path = "$env:USERPROFILE\Desktop\Windows11_Licencia.txt"
if ($key) {
    @"
Fecha: $date
Equipo: $computerName
Clave de producto: $key
"@ | Out-File -FilePath $path
    Write-Output "Licencia guardada en: $path"
} else {
    Write-Output "No se encontró ninguna clave de producto."
}