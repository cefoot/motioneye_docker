#!/usr/bin/env bash
set -e

# 1) Ordner anlegen, falls nicht vorhanden
mkdir -p /run/motioneye
mkdir -p /var/log/motioneye
mkdir -p /var/lib/motioneye

# 2) LANG setzen (falls nötig)
export LANGUAGE=en

# 3) MotionEye starten (im Vordergrund)
exec /usr/local/bin/meyectl startserver -c /etc/motioneye/motioneye.conf
