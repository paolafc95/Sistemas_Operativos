### CLASE 4 - POWERSHELL

1. Mostrar una tabla de procesos que incluya únicamente los nombres de los procesos, sus IDs, y si están respondiendo a Windows (la propiedad Responding muestra eso). Haga que la tabla tome el mínimo de espacio horizontal, pero no permita que la información se trunque.
~~~
Get-Process | ft -AutoSize -Wrap   name, id, responding
~~~

2. Muestre una tabla de procesos que incluya los nombres de los procesos y sus IDs. También incluya columnas para uso de memoria virtual y física; exprese dichos valores en megabytes (MB).
~~~
Get-Process |ft name, id, @{n='VM (MB)'; e={$_.VM / 1MB -as [int]}}, @{n='PM (MB)'; e={$_.pm / 1MB -as [int]}}
~~~

3. Emplee Get-EventLog para mostrar una lista de los logs de eventos disponibles (revise la ayuda para encontrar el parámetro que le permitirá obtener dicha información). Formatee la salida como una tabla que incluya el nombre de despliegue del log y el período de retención. Los encabezados de columna deben ser NombreLog y Per-Retencion.
~~~
Get-EventLog -List 
~~~

4. Muestre una lista de servicios, de tal manera que aparezcan agrupados los servicios que están iniciados y los que están detenidos. Los que están iniciados deben aparecer primero.
~~~
Get-EventLog -lis | fl @{n='NombreLog';e={$_.LogDisplayName}}, @{n='Per-Retencion';e={$_.retain}}
~~~

5. Mostrar una lista a cuatro columnas de todos los directorios que están en el raíz de la unidad C:
~~~
dir | fw -column 4
~~~

6. Cree una lista formateada de todos los archivos .exe del directorio C:\Windows. Debe mostrarse el nombre, la información de versión, y el tamaño del archivo. La propiedad de tamaño se llama length en Powershell, pero para mayor claridad, la columna se debe llamar Tamaño en su listado.
~~~
Get-ChildItem -Path C:\Windows -Filter *.exe|fl -Property @{n='Nombre';e={$_.Name}},@{n='Tamaño';e={$_.Length / 1KB -as [int]}},@{n='Versión';e={$_.VersionInfo.FileVersion}}
~~~

7. Importe el módulo NetAdapter (empleando el comando Import-Module NetAdapter). Empleando el cmdlet Get-NetAdapter, muestre una lista de adaptadores no virtuales (adaptadores cuya propiedad Virtual sea falsa. El valor lógico falso es representado por Powershell como $False).
~~~
Get-NetAdapter | Where-Object {$_.Virtual -eq '$false'}
~~~

8. Importe el módulo DnsClient. Empleando el cmdlet Get-DnsClientCache, muestre una lista de los registros A y AAAA que estén en el caché. Sugerencia: Si el caché está vacío, visite algunos sitios web para poblarlo.
~~~
Get-DnsClientCache -Type A
~~~
~~~
Get-DnsClientCache -Type AAAA
~~~

9. Genere una lista de todos los archivos .exe del directorio C:\Windows\System32 que tengan más de 5 MB.
~~~
Get-ChildItem -Path C:\Windows\System32 -Filter *.exe|fl -Property @{n='Nombre';e={$_.Name}},@{n='Tamaño';e={$_.Length /5MB -as [int]}}
~~~

10. Muestre una lista de parches que sean actualizaciones de seguridad.
~~~
Get-HotFix -Description 'security*'
~~~

11. Muestre una lista de parches que hayan sido instalados por el usuario Administrador, que sean actualizaciones. Si no tiene ninguno, busque parches instalados por el usuario System. Note que algunos parches no tienen valor en el campo Installed By.
~~~
Get-HotFix | Where-Object {$_.installedby -like '*system*' -and $_.description -like 'update'}
~~~

12. Genere una lista de todos los procesos que estén corriendo con el nombre Conhost o Svchost.
~~~
Get-Process | Where-Object -FilterScript {$_.Name -like 'svchost*'}
~~~
~~~
Get-Process | Where-Object -FilterScript {$_.Name -like 'conhost*'}
~~~

