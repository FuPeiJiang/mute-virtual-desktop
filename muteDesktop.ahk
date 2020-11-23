#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, force
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

VD_init()
^Numpad1:: ;ctrl+Numpad1
^Numpad2:: ;ctrl+Numpad2
^Numpad3:: ;ctrl+Numpad3
whichDesktop:=SubStr(A_ThisHotkey, 0) ;get last character from numpad{N}
muteDesktop(whichDesktop)
return
#Numpad1:: ;win+Numpad1
#Numpad2:: ;win+Numpad2
#Numpad3:: ;win+Numpad3
whichDesktop:=SubStr(A_ThisHotkey, 0) ;get last character from numpad{N}
UnmuteDesktop(whichDesktop)
return

#!m:: ;win+alt+m
currentDesktop:=VD_getCurrentVirtualDesktop()
MuteAllButThisDesktop(currentDesktop)
return
#!u:: ;win+alt+u
UnmuteAll()
return

MuteAllButThisDesktop(desktopNumber)
{
    vd_Count := VD_getCount()
    loop %vd_Count% {
        if (A_Index!=desktopNumber) {
            MuteDesktop(A_Index)
        }
    }
}

UnmuteAll()
{
    vd_Count := VD_getCount()
    loop %vd_Count% {
        UnmuteDesktop(A_Index)
    }
}

MuteDesktop(desktopNumber)
{
    muteOrUnmuteDesktop(desktopNumber, hasVolume:=false)
}

UnmuteDesktop(desktopNumber)
{
    muteOrUnmuteDesktop(desktopNumber, hasVolume:=true)
}

muteOrUnmuteDesktop(desktopNumber, hasVolume:=true)
{
    DetectHiddenWindows, on
    WinGet windows, List
    Loop %windows%
    {
        id := windows%A_Index%
        IfEqual, False, % VD_isValidWindow(id), continue
        desktopOfWindow:=VD_getDesktopOfWindow("ahk_id " id)
        if (desktopOfWindow=desktopNumber)
        {
            DetectHiddenWindows, on
            WinGet, windowProcessName, ProcessName, % "ahk_id " id
            if (windowProcessName) {
                toRun=nircmd.exe setappvolume %windowProcessName% %hasVolume%
                Run, %toRun%

            }
        }
    }
    DetectHiddenWindows, off
}
return

f3::Exitapp