function Clear-TempFiles {
    $tempfolders = @(
        "C:\Windows\Temp\*"
        "C:\Windows\Prefetch\*"
        "C:\Documents and Settings\*\Local Settings\temp\*"
        "C:\Users\*\AppData\Local\Temp\*"
    )
    
    foreach ($folder in $tempfolders) {
        Remove-Item $folder -Force -Recurse -ErrorAction SilentlyContinue
    }
    Write-Host "Archivos temporales eliminados" -ForegroundColor Green
}
