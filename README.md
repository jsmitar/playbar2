
# PlayBar2

MPRIS2 client, written in QML for **Plasma 5** and **GNU/Linux**.

<p align="center">
<img src="https://github.com/audoban/PlayBar2/blob/master/screenshot.png" width="500"></img>
</p>

# Shortcuts

On expanded:

| Key          | Action          |
|-------------:|-----------------|
| `K`, `Space` | Play/Pause      |
| `P`          | Previous        |
| `N`          | Next            |
| `S`          | Stop            |
| `Left`, `J`  | Seek back 5s    |
| `Right`, `L` | Seek forward 5s |
| `Home`       | Seek start      |
| `End`        | Seek end        |
| `Num: [0..9]`| Jump to porcentage, `Key 0: 0%, ..., Key 9: 90%` |

On panel:

| Mouse key       | Action         |
|----------------:|----------------|
| `Middle button` | Play/Pause     |
| `Wheel`         | Up/Down volume |
| `Back button`   | Previous       |
| `Forward button`| Next           |

# Installation
## Build from the source code
**Dependencies:** `plasma-framework-devel plasma5-workspace-devel kdeclarative-devel kglobalaccel-devel kconfigwidgets-devel kxmlgui-devel kwindowsystem-devel kdoctools-devel extra-cmake-modules`

**Dependencies for OpenSUSE:**
```
sudo zypper install gcc-c++ plasma-framework-devel plasma5-workspace-devel kdeclarative-devel \
kglobalaccel-devel kconfigwidgets-devel kxmlgui-devel kwindowsystem-devel kdoctools-devel \
extra-cmake-modules
```
**Dependencies for Kubuntu:**
```bash
sudo apt-get install g++ plasma-framework-dev plasma-workspace-dev libkf5declarative-dev \
libkf5globalaccel-dev libkf5configwidgets-dev libkf5xmlgui-dev \
libkf5windowsystem-dev kdoctools-dev cmake extra-cmake-modules kdelibs5-dev
```

Create a *build* directory into **PlayBar**, compile the Plasmoid and enjoy it.

**OpenSUSE:**
```bash
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DKDE_INSTALL_LIBDIR=lib64/qt5 -DCMAKE_BUILD_TYPE=Release ..
make && sudo make install
```
**Kubuntu:**
```bash
mkdir build && cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
make && sudo make install
```

## Repositories
**Kubuntu:**
```bash
sudo add-apt-repository ppa:varlesh-l/plasma5-tools
sudo apt-get update
sudo apt-get install plasma-widget-playbar2
```

**Arch Linux (AUR):**
```bash
yaourt kdeplasma-applets-playbar2
```

## Configure your global shortcuts
PlayBar also supports keyboard shortcuts, if you want change you must go to preferences of PlayBar.

# Help me to translate!
**If you want to add a language, please follow this**  __[Thread.](https://github.com/audoban/PlayBar2/issues/1)__

# Contributors
- ![Alexey Murz Korepov](https://github.com/MurzNN) Improve Readme
- ![varlesh](https://github.com/varlesh) Create a PPA repository with Packages for **Ubuntu**
- ![André Vitor de Lima Matos](https://github.com/andrevmatos) Create a AUR package for **Arch Linux** and Portuguese translation
- ![Tomasz Przybył](https://github.com/FadeMind) Polish translation
- ![Konstantin](https://github.com/KottV) Russian translation
- ![dkadioglu](https://github.com/dkadioglu) German translation
- ![tillschaefer](https://github.com/tillschaefer) Gentoo ebuild
