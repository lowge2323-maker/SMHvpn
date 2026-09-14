#!/bin/bash

# SMHvpn - Existing Server မှ Client ထည့်သွင်းခြင်း
# မြန်မာ အသုံးစာရင်း

echo "═══════════════════════════════════"
echo "SMHvpn - Add Client to Server"
echo "═══════════════════════════════════"

# Root အခွင့်အာဏာ စစ်ဆေးခြင်း
if [[ $EUID -ne 0 ]]; then
   echo "❌ ဤစ္ကြစ်ပ်တ်ကို root အနေနဲ့ အသုံးပြုရမည်။"
   exit 1
fi

# Client အမည် ယူခြင်း
read -p "👤 Client အမည် ထည့်သွင်းပါ (default: client1): " CLIENT_NAME
CLIENT_NAME=${CLIENT_NAME:-client1}

read -p "🔢 Client IP Address (default: 10.0.0.2): " CLIENT_IP
CLIENT_IP=${CLIENT_IP:-10.0.0.2}

echo ""
echo "🔑 Client Keys ထုတ်ယူနေပါသည်..."

# Keys သိုလှောင်သည့်ဖိုင် ဖန်တီးခြင်း
mkdir -p /etc/wireguard/clients
cd /etc/wireguard/clients

# Client Key ထုတ်ယူခြင်း
wg genkey | tee ${CLIENT_NAME}_private.key | wg pubkey > ${CLIENT_NAME}_public.key
chmod 600 ${CLIENT_NAME}_private.key

CLIENT_PUBLIC=$(cat ${CLIENT_NAME}_public.key)

echo "✅ Client Keys ထုတ်ယူပြီးပါပြီ။"

# Server Configuration ထည့်သွင်းခြင်း
echo "⚙️  Server Configuration သို့ Client ထည့်သွင်းနေပါသည်..."

# Server ၏ Private Key ယူခြင်း
SERVER_PRIVATE=$(cat /etc/wireguard/keys/server_private.key)

# WireGuard Configuration ကို ပြုပြင်ခြင်း
cat >> /etc/wireguard/wg0.conf <<EOF

[Peer]
# Client: $CLIENT_NAME
PublicKey = $CLIENT_PUBLIC
AllowedIPs = $CLIENT_IP/32

EOF

# WireGuard Restart ပြုလုပ်ခြင်း
echo "🔄 WireGuard Service Restart ပြုလုပ်နေပါသည်..."

systemctl restart wg-quick@wg0

if systemctl is-active --quiet wg-quick@wg0; then
    echo "✅ Server Configuration ပြီးပြည့်စုံပြီးပါပြီ။"
else
    echo "❌ WireGuard Restart မှုကျေးဇူးပြု၍ အရေးယူမှုလုပ်ပါ။"
    exit 1
fi

# Client Configuration ဖိုင် ထုတ်ယူခြင်း
echo "📝 Client Configuration ဖိုင် ကြေးကြေးပြုလုပ်နေပါသည်..."

SERVER_PUBLIC=$(cat /etc/wireguard/keys/server_public.key)
read -p "📍 Server IP Address ထည့်သွင်းပါ: " SERVER_IP

cat > ${CLIENT_NAME}_config.conf <<EOF
[Interface]
PrivateKey = $(cat ${CLIENT_NAME}_private.key)
Address = $CLIENT_IP/24
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = $SERVER_PUBLIC
AllowedIPs = 10.0.0.0/24
Endpoint = $SERVER_IP:51820
PersistentKeepalive = 25

EOF

chmod 600 ${CLIENT_NAME}_config.conf

echo ""
echo "═══════════════════════════════════"
echo "✅ Client ထည့်သွင်းမှု အပြီးသတ်ပြီးပါပြီ!"
echo "═══════════════════════════════════"
echo ""
echo "📋 Client အချက်အလက်:"
echo "   Client အမည်: $CLIENT_NAME"
echo "   Client IP: $CLIENT_IP"
echo "   Client Public Key: $CLIENT_PUBLIC"
echo ""
echo "💾 သိုလှောင်သည့်နေရာ:"
echo "   Client Config: /etc/wireguard/clients/${CLIENT_NAME}_config.conf"
echo "   Private Key: /etc/wireguard/clients/${CLIENT_NAME}_private.key"
echo ""
echo "📝 Client သို့ပေးပို့ရန် အပတ်အဓိများ:"
echo "   1. ${CLIENT_NAME}_config.conf ဖိုင်ကို Client သို့ ကူးမည်"
echo "   2. Client မှာ: sudo cp ${CLIENT_NAME}_config.conf /etc/wireguard/wg0.conf"
echo "   3. Client မှာ: sudo wg-quick up wg0"
echo ""
