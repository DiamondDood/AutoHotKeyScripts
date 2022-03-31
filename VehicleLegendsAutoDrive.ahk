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

; Variables we will use below
RaceState = Ended ; Must be either: Starting, Racing, Ending, Ended
HighwaySide := "none"

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
            ; no r found
            if (RaceState = "Starting" or RaceState = "Racing")
            {
                RaceState := "Ending"
            }
        }
        else
        {
            ; r found
            if (RaceState = "Ending" or RaceState = "Ended")
            {
                RaceState := "Starting"
            }
        }
        Race()
    }
    else
    {
        ; Clear tooltip and stop holding W
        ToolTip
        SendInput {w up}
    }

    if not KeepMiningRunning  ; The user signaled the loop to stop by pressing Win-Z again.
    {
        break  ; Break out of this loop.
    }
    Sleep 50
}
Return

Race()
{
    global RaceState
    global HighwaySide 

    if (RaceState = "Starting")
    {
        ;ToolTip Recomputing Highway side, A_ScreenWidth/2, A_ScreenHeight/3*2
        HighwaySide := GetHighwaySide()
        RaceState := "Racing"
    }
    
    if (RaceState = "Racing") 
    {
        ; Todo: turn left or right to follow yellow line
        SendInput {w down}
    }

    if (RaceState = "Ending")
    {
        SendInput {w up}

        SendInput {s down}
        Sleep 80
        SendInput {s up}
        
        HighwaySide := "none"
        RaceState := "Ended"
    }

    if (RaceState = "Ended")
    {
        ; Do nothing for now
    }

    ToolTip, RaceState: %RaceState%`nHighwaySide: %HighwaySide%, A_ScreenWidth/2, A_ScreenHeight/3*2
    return
}

GetHighwaySide() 
{
    ; Look for yellow on initial load and set the variable below
    localHighwaySide := "unknown"
    ImageSearch, FoundX, FoundY, A_ScreenWidth*3/5, A_ScreenHeight*3/5, A_ScreenWidth, A_ScreenHeight, *20 C:\Users\bryce\Documents\Code\AutoHotKeyScripts\yellow.png
    if (ErrorLevel = 2)
        ;ToolTip, Unable to search for image, 400, 400
        MsgBox Unable to search for image
    else if (ErrorLevel = 1)
    {
        ;ToolTip, Image Not found, 400, 400
    }
    else
    {
        ;;ToolTip, Image found on left
        localHighwaySide := "Left"
    }

    ImageSearch, FoundX, FoundY, 0, A_ScreenHeight*3/5, A_ScreenWidth*2/5, A_ScreenHeight, *20 C:\Users\bryce\Documents\Code\AutoHotKeyScripts\yellow.png
    if (ErrorLevel = 2)
        MsgBox Unable to search for image
    else if (ErrorLevel = 1)
    {
        ;ToolTip, Image Not found, 400, 400
    }
    else
    {
        ;ToolTip, Image found on right
        localHighwaySide := "Right"
    }
    ;ToolTip, On %HighwaySide% side of the highway`nAt %FoundX% - %FoundY%, A_ScreenWidth/2, A_ScreenHeight/3*2
    return localHighwaySide
}