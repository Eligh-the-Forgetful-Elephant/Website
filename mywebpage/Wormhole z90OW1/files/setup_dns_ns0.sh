#!/bin/bash

echo "🔧 Setting up DNS Server on ns0"
echo "==============================="

echo "📡 Installing BIND9 DNS server..."
sudo apt-get update
sudo apt-get install -y bind9 bind9utils dnsutils

echo "🔧 Configuring BIND9..."
sudo cp /etc/bind/named.conf.local /etc/bind/named.conf.local.backup
sudo cp /etc/bind/named.conf.options /etc/bind/named.conf.options.backup

echo "📝 Creating DNS configuration..."
sudo tee /etc/bind/named.conf.options << 'EOF'
options {
        directory "/var/cache/bind";
        listen-on { any; };
        listen-on-v6 { any; };
        allow-query { any; };
        allow-recursion { 127.0.0.1; 192.168.0.0/16; };
        forwarders {
                8.8.8.8;
                8.8.4.4;
        };
        dnssec-validation auto;
        auth-nxdomain no;
        listen-on port 53 { any; };
};
EOF

echo "📝 Creating zone configuration..."
sudo tee /etc/bind/named.conf.local << 'EOF'
zone "localdomain" {
        type master;
        file "/etc/bind/zones/db.localdomain";
};

zone "0.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/zones/db.192.168.0";
};
EOF

echo "📁 Creating zone directories..."
sudo mkdir -p /etc/bind/zones

echo "📝 Creating forward zone file..."
sudo tee /etc/bind/zones/db.localdomain << 'EOF'
$TTL    86400
@       IN      SOA     ns0.localdomain. admin.localdomain. (
                        2023080401      ; Serial
                        3600            ; Refresh
                        1800            ; Retry
                        1209600         ; Expire
                        86400 )         ; Negative Cache TTL

@       IN      NS      ns0.localdomain.
@       IN      A       192.168.1.10

ns0     IN      A       192.168.1.10
mail0   IN      A       192.168.1.20
web0    IN      A       192.168.1.30
db0     IN      A       192.168.1.40
app0    IN      A       192.168.1.50
monitor0 IN     A       192.168.1.60
EOF

echo "📝 Creating reverse zone file..."
sudo tee /etc/bind/zones/db.192.168.0 << 'EOF'
$TTL    86400
@       IN      SOA     ns0.localdomain. admin.localdomain. (
                        2023080401      ; Serial
                        3600            ; Refresh
                        1800            ; Retry
                        1209600         ; Expire
                        86400 )         ; Negative Cache TTL

@       IN      NS      ns0.localdomain.

10.1    IN      PTR     ns0.localdomain.
20.1    IN      PTR     mail0.localdomain.
30.1    IN      PTR     web0.localdomain.
40.1    IN      PTR     db0.localdomain.
50.1    IN      PTR     app0.localdomain.
60.1    IN      PTR     monitor0.localdomain.
EOF

echo "🔧 Setting permissions..."
sudo chown -R bind:bind /etc/bind/zones
sudo chmod 644 /etc/bind/zones/*

echo "🔍 Testing configuration..."
sudo named-checkconf /etc/bind/named.conf
sudo named-checkzone localdomain /etc/bind/zones/db.localdomain
sudo named-checkzone 0.168.192.in-addr.arpa /etc/bind/zones/db.192.168.0

echo "🔄 Restarting BIND9..."
sudo systemctl restart bind9
sudo systemctl enable bind9

echo "🔍 Checking DNS service..."
sudo systemctl status bind9 --no-pager -l

echo "🌐 Checking port 53..."
sudo netstat -tulpn | grep :53

echo "🧪 Testing DNS resolution..."
nslookup ns0.localdomain 127.0.0.1
nslookup mail0.localdomain 127.0.0.1

echo "✅ DNS server setup complete!"
echo "🔍 Test DNS: nslookup mail0.localdomain 127.0.0.1" 