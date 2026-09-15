#Requires AutoHotkey v2.0
#SingleInstance Force

;==========================================================
; WallCamera
; Version 1.0.1
;
; Opens and arranges camera folders for a selected date
; in Windows Explorer for camera monitoring.
;==========================================================

;---------------------------
; Modules
;---------------------------

#Include Source\Utils.ahk
#Include Source\Camera.ahk
#Include Source\Config.ahk
#Include Source\Explorer.ahk
#Include Source\Layout.ahk
;#Include Source\Refresh.ahk


;---------------------------
; Main program
;---------------------------

Main()

return


Main()
{
    Log("===================================")
    Log("Starting WallCamera")
    Log("===================================")

    ;----------------------------------
    ; Select target date
    ;----------------------------------

    if !SelectTargetDate()
    {
        Log("Startup cancelled by user.")
        ExitApp
    }

    Log("Target date: " TargetDate)

    ;----------------------------------
    ; Load Config.ini
    ;----------------------------------

    if !LoadConfiguration()
    {
        ErrorMessage("Configuration loading error.")
        ExitApp
    }

    ;----------------------------------
    ; Load Layout.ini
    ;----------------------------------

    if !LoadLayout()
    {
        ErrorMessage("Layout loading error.")
        ExitApp
    }

    ;----------------------------------
    ; Open Explorer windows
    ;----------------------------------

    OpenExplorerWindows()

    Sleep 4000

    ;----------------------------------
    ; Apply layout
    ;----------------------------------

    ApplyLayout()

    Sleep 300

    ApplyLayout()

    Sleep 300

    BringAllToFront()

    ;----------------------------------
    ; Refresh system intentionally disabled
    ;----------------------------------

    ; WallCamera displays an existing historical date.
    ; No automatic refresh is required.

    Log("WallCamera started successfully.")
}


;----------------------------------------------------------
; Save current layout
;----------------------------------------------------------

F9::
{
    SaveLayout()
    MsgBox("Layout saved.")
}


;----------------------------------------------------------
; F10 - Close WallCamera and its Explorer windows
;----------------------------------------------------------
F10::
{
    Log("F10 pressed - closing WallCamera windows.")
    CloseExplorerWindows()
    Sleep 300
    Log("WallCamera closed by user.")
    ExitApp
}