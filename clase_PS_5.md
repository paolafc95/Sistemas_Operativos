## CLASE 5 - POWERSHELL

1. ¿Cuál clase puede emplearse para consultar la dirección IP de un adaptador de red? ¿Posee dicha clase algún método para liberar un préstamo de dirección (lease) DHCP?
~~~
Get-CimInstance Win32_NetworkAdapterConfiguration | Select-Object IP
~~~
- No se encontró una clase con algún método que libere un préstamo de dirección DHCP

2. Despliegue una lista de parches empleando WMI (Microsoft se refiere a los parches con el nombre quick-fix engineering). Es diferente el listado al que produce el cmdlet Get-Hotfix?
~~~
Get-WmiObject -Namespace root\CIMv2 -Class Win32_QuickFixEngineering
~~~

3. Empleando WMI, muestre una lista de servicios, que incluya su status actual, su modalidad de inicio, y las cuentas que emplean para hacer login.
~~~
Get-WmiObject win32_service | Select-Object name, status, startmode, startname
~~~

4. Empleando cmdlets de CIM, liste todas las clases del namespace SecurityCenter2, que tengan product como parte del nombre.
~~~
Get-CimClass -Namespace root\SecurityCenter2 | where CimClassProperties -Like '*product*'
~~~

5. Empleando cmdlets de CIM, y los resultados del ejercicio anterior, muestre los nombres de las aplicaciones antispyware instaladas en el sistema. También puede consultar si hay productos antivirus instalados en el sistema.
~~~
Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiSpywareProduct | ft -Property displayName, productState, timestamp
~~~
~~~
Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntiVirusProduct | ft -Property displayName, productState, timestamp
~~~
