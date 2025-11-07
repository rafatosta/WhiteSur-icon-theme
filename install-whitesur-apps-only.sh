#!/usr/bin/env bash

# Tema reduzido: WhiteSurApps
# Instala apenas os ícones de aplicativos, excluindo a pasta 'apps/symbolic'

# Uso: ./install-whitesur-apps-only-nosymbolic.sh

set -e

SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_NAME="WhiteSurApps"
DEST_DIR="$HOME/.local/share/icons/$THEME_NAME"

# Diretórios do tema original
APPS_SRC="$SRC_DIR/src/apps"
LINKS_APPS_SRC="$SRC_DIR/links/apps"

if [ ! -d "$APPS_SRC" ]; then
  echo "❌ Erro: pasta '$APPS_SRC' não encontrada."
  echo "Execute este script dentro do diretório raiz do tema WhiteSur original."
  exit 1
fi

# Remove versão anterior (se existir)
if [ -d "$DEST_DIR" ]; then
  echo "🔁 Atualizando tema '$THEME_NAME'..."
  rm -rf "$DEST_DIR"
else
  echo "🆕 Instalando tema '$THEME_NAME'..."
fi

mkdir -p "$DEST_DIR/apps"

echo "📦 Copiando ícones de aplicativos (sem 'symbolic')..."
# Copia tudo de apps exceto a pasta symbolic
shopt -s extglob
cp -r "$APPS_SRC"/!(symbolic) "$DEST_DIR/apps/" 2>/dev/null || true
shopt -u extglob

# Copia também os links do tema original (atalhos de nomes de apps)
if [ -d "$LINKS_APPS_SRC" ]; then
  echo "🔗 Copiando links simbólicos de aplicativos..."
  cp -r "$LINKS_APPS_SRC"/* "$DEST_DIR/apps/"
fi

# Cria o index.theme compatível
cat > "$DEST_DIR/index.theme" << 'EOF'
[Icon Theme]
Name=WhiteSurApps
Comment=Tema WhiteSur apenas para ícones de aplicativos (sem ícones simbólicos)
Inherits=Adwaita, hicolor
Directories=apps/16,apps/22,apps/24,apps/32,apps/48,apps/64,apps/128,apps/scalable

[apps/16]
Size=16
Context=Applications
Type=Fixed

[apps/22]
Size=22
Context=Applications
Type=Fixed

[apps/24]
Size=24
Context=Applications
Type=Fixed

[apps/32]
Size=32
Context=Applications
Type=Fixed

[apps/48]
Size=48
Context=Applications
Type=Fixed

[apps/64]
Size=64
Context=Applications
Type=Fixed

[apps/128]
Size=128
Context=Applications
Type=Fixed

[apps/scalable]
Size=96
Context=Applications
Type=Scalable
MinSize=16
MaxSize=512
EOF

# Atualiza cache de ícones
echo "🔄 Atualizando cache GTK..."
gtk-update-icon-cache "$DEST_DIR" || true

echo "✅ Tema '$THEME_NAME' instalado com sucesso em:"
echo "   $DEST_DIR"
echo ""
echo "💡 A pasta 'apps/symbolic' foi ignorada para evitar ícones duplicados ou redundantes."
echo "   Selecione o tem
