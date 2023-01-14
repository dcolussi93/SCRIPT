# Forma de uso
Script powershell que consultan estadisticas de uso de MS powerbi.

https://learn.microsoft.com/en-us/powershell/power-bi/overview?view=powerbi-ps

https://learn.microsoft.com/en-us/powershell/module/microsoftpowerbimgmt.admin/get-powerbiactivityevent?view=powerbi-ps

# Comando Instalacion
Forma de instalar y usar
```
Install-Module -Name MicrosoftPowerBIMgmt
Connect-PowerBIServiceAccount
Get-PowerBIActivityEvent -StartDateTime '2023-01-08T00:01:20' -EndDateTime '2023-01-08T23:59:50'
```
Ejecutar comando completo
```
PS C:\Users\xxxx\SCRIPT\METRICAS_PBI> .\_RUNALL.ps1
```
# Resultado
Metricas se guardan en la siguiente carpeta
```
DATAEXPORT
```
