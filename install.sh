#!/usr/bin/env bash
# ============================================================
#  ExoFM App Ubuntu — Script d'installation
#  Installe libmpv, crée un venv Python et installe les deps.
# ============================================================

set -e  # Arrêt en cas d'erreur

# --- Couleurs ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════╗"
echo "║        ExoFM App Ubuntu — Installation       ║"
echo "╚══════════════════════════════════════════════╝"
echo -e "${NC}"

# --- Vérification que le script est lancé depuis le bon dossier ---
if [ ! -f "exo.py" ]; then
    echo -e "${RED}✗ Erreur : exo.py introuvable.${NC}"
    echo -e "${YELLOW}  Lance ce script depuis la racine du projet :${NC}"
    echo -e "  cd exofm-app-ubuntu && ./install.sh"
    exit 1
fi

# --- Détection de la distribution ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo -e "${RED}✗ Impossible de détecter la distribution.${NC}"
    exit 1
fi

if [ "$OS" != "ubuntu" ] && [ "$OS" != "debian" ]; then
    echo -e "${YELLOW}⚠ Distribution détectée : $OS${NC}"
    echo -e "${YELLOW}  Ce script est optimisé pour Ubuntu/Debian.${NC}"
    read -p "  Continuer quand même ? [o/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[OoYy]$ ]]; then
        exit 1
    fi
fi

# --- 1. Installation des paquets système ---
echo -e "${BLUE}[1/3]${NC} Installation des paquets système..."
sudo apt update
sudo apt install -y \
    python3 \
    python3-venv \
    python3-pip \
    libmpv-dev \
    mpv

# --- 2. Création de l'environnement virtuel ---
echo -e "${BLUE}[2/3]${NC} Création de l'environnement virtuel..."
if [ -d "ex" ]; then
    echo -e "${YELLOW}  Le dossier 'ex' existe déjà, réutilisation.${NC}"
else
    python3 -m venv ex
fi

# --- 3. Installation des dépendances Python ---
echo -e "${BLUE}[3/3]${NC} Installation des dépendances Python..."
source ex/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# --- Fin ---
echo
echo -e "${GREEN}╔══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           ✓ Installation terminée !          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════╝${NC}"
echo
echo -e "Pour lancer l'application :"
echo -e "  ${BLUE}source ex/bin/activate${NC}"
echo -e "  ${BLUE}python3 exo.py${NC}"
echo
