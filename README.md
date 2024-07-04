# Setup tool for Rocky on WSL2
This tool enables you to setup Rocky (8 or above) environment to your Windows machine.

## Requirements
OS: Windows 10 or above

## How to run
1. Clone this repository
1. Copy ./wsl_env to your home directory
1. Download Rocky image and move it to ./wsl_env/src/rocky_image  
   Latest Rocky9:  
     - Japan (Mirror server): https://ftp.iij.ad.jp/pub/linux/rocky/9/images/x86_64/Rocky-9-Container-Base.latest.x86_64.tar.xz  
     - Official (Rocky9): https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-Container-Base.latest.x86_64.tar.xz  
   Other versions:
     - Japan (Mirror server): https://ftp.iij.ad.jp/pub/linux/rocky/
     - Official: https://docs.rockylinux.org/guides/interoperability/import_rocky_to_wsl/
1. Run setup_rocky.bat

## How to delete distribution
Run `wsl --unregister {Rocky env name}` and remove empty directory({your home directory}/wsl_env/vm/{Rocky env name}).
