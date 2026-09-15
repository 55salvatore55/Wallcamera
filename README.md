# WallCamera

WallCamera is an AutoHotkey v2 application designed to automatically
open, arrange and refresh multiple Windows Explorer windows used for
CCTV image monitoring. Is a sister of CameraWall, it open specific folder, if exisist, to look in the past some occured event.


It was developed for a surveillance system where cameras continuously
upload JPG images to folders through FTP. When WallCamera starts, an input box appears showing yesterday's date by default, though you can enter a different date. Once confirmed, all windows available for that date will open at the location specified in the `config.ini` file and be positioned according to the previously saved layout. Pressing the F10 key closes all open windows and exits the program.

WallCamera automatically:

- Opens the configured camera folders.
- Finds the most recent JPG image.
- Arranges Explorer windows according to a saved layout.
- Uses Extra Large Icons for camera folders.
- Opens folders automatically.
- Restores the saved window layout.
- Supports local and network paths.

---

## Features

### Automatic camera folders

Each camera can be configured independently in `Config.ini`.

WallCamera builds the path for the current date automatically.

Example:

    C:\CameraData\CAMERA_1\2026-08-10\01\pic

The date folder is generated automatically using the current date.

### Extra Large Icons

WallCamera explicitly sets Windows Explorer to Extra Large Icons.

This prevents Explorer's saved folder-view preferences from changing
the camera display unexpectedly.


### Saved layout

Window positions and sizes can be saved with:

    F9

The layout is stored in `Layout.ini`.

The layout is specific to the computer and monitor configuration.

If `Layout.ini` does not exist, WallCamera starts without a saved
layout. The user can arrange the windows and press F9 to create one.

### Network paths

Camera folders do not have to be located on the same computer.

Windows network paths are supported, for example:

    \\SERVER\CameraData\CAMERA_1

The only requirement is that Windows Explorer can access the configured
path.

---

## Requirements

- Windows
- AutoHotkey v2
- Windows Explorer
- Access to the configured camera folders

WallCamera has been tested on:

- Windows 10
- Windows 7

The application was also tested on different computers and screen
resolutions.

---

## Installation

1. Install AutoHotkey v2.
2. Copy the WallCamera folder to a suitable location.
3. Copy `Config.ini.example` to `Config.ini`.
4. Edit `Config.ini` according to your camera folders.
5. Run `WallCamera.ahk`.

The first time WallCamera is started, no `Layout.ini` is required.

Arrange the Explorer windows as desired and press F9 to save the layout.

---

## Configuration

Camera configuration is stored in `Config.ini`.

A configuration example is provided as:

    Config.ini.example

Example:

    [GENERAL]
    CameraCount=8

    [CAMERA1]
    Enabled=1
    Name=Camera 1
    BasePath=C:\CameraData\CAMERA_1
    SubFolder=01\pic

Each camera section contains:

- `Enabled` — enables or disables the camera.
- `Name` — display name used in the log.
- `BasePath` — base folder containing the date folders.
- `SubFolder` — folder below the date folder containing the JPG images.

---

## Project Structure

    WallCamera/
    │
    ├── WallCamera.ahk
    ├── Config.ini.example
    ├── README.md
    ├── CHANGELOG.md
    ├── .gitignore
    │
    └── Source/
        ├── Camera.ahk
        ├── Config.ahk
        ├── Explorer.ahk
        ├── Layout.ahk
        └── Utils.ahk

`Config.ini` and `Layout.ini` are user-specific files and are not
included in the public repository.

---

## Logging

WallCamera writes operational information to:

    WallCamera.log

The log can be useful for troubleshooting camera availability,
Explorer windows and refresh operations.

---
### Exit program

Pressing F10 program close all previous opened folder by WallCamera en exit program

---

## Troubleshooting

If a camera folder is not available when WallCamera starts, the camera
is skipped.


If troubleshooting is required, additional diagnostic logging can be
temporarily enabled in `Refresh.ahk`.

---

## Version

Current release:

**WallCamera 1.0.0**

This is the first stable release.

---

## License

See the `LICENSE` file included with the project.