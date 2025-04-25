function Get-PendingUpdates {
    $Session = New-Object -ComObject "Microsoft.Update.Session"
    $Searcher = $Session.CreateUpdateSearcher()
    $Updates = $Searcher.Search("IsInstalled=0")
    
    if ($Updates.Updates.Count -eq 0) {
        Write-Host "No hay actualizaciones pendientes" -ForegroundColor Green
    } else {
        Write-Host "Actualizaciones pendientes:" -ForegroundColor Yellow
        foreach ($Update in $Updates.Updates) {
            Write-Host " - $($Update.Title)"
        }
    }
}
