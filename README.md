
#PlayBar2

MPRIS2 client, written in QML for Plasma KDE. ![Screenshots](https://raw.githubusercontent.com/audoban/PlayBar2/master/playbar_desktop.png)

## Installation
Remember to install the development libraries for __KDE.__

Create a build directory and then enter it.
```
$ mkdir build && cd build
```

And compile. :D
```
$ cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && sudo make install
```

## Configure keyboard shortcuts
PlayBar also supports keyboard shortcuts and these come with a default configuration, but if you want change you must go to: System Preferences> Shortcuts and Gestures> Global Keyboard Shortcuts and select the component "Plasma Desktop Shell".
![Shortcuts](https://raw.githubusercontent.com/audoban/PlayBar/master/shortcuts.png)

## Add a window rule for _plasma-desktop_
If you use a Dock as  Plank or CairoDock you may notice as an application called "plasma-desktop" in the Dock appears when the PlayBar popup window opens.

__This can be fixed in two ways:__

1. Opening the config-ui window of the plasmoid and uncheck the option "Avoid close popup when It loses focus:".
2. Add a [KWin rule](https://raw.githubusercontent.com/audoban/PlayBar/master/plasma-desktop.kwinrule) for "plasma-desktop" in Window Behavior> Window rules.
![KWin Rule](https://raw.githubusercontent.com/audoban/PlayBar/master/kwinrule.png)

## Help me to translate!
If you want to add a language, please follow this  __[thread.](https://github.com/audoban/PlayBar/issues/4)__

## Contributions

* __Salim Gazizov:__ [Russian translation](https://github.com/audoban/PlayBar/commit/d4d068852f5608c2ff24586f29a8d0631a087d70), Testing and bugs reports.
* __Yoyo Fernandez:__ PKGBUILD for [Arch and KaOS](https://github.com/KaOS-Personal-Packages/kdeplasma-applets-playbar) and thanks for his dedicated blog entries and support in spreading PlayBar.

## TODO
* Add SetRating
* Port to Plasma5
