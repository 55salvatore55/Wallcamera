#Requires AutoHotkey v2.0
;==========================================================
; WallCamera
; Utils.ahk
; Version 1.0.1
;==========================================================

global LogFile := A_ScriptDir "\..\WallCamera.log"


;----------------------------------------------------------
; Write a line to the log file
;----------------------------------------------------------
Log(Text)
{
    global LogFile

    TimeStamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

    try
        FileAppend(TimeStamp " - " Text "`n", LogFile, "UTF-8")
}


;----------------------------------------------------------
; Check whether a folder exists
;----------------------------------------------------------
FolderExists(Path)
{
    return DirExist(Path) != ""
}


;----------------------------------------------------------
; Check whether a file exists
;----------------------------------------------------------
FileExistsEx(Path)
{
    return FileExist(Path) != ""
}


;----------------------------------------------------------
; Target date selected at startup
;----------------------------------------------------------
global TargetDate := ""

SelectTargetDate()
{
    global TargetDate

    Yesterday := DateAdd(A_Now, -1, "Days")
    DefaultDate := FormatTime(Yesterday, "yyyy-MM-dd")

    Result := InputBox(
        "Enter the date to display (YYYY-MM-DD).`n`nThe default is yesterday.",
        "WallCamera - Target Date",
        "w360 h150",
        DefaultDate
    )

    if (Result.Result != "OK")
        return false

    DateText := Trim(Result.Value)

    if !RegExMatch(DateText, "^\d{4}-\d{2}-\d{2}$")
    {
        MsgBox(
            "Invalid date.`n`nPlease enter the date in YYYY-MM-DD format.",
            "WallCamera",
            "Iconx"
        )
        return false
    }

    ; Validate that the date really exists.
    try
    {
        DateAdd(StrReplace(DateText, "-", "") "000000", 0, "Days")
    }
    catch
    {
        MsgBox(
            "Invalid date.`n`nPlease enter a valid calendar date.",
            "WallCamera",
            "Iconx"
        )
        return false
    }

    TargetDate := DateText
    return true
}


;----------------------------------------------------------
; Return the selected target folder
;----------------------------------------------------------
GetTargetFolder()
{
    global TargetDate
    return TargetDate
}


;----------------------------------------------------------
; Backward-compatible name used by existing modules
;----------------------------------------------------------
GetYesterdayFolder()
{
    return GetTargetFolder()
}


;----------------------------------------------------------
; Return the name of the most recently modified JPG
;----------------------------------------------------------
GetLastJpg(Path)
{
    if !DirExist(Path)
        return ""

    LastFile := ""
    LastTime := ""

    Loop Files Path "\*.jpg", "F"
    {
        if (LastFile = "" || A_LoopFileTimeModified > LastTime)
        {
            LastFile := A_LoopFileName
            LastTime := A_LoopFileTimeModified
        }
    }

    return LastFile
}


;----------------------------------------------------------
; Display an error message
;----------------------------------------------------------
ErrorMessage(Text)
{
    Log("ERROR: " Text)

    MsgBox(
        Text,
        "WallCamera",
        "Iconx"
    )
}