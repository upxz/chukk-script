#!/bin/bash
clear
[[ $(uname -m 2> /dev/null) != x86_64 ]] && echo -e " SLOWDNS NO COMPATIBLE CON ARM64 \n" && read -p " ENTER PARA REGRESAR " && exit 
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "  \033[1;33mAGUARDE \033[1;37m- \033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}

mportas () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $portas|grep "$var1:$var2")" ]] || portas+="$var1:$var2\n"
done <<< "$portas_var"
i=1
echo -e "$portas"
} 

clear
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%40s%s%-12s\n' "INSTALADOR SLOWDNS MANAGER" ; tput sgr0
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
echo -e ""
echo -e "       Este script instalara las dependencias"
echo -e "   Para el Pannel ADMINISTRADOR de Conexion SlowDNS."
echo -e ""
echo -e "    \033[1;33mINSTALADOR REFACTORIZADO POR @drowkid01 \033[1;37m"
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
echo ""
echo -e " DESCARGANDO LAS DEPENDENCIAS..."
echo ""
[[ $(uname -m 2> /dev/null) != x86_64 ]] && echo -e " SLOWDNS NO COMPATIBLE CON ARM64 \n" && read -p " ENTER PARA REGRESAR " && exit 
fun_att () {
apt install ncurses-utils -y
mkdir /etc/slowdns
cd /etc/slowdns
wget https://www.dropbox.com/s/di46c8oucqu7j1k/dns-server; chmod +x dns-server  #https://github.com/leitura/slowdns/raw/main/dns-server
#wget https://raw.githubusercontent.com/leitura/slowdns/main/remove-slow; chmod +x remove-slow
wget https://www.dropbox.com/s/g3z7vme48ecpefe/remove-slow; chmod +x remove-slow
#wget https://raw.githubusercontent.com/leitura/slowdns/main/slowdns-info; chmod +x slowdns-info
wget https://www.dropbox.com/s/2wkvlbne7yg3n9o/slowdns-info; chmod +x slowdns-info
wget https://raw.githubusercontent.com/leitura/slowdns/main/slowdns-drop; chmod +x slowdns-drop
wget https://www.dropbox.com/s/40c91zapv9swf73/slowdns-ssh; chmod +x slowdns-ssh
wget https://raw.githubusercontent.com/leitura/slowdns/main/slowdns-ssl; chmod +x slowdns-ssl
wget https://raw.githubusercontent.com/leitura/slowdns/main/slowdns-socks; chmod +x slowdns-socks
wget https://www.dropbox.com/s/tcojobrnksceacw/slowdns; chmod +x slowdns; cp slowdns /bin/
#wget https://raw.githubusercontent.com/leitura/slowdns/main/stopdns; chmod +x stopdns
wget https://www.dropbox.com/s/2lj498mi40x7xi2/stopdns; chmod +x stopdns
}
fun_bar 'fun_att'
echo -e "CONFIGURANDO FIREWALL... ( PUERTOS ACTIVADOS )"
echo ""
fun_ports () {
portas1=$(mportas)
apt install firewalld -y 
for i in ${portas1}; do
b=$(echo $i | awk -F ":" '{print $2}')
sudo firewall-cmd --zone=public --permanent --add-port=${b}/tcp
done
sudo firewall-cmd --zone=public --permanent --add-port=5300/udp
sudo firewall-cmd --zone=public --permanent --add-port=7300/udp
sudo firewall-cmd --reload
}
fun_bar
#fun_bar #'fun_ports' 
echo -e "DEFINIENDO DNS DE CLOUDFLARE  ( 1.1.1.1 )..."
echo ""
fun_dnscf () {
sudo systemctl disable systemd-resolved.service && sudo systemctl stop systemd-resolved.service && sudo mv /etc/resolv.conf /etc/resolv.conf.bkp
echo "nameserver 1.1.1.1" > /etc/resolv.conf
echo "nameserver 1.0.0.1" >> /etc/resolv.conf
sudo systemctl enable systemd-resolved.service && sudo systemctl start systemd-resolved.service
sleep 0.5s
}
fun_bar 'fun_dnscf'
clear
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%40s%s%-12s\n' "INSTALADOR SLOWDNS MANAGER" ; tput sgr0
echo -e "\033[1;31m════════════════════════════════════════════════════\033[0m"
echo ""
echo -e "          \033[1;33mINSTALACION FINALIZADA!\033[0m          "
echo ""
echo -e "Para abrir el menu, use el comando: \033[1;33mslowdns\033[0m"
cd
slowdns
rm -rf install