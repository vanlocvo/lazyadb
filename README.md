# LazyADB

There are many ADB installers out there, but most are outdated and you are too lazy to Google, find the download link, extract, and add to PATH. This is the installer you need.

With LazyADB, it will always download the latest adb from Google, you just need to click next, next, next,... and enjoy \o/.

## Usage:
- Download the installer at release
- Run it

## Build your own installer:
- Install [NSIS](https://nsis.sourceforge.io/Download) 3.09
- Add NSIS to PATH
- Install plugins:
    + [nsisunz](https://nsis.sourceforge.io/Nsisunz_plug-in) Unicode version by Gringoloco
    + [EnVar](https://nsis.sourceforge.io/EnVar_plug-in)
    + [NsProcess](https://nsis.sourceforge.io/NsProcess_plugin) v1.6  
    **OR**:  
        Copy all files in `plugins` folder to `<NSIS_installed_path>\Plugins\x86-unicode`   
        Ex: `C:\Program Files (x86)\NSIS\Plugins\x86-unicode`
- Run build.bat
