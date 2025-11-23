# Definimos variables

I = /sbin/iptables
LAN = 10.0.1.0/24
DMZ = 181.16.1.16/28
INET = 200.3.1.2
ILAN = eth0
IDMZ = eth1
IINET = eth2
ADMIN = 10.0.1.22
WWW = 181.16.1.18
PROXY = 181.16.1.19
# En la DMZ tenemos 2 servidores: 
# www: que habilita Web (http y https), DNS y ssh
# Proxy: que habilita Proxy Web (puerto 3128), DNS y ssh

# Politicas por defecto

$I -P INPUT DROP
$I -P OUTPUT DROP
$I -P FORWARD DROP
# Permitimos conexiones

$I -A FORWARD -m state --state INVALID -j DROP
$I -A FORWARD -m state --state RELATED, ESTABLISHED -j ACCEPT

$I -A INPUT -m state --state INVALID -j DROP
$I -A INPUT -m state --state RELATED, ESTABLISHED -j ACCEPT

$I -A OUTPUT -m state --state INVALID -j DROP
$I -A OUTPUT -m state --state RELATED, ESTABLISHED -j ACCEPT

# Aceptamos conexiones ssh y firewall desde la pc admin

$I -A FORWARD -s $ADMIN -d $WWW -p tcp --dport 22 -j ACCEPT
$I -A FORWARD -s $ADMIN -d $PROXY -i $ILAN -o $IDMZ -p tcp --dport 22 -j ACCEPT

$I -A INPUT -s $ADMIN -i $ILAN -p tcp --dport 22 -j ACCEPT

# Resto de PCS de la LAN pueden acceder a los OTROS servicios de la DMZ.

$I -A FORWARD -s $LAN -i $ILAN -d $WWW -o $IDMZ -p tcp -m multiport --dports 80,443,53

$I -A FORWARD -s $LAN -i $ILAN -d $WWW -o $IDMZ -p udp -m multiport --dports 80,53

$I -A FORWARD -s $LAN -i $ILAN -d $PROXY -o $IDMZ -p tcp -m multiport --dports 3128,53

$I -A FORWARD -s $LAN -i $ILAN -d $PROXY -o $IDMZ -p udp --dport 53

# Rechazamos conexiones a la DMZ que no hayan matcheado anteriormente.

$I -A FORWARD -i $ILAN -o $IDMZ -j REJECT

# Regla 3: Ya aceptamos que los usuarios de la LAN accedan a proxy web en la Regla 2.
# 	   Por lo tanto debemos rechazar aquellos que quieran acceder a web a traves de 
	  #internet 

$I -A FORWARD -s $LAN -i $ILAN -p tcp -m multiport --dports 80,443 -j REJECT

$I -A FORWARD -s $LAN -i $ILAN -p udp --dport 80 -j REJECT

$I -t nat -A POSTROUTING -s $LAN -o $IINET -j SNAT --to-source $INET

$I -A FORWARD -s $LAN -i $ILAN  -j ACCEPT

# NOTA: Pudimos OBVIAR -o $IINET en los 3 forward porque antes rechazamos todas las
# demas conexiones que tenian como interfaz de salida $IDMZ.

# Regla 4: Primero prohibimos cualquier acceso a la lan

$I -A FORWARD -s $DMZ -i $IDMZ -d $INET -o $IINET -p tcp -m multiport --dports 53,80,443 -j ACCEPT

$I -A FORWARD -s $DMZ -i $IDMZ -d $INET -o $IINET -p udp -m multiport --dports 53,80 -j ACCEPT

$I -A FORWARD -s $DMZ -i $IDMZ -j REJECT 

# Regla 5:

$I -A FORWARD -i $IINET -d $WWW -o $IDMZ -p tcp -m multiport --dports 53,80,443 -j ACCEPT

$I -A FORWARD -i $IINET -d $WWW -o $IDMZ -p udp -m multiport --dports 53,80 -j ACCEPT

$I -A FORWARD -i $IINET -d $PROXY -o $IDMZ -p tcp --dport 53 -j ACCEPT

$I -A FORWARD -i $IINET -d $WWW -o $IDMZ -p udp --dport 53 -j ACCEPT

$I -A FORWARD -i $IINET -j REJECT

# Regla 6:
$I -A OUTPUT -d $PROXY -o $IDMZ -j ACCEPT 
$I -A OUTPUT -j REJECT
