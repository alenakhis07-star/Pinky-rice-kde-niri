#!/usr/bin/env bash
# Xbox DNS (https://xbox-dns.ru) для всей системы через systemd-resolved, с шифрованием DNS-over-TLS.
# Работает для любой сети (проводной, Wi-Fi): адреса от роутера/DHCP больше не используются.
#   bash scripts/xbox-dns.sh        — включить
#   bash scripts/xbox-dns.sh --off  — выключить (вернуть DNS от роутера)
set -euo pipefail

if [ "${1:-}" = "--off" ]; then
  sudo rm -f /etc/systemd/resolved.conf.d/xbox-dns.conf /etc/NetworkManager/conf.d/xbox-dns.conf
  sudo systemctl restart systemd-resolved
  sudo systemctl restart NetworkManager
  echo "Xbox DNS выключен, DNS снова от роутера."
  exit 0
fi

echo "==> systemd-resolved: Xbox DNS + DNS-over-TLS"
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo tee /etc/systemd/resolved.conf.d/xbox-dns.conf >/dev/null <<'EOF'
# Xbox DNS — https://xbox-dns.ru
[Resolve]
DNS=111.88.96.54#xbox-dns.ru 111.88.96.55#xbox-dns.ru 2a00:ab00:1233:26::50#xbox-dns.ru 2a00:ab00:1233:26::51#xbox-dns.ru
FallbackDNS=
DNSOverTLS=yes
Domains=~.
EOF

echo "==> NetworkManager: не подсовывать DNS от роутера"
sudo mkdir -p /etc/NetworkManager/conf.d
sudo tee /etc/NetworkManager/conf.d/xbox-dns.conf >/dev/null <<'EOF'
# DNS задаёт systemd-resolved (Xbox DNS), NetworkManager в него не вмешивается
[main]
dns=none
EOF

# программы спрашивают DNS у локального resolved, а он — у Xbox DNS по TLS
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf

sudo systemctl enable systemd-resolved >/dev/null 2>&1 || true
sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager
sleep 3
# сбросить DNS от роутера, оставшиеся на сетевых интерфейсах (туннели VPN не трогаем)
for l in $(resolvectl status --no-pager | sed -n 's/^Link [0-9]* (\(.*\))$/\1/p'); do
  case "$l" in happ*|tun*|wg*|xray*|lo) continue ;; esac
  sudo resolvectl revert "$l" 2>/dev/null || true
done

echo
resolvectl status | sed -n '1,8p'
echo
if resolvectl query xbox-dns.ru >/dev/null 2>&1; then
  echo "Xbox DNS работает ♡ (шифрование DNS-over-TLS включено)"
else
  echo "! DNS не отвечает. Выключить обратно: bash $0 --off"
fi
