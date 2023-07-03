# Klipper Firmware Build Tool

# Overview
This script allows you to build multiple firmwares at once automatically.

# How to setup 

Example below is for pico boards

1. create a folder that will contain firmware builds (this will be DIR_FIRMWARE)
2. create a folder that will contain subfolder with boards (this will be DIR_BOARDS)
3. create a new subfolder under <DIR_BOARDS> named "pico"
4. go to klipper folder ( usually cd ~/klipper )
5. run "make menuconfig", configure the options you need for the board then quit and save
6. copy .config file (usually ~/klipper/.config) to <DIR_BOARDS>/pico/config/make.config.txt 
7. repeat steps 3-6 for all boards
8. run script firmware_make_all
9. in <DIR_FIRMWARE>/<year-month-day>/ you will have all the firmware build

when needing to rebuild firmwares in the future just run firmware_make_all again

## Configuration
* DIR_FIRMWARE - where subfolders for each date will be created
* DIR_BOARDS - where the folder that contains subfolders per board are
* DIR_KLIPPER - where the klipper folder is
* MAKE_LOG - where the build log will be saved temporarely

DATE_PARAM allows you to set subfolder naming for built firmwares

for daily firmwares
```
DATE_PARAM="'%Y-%m-%d'"
```
generates subfolders like
```
2023-07-03
```



to include also hour and minute
```
DATE_PARAM="'%Y-%m-%d-%H-%M'"
```
generates subfolders like
```
2023-07-03-13-56
```

