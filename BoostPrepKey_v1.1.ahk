#Requires AutoHotkey v2.0
#SingleInstance

DetectHiddenWindows 1

BoostMacroFileName := "BoostMacro2.ahk"
AltMacroFileName := "MacroCommInput.ahk"

BoostMacroDir := (A_ScriptDir "\Submacros\" BoostMacroFileName)
AltMacroDir := (A_ScriptDir "\Submacros\" AltMacroFileName)

;       Debug 
;MsgBox(BoostMacroDir)
;MsgBox(AltMacroDir)

Home::{
     if !WinExist(AltMacroFileName) {
            run(AltMacroDir)
        }

     if !WinExist(BoostMacroFileName) {
            run(BoostMacroDir)
        }
}

End::{
    if WinExist(AltMacroFileName)
         WinClose(AltMacroFileName)
    if WinExist(BoostMacroFileName)
         WinClose(BoostMacroFileName)
}

