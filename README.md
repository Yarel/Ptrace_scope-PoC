# Explotando ptrace_scope - PoC


#### Este exploit es funcional en > = Ubuntu, CentOS, RedHat, Kali, Parrot


## Introduction

Sudo crea un archivo para cada usuario de Linux en /var/run/sudo/ts/[username]. 
Estos archivos contienen autenticaciones exitosas y fallidas, luego sudo usa estos archivos 
para recordar todos los procesos autenticados de lo cual nosotros nos aprovecharemos
de dichos tokens y hacer un secuestro de sesion (Session hijacking) para hacer escalada de privilegios (root).

## Requisitos
	
	- cat /proc/sys/kernel/yama/ptrace_scope = 0
	- gdb instalado

	
