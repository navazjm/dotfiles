# obs.sh

A Bash script to **install, update, or uninstall [OBS Studio](https://obsproject.com/)** on **Void Linux**, with support for the OBS Browser (CEF) component.

- [Features](#features)
- [Requirements](#requirements)
- [Usage](#usage)
  - [Commands](#commands)
  - [Options for `install` command](#options-for-install-command)
- [Install Example](#install-example)
- [Uninstall Example](#uninstall-example)
- [Notes](#notes)
- [License](#license)

## Features

- Installs OBS Studio from source with required dependencies
- Downloads and integrates prebuilt CEF for browser support
    - Supports custom browser docks (e.g., chat docks), which are not supported by Void Linux's xbps OBS package despite building with CEF
- Adds OBS to your `$PATH` and configures necessary environment variables
- Optionally uninstalls all installed components cleanly

## Requirements

- Void Linux
- Basic build dependencies (e.g., `git`, `cmake`, `gcc`, `wget` or `curl`)
- [CMakeUserPresets.json](./CMakeUserPresets.json) and [`obs-webrtc.patch`](./obs-webrtc.patch) should be in the same directory as the script
- This script assumes all OBS Studio dependencies are pre-installed on your system

## Usage

```bash
./obs.sh [command]
```

### Commands

| Command     | Description                                                    |
|-------------|----------------------------------------------------------------|
| `install`   | Installs/updates OBS Studio from source                        |
| `setup`     | Adds required paths to your shell config                       |
| `uninstall` | Removes OBS binaries and libraries installed by script         |
| `help`      | Displays usage instructions                                    |

## Install Example

```bash
./obs.sh setup
./obs.sh install
```

This will:
- Download the CEF archive
- Clone OBS Studio source code
- Build and install OBS into `$HOME/.local`

### Options for `install` command

| Option             | Description                                             |
|--------------------|---------------------------------------------------------|
| (none)             | Build OBS with WebRTC plugin enabled (default)          |
| `--disable-webrtc` | Build OBS without the WebRTC plugin                     |

## Uninstall Example

```bash
./obs.sh uninstall
```

This will remove the following files:
- `$HOME/.local/bin/obs`
- `$HOME/.local/bin/obs-ffmpeg-mux`
- `$HOME/.local/lib64` (OBS built .so files)

## Notes

- Only `.bashrc`, `.zshrc`, `.profile`, and Fish shell config are supported for `setup`
- Your original OBS configuration files (if any) are **not** touched or deleted

## License

MIT © 2025 [Michael Navarro](https://github.com/navazjm)
