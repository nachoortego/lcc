# Definimos variables
I = /sbin/iptables
LAN = 10.23.0.0/16
SRV = 10.10.0.0/22
DBSRV = 10.10.1.2
MAILSRV = 10.10.1.3
INET = 200.123.131.112
DMZ = 10.1.1.0/29
WEBSRV = 10.1.1.2
MAILRELAY = 10.1.1.3
IINET = eth0
ISRV = eth1
ILAN = eth2
IDMZ = eth3

ADMIN = 10.23.23.5
# Politicas por omision
$I -P FORWARD DROP

# Para el item 8 dejamos las siguientes politicas

$I -P INPUT DROP
$I -P OUTPUT DROP

# Descartamos conexiones invalidad y aceptamos aquellas que ya han sido establecidas.

$I -A FORWARD -m state --state INVALID -j DROP
$I -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#Para el item 8 tambien hacemos lo mismo

$I -A INPUT -m state --state INVALID -j DROP
$I -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

$I -A OUTPUT -m state --state INVALID -j DROP
$I -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

#1. Le damos acceso a las PC de la lan para el servidor de correo en la red de servers.

$I -A FORWARD -s $LAN -i $ILAN -d $MAILSRV -o $ISRV -p tcp -m multiport --dports imap,imaps,pop,pop3s,smtp,smtp-ssl -j ACCEPT

#Le damos permisos para dbserver en el puerto https (443)

$I -A FORWARD -s $LAN -i $ILAN -d $DBSRV -o $ISRV -p tcp --dport 443 -j ACCEPT

#Le damos permisos a la lan para el DNS de la dmz (53 UDP y TCP)

$I -A FORWARD -s $LAN -i $ILAN -d $DMZ -o $IDMZ -p tcp --dport 53 -j ACCEPT
$I -A FORWARD -s $LAN -i $ILAN -d $DMZ -o $IDMZ -p udp --dport 53 -j ACCEPT

#2.

$I -A FORWARD -s $MAILSRV -i $ISRV -d $MAILRELAY -o $IDMZ -p tcp -m multiport --dports 53,465 -j ACCEPT
$I -A FORWARD -s $MAILSRV -i $ISRV -d $MAILRELAY -o $IDMZ -p udp --dport 53 -j ACCEPT

#3. Le damos acceso al relay para el puerto 465 del mail serv.
$I -A FORWARD -s $MAILRELAY -i $IDMZ -d $MAILSRV -o $ISRV -p tcp --dport 465 -j ACCEPT

#4.Le damos permiso al websrv al puerto 3306 tcp del dbserv.

$I -A FORWARD -s $WEBSRV -i $IDMZ -d $DBSRV -o $ISRV -p tcp --dport 3306 -j ACCEPT

#5. Le damos permiso a las PC para navegar libremente por internet.

$I -A FORWARD -s $LAN -i $ILAN -o $IINET -j ACCEPT
#Nateamos las pcs de la LAN
$I -t nat -A POSTROUTING -s $LAN -o $IINET -j SNAT --to-source $INET

#6. Le damos permiso a lo que venga de internet para acceder a los servicios

$I -A FORWARD -i $IINET -d $MAILRELAY -o $IDMZ -p tcp -m multiport --dports 25,53 -j ACCEPT
$I -A FORWARD -i $IINET -d $MAILRELAY -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -i $IINET -d $WEBSRV -o $IDMZ -p tcp -m multiport --dports 80,443 -j ACCEPT

# Sin embargo necesitamos hacer un PREROUTING, ya que cuando internet manda a nuestra
# direccion publica, tenemos que cambiar la ip de destino ya que nuestra DMZ es privada.

$I -t nat -A PREROUTING -i $IINET -d $INET -p tcp -m multiport --dports 25,53 -j DNAT --to-destination $MAILRELAY
$I -t nat -A PREROUTING -i $IINET -d $INET -p udp --dport 53 -j DNAT --to-destination $MAILRELAY
$I -t nat -A PREROUTING -i $IINET -d $INET -p tcp -m multiport --dports 80,443 -j DNAT --to-destination $WEBSRV

#7. Aceptamos que los servidores DMZ consulten DNS a internet, sumado al correo del
# relay.

$I -A FORWARD -s $WEBSRV -i $IDMZ -o $IINET -p tcp --dport 53 -j ACCEPT
$I -A FORWARD -s $WEBSRV -i $IDMZ -o $IINET -p udp --dport 53 -j ACCEPT

$I -A FORWARD -s $MAILRELAY -i $IDMZ -o $IINET -p tcp -m multiport --dports 25,53 -j ACCEPT
$I -A FORWARD -s $MAILRELAY -i $IDMZ -o $IINET -p udp --dport 53 -j ACCEPT

# Nuevamente tenemos que natear en POSTROUTING, ya que al salir la consulta a internet
# saldria con una ip privada lo cual no es posible
$I -t nat -A POSTROUTING -s $MAILRELAY -o $IINET -j SNAT --to-source $INET
$I -t nat -A POSTROUTING -s $WEBSRV -o $IINET -j SNAT --to-source $INET

#8. 

$I -A INPUT -s $ADMIN -i $ILAN -p tcp --dport ssh -j ACCEPT

$I -A OUTPUT -d $DMZ -o $IDMZ -p tcp --dport 53 -j ACCEPT
$I -A OUTPUT -d $DMZ -o $IDMZ -p udp --dport 53 -j ACCEPT
