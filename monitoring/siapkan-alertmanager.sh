#!/usr/bin/env bash
# Membuat alertmanager.yml dari template; chat_id dibaca dari ~/.secrets (tidak di-commit).
set -euo pipefail
cd "$(dirname "$0")"
chat_id=$(cat "$HOME/.secrets/telegram_chat_id")
[[ "$chat_id" =~ ^-?[0-9]+$ ]] || { echo "chat_id tidak valid"; exit 1; }
sed "s/__CHAT_ID__/${chat_id}/" alertmanager.yml.tmpl > alertmanager.yml
echo "alertmanager.yml dibuat dari template"
