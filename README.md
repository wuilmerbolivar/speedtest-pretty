# speedtest-pretty 📡

Un wrapper en Bash para el CLI oficial de [Speedtest by Ookla](https://www.speedtest.net/apps/cli) que transforma la salida JSON en un resultado legible, con colores y barras de progreso, directamente en tu terminal.

![bash](https://img.shields.io/badge/bash-%23121011.svg?style=flat&logo=gnu-bash&logoColor=white)
![license](https://img.shields.io/badge/license-MIT-blue.svg)

## ✨ Características

- Convierte automáticamente bytes/s → Mbps
- Barras de progreso para descarga y subida
- Muestra ping, jitter y pérdida de paquetes
- Incluye ISP, servidor usado y enlace al resultado público
- Sin dependencias pesadas: solo `jq` y `awk`

## 📋 Requisitos

- [Speedtest CLI oficial de Ookla](https://www.speedtest.net/apps/cli) (no confundir con `speedtest-cli` de Python)
- `jq`
- `awk`
- Terminal compatible con `tput` (la mayoría lo son: kitty, alacritty, gnome-terminal, etc.)

### Instalar el CLI de Ookla

**Arch Linux:**
```bash
yay -S speedtest
```

**Debian/Ubuntu:**
```bash
curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
sudo apt-get install speedtest
```

**macOS:**
```bash
brew tap teamookla/speedtest
brew install speedtest --force
```

## 🚀 Instalación

```bash
git clone https://github.com/wuilmerbolivar/speedtest-pretty.git
cd speedtest-pretty
chmod +x speedtest-pretty.sh
```

## ▶️ Uso

```bash
./speedtest-pretty.sh
```

### Ejemplo de salida

```
⚡ Ejecutando speedtest...

┌──────────────────────────────────────────┐
│        📡  RESULTADOS DE VELOCIDAD         │
└──────────────────────────────────────────┘

  ▼ Descarga    881.7 Mbps  [██████████████████████████░░]
  ▲ Subida      878.2 Mbps  [██████████████████████████░░]

  Ping            4.5 ms
  Jitter           0.8 ms
  Pérdida            0 %

  ISP:       Claro Fibra
  Servidor:  Claro Perú (Colonial)
  Resultado: https://www.speedtest.net/result/c/...
```

## ⚙️ Cómo funciona

El CLI oficial de Ookla reporta el ancho de banda en **bytes por segundo**. El script lo convierte a Mbps con:

```
Mbps = (bytes_por_segundo × 8) / 1,000,000
```

Todos los campos se extraen del JSON con `jq` y se formatean con colores ANSI vía `tput`, sin secuencias de escape codificadas a mano.

## 📄 Licencia

MIT — úsalo, modifícalo y compártelo libremente.

## 🔗 Autor

**Wuilmer Bolívar**
Portafolio: [wuilmerbolivar.lat](https://www.wuilmerbolivar.lat)
