# Setup tool for Rocky on WSL2
This tool enables you to setup Rocky environment to your Windows machine.

## Requirements
OS: Windows 10 or above

## How to run
1. Clone this repository
1. Copy ./wsl_env to your home directory
1. Download Rocky image and move it to ./wsl_env/src/rocky_image
1. Run setup_rocky.bat

## How to delete distribution
Run `wsl --unregister {Rocky env name}` and remove empty directory({your home directory}/wsl_env/vm/{Rocky env name}).
