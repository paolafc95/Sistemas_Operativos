function Show-Menu
{
     param (
           [string]$Title = 'DATA CENTER MANAGER'
     )
     cls
     Write-Host "================ $Title ================"
    
     Write-Host "1: Desplegar los 5 procesos que consumen m�s CPU en este momento."
     Write-Host "2: Desplegar los filesystems o discos conectados a la m�quina."
     Write-Host "3: Desplegar el nombre y el tama�o del archivo m�s grande almacenado en un disco."
     Write-Host "4: Cantidad de memoria libre y cantidad del espacio de swap en uso."
     Write-Host "5: N�mero de conexiones de red activas actualmente."
     Write-Host "Q: Presione 'Q' para salir."
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                cls
                Get-Process | sort CPU -Descending | Select-Object -First 5
           } '2' {
                cls
                Get-PSDrive | Where {$_.Free -gt 0} | ft Name, @{n='Tama�o (bytes)'; e={$_.Used + $_.Free}}, Used, Free
           } '3' {
                $discoFile = Read-Host "Ingrese el disco o filesystem"
                Write-Host "Directorio ingresado: $discoFile"              
                Get-ChildItem -Path $discoFile -Recurse -file | sort -Descending -Property Length | Select-Object  * -First 1  |  ft  @{n='Nombre';e={$_.Name}},@{n='Tama�o (MB)';e={$_.Length / 1MB -as [int]}},@{n='Trayectoria';e={$_.Fullname}}
           } '4' {
                cls
                $ramTotal=get-ciminstance -class "cim_physicalmemory" | % {$_.Capacity}
                $ramLibre=get-ciminstance Win32_OperatingSystem | Select FreePhysicalMemory
                
                $system = Get-WmiObject win32_OperatingSystem
                $totalPhysicalMem = $system.TotalVisibleMemorySize
                $freePhysicalMem = $system.FreePhysicalMemory
                $usedPhysicalMem = $totalPhysicalMem - $freePhysicalMem
                $usedPhysicalMemPct = [math]::Round(($usedPhysicalMem / $totalPhysicalMem) * 100,1)
                $freePhysicalMemPct = 100 - ([math]::Round(($usedPhysicalMem / $totalPhysicalMem) * 100,1))
                "Memoria Libre: $freePhysicalMem bytes"
                "Memoria libre en porcentaje: $freePhysicalMemPct %"
                "Memoria en uso en porcentaje: $usedPhysicalMemPct %"
           } '5' {
                cls
                Get-NetTCPConnection | where {$_.State -eq "Established"}
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')