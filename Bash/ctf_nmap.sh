#!/bin/bash

# ─────────────────────────────────────────────
#  ctf_nmap.sh — Reconocimiento automático CTF
# ─────────────────────────────────────────────

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

banner() {
  echo -e "${CYAN}${BOLD}"
  echo " _____             _                ______                     "
  echo "|  __ \\           | |              |  ____|                    "
  echo "| |__) |  ___   __| | _ __   ___   | |__     __ _   ___   __ _"
  echo "|  ___/  / _ \\ / _\` || '__| / _ \\  |  __|   / _\` | / _ \\ / _\` |"
  echo "| |     |  __/| (_| || |   | (_) | | |____ | (_| ||  __/| (_| |"
  echo "|_|      \\___| \\__,_||_|    \\___/  |______| \\__, | \\___| \\__,_|"
  echo "                                              __/ |             "
  echo "                                             |___/              "
  echo -e "${RESET}"
  echo -e "${YELLOW}  Reconocimiento automático en dos fases — by ctf_nmap.sh${RESET}"
  echo ""
}

usage() {
  echo -e "${BOLD}Uso:${RESET}  $0 <IP_VICTIMA>"
  echo -e "      $0 10.10.10.10"
  exit 1
}

check_root() {
  if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}[!] Este script requiere privilegios de root (nmap -sS usa raw sockets).${RESET}"
    echo -e "    Ejecuta: ${BOLD}sudo $0 $1${RESET}"
    exit 1
  fi
}

check_deps() {
  if ! command -v nmap &>/dev/null; then
    echo -e "${RED}[!] nmap no está instalado. Instálalo con: apt install nmap${RESET}"
    exit 1
  fi
}

# ── Validación básica de IP ──────────────────
validate_ip() {
  local ip="$1"
  if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo -e "${RED}[!] IP inválida: ${ip}${RESET}"
    exit 1
  fi
}

# ════════════════════════════════════════════
banner

[[ $# -lt 1 ]] && usage

TARGET="$1"
validate_ip "$TARGET"
check_root "$TARGET"
check_deps

# Directorio de trabajo
WORKDIR="$(pwd)/recon_${TARGET}"
mkdir -p "$WORKDIR"

echo -e "${GREEN}[*] Target   : ${BOLD}${TARGET}${RESET}"
echo -e "${GREEN}[*] Directorio: ${BOLD}${WORKDIR}${RESET}"
echo ""

# ────────────────────────────────────────────
# FASE 1 — Escaneo completo de puertos
# ────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[FASE 1] Escaneo de todos los puertos...${RESET}"
echo -e "${YELLOW}  nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn${RESET}"
echo ""

GREPABLE_FILE="${WORKDIR}/${TARGET}.gnmap"

nmap -p- --open -sS --min-rate 5000 -vvv -n -Pn \
  -oG "$GREPABLE_FILE" \
  "$TARGET"

if [[ $? -ne 0 ]]; then
  echo -e "${RED}[!] Error en la fase 1. Abortando.${RESET}"
  exit 1
fi

# ── Extracción de puertos ────────────────────
PORTS=$(grep -oP '\d+/open' "$GREPABLE_FILE" | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')

if [[ -z "$PORTS" ]]; then
  echo -e "${RED}[!] No se encontraron puertos abiertos en ${TARGET}.${RESET}"
  exit 0
fi

echo ""
echo -e "${GREEN}[+] Puertos abiertos detectados: ${BOLD}${PORTS}${RESET}"
echo ""

# ────────────────────────────────────────────
# FASE 2 — Escaneo de versiones y scripts
# ────────────────────────────────────────────
echo -e "${CYAN}${BOLD}[FASE 2] Escaneo de servicios y scripts en puertos abiertos...${RESET}"
echo -e "${YELLOW}  nmap -sCV -p ${PORTS}${RESET}"
echo ""

TARGETED_FILE="${WORKDIR}/targeted"

nmap -sCV -p "$PORTS" \
  -oN "$TARGETED_FILE" \
  "$TARGET"

if [[ $? -ne 0 ]]; then
  echo -e "${RED}[!] Error en la fase 2.${RESET}"
  exit 1
fi

# ────────────────────────────────────────────
# Resumen final
# ────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  ✔  Reconocimiento completado           ${RESET}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════${RESET}"
echo -e "  Target  : ${BOLD}${TARGET}${RESET}"
echo -e "  Puertos : ${BOLD}${PORTS}${RESET}"
echo -e "  Archivos:"
echo -e "    → ${WORKDIR}/${TARGET}.gnmap   (fase 1, grepable)"
echo -e "    → ${WORKDIR}/targeted          (fase 2, detallado)"
echo ""
