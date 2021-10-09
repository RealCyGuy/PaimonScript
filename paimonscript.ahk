; PaimonScript by Cyrus Yip

SetWorkingDir % A_ScriptDir
IniRead, Enabled, config.ini, PaimonScript, enabled
if (not enabled == "true") {
    ExitApp
}

if (A_IsAdmin != true) {
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}

IniRead, Exe, config.ini, PaimonScript, genshinExe
IniRead, InteractEnabled, config.ini, QuickInteract, enabled
IniRead, InteractTriggerKey, config.ini, QuickInteract, triggerKey
IniRead, InteractTriggeredKey, config.ini, QuickInteract, triggeredKey
IniRead, AARREnabled, config.ini, AARR, enabled
IniRead, BunnyEnabled, config.ini, BunnyHop, enabled
IniRead, BunnyKey, config.ini, BunnyHop, key
IniRead, CookEnabled, config.ini, AutoCook, enabled
IniRead, CookAutoConfirm, config.ini, AutoCook, autoConfirm
IniRead, CookX, config.ini, AutoCook, buttonX
IniRead, CookStart, config.ini, AutoCook, startY
IniRead, CookStop, config.ini, AutoCook, stopY
global CookAutoConfirm
global CookX := Format("{:d}", CookX)
global CookStart := Format("{:d}", CookStart)
global CookStop := Format("{:d}", CookStop)
IniRead, CookAdeptusTemptation, config.ini, AutoCook, adeptusTemptation

if (InteractEnabled == "true") {
    #If WinActive("ahk_exe" Exe)
    Hotkey, $%InteractTriggerKey%, QuickInteract
}
if (AARREnabled == "true") {
    #If WinActive("ahk_exe" Exe)
    Hotkey, $LButton, AARR
}
if (BunnyEnabled == "true") {
    #If WinActive("ahk_exe" Exe)
    Hotkey, $%BunnyKey%, BunnyHop
}
if (CookEnabled == "true") {
    if (CookAdeptusTemptation) {
        #If WinActive("ahk_exe" Exe)
        Hotkey, $%CookAdeptusTemptation%, AdeptusTemptation
    }
}

; Quick Pickup/Skip Conversation
direction = 1
times = 0
QuickInteract:
    Send, %InteractTriggeredKey%
    Sleep, 100f
    While GetKeyState(InteractTriggerKey,"P") {
        if (direction) {
            Send, {WheelDown}
        }
        Else {
            Send, {WheelUp}
        }
        times += 1
        if (times = 2) {
            direction := !direction
            times = 0
        }
        Sleep, 30
        Send, %InteractTriggeredKey%
        Sleep, 30
    }
    Return

; AARR Attack Sequence
in_aarr = 0
AARR:
    Send, {Click Left}
    Sleep, 300
    step = 1
    if (in_aarr) Return
    in_aarr = 1
    While GetKeyState("LButton","P") {
        if (step = 0) {
            Send, {Click Left}
            Sleep, 300
        }
        if (step = 1) {
            Send, {Click Left}
            Sleep, 200
        }
        if (step = 2) {
            Send, r
            Sleep, 100
            Send, r
            Sleep, 200
            step = -1
        }
        step += 1
    }
    in_aarr = 0
    Return

; Bunny Hop
BunnyHop:
    Send, {Click Right}
    Sleep, 50
    Send, {w Down}
    Sleep, 350
    While GetKeyState(BunnyKey, "P") {
        Send, {Space}
        Sleep, 100
    }
    Send, {w Up}
    Return

; Auto Food Cooker
Cook(delay) {
    Click %CookX%, %CookStart%
    Sleep, %delay%
    Click %CookX%, %CookStop%
    if (CookAutoConfirm == "true") {
        Sleep, 2000
        Click %CookX%, %CookStop%
    }
}
AdeptusTemptation:
    Cook(2200)
    Return
