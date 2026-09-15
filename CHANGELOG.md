# Changelog

## [1.0.1] - 2026-08-26

### Added
- F10 closes all Explorer windows opened by WallCamera and exits the application.
- Startup date selection with yesterday preselected as the default.
- A custom target date can be entered in `YYYY-MM-DD` format.

### Changed
- Camera paths now use the selected target date instead of being tied to yesterday.
- Automatic refresh remains disabled because WallCamera is intended for historical folders.

All notable changes to Wallcamera are documented in this file.

## [1.0.0] - 2026-08-10

### Added

- Automatic opening of configured camera folders.
- Automatic detection of the latest JPG image.
- Automatic arrangement of Explorer windows using a saved layout.
- Automatic use of Extra Large Icons in Windows Explorer
- Support for local and Windows network paths.
- Layout saving with the F9 hotkey.
- Logging for normal operation and troubleshooting.
- Support for starting Wallcamera without an existing `Layout.ini`.

### Compatibility

- Tested on Windows 10.
- Tested on Windows 7.
- Tested on different computers and screen resolutions.

### Notes

This is the first stable release of Wallcamera.

The user's `Config.ini` and `Layout.ini` files are not included in
the public repository because they contain computer-specific settings.