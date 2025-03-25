# Convierte la contraseña a un objeto SecureString para mayor seguridad.
$pass = ConvertTo-SecureString "password" -AsPlainText -Force

# Habilita la opción para permitir BitLocker sin un TPM
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\BitLocker" -Name "RequireAdditionalAuthenticationAtStartup" -Value 1 -Force

# Habilita la opción "Permitir BitLocker sin un TPM compatible"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\BitLocker" -Name "AllowStandardUser" -Value 1 -Force

# Activa BitLocker en la unidad C: con el método de cifrado AES de 128 bits usando la contraseña almacenada en $pass.
Enable-BitLocker -MountPoint "C:" -EncryptionMethod Aes128 -Password $pass -PasswordProtector

# Muestra los protectores de clave actuales para la unidad C:.
manage-bde -protectors -get C:

# Reinicia el equipo de inmediato, sin esperar.
shutdown /r /t 0
