# Declaramos variables:

I = sbin/iptables
LAN = 10.0.1.0/24
ADMIN = 10.0.1.22
SERVERS = 10.0.2.0/24
DMZ = 181.16.1.16/28
DB = 10.0.2.3
INET = 200.3.1.2
ILAN = eth0
ISERV = eth1
IDMZ = eth2
IINET = eth3
WEB = 181.16.1.18
DNS = 181.16.1.19
# Damos la politica ante omision

$I -P FORWARD DROP

# Nos encargamos de conexiones invalidas o ya establecidas.

$I -A FORWARD -m state --state INVALID -j REJECT
$I -A FORWARD -m state --state RELATED, ESTABLISHED -j ACCEPT

#Nateamos la salida de la LAN a Internet
$I -t nat -A POSTROUTING -s $LAN -o $IINET -j SNAT --to-source $INET

# Le damos acceso completo a la LAN para internet y la DMZ.

$I -A FORWARD -s $LAN -i $ILAN -d $DMZ -o $IDMZ -j ACCEPT
$I -A FORWARD -s $LAN -i $ILAN -o $IINET -j ACCEPT

#Por politica se rechaza todo lo demas, pero igualmente lo escribimos para dar una
#capa mas de seguridad.

$I -A FORWARD -s $LAN -i $ILAN -j REJECT

# Acceso a la dmz desde el exterior:

$I -A FORWARD -i $IINET -d $DNS -o $IDMZ -p tcp --dport 53 -j ACCEPT
$I -A FORWARD -i $IINET -d $DNS -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -i $IINET -d $WEB -o $IDMZ -p tcp -m multiport --dports 53,80,443 -j ACCEPT
$I -A FORWARD -i $IINET -d $WEB -o $IDMZ -p udp -m multiport --dports 53,80 -j ACCEPT

# Reglas para la DMZ

$I -A FORWARD -s $DMZ -i $IDMZ -o $IINET -p tcp --dport 53 -j ACCEPT
$I -A FORWARD -s $DMZ -i $IDMZ -o $IINET -p udp --dport 53 -j ACCEPT
$I -A FORWARD -s $DMZ -i $IDMZ -d $DB -o $ISERV -p tcp --dport 3306 -j ACCEPT

#Rechazamos lo demas
$I -A FORWARD -j REJECT
