#!/bin/bash

# SMHvpn - Complete Setup Guide (Myanmar)
# အစောင့်အရှောက် လည်ပတ်စေရန် အစီအစဉ်

echo "═══════════════════════════════════════════════════"
echo "       SMHvpn - အဆင့်ဆင့် လည်ပတ်စေခြင်း"
echo "═══════════════════════════════════════════════════"
echo ""

# ===== အဆင့် ၁ - Folder & Key ထုတ်ယူခြင်း =====
echo "📁 အဆင့် ၁ - Folder ဖန်တီးခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "1. Terminal ဖွင့်ပါ"
echo "2. အောက်ပါ အမိန့်ချက် အလုံအလျှော်ကူးယူပါ:"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "mkdir -p ~/.wireguard/keys"
echo "cd ~/.wireguard/keys"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၁ အပြီးသတ်"
echo ""

# ===== အဆင့် ၂ - Key ထုတ်ယူခြင်း =====
echo ""
echo "🔑 အဆင့် ၂ - Key ထုတ်ယူခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "SERVER KEY ထုတ်ယူခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "wg genkey | tee server_private.key | wg pubkey > server_public.key"
echo "chmod 600 server_private.key"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "CLIENT KEY ထုတ်ယူခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "wg genkey | tee client_private.key | wg pubkey > client_public.key"
echo "chmod 600 client_private.key"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၂ အပြီးသတ်"
echo ""

# ===== အဆင့် ၃ - Key များ ရှု့ခြင်း =====
echo ""
echo "👀 အဆင့် ၃ - Key များ ရှု့ခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "Server Private Key ကြည့်ခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "cat server_private.key"
echo "━━━━━━━━━━━━━━━━━━━━��━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Server Public Key ကြည့်ခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "cat server_public.key"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Client Private Key ကြည့်ခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "cat client_private.key"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Client Public Key ကြည့်ခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "cat client_public.key"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၃ အပြီးသတ်"
echo ""

# ===== အဆင့် ၄ - Server Configuration ဖြည့်သွင်းခြင်း =====
echo ""
echo "⚙️  အဆင့် ၄ - Server Configuration ဖြည့်သွင်းခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "အောက်ပါ ဖိုင်ကို ဖန်တီးပါ: /etc/wireguard/wg0.conf"
echo ""
echo "အုပ်စုသည် အောက်ပါကို အသုံးပြုပါ:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat << 'EOF'
[Interface]
PrivateKey = [SERVER_PRIVATE_KEY ကို အထည့်]
Address = 10.0.0.1/24
ListenPort = 51820
SaveCounter = true

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = [CLIENT_PUBLIC_KEY ကို အထည့်]
AllowedIPs = 10.0.0.2/32
EOF
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၄ အပြီးသတ်"
echo ""

# ===== အဆင့် ၅ - Server စတင်ခြင်း =====
echo ""
echo "🚀 အဆင့် ၅ - Server စတင်ခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "Server စတင်ပြုလုပ်ခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "sudo wg-quick up wg0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "အလိုအလျောက်စတင်ရန် (Optional):"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "sudo systemctl enable wg-quick@wg0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၅ အပြီးသတ်"
echo ""

# ===== အဆင့် ၆ - Client Configuration ဖြည့်သွင်းခြင်း =====
echo ""
echo "📱 အဆင့် ၆ - Client Configuration ဖြည့်သွင်းခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "Client ကွန်ပျူတာတွင် အောက်ပါ ဖိုင်ကို ဖန်တီးပါ:"
echo "/etc/wireguard/wg0.conf"
echo ""
echo "အုပ်စုသည် အောက်ပါကို အသုံးပြုပါ:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
cat << 'EOF'
[Interface]
PrivateKey = [CLIENT_PRIVATE_KEY ကို အထည့်]
Address = 10.0.0.2/24
DNS = 8.8.8.8, 8.8.4.4

[Peer]
PublicKey = [SERVER_PUBLIC_KEY ကို အထည့်]
AllowedIPs = 10.0.0.0/24
Endpoint = [SERVER_IP_ADDRESS]:51820
PersistentKeepalive = 25
EOF
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၆ အပြီးသတ်"
echo ""

# ===== အဆင့် ၇ - Client ချိတ်ဆက်ခြင်း =====
echo ""
echo "🔗 အဆင့် ၇ - Client ချိတ်ဆက်ခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "Client မှာ အောက်ပါ အမိန့်ချက်ကို အသုံးပြုပါ:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "sudo wg-quick up wg0"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၇ အပြီးသတ်"
echo ""

# ===== အဆင့် ၈ - ချိတ်ဆက်မှု စမ်းသပ်ခြင်း =====
echo ""
echo "✅ အဆင့် ၈ - ချိတ်ဆက်မှု စမ်းသပ်ခြင်း"
echo "─────────────────────────────────────────────────"
echo ""
echo "Client မှာ အောက်ပါကို အသုံးပြုပါ:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "ping 10.0.0.1"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "အခြေအနေ ကြည့်ခြင်း:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "sudo wg show"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ အဆင့် ၈ အပြီးသတ်"
echo ""

# ===== အဆင့် ၉ - အသုံးအများဆုံး အမိန့်ချက်များ =====
echo ""
echo "📋 အဆင့် ၉ - အသုံးအများဆုံး အမိန့်ချက်များ"
echo "─────────────────────────────────────────────────"
echo ""
echo "VPN စတင်ခြင်း:"
echo "  sudo wg-quick up wg0"
echo ""
echo "VPN ချပ်ခွင်းခြင်း:"
echo "  sudo wg-quick down wg0"
echo ""
echo "အခြေအနေ ကြည့်ခြင်း:"
echo "  sudo wg show"
echo ""
echo "Server အခြေအနေ ကြည့်ခြင်း:"
echo "  sudo wg show wg0"
echo ""
echo "Client အခြေအနေ ကြည့်ခြင်း:"
echo "  sudo wg show wg0"
echo ""
echo "═══════════════════════════════════════════════════"
echo "✅ အဆင့်အားလုံး အပြီးသတ်ပြီးပါပြီ!"
echo "═══════════════════════════════════════════════════"
echo ""
