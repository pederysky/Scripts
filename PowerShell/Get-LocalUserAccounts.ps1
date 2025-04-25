function Get-LocalUsers {
    Get-LocalUser | Select-Object Name, Enabled, LastLogon, PasswordRequired, PasswordLastSet |
    Format-Table -AutoSize
}
