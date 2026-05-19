#!/bin/bash

# ============================================================
#  ctf_web.sh — Web Reconnaissance Script
#  Uso: ./ctf_web.sh <IP> [puerto]
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BOLD='\033[1m'
RESET='\033[0m'

banner() {
  echo -e "${CYAN}${BOLD}"
  echo " _____         _              ______               "
  echo "|  __ \       | |            |  ____|              "
  echo "| |__) |__  __| |_ __ ___    | |__ ___  __ _  __ _"
  echo "|  ___/ _ \/ _\` | '__/ _ \   |  __/ _ \/ _\` |/ _\` |"
  echo "| |  |  __/ (_| | | | (_) |  | | |  __/ (_| | (_| |"
  echo "|_|   \___|\__,_|_|  \___/   |_|  \___|\__, |\__,_|"
  echo "                                        __/ |      "
  echo "                                       |___/       "
  echo -e "${RESET}"
  echo -e "${YELLOW}  Reconocimiento web automático — by ctf_web.sh${RESET}"
  echo ""
}

banner

# --- Validar parámetros ---
if [ -z "$1" ]; then
    echo -e "${RED}[!] Error: debes indicar una IP o host.${NC}"
    echo -e "    Uso: $0 <IP> [puerto]"
    echo -e "    Ejemplo: $0 10.10.10.10"
    echo -e "    Ejemplo: $0 10.10.10.10 8080"
    exit 1
fi

TARGET_IP="$1"
PORT="${2:-80}"  # Puerto por defecto: 80
TARGET_URL="http://${TARGET_IP}:${PORT}/"

WORDLIST="/usr/share/seclists/Discovery/Web-Content/common.txt"
EXTENSIONS="php,html,txt"
OUTPUT_DIR="./recon_${TARGET_IP}_$(date +%Y%m%d_%H%M%S)"

# --- Verificar dependencias ---
echo -e "${CYAN}[*] Verificando dependencias...${NC}"

if ! command -v feroxbuster &>/dev/null; then
    echo -e "${RED}[!] feroxbuster no encontrado. Instálalo con: sudo apt install feroxbuster${NC}"
    exit 1
fi

if [ ! -f "$WORDLIST" ]; then
    echo -e "${RED}[!] Wordlist no encontrada: $WORDLIST${NC}"
    echo -e "${YELLOW}    Instala seclists: sudo apt install seclists${NC}"
    exit 1
fi

# --- Crear directorio de salida ---
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}[+] Resultados guardados en: $OUTPUT_DIR${NC}"

# --- Banner ---
echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}   WEB RECON :: ${TARGET_URL}${NC}"
echo -e "${CYAN}============================================${NC}"
echo -e "${YELLOW}  Target  :${NC} $TARGET_URL"
echo -e "${YELLOW}  Puerto  :${NC} $PORT"
echo -e "${YELLOW}  Wordlist:${NC} $WORDLIST"
echo -e "${YELLOW}  Ext.    :${NC} $EXTENSIONS"
echo -e "${YELLOW}  Output  :${NC} $OUTPUT_DIR"
echo -e "${CYAN}============================================${NC}"
echo ""

# --- Feroxbuster ---
echo -e "${GREEN}[+] Iniciando feroxbuster...${NC}"
echo ""

feroxbuster \
    -u "$TARGET_URL" \
    -w "$WORDLIST" \
    -x "$EXTENSIONS" \
    --output "${OUTPUT_DIR}/feroxbuster.txt" \
    --threads 50 \
    --depth 3 \
    --status-codes 200,204,301,302,307,401,403

echo ""
echo -e "${GREEN}[+] Escaneo completado.${NC}"
echo -e "${GREEN}[+] Resultados en: ${OUTPUT_DIR}/feroxbuster.txt${NC}"
