
#PlayBar2

MPRIS2 client, written in QML for **Plasma 5** and **GNU/Linux**.

![desktop](https://raw.githubusercontent.com/audoban/PlayBar2/master/playbar_desktop.png)
![panel](https://raw.githubusercontent.com/audoban/PlayBar2/master/playbar_panel.png) 
![notification](https://raw.githubusercontent.com/audoban/PlayBar2/master/playbar_notification_area.png)


## Installation
**Dependencies:** `plasma-framework-devel plasma5-workspace-devel kdeclarative-devel kglobalaccel-devel kconfigwidgets-devel kxmlgui-devel kwindowsystem-devel kdoctools-devel extra-cmake-modules`

**Dependencies for Kubuntu:**
```
sudo apt-get install g++ plasma-framework-dev plasma-workspace-dev libkf5declarative-dev libkf5globalaccel-dev libkf5configwidgets-dev libkf5xmlgui-dev libkf5windowsystem-dev kdoctools-dev cmake extra-cmake-modules kdelibs5-dev
```
Create a *build* directory and then enter it.
```bash
$ mkdir build && cd build
```

And compile.
```bash
$ cmake -DCMAKE_INSTALL_PREFIX=/usr .. && make && sudo make install
```

## Configure keyboard shortcuts
PlayBar also supports keyboard shortcuts and these come with a default configuration, but if you want change you must go to preferences of PlayBar. 

![Shortcuts](https://raw.githubusercontent.com/audoban/PlayBar2/master/playbar_keys.png)

## Help me to translate!
If you want to add a language, please follow this  __[thread.](https://github.com/audoban/PlayBar2/issues/1)__
