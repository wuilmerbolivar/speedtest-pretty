#!/usr/bin/env bash
#
# speedtest-pretty.sh
# Muestra los resultados del CLI oficial de Ookla (speedtest) de forma clara,
# con colores y barras, en vez del JSON crudo.
#
# Requisitos: speedtest (https://www.speedtest.net/apps/cli), jq, awk
# Uso:
#   chmod +x speedtest-pretty.sh
#   ./speedtest-pretty.sh

set -euo pipefail

# --- Colores (vía tput, funcionan en kitty/alacritty/etc) ---
RESET=$(tput sgr0)
BOLD=$(tput bold)
DIM=$(tput dim)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
MAGENTA=$(tput setaf 5)
RED=$(tput setaf 1)
BLUE=$(tput setaf 4)

repeat_char() {
  local char="$1" count="$2" out=""
  for ((i = 0; i < count; i++)); do out+="$char"; done
  printf '%s' "$out"
}

draw_bar() {
  local value="$1" max="$2" width=28 filled empty
  filled=$(awk -v v="$value" -v m="$max" -v w="$width" \
    'BEGIN{f=int((v/m)*w); if(f>w)f=w; if(f<0)f=0; print f}')
  empty=$((width - filled))
  printf '%s%s%s%s%s' "$GREEN" "$(repeat_char '█' "$filled")" "$DIM" "$(repeat_char '░' "$empty")" "$RESET"
}

echo "${CYAN}${BOLD}⚡ Ejecutando speedtest...${RESET}"
echo

if ! JSON=$(speedtest --accept-license --accept-gdpr --format=json 2>/dev/null); then
  echo "${RED}✕ No se pudo ejecutar speedtest. ¿Está instalado y en el PATH?${RESET}" >&2
  exit 1
fi

DOWN_BPS=$(echo "$JSON" | jq -r '.download.bandwidth // 0')
UP_BPS=$(echo "$JSON"   | jq -r '.upload.bandwidth // 0')
PING=$(echo "$JSON"     | jq -r '.ping.latency // "N/A"')
JITTER=$(echo "$JSON"   | jq -r '.ping.jitter // "N/A"')
LOSS=$(echo "$JSON"     | jq -r '.packetLoss // 0')
ISP=$(echo "$JSON"      | jq -r '.isp // "N/A"')
SRV_NAME=$(echo "$JSON" | jq -r '.server.name // "N/A"')
SRV_LOC=$(echo "$JSON"  | jq -r '.server.location // "N/A"')
RESULT_URL=$(echo "$JSON" | jq -r '.result.url // empty')

# Ookla reporta "bandwidth" en bytes/seg -> convertir a Mbps
DOWN_MBPS=$(awk -v b="$DOWN_BPS" 'BEGIN{printf "%.1f", (b*8)/1000000}')
UP_MBPS=$(awk -v b="$UP_BPS" 'BEGIN{printf "%.1f", (b*8)/1000000}')

echo "${BOLD}┌──────────────────────────────────────────┐${RESET}"
echo "${BOLD}│        📡  RESULTADOS DE VELOCIDAD         │${RESET}"
echo "${BOLD}└──────────────────────────────────────────┘${RESET}"
echo
printf "  %s▼ Descarga%s  %s%7s Mbps%s  [%s]\n" "$GREEN$BOLD" "$RESET" "$GREEN$BOLD" "$DOWN_MBPS" "$RESET" "$(draw_bar "$DOWN_MBPS" 1000)"
printf "  %s▲ Subida%s    %s%7s Mbps%s  [%s]\n" "$MAGENTA$BOLD" "$RESET" "$MAGENTA$BOLD" "$UP_MBPS" "$RESET" "$(draw_bar "$UP_MBPS" 1000)"
echo
printf "  %sPing%s       %6s ms\n" "$YELLOW$BOLD" "$RESET" "$PING"
printf "  %sJitter%s     %6s ms\n" "$BLUE$BOLD" "$RESET" "$JITTER"
printf "  %sPérdida%s    %6s %%\n" "$RED$BOLD" "$RESET" "$LOSS"
echo
echo "  ${BOLD}ISP:${RESET}       $ISP"
echo "  ${BOLD}Servidor:${RESET}  $SRV_NAME ($SRV_LOC)"
[ -n "$RESULT_URL" ] && echo "  ${BOLD}Resultado:${RESET} $RESULT_URL"
echo
