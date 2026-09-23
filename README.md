# 📻 ExoFM App Ubuntu

> Lecteur desktop pour **Exo FM** (radio) et **Exo FM TV** (chaîne télé) — Réunion.
> Interface sombre, frameless, avec visualiseur audio et lecture vidéo HLS intégrée.

![Python](https://img.shields.io/badge/Python-3.10%2B-blue?style=flat-square&logo=python)
![PyQt6](https://img.shields.io/badge/PyQt6-6.x-green?style=flat-square&logo=qt)
![mpv](https://img.shields.io/badge/mpv-libmpv-orange?style=flat-square)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04%20%7C%2024.04-E95420?style=flat-square&logo=ubuntu)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)

---

## ✨ Fonctionnalités

- 🎵 **Exo FM** en direct — flux audio AAC (Icecast / Infomaniak)
- 📺 **Exo FM TV** en direct — flux vidéo HLS Akamai, rendu intégré via OpenGL
- 🎨 **Interface frameless** moderne — coins arrondis, fond translucide, drag & resize custom
- 🎚️ **Visualiseur audio animé** — 32 barres réactives pendant la lecture
- 🔊 **Contrôles complets** — play / pause / stop / mute / volume
- 🪟 **Repliable** — réduit la fenêtre à une simple barre de titre
- 🔽 **Contrôles auto-masquables** — disparaissent après 3,5 s d'inactivité
- 🌐 **Menu sites officiels** — accès rapide à exofm.re, replay, webradios, app
- 🖥️ **Optimisé Ubuntu** — compatible X11 et Wayland, rendu vidéo via `MpvRenderContext` + `QOpenGLWidget`

---

## 📸 Aperçu

```
┌──────────────────────────────────────────────┐
│  EXOFM       [SITES]              – □ × ⌃   │
│  by gleaphe                                  │
│  ┌────────────────────────────────────────┐  │
│  │                                        │  │
│  │            EXO FM TV                   │  │
│  │          ▶ TV EN DIRECT                │  │
│  │                                        │  │
│  │  ▂▃▅▇▅▃▂▃▅▇▅▃▂▃▅▇▅▃▂▃▅▇▅▃▂▃▅▇▅▃▂       │  │
│  │  ⏸  ■  EN DIRECT   🔊 ──●──  ⌄      │  │
│  └────────────────────────────────────────┘  │
│  STATIONS EXOFM                              │
│  ▸ EXO FM                                    │
│  ▸ EXO FM TV                                 │
│  PRÊT                                        │
└──────────────────────────────────────────────┘
```

---

## 🚀 Installation rapide (Ubuntu)

### Méthode 1 — Script automatique (recommandée)

```bash
git clone https://github.com/gunout/exofm-app-ubuntu.git
cd exofm-app-ubuntu
chmod +x install.sh
./install.sh
```

Le script installe automatiquement :
- `libmpv-dev` et `mpv` (via `apt`)
- Un environnement virtuel Python dans `./ex`
- Les dépendances Python (`PyQt6`, `python-mpv`)

### Méthode 2 — Installation manuelle

#### 1. Installer libmpv

```bash
sudo apt update
sudo apt install -y libmpv-dev mpv python3-venv python3-pip
```

#### 2. Cloner le projet

```bash
git clone https://github.com/gunout/exofm-app-ubuntu.git
cd exofm-app-ubuntu
```

#### 3. Créer un environnement virtuel

```bash
python3 -m venv ex
source ex/bin/activate
```

#### 4. Installer les dépendances Python

```bash
pip install -r requirements.txt
```

---

## 🎮 Utilisation

```bash
# Avec l'environnement virtuel activé
source ex/bin/activate
python3 exo.py
```

### Raccourcis & interactions

| Action | Comment |
|---|---|
| **Lancer une station** | Double-clic sur un élément de la liste |
| **Pause / Reprise** | Bouton ⏸ / ▶ |
| **Stop** | Bouton ■ |
| **Mute** | Bouton 🔊 / 🔇 |
| **Volume** | Slider horizontal |
| **Ouvrir le menu sites** | Bouton `SITES` en haut |
| **Replier la fenêtre** | Bouton `⌃` (chevron haut) |
| **Déplacer la fenêtre** | Clic-glisser n'importe où |
| **Redimensionner** | Glisser les bords / coins |

---

## 📜 Script `install.sh`

Voici le contenu du script d'installation automatique :

```bash
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
```

---

## 🏗️ Architecture

```
exofm-app-ubuntu/
├── exo.py               # Application principale
├── logo.png             # Logo affiché dans la barre de titre
├── requirements.txt     # Dépendances Python
├── install.sh           # Script d'installation automatique
├── LICENSE              # Licence MIT
└── README.md            # Ce fichier
```

### Structure interne de `exo.py`

```
exo.py
├── STATIONS               # Liste des flux (audio + vidéo)
├── SITE_LINKS             # URLs du site officiel exofm.re
├── _make_icon()           # Générateur d'icônes vectorielles (QPainter)
├── Visualizer             # Widget animé (32 barres, sinusoïdes + bruit)
├── MPVVideoWidget         # QOpenGLWidget + MpvRenderContext
│   ├── initializeGL()     # Init mpv + contexte OpenGL
│   ├── paintGL()          # Rendu frame par frame
│   ├── _get_process_address()  # Callback libmpv → OpenGL
│   └── play / stop / set_pause / set_volume
├── SitePopup              # Popup grid des liens officiels
└── ExoFM                  # Fenêtre principale
    ├── audio_player       # mpv en mode `vo=null`
    ├── video_widget       # MPVVideoWidget (page 1 du stack)
    ├── viz                # Visualizer (page 0 du stack)
    ├── media_stack        # QStackedWidget : bascule audio ↔ vidéo
    └── controls           # Barre de contrôle auto-masquable
```

### Bascule audio ↔ vidéo

| Mode | Page du stack | Lecteur |
|---|---|---|
| **Audio (Exo FM)** | `viz` (visualiseur) | `audio_player` (mpv silencieux) |
| **Vidéo (Exo FM TV)** | `video_widget` | `MPVVideoWidget` (mpv + OpenGL) |

---

## 📦 Dépendances

### Python (`requirements.txt`)

```
PyQt6>=6.4
python-mpv>=1.0
```

### Système

| Paquet | Rôle |
|---|---|
| `libmpv-dev` | Bibliothèque de lecture audio/vidéo |
| `mpv` | Lecteur multimédia (fournit les codecs) |
| `python3-venv` | Environnement virtuel Python |
| `python3-pip` | Gestionnaire de paquets Python |

---

## 🔧 Détails techniques

### Points clés de l'intégration mpv + PyQt6

1. **`locale.setlocale(locale.LC_NUMERIC, 'C')`** est appelé **avant** la création de mpv.
   PyQt6 écrase les paramètres de locale dont libmpv a besoin.

2. **`QOpenGLContext`** est importé depuis **`PyQt6.QtGui`** (pas `QtOpenGL`) en Qt6.

3. **Callback `get_proc_address`** : libmpv l'appelle avec `(ctx, name)`, donc la signature doit être `def _get_process_address(self, _ctx, name)`.

4. **`vo='libmpv'`** pour la vidéo intégrée (pas `vo='gpu'`), avec rendu dans le framebuffer OpenGL fourni par Qt :
   ```python
   self.ctx.render(flip_y=True, opengl_fbo={'w': w, 'h': h, 'fbo': fbo})
   ```

---

## 🐛 Dépannage

### Aucune image, seulement le son

- Vérifie que libmpv ≥ 1.28 (`mpv --version`)
- Sur **Wayland**, force le backend xcb si nécessaire :
  ```bash
  QT_QPA_PLATFORM=xcb python3 exo.py
  ```
- Vérifie que `python-mpv` ≥ 1.0 (`pip show mpv`)

### Segfault au démarrage

- Vérifie que `locale.setlocale(locale.LC_NUMERIC, 'C')` est bien exécuté **avant** le premier `mpv.MPV()`
- Vérifie que `QSurfaceFormat` par défaut est compatible OpenGL 3.3 Core

### `dbus reply error: No such interface "org.freedesktop.portal.Settings"`

Message **non bloquant** — Qt n'arrive pas à lire le thème GNOME. Ignorable.

### Le flux ne démarre pas

- Teste l'URL dans VLC ou `mpv <url>` directement
- Vérifie ta connexion réseau
- Les flux HLS peuvent mettre quelques secondes à démarrer (buffering)

### Erreur `ImportError: cannot import name 'QOpenGLContext' from 'PyQt6.QtOpenGL'`

En PyQt6, `QOpenGLContext` se trouve dans **`PyQt6.QtGui`** (pas `QtOpenGL`). Corrige l'import :
```python
from PyQt6.QtGui import QOpenGLContext
```

---

## 🗺️ Roadmap

- [ ] Métadonnées en direct (titre du morceau en cours) via l'API Icecast
- [ ] Bouton plein écran pour la TV
- [ ] Reconnexion automatique en cas de coupure
- [ ] Systray / mini-player
- [ ] Packaging `.deb` pour Ubuntu
- [ ] Thèmes clair / sombre

---

## 🤝 Contribution

Les PR sont bienvenues ! Pour les changements majeurs, ouvre d'abord une issue pour discuter de ce que tu veux modifier.

1. Fork le projet
2. Crée ta branche (`git checkout -b feature/ma-feature`)
3. Commit (`git commit -m 'feat: ajoute ma feature'`)
4. Push (`git push origin feature/ma-feature`)
5. Ouvre une Pull Request

---

## 📄 Licence

MIT — voir [LICENSE](LICENSE) pour plus de détails.

---

## ⚠️ Avertissement

Ce projet est un lecteur personnel non affilié à Exo FM ni à Antenne Réunion.
Les flux utilisés sont publics et accessibles librement depuis les sites officiels.
Tous les droits sur les contenus diffusés appartiennent à leurs propriétaires respectifs.

---

<p align="center">
  <sub>Fait avec ❤️ à La Réunion — par <a href="https://github.com/gunout">gunout</a></sub>
</p>
