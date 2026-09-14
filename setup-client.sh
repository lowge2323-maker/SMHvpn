#!/bin/bash

# SMHvpn Client Setup Script
# WireGuard Client ကို တည်ဆောက်ရန်

echo "═══════════════════════════════════"
echo "SMHvpn - WireGuard Client Setup"
echo "═══════════════════════════════════"

# Client အဘယ်အရာများ ယူခြင်း
read -p "📍 Server IP Address ထည့်သွင်းပါ: " SERVER_IP
read -p "🔑 Server Public Key ထည့်သွင်းပါ: " SERVER_PUBLIC_KEY
read -p "👤 Client အမည် ထည့်သွင်းပါ (default: client1): " CLIENT_NAME
CLIENT_NAME=${CLIENT_NAME:-client1}

# Root အခွင့်အာဏာ စစ်ဆေးခြင်း
if [[ $EUID -ne 0 ]]; then
   echo "❌ ဤစ္ကြစ်ပ်တ်ကို root အနေနဲ့ အသုံးပြု���မည်။"
   exit 1
fi

echo ""
echo "📦 WireGuard ထည့်သွင်းနေပါသည်..."

# WireGuard ထည့်သွင်းခြင်း
apt-get update -y
apt-get install -y wireguard wireguard-tools

echo "✅ WireGuard ထည့်သွင်းပြီးပါပြီ။"

# Client Key ထုတ်ယူခြင်း
echo "🔑 Client Keys ထုတ်ယူနေပါသည်..."

mkdir -p /etc/wireguard/keys
cd /etc/wireguard/keys

# ယခင် Key များ ရှိပါက ကျေးဇူးပြု၍ ရွှေ့ပါ
if [ -f "${CLIENT_NAME}_private.key" ]; then
    mv "${CLIENT_NAME}_private.key" "${CLIENT_NAME}_private.key.bak"
    mv "${CLIENT_NAME}_public.key" "${CLIENT_NAME}_public.key.bak"
fi

wg genkey | tee ${CLIENT_NAME}_private.key | wg pubkey > ${CLIENT_NAME}_public.key
chmod 600 ${CLIENT_NAME}_private.key

CLIENT_PRIVATE=$(cat ${CLIENT_NAME}_private.key)
CLIENT_PUBLIC=$(cat ${CLIENT_NAME}_public.key)

echo "✅ Client Keys ထုတ်ယူပြီးပါပြီ။"

# WireGuard Interface Configuration
echo "⚙️  Client Configuration ဖြည့်သွင်းနေပါသည်..."

cat > /etc/wireguard/wg0.conf <<EOF
[Interface]
PrivateKey = $CLIENT_PRIVATE
Address = 10.0.0.2/32
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = $SERVER_PUBLIC_KEY
AllowedIPs = 10.0.0.0/24
Endpoint = $SERVER_IP:51820
PersistentKeepalive = 25

EOF

chmod 600 /etc/wireguard/wg0.conf

echo "✅ Client Configuration အပြီးသတ်ပြီးပါပြီ။"

# Client ချိတ်ဆက်ခြင်း
echo "🚀 WireGuard Client ချိတ်ဆက်နေပါသည်..."

wg-quick up wg0

# ချိတ်ဆက်မှု စမ်းသပ်ခြင်း
sleep 2
if ping -c 1 10.0.0.1 &> /dev/null; then
    echo "✅ VPN ချိတ်ဆက်မှု အောင်မြင်ပြီးပါပြီ!"
else
    echo "⚠️  ချိတ်ဆက်မှု အနက်အသားကျ။ အောက်ပါအရာများ ကြည့်ပါ:"
    echo "   - Server IP Address မှားမမှားသည်"
    echo "   - Server Public Key မှားမမှားသည်"
    echo "   - Server WireGuard Service ဖွင့်ထားခြင်း"
fi

echo ""
echo "════════════════════════════════���══"
echo "✅ Client Setup အပြီးသတ်ပြီးပါပြီ!"
echo "═══════════════════════════════════"
echo ""
echo "📋 Client အချက်အလက်:"
echo "   Client Public Key: $CLIENT_PUBLIC"
echo "   Client Private Key: သိုလှောင်ထားပြီး"
echo ""
echo "💾 Keys များ သိုလှောင်သည့်နေရာ: /etc/wireguard/keys/"
echo ""
echo "📝 အသုံးစာရင်း:"
echo "   VPN ချပ်ခွင်းခြင်း: sudo wg-quick down wg0"
echo "   VPN ဖွင့်ခြင်း: sudo wg-quick up wg0"
echo "   အခြေအနေ ကြည့်ခြင်း: sudo wg show"
echo ""
