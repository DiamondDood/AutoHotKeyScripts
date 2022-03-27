#MaxThreadsPerHotkey 3
F3::
#MaxThreadsPerHotkey 1
if KeepMiningRunning  ; This means an underlying thread is already running the loop below.
{
    KeepMiningRunning := false  ; Signal that thread's loop to stop.
    return  ; End this thread so that the one underneath will resume and see the change made by the line above.
}
; Otherwise:
KeepMiningRunning := true


InRace = false

Loop
{
    WinGetTitle, Title, A
    If (Title = "Roblox")            ; was it Notepad window
    {
        CoordMode Pixel
        ImageSearch, FoundX, FoundY, 1332, 93, 1360, 122, C:\Users\bryce\Documents\Code\AutoHotKeyScripts\white.png
        if (ErrorLevel = 2)
            ToolTip, Unable to search for image, 400, 400
        else if (ErrorLevel = 1)
        {
            RaceEnded()
        }
        else
        {
            RaceStarted()
        }
    }
    else
    {
        ; Clear tooltip and stop holding W
        ToolTip
        SendInput {w up}
    }

    Sleep 50
}
Return

RaceStarted()
{
    ToolTip, Race Going, 400, 400
    SendInput {d down}
    Sleep 10
    SendInput {d up}
    SendInput {w down}
    InRace = true
}

RaceEnded()
{
    ToolTip, Race Ended, 400, 400
    SendInput {w up}

    ; Quick backwards to stop any movement
    ; but only if we were just in a race
    if (InRace = true) 
    {
        SendInput {s down}
        Sleep 80
        SendInput {s up}
    }
    InRace = false
}