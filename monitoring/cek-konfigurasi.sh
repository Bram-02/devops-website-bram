#!/usr/bin/env bash
# Memeriksa konfigurasi monitoring dengan versi image yang sama persis seperti di compose.yaml.
# Dipakai di laptop (./monitoring/cek-konfigurasi.sh) dan di CI (workflow monitoring.yml).
set -euo pipefail
cd "$(dirname "$0")"

versi() { grep -oP "image: \K$1:\S+" compose.yaml; }
PROM=$(versi prom/prometheus)
AM=$(versi prom/alertmanager)
BB=$(versi prom/blackbox-exporter)

# alertmanager.yml asli tidak ada di repo (chat_id rahasia), jadi template dirender
# dengan chat_id palsu hanya untuk validasi.
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
chmod 755 "$tmp"
sed "s/__CHAT_ID__/123456789/" alertmanager.yml.tmpl > "$tmp/alertmanager.yml"
chmod 644 "$tmp/alertmanager.yml"

echo "== 1. Prometheus dan aturan alert ($PROM)"
docker run --rm -v "$PWD:/cfg:ro" --entrypoint promtool "$PROM" \
  check config /cfg/prometheus.yml

echo "== 2. Alertmanager ($AM)"
docker run --rm -v "$tmp:/cfg:ro" --entrypoint amtool "$AM" \
  check-config /cfg/alertmanager.yml

echo "== 3. Blackbox exporter ($BB)"
docker run --rm -v "$PWD/blackbox.yml:/cfg/blackbox.yml:ro" "$BB" \
  --config.file=/cfg/blackbox.yml --config.check

echo "OK: semua konfigurasi monitoring valid"
