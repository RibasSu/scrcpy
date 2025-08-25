#!/usr/bin/env bash

# Script completo para instalar, configurar e iniciar scrcpy via Wi-Fi
# Autor: André

set -e

DEVICES_FILE="$HOME/.scrcpy_devices"

# Função de spinner animado
spinner() {
    local pid=$!
    local delay=0.1
    local spin='|/-\'
    while kill -0 $pid 2>/dev/null; do
        for i in $(seq 0 3); do
            printf "\r[%c] $1" "${spin:$i:1}"
            sleep $delay
        done
    done
    printf "\r[✔] $1\n"
}

echo "============================================"
echo "   SCRCPY SETUP E CONEXÃO VIA WIFI (Android)"
echo "============================================"

# 1. Instalar dependências
(sudo apt update -y >/dev/null 2>&1) & spinner "Atualizando pacotes..."
(sudo apt install -y adb snapd >/dev/null 2>&1) & spinner "Instalando dependências..."
(sudo snap install scrcpy >/dev/null 2>&1 || sudo snap refresh scrcpy >/dev/null 2>&1) & spinner "Instalando/atualizando scrcpy..."
echo ""

# 2. Se já existem dispositivos salvos
if [ -f "$DEVICES_FILE" ] && [ -s "$DEVICES_FILE" ]; then
    echo "📱 Dispositivos salvos:"
    nl -w2 -s'. ' "$DEVICES_FILE"
    echo "0. Adicionar novo dispositivo"
    echo ""
    read -p "Escolha o dispositivo (número) [1]: " CHOICE
    CHOICE=${CHOICE:-1}

    if [ "$CHOICE" != "0" ]; then
        DEVICE_IP=$(sed -n "${CHOICE}p" "$DEVICES_FILE")
        echo ""
        echo "🔌 Conectando ao dispositivo salvo: $DEVICE_IP ..."
        adb connect "$DEVICE_IP" >/dev/null 2>&1
        scrcpy -s "$DEVICE_IP"
        exit 0
    fi
fi

# 3. Fluxo para adicionar novo dispositivo
echo ""
echo "👉 Conecte o celular via USB com a depuração ativada e pressione ENTER..."
read

adb kill-server >/dev/null 2>&1
adb start-server >/dev/null 2>&1
DEVICE_USB=$(adb devices | grep -w "device" | grep -v "List" | awk '{print $1}')

if [ -z "$DEVICE_USB" ]; then
    echo "❌ Nenhum dispositivo USB encontrado. Verifique o cabo e a depuração USB."
    exit 1
fi

echo "✅ Dispositivo detectado via USB: $DEVICE_USB"

# 4. Habilitar TCP/IP
(adb -s "$DEVICE_USB" tcpip 5555 >/dev/null 2>&1) & spinner "Habilitando modo TCP/IP..."

# 5. Perguntar IP
echo ""
read -p "Digite o IP do celular (Configurações > Wi-Fi > Detalhes): " DEVICE_IP

# 6. Conectar via Wi-Fi
(adb connect "$DEVICE_IP:5555" >/dev/null 2>&1) & spinner "Conectando em $DEVICE_IP:5555"

# 7. Salvar no arquivo
if ! grep -q "$DEVICE_IP:5555" "$DEVICES_FILE" 2>/dev/null; then
    echo "$DEVICE_IP:5555" >> "$DEVICES_FILE"
    echo "💾 Dispositivo salvo em $DEVICES_FILE"
fi

# 8. Desconectar USB
echo ""
echo "👉 Agora você pode desconectar o cabo USB. Pressione ENTER para continuar..."
read

# 9. Iniciar scrcpy
echo "🚀 Iniciando scrcpy via Wi-Fi..."
scrcpy -s "$DEVICE_IP:5555"
