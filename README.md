# Explotando ptrace_scope - PoC


#### Este exploit es funcional en Ubuntu, CentOS, RedHat, Kali, Parrot, Debian


## Introduction

Sudo crea un archivo para cada usuario de Linux en /var/run/sudo/ts/[username]. 
Estos archivos contienen autenticaciones exitosas y fallidas, luego sudo usa estos archivos 
para recordar todos los procesos autenticados por otro lado esta ptrace_scope.
Linux tiene la capacidad de incluir módulos de seguridad de Linux, para proporcionar funciones adicionales con los medios de un módulo. 
Yama realiza el control de acceso discrecional de algunas funciones relacionadas con el núcleo, como definir si se permite el rastreo de procesos (prace).
El parámetro kernel.yama.ptrace_scope ayuda a los administradores del sistema a seleccionar qué procesos se pueden depurar con ptrace.
Podemos determinar el valor activo con sysctl o usando el pseudo sistema de archivos /proc y encontrar la clave relacionada.


````     $ sysctl kernel.yama.ptrace_scope
	    kernel.yama.ptrace_scope = 1
````


o realizando:


````
 	    $ cat / proc / sys / kernel / yama / ptrace_scope

    		1
````

Para esta clave en particular hay cuatro opciones válidas: 0-3


    kernel.yama.ptrace_scope = 0 : todos los procesos se pueden depurar, siempre que tengan el mismo uid. 
				   Esta es la forma clásica de cómo funciona el trazado.

    kernel.yama.ptrace_scope = 1 : solo se puede depurar un proceso padre.

    kernel.yama.ptrace_scope = 2 : solo el administrador puede usar ptrace, ya que requería la capacidad CAP_SYS_PTRACE.

    kernel.yama.ptrace_scope = 3 : no se pueden rastrear procesos con ptrace. 
				   Una vez configurado, es necesario reiniciar para habilitar nuevamente el seguimiento.


## Run

## Requisitos
	
	- cat /proc/sys/kernel/yama/ptrace_scope = 0
	- gdb instalado

Teniendo en cuenta que el valor por defecto en Ubuntu, CentOS, RedHat, Kali, Parrot, Debian es igual a 0 aprevechamos
Escalada de privilegios mediante inyección (trazado) del proceso que tenga un token sudo válido y activar nuestro propio token sudo similar
a Session hijacking

## ¿Cómo remediar?

    	 Reduzca la potencia de ptrace, edite el ejemplo /etc/sysctl.conf con

		````
		kernel.yama.ptrace_scope = 1
		````


