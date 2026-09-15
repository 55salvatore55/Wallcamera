#Requires AutoHotkey v2.0

;==========================================================
; WallCamera
; Config.ahk
; Version 1.0.1
;==========================================================

global Cameras := []


;----------------------------------------------------------
; Load the complete configuration
;----------------------------------------------------------
LoadConfiguration()
{
    global Cameras

    Cameras := []

    ConfigFile := A_ScriptDir "\Config.ini"

    if !FileExist(ConfigFile)
    {
        ErrorMessage("Config.ini not found.")
        return false
    }

    CameraCount := IniRead(
        ConfigFile,
        "GENERAL",
        "CameraCount",
        0
    ) + 0

    if (CameraCount <= 0)
    {
        ErrorMessage("Invalid CameraCount.")
        return false
    }

    Loop CameraCount
    {
        if !LoadCamera(ConfigFile, A_Index)
            continue
    }

    Log("Cameras loaded: " Cameras.Length)

    return (Cameras.Length > 0)
}


;----------------------------------------------------------
; Load a single camera
;----------------------------------------------------------
LoadCamera(ConfigFile, Index)
{
    global Cameras

    Section := "CAMERA" Index

    Enabled := IniRead(
        ConfigFile,
        Section,
        "Enabled",
        1
    ) + 0

    if (!Enabled)
        return false

    Name := Trim(
        IniRead(
            ConfigFile,
            Section,
            "Name",
            ""
        )
    )

    BasePath := Trim(
        IniRead(
            ConfigFile,
            Section,
            "BasePath",
            ""
        )
    )

    SubFolder := Trim(
        IniRead(
            ConfigFile,
            Section,
            "SubFolder",
            ""
        )
    )

    if (BasePath = "")
    {
        Log("Camera " Index " ignored (empty BasePath).")
        return false
    }

    Cam := Camera(
        Index,
        Name,
        BasePath,
        SubFolder
    )

    ; Check whether the camera folder exists
    if Cam.Exists()
    {
        Cam.Online := true
        Cam.UpdateLastImage()

        Log("Camera " Index ": OK")
        Log("Path: " Cam.Path)

        if (Cam.LastImage != "")
            Log("Latest image: " Cam.LastImage)
        else
            Log("No image found.")
    }
    else
    {
        Cam.Online := false

        Log("Camera " Index ": OFFLINE")
        Log("Folder not found: " Cam.Path)
    }

    Cameras.Push(Cam)

    return true
}


;----------------------------------------------------------
; Return the number of cameras
;----------------------------------------------------------
GetCameraCount()
{
    global Cameras

    return Cameras.Length
}


;----------------------------------------------------------
; Return the complete camera list
;----------------------------------------------------------
GetCameraList()
{
    global Cameras

    return Cameras
}


;----------------------------------------------------------
; Return a camera by index
;----------------------------------------------------------
GetCamera(Index)
{
    global Cameras

    if (Index < 1)
        return 0

    if (Index > Cameras.Length)
        return 0

    return Cameras[Index]
}


;----------------------------------------------------------
; Find a camera by name
;----------------------------------------------------------
FindCameraByName(Name)
{
    global Cameras

    for Cam in Cameras
    {
        if (StrLower(Cam.Name) = StrLower(Name))
            return Cam
    }

    return 0
}


;----------------------------------------------------------
; Update all paths after a target-date change
;----------------------------------------------------------
RefreshCameraPaths()
{
    global Cameras

    for Cam in Cameras
    {
        OldPath := Cam.Path

        Cam.UpdateyesterdayPath()

        if (OldPath != Cam.Path)
        {
            Log("Date change detected.")
            Log("New path: " Cam.Path)
        }

        if Cam.Exists()
        {
            Cam.Online := true
            Cam.UpdateLastImage()
        }
        else
        {
            Cam.Online := false
            Cam.LastImage := ""
        }
    }
}


;----------------------------------------------------------
; Update the status of all cameras
;----------------------------------------------------------
RefreshCameraStatus()
{
    global Cameras

    for Cam in Cameras
    {
        Cam.UpdateyesterdayPath()

        if Cam.Exists()
        {
            Cam.Online := true
            Cam.UpdateLastImage()
        }
        else
        {
            Cam.Online := false
            Cam.LastImage := ""
        }
    }
}


;----------------------------------------------------------
; Debug information
;----------------------------------------------------------
DumpConfiguration()
{
    global Cameras

    Log("--------------------------------------")
    Log("CAMERA CONFIGURATION")
    Log("--------------------------------------")

    for Cam in Cameras
    {
        Log("ID       : " Cam.Id)
        Log("Name     : " Cam.Name)
        Log("Path     : " Cam.Path)
        Log("Online   : " Cam.Online)
        Log("Image    : " Cam.LastImage)
        Log("--------------------------------------")
    }
}