#!/bin/sh
#Cortafuegos para la configuracion de iptables
#borrado de reglas
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

#Politica por defecto ACEPTAR
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREORUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

#para evitar errores en el sistema 
#aceptar todas las comunicaciones localhost 
iptables -A -i eth0 -j ACCEPT

#Aceptamos las comunicaciones que nos interesan y luego denegamos el resto
#ejemplo: Denegar acceso
iptables -A FORWARD -s 192.168.0.0/24 -j DROP

#aceptamos SMTP, POP3 Y FTP (correo electronico y ftp)
iptables -A FORWARD -s 0/0 -p tcp --dport 25 -j ACCEPT 
iptables -A FORWARD -s 0/0 -p tcp --dport 110 -j ACCEPT
iptables -A FORWARD -s 0/0 -p tcp --dport 20 -j ACCEPT
iptables -A FORWARD -s 0/0 -p tcp --dport 21 -j ACCEPT
#iptables -A FORWARD -s 10.0.0.0/8 -p tcp --dport 8080 -j ACCEPT

#HTTP Y HTTPS no son necesarios porque el servidor es proxy
#se dejaran comentadas a futuro
#iptables -A FORWARD -s 10.0.0.0/8 -p tcp --dport 80 -j ACCEPT
#iptables -A FORWARD -s 10.0.0.0/8 -p udp --dport 443 -j ACCEPT

#acceso a todo para el administrador 
iptables -A FORWARD -s 0/0 -j ACCEPT 

#denegamos todas las comunicaciones
iptables -A FORWARD -s 192.168.0.0/24 -j DROP

#Hacemos NAT si la ip local sale por ethernet
iptables -t nat -A POSTROUTING -s 0/0 eth0 -j MASQUERADE

#activamos el enrutamiento
echo 1 > /proc/sys/net/ipv4/ip_forward

#compravamos el estado de las reglas
iptables -L -n 