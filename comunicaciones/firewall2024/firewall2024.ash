# Declaramos variables NOTA: eth0 = LAN, eth1=DMZ, eth2 = Internet
I = /sbin/iptables
LAN = 192.168.0.0/24
DMZ = 168.96.18.0/29
INET = 45.231.2.17
SRV1 = 168.96.18.2
SRV2 = 168.96.18.3
PROXY = 168.96.18.4
ILAN = eth0
IDMZ = eth1
IINET = eht2

# Regla de FORWARD por omision (si no matchea ninguna regla)
$I -P FORWARD DROP

# Aceptamos por defecto conexiones ya establecidas, y rechazamos las invalidas

$I -A FORWARD -m state --state INVAlID -j DROP
$I -A FORWARD -m state --state ESTABLISHED, RELATED -j ACCEPT

# Regla 1: aceptamos solicitudes de la LAN para DNS a los sv de la DMZ.

$I -A FORWARD -s $LAN -i $ILAN -d $SRV1 -o $IDMZ -p tcp --dport 53 -j ACCEPT

$I -A FORWARD -s $LAN -i $ILAN -d $SRV1 -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -s $LAN -i $ILAN -d $SRV2 -o $IDMZ -p tcp --dport 53 -j ACCEPT

$I -A FORWARD -s $LAN -i $ILAN -d $SRV2 -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -s $LAN -i $ILAN -d $PROXY -o $IDMZ -p tcp --dport 3128 -j ACCEPT

# Denegamos conexiones web y DNS de usuarios de la LAN hacia internet.
$I -A FORWARD -s $LAN -i $ILAN -o $IINET -p tcp -m multiport --dports 53,80,443 -j REJECT
$I -A FORWARD -s $LAN -I $ILAN -o $IINET -p udp --dport 53 -j REJECT
# Aceptamos las demas
$I -A FORWARD -s $LAN -i $ILAN -o $IINET -j ACCEPT

# Nateamos la IP de la LAN cuando quiere salir a internet.
$I -t nat -A POSTROUTING -s $LAN -o $IINET -j SNAT --to-source $INET
# Permitimos que el servidor proxy utilice web.

$I -A FORWARD -s $PROXY -i $IDMZ -o $IINET -p tcp -m multiport --dports 80,443 -j ACCEPT

#Lo demas dejamos que se encargue la politica de FORWARD.

# Le damos acceso a los clientes de la lan acceso a los puertos de la DMZ
# recordar que dns ya esta arriba:

$I -A FORWARD -s $LAN -i $ILAN -d $SRV2 -o $IDMZ -p tcp -m multiport --dports 25,587,465,993,995 -j ACCEPT

$I -A FORWARD -s $LAN -i $ILAN -d $SRV1 -o $IDMZ -p tcp -m multiport --dports 80,443 -j ACCEPT

#La politica de forward le haria drop, pero para tener una capa mas de seguridad:

$I -A FORWARD -s $LAN -i $ILAN -d $DMZ -o $IDMZ -j REJECT

# Le damos acceso total a internet a la DMZ:

$I -A FORWARD -s $DMZ -i $IDMZ -o $IINET -j ACCEPT

# Revocamos todo lo demas (en nuestro caso la LAN)

$I -A FORWARD -s $DMZ -i $IDMZ -j REJECT

$I -A FORWARD -i $IINET -d $SRV1 -o $IDMZ -p tcp -m multiport --dports 53,80,443 -j ACCEPT
$I -A FORWARD -i $IINET -d $SRV1 -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -i $IINET -d $SRV2 -o $IDMZ -p tcp -m multiport --dports 25,53 -j ACCEPT
$I -A FORWARD -i $IINET -d $SRV2 -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -i $IINET -j DROP
