#!/usr/bin/env bash
set -euo pipefail

# Источники (Loon / QuantumultX формат)
APPLE_URL="https://raw.githubusercontent.com/Keviin560/Shunt_Rules/main/rule/Loon/AppleProxy.lsr"
HOYO_URL="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/release/rule/QuantumultX/HoYoverse/HoYoverse.list"
STEAM_URL="https://raw.githubusercontent.com/blackmatrix7/ios_rule_script/master/rule/QuantumultX/Steam/Steam.list"

# Универсальный конвертер Loon/QuantumultX → plain domain list
convert() {
  awk -F',' '
    /^[[:space:]]*#/      { next }
    /^[[:space:]]*\/\//   { next }
    /^[[:space:]]*$/      { next }
    {
      for (i=1; i<=NF; i++) gsub(/^[ \t]+|[ \t]+$/, "", $i)
      t = tolower($1)
      if (t=="host-suffix" || t=="domain-suffix" || t=="host" || t=="domain" || t=="hostname") {
        d = $2
        gsub(/^\.+/, "", d)
        if (d ~ /\*/ || d == "") next
        print tolower(d)
      }
    }
  ' | sort -u
}

echo "==> Apple"
curl -sSL "$APPLE_URL" | convert > apple.txt
echo "    $(wc -l < apple.txt) entries"

echo "==> HoYoverse"
curl -sSL "$HOYO_URL" | convert > hoyoverse.txt
echo "    $(wc -l < hoyoverse.txt) entries"

echo "==> Steam"
curl -sSL "$STEAM_URL" | convert > steam.txt
echo "    $(wc -l < steam.txt) entries"
