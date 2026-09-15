#Requires AutoHotkey v2.0

;==========================================================
; WallCamera
; Explorer.ahk
; Version 1.0.0
;
; Opens, manages and arranges Windows Explorer windows
; used by WallCamera.
;==========================================================


;----------------------------------------------------------
; Check whether a camera can be opened
;----------------------------------------------------------
CameraReady(Cam)
{
    ; Always update the path for the selected target date
    Cam.UpdateyesterdayPath()

    ; Folder is not available yet
    if !Cam.Exists()
        return false

    ; Is Explorer already open?
    if (Cam.WindowHwnd != 0)
    {
        if WinExist("ahk_id " Cam.WindowHwnd)
            return false

        ; The window no longer exists
        Cam.WindowHwnd := 0
    }

    return true
}


;----------------------------------------------------------
; Wait until an Explorer window is ready
;----------------------------------------------------------
WaitExplorerReady(Hwnd)
{
    Timeout := A_TickCount + 10000

    while (A_TickCount < Timeout)
    {
        if !WinExist("ahk_id " Hwnd)
            return false

        try
        {
            WinGetPos(&X, &Y, &W, &H, "ahk_id " Hwnd)

            if (W > 0 && H > 0)
                return true
        }

        Sleep 100
    }

    return false
}


;----------------------------------------------------------
; Find the Explorer window displaying the requested folder
;----------------------------------------------------------
FindExplorerWindow(Folder)
{
    global Cameras

    try
        Shell := ComObject("Shell.Application")
    catch
        return 0

    for Window in Shell.Windows
    {
        try
        {
            Path := Window.Document.Folder.Self.Path

            if (Path = Folder)
            {
                AlreadyUsed := false

                for Cam in Cameras
                {
                    if (Cam.WindowHwnd = Window.HWND)
                    {
                        AlreadyUsed := true
                        break
                    }
                }

                if !AlreadyUsed
                    return Window.HWND
            }
        }
        catch
        {
            ; Ignore windows that are not valid Explorer windows
        }
    }

    return 0
}


;----------------------------------------------------------
; Set Explorer to "Extra large icons" and sort by
; Date Modified - newest first
;----------------------------------------------------------
SetLargeIcons(Hwnd)
{
    try
    {
        Shell := ComObject("Shell.Application")

        for Window in Shell.Windows
        {
            if (Window.HWND != Hwnd)
                continue

            Window.Document.CurrentViewMode := 1
            Window.Document.IconSize := 256

            ; Sort by Date Modified - descending
            Window.Document.SortColumns := "prop:-System.DateModified;"

            Log("Large icons and date sorting applied.")

            return true
        }
    }
    catch Error as Err
    {
        Log("SetLargeIcons: " Err.Message)
    }

    return false
}

;----------------------------------------------------------
; Open a single camera
;----------------------------------------------------------
OpenSingleCamera(Cam)
{
    if !CameraReady(Cam)
        return false

    Folder := Cam.Path

    Log("Opening Explorer: " Cam.Name)

    Run('explorer.exe "' Folder '"')

    Timeout := A_TickCount + 10000

    while (A_TickCount < Timeout)
    {
        Sleep 100

        Hwnd := FindExplorerWindow(Folder)

        if (Hwnd = 0)
            continue

        if !WaitExplorerReady(Hwnd)
            continue

        Cam.WindowHwnd := Hwnd

        SetLargeIcons(Hwnd)

        Log("Explorer opened: " Cam.Name)

        return true
    }

    Log("Timeout: " Cam.Name)

    return false
}


;----------------------------------------------------------
; Open all available cameras
;----------------------------------------------------------
OpenExplorerWindows()
{
    global Cameras

    Log("========================================")
    Log("Starting Explorer windows")
    Log("========================================")

    for Cam in Cameras
    {
        if OpenSingleCamera(Cam)
        {
            Log("OK  : " Cam.Name)
        }
        else
        {
            Log("SKIP: " Cam.Name)
        }

        ; Allow Explorer to finish loading completely
        Sleep 1000
    }

    Log("========================================")
    Log("Explorer windows opened")
    Log("========================================")
}


;----------------------------------------------------------
; Check whether an Explorer window is still open
;----------------------------------------------------------
CameraWindowAlive(Cam)
{
    if (Cam.WindowHwnd = 0)
        return false

    if !WinExist("ahk_id " Cam.WindowHwnd)
    {
        Cam.WindowHwnd := 0
        return false
    }

    return true
}


;----------------------------------------------------------
; Close all Explorer windows opened by WallCamera
;----------------------------------------------------------
CloseExplorerWindows()
{
    global Cameras

    for Cam in Cameras
    {
        if CameraWindowAlive(Cam)
        {
            try
                WinClose("ahk_id " Cam.WindowHwnd)

            Cam.WindowHwnd := 0
        }
    }
}


;----------------------------------------------------------
; Update the state of Explorer windows
;----------------------------------------------------------
RefreshExplorerWindows()
{
    global Cameras

    for Cam in Cameras
    {
        ; Update the path for the selected target date
        Cam.UpdateyesterdayPath()

        ; Folder is not available yet
        if !Cam.Exists()
            continue

        ; Explorer is already open
        if CameraWindowAlive(Cam)
            continue

        ; Automatically open the missing window
        OpenSingleCamera(Cam)
    }
}


;----------------------------------------------------------
; Return the number of open Explorer windows
;----------------------------------------------------------
CountOpenExplorerWindows()
{
    global Cameras

    Count := 0

    for Cam in Cameras
    {
        if CameraWindowAlive(Cam)
            Count++
    }

    return Count
}


;----------------------------------------------------------
; Apply the layout to a single camera
;----------------------------------------------------------
ApplyLayoutToCamera(Cam)
{
    global Layout

    if !Layout.Has(Cam.Id)
        return

    Pos := Layout[Cam.Id]

    try
    {
        WinMove(
            Pos["X"],
            Pos["Y"],
            Pos["W"],
            Pos["H"],
            "ahk_id " Cam.WindowHwnd
        )
    }
}