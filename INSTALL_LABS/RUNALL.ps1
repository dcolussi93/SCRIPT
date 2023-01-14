$scriptsList = @(
    '_DOWNLOAD2.ps1',
    '_INSTALL2.ps1'
)
# Ejecutar Scripts
foreach( $script in $scriptsList) {
    Invoke-Expression ".\$script"
}