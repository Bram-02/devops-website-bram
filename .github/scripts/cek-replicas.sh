#!/usr/bin/env bash
# Uji regresi: Deployment tidak boleh menulis replicas saat HPA aktif.
set -euo pipefail
chart="${1:-helm/website}"

aktif=$(helm template website "$chart" --set image.tag=ci)
if ! grep -q "^kind: HorizontalPodAutoscaler" <<<"$aktif"; then
  echo "GAGAL: HPA tidak dirender padahal autoscaling.enabled bawaan true"; exit 1
fi
if grep -q "^  replicas:" <<<"$aktif"; then
  echo "GAGAL: Deployment menulis replicas padahal HPA aktif (Helm dan HPA akan berebut)"; exit 1
fi

mati=$(helm template website "$chart" --set image.tag=ci --set autoscaling.enabled=false)
if ! grep -q "^  replicas:" <<<"$mati"; then
  echo "GAGAL: replicas tidak ditulis saat autoscaling dimatikan"; exit 1
fi
if grep -q "^kind: HorizontalPodAutoscaler" <<<"$mati"; then
  echo "GAGAL: HPA tetap dirender saat autoscaling dimatikan"; exit 1
fi
echo "OK: replicas hanya ditulis saat autoscaling mati"
