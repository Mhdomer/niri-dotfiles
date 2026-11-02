<div align="center">

# 🌌 Niri & Noctalia Desktop Dotfiles

**A high-performance scrollable Wayland workspace built on CachyOS Linux.**

[![OS](https://img.shields.io/badge/OS-CachyOS%20%7C%20Arch%20Linux-00a88f?style=flat&logo=archlinux&logoColor=white)](https://cachyos.org)
[![Compositor](https://img.shields.io/badge/WM-Niri-585b70?style=flat&logo=wayland&logoColor=white)](https://github.com/YaLTeR/niri)
[![Shell](https://img.shields.io/badge/Shell-Fish%20%7C%20Starship-89b4fa?style=flat&logo=fishshell&logoColor=white)](https://fishshell.com)
[![Terminal](https://img.shields.io/badge/Terminal-Kitty-f38ba8?style=flat&logo=kitty&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![Desktop Shell](https://img.shields.io/badge/Panel-Noctalia%20Shell-cba6f7?style=flat&logo=qml&logoColor=white)](https://noctalia.dev)
[![Theme](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-fab387?style=flat&logo=curseforge&logoColor=white)](https://github.com/catppuccin/catppuccin)
[![License](https://img.shields.io/badge/License-MIT-a6e3a1?style=flat)](LICENSE)

<br/>

<img src="assets/desktop.png" alt="Desktop Showcase" width="100%" />

</div>

---

## ⚡ Highlights & Key Features

- **Infinite Scrollable Tiling (Niri):** Non-overlapping dynamic columns that flow smoothly across your display ribbon.
- **🛡️ Screen-Share Privacy Shield:** Native `block-out-from "screencast"` rule turns Bitwarden, KeePassXC, Telegram, and sensitive credentials into pitch-black boxes during Discord, Google Meet, or Zoom presentations while remaining fully visible on your physical screen.
- **🚨 Active Screencast Warning Ring:** Automatically highlights any window actively being captured on a stream or call with a distinct rose/dark-red glowing border (`is-window-cast-target`).
- **🎵 Desktop Shazam (SongRec):** Press `Mod + Shift + M` to sample your PipeWire speaker sink and identify any playing track via desktop notifications.
- **📷 On-Screen OCR:** Press `Mod + Shift + O` to drag a box over any on-screen area (supporting both English and Arabic) and copy extracted text straight to the Wayland clipboard.
- **🎧 Spotify Controls & Spicetify:** Catppuccin Mocha themed Spotify client with MPRIS next/prev track shortcuts (`Mod + .` and `Mod + ,`) and live track toasts.
- **🔍 Kitty Fuzzy Scrollback Search:** Press `Ctrl + Shift + F` inside Kitty terminal to overlay an interactive `fzf` search across your command history and output buffer.
- **🩺 DevSecOps & Systems Toolkit:** Custom Fish utilities including `wifi-networks` (band analysis), `clean` (cache cleaner), `pkgdiff` (system file integrity audit), `slay` (high-CPU process hunter), and `zombies` (zombie process parent tracer).
- **🌙 Night Light & Media:** Native warm color temperature toggle (`Mod + N`) using `wlsunset` (4000K) and Holy Quran Radio stream (`Mod + C`).

---

## 💻 Hardware Specifications

| Component | Hardware |
| :--- | :--- |
| **Machine** | ASUS TUF Gaming A15 |
| **CPU** | AMD Ryzen 7 6800H (16 threads @ 4.7 GHz) |
| **iGPU** | AMD Radeon 680M |
| **dGPU** | NVIDIA GeForce RTX 3050 Mobile |
| **RAM** | 38 GB DDR5 |
| **Storage** | 2 TB NVMe PCIe Gen 4 SSD |
| **Internal Display** | 1920x1080 @ 165.00 Hz (eDP-2) |
| **External Display** | Lenovo L24i-4A 1920x1080 @ 100 Hz (DP-3) |

---

## 🧰 Software Stack

| Role | Application | Config Location |
| :--- | :--- | :--- |
| **Compositor** | [Niri](https://github.com/YaLTeR/niri) | `niri/config.kdl`, `niri/cfg/*.kdl` |
| **Desktop Shell** | [Noctalia Shell](https://noctalia.dev) | `niri/noctalia.kdl` |
| **Terminal** | [Kitty](https://sw.kovidgoyal.net/kitty/) | `kitty/kitty.conf` |
| **Primary Shell** | [Fish](https://fishshell.com) | `fish/config.fish`, `fish/functions/` |
| **Prompt** | [Starship](https://starship.rs) | `~/.config/starship.toml` |
| **File Manager** | [Yazi](https://github.com/sxyazi/yazi) + [Dolphin](https://apps.kde.org/dolphin/) | `~/.config/yazi/`, Dolphin Breeze Dark |
| **Multiplexer** | [Zellij](https://zellij.dev) | `zellij/config.kdl` |
| **Video Player** | [MPV](https://mpv.io) (uosc UI) | `mpv/mpv.conf` |
| **Git & Docker** | [Lazygit](https://github.com/jesseduffield/lazygit) / [Lazydocker](https://github.com/jesseduffield/lazydocker) | `lazygit/config.yml` |
| **System Fetch** | [Fastfetch](https://github.com/fastfetch-cli/fastfetch) | `fastfetch/config.jsonc` |

---

## ⌨️ Master Keybindings

`Mod` is mapped to the **Super / Windows key**.

### Core Applications
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| **`Mod + Return`** | **Terminal** | Opens Kitty terminal with Starship prompt |
| **`Mod + R`** | **App Launcher** | Noctalia interactive application search |
| **`Mod + E`** | **File Manager** | Opens Dolphin file manager |
| **`Mod + Shift + E`** | **Emoji Picker** | Noctalia floating emoji popup |
| **`Mod + B`** | **Browser** | Launches Helium browser (or Firefox fallback) |
| **`Mod + O`** | **Obsidian** | Launches personal notes vault |
| **`Mod + Shift + O`** | **Screen OCR** | Snips screen area to extract text into clipboard |
| **`Mod + M`** | **Spotify Toggle** | Toggles Spotify playback with desktop track toast |
| **`Mod + .`** *(or `>`)* | **Spotify Next** | Skips to next track with desktop toast |
| **`Mod + ,`** *(or `<`)* | **Spotify Previous** | Returns to previous track with desktop toast |
| **`Mod + Shift + M`** | **Shazam** | Samples speaker output to identify song |
| **`Mod + H`** | **Discord** | Launches Vesktop client |
| **`Mod + V`** | **Clipboard** | CopyQ clipboard history manager |
| **`Mod + W`** | **Wallpaper** | Opens Noctalia wallpaper switcher |
| **`Mod + Shift + W`** | **Window Switcher** | Noctalia interactive window search and switcher |
| **`Mod + S`** | **Settings** | Opens Noctalia desktop settings panel |
| **`Mod + N`** | **Night Light** | Toggles wlsunset 4000K warm blue-light filter |
| **`Mod + C`** | **Holy Quran Radio** | Toggles background Quran radio stream |
| **`Mod + L`** | **Lock Screen** | Noctalia Wayland secure lockscreen |
| **`Mod + Shift + Q`** | **Session Menu** | Noctalia power, reboot, and logout menu |

### Navigation & Layout
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| **`Mod + Left / Right`** | **Focus Column** | Focus adjacent column left / right |
| **`Mod + Up / Down`** | **Focus Window** | Focus window up / down (or switch tab) |
| **`Mod + Ctrl + Left / Right`** | **Move Column** | Move column left / right in the ribbon |
| **`Mod + Shift + T`** | **Tabbed Column** | Toggles column between vertical stack and tabs |
| **`Mod + [` / **`Mod + ]`** | **Absorb Window** | Pulls adjacent window into current tab group |
| **`Mod + D`** | **Preset Width** | Cycles preset widths: 33% ➔ 50% ➔ 67% |
| **`Mod + F`** | **Maximize Column** | Expands column to full monitor width |
| **`Mod + Shift + C`** | **Center Column** | Centers current column on screen |
| **`Mod + T`** | **Toggle Floating** | Un-tiles window to float freely |
| **`Mod + Tab`** | **Overview** | Bird's-eye view of all columns & workspaces |
| **`Mod + 1 .. 9`** | **Workspaces** | Switch to Workspace 1 through 9 |
| **`Mod + Shift + 1 .. 9`** | **Move to Workspace** | Moves focused column to Workspace 1 through 9 |
| **`Print`** | **Screenshot** | Captures active display to clipboard |
| **`Mod + Shift + S`** | **Satty Annotation** | Interactive screenshot editor |

### Kitty Terminal Shortcuts
| Shortcut | Action |
| :--- | :--- |
| **`Ctrl + Shift + F`** | **Fuzzy search scrollback output with fzf** |
| **`Ctrl + Enter`** | Split pane horizontally |
| **`Ctrl + Shift + Enter`** | Split pane vertically |
| **`Ctrl + Arrow Keys`** | Move focus between split panes |
| **`Ctrl + T`** / **`Ctrl + W`** | New tab / Close tab |

---

## 🛠️ CLI Utilities Reference

These functions are available natively across any Fish shell session:

```bash
wifi-networks         # Scans local Wi-Fi and outputs table sorted by 2.4/5/6 GHz
clean                 # Prunes pacman cache, paru cache, pip, cargo, docker, and shows duf
pkgdiff /etc/file     # Diffs your live system config against clean upstream Arch package
slay                  # Automatically kills runaway background processes over 90% CPU
zombies               # Identifies parent process holding zombie child processes in memory
fast <command>        # Runs heavy task under hardware maximum performance profile
dotenv [file]         # Loads .env variables directly into active Fish session
hl <query>            # Highlights search terms in bold color while printing full stream
kssh <user@host>      # SSH to remote server with automatic Kitty terminfo cloning
y                     # Yazi terminal file manager with automatic cd on exit
lg                    # Lazygit TUI
lzd                   # Lazydocker TUI
```

---

## 🚀 Installation & Stow

This repository is organized for [GNU Stow](https://www.gnu.org/software/stow/).

### 1. Clone the repository
```bash
git clone https://github.com/Mhdomer/niri-dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Symlink packages with Stow
```bash
stow fish kitty niri fastfetch lazygit mpv zellij
```

### 3. Install scripts to `~/.local/bin`
```bash
mkdir -p ~/.local/bin
cp bin/* ~/.local/bin/
chmod +x ~/.local/bin/*
```

---

## 🏷️ Suggested GitHub Topics / Tags

To make this repository easily discoverable on GitHub, add these repository topics:

`niri` · `niri-compositor` · `cachyos` · `archlinux` · `wayland` · `catppuccin` · `noctalia` · `noctalia-shell` · `fish-shell` · `kitty-terminal` · `dotfiles` · `unixporn` · `devsecops` · `yazi`

---

## 📄 License & Credits

- **License:** MIT License.
- **Base Inspiration:** Built upon initial foundations from [robaa12/niri-dotfiles](https://github.com/robaa12/niri-dotfiles) by Robaa.
- **Upgraded & Maintained by:** [Mohamed Makhlouf (Mhdomer)](https://github.com/Mhdomer).
