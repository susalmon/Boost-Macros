#SingleInstance
#Requires AutoHotkey v2.0
#^x::ExitApp  ;Script Termination (CtrlWinX)

scriptName := strsplit(A_ScriptName, ".")
fileformat := scriptName.Get(2)

; Paths
publicDesktop := EnvGet("PUBLIC") "\Desktop"
userDesktop   := A_Desktop  ; current user's desktop
userInstall   := userDesktop "\MacroCommListener."  fileformat
sourcePath    := A_ScriptFullPath

;Check if the script is running from Public Desktop
if InStr(A_ScriptDir, publicDesktop) {
    ;Copy to the current user's desktop
    try {
        FileCopy(sourcePath, userInstall, true)  ; overwrite if exists
        MsgBox("Listener copied to your Desktop successfully!", "Info")
    } catch {
        ; Copy failed → fallback: open folder for manual drag & drop
        MsgBox("Automatic copy failed.`nPlease manually copy MacroCommListener." fileformat " into your desktop.", "Manual Action Required")
        Run("explorer.exe " userDesktop)
        ExitApp
    }

    ;Relaunch from the new location
    Run('"' userInstall '"')
    ExitApp
}

mygui := GUI(,"Macro Command Listener")

Prefix := "AccSettings"
folder := EnvGet("PUBLIC") "\AltItemUser"

CombineTextFileArr() {
	global mygui, folder, Prefix, textfileArr
	textfileArr := []
	Loop Files, folder "\" Prefix "*.txt" {
		textfileArr.Push(A_LoopFileName)
		;MsgBox("Added file: " A_LoopFileName)
	}
}

SummonGUIInput() {
    global mygui, fileCombo, textfileArr

    CombineTextFileArr()

    if !IsSet(fileCombo) {
        fileCombo := mygui.AddComboBox("w125", textfileArr)

        mygui.AddText(
            "y10 x145 w150",
            "Press 'F4' to reopen this window.`n`nInfo:`nThis menu allows you to select which file THIS listener will monitor and use.`n`nNote:`nAccSettings1.txt corresponds to Main in the input and should generally not be used for alt accounts as it is more intricate. AccSettings2.txt and onwards correspond to Alt_1, Alt_2 etc"
        )
    } else {
        fileCombo.Delete()       ; clear existing items
        fileCombo.Add(textfileArr)
    }

	btnSetFile := mygui.AddButton("y190 x10 w80 h25", "Set Listener")
	btnSetFile.OnEvent("Click", SetFileButton)

    mygui.Show("w300 h225")
}

flagText := []

AutoAppendAcc := ""
    Loop 7
    {
        AutoAppendAcc .= "0.0`n"
    }

if !FileExist("launched.flag") {
    FileAppend( AutoAppendAcc "launched.flag", "launched.flag")
	filePath := A_ScriptDir "\launched.flag"  ;Default file path to avoid errors before selection
	SummonGUIInput()
	} else {
		loop read "launched.flag" {
			flagText.push(A_LoopReadLine)
		}
		Filepath := flagText.get(8)
	}


F4::SummonGUIInput()


SetFileButton(*) {
	global fileCombo, folder, textfileArr, filePath
	Filepath := folder "\" textfileArr.Get(fileCombo.Value)
	addSettings := FileOpen(A_ScriptDir "\launched.flag", "w")
	addSettings.write(AutoAppendAcc Filepath)
}

;------------------------------------------------------------Listener Functionality------------------------------------------------------------

lastTimer := [0,0,0,0,0,0,0]


global DelayMap, RepeatMap
DelayMap := Map()
RepeatMap := Map()

global boundFuncs := []
Loop lastTimer.Length {
    boundFuncs.Push(Send.Bind(A_Index))
}

T0 := 0

if !FileExist(filePath) {
    MsgBox("Exitcode 2, File not found at: " filePath)
	ExitApp(Exitcode := 2)
}

Loop {		;Check File endlessly
   Timestamp := FileGetTime(filePath, "M")
   if T0 != Timestamp {
      	T0 := Timestamp
		;MsgBox("File was changed")
		ReadFilePath2
        detectfunc()
		sleep 500
   } ;Loop is ending at readfilepath2 under some conditions
}
MsgBox("Exitcode 1, You shouldn't be here.")
ExitApp(Exitcode := 1)

ReadFilePath2() {
	global lastTimer, timers, filePath, DupeDelayArr, DupeKeyArr, DupeRepeatArr, boundFuncs
	timers := []

    DupeRepeatArr := []
    DupeDelayArr := []
    DupeKeyArr := []
		loop read filePath {
			if (A_Index > lasttimer.Length)
        		break
                SplitString := []
                SplitString := Strsplit((A_LoopReadLine), ".")
                if SplitString.get(2) != 0
                    delayVal := SplitString.get(2) + 1000
                else
                    delayVal := 0
                if Splitstring.get(1) = 0 {
                    timerLine := delayVal
                } else {
                    timerLine := 0
                    DupeKeyArr.Push(A_Index)
                    DupeRepeatArr.Push(SplitString.get(1) + 1)
                    DupeDelayArr.Push(delayVal)

                    DelayMap[A_Index] := SplitString.get(2)
                    RepeatMap[A_Index] := SplitString.get(1)
                }
                timers.Push(Number(Trim(timerLine)))
                ;loop DupeKeyArr.length ;Debug
                     ;MsgBox("key: " DupeKeyArr.Get(A_Index) ", delay: " DupeDelayArr.Get(A_Index) ", repeat: " DupeRepeatArr.Get(A_Index) ,"Debug")
        }
        if timers.Length < 1 {
            MsgBox("No valid numeric timers found in file. Use the input application (MacroCommInput." fileformat "). Exiting." ,, "T5")
            ExitApp
        }
        Loop timers.Length {
            currentTimer := timers.get(A_Index)
            if lastTimer.Get(A_Index) != currentTimer {
                if currentTimer = 0
                    SetTimer(boundFuncs[A_Index], 0)  ; disable timer
                else
                    SetTimer(boundFuncs[A_Index], currentTimer)     ; set new interval
                ;msgbox ( "processing A_Index="  A_Index "Item :" currentTimer)
                ;SetTimer(Send.Bind(A_Index), currentTimer)
            }
        }
	lastTimer := timers
}

;WORKING DETECTION FUNCTION
detectFunc() {
    loop DupeKeyArr.Length {
        key := DupeKeyArr.get(A_Index)
        Hotkey(key, actionFunc)
    }
}

actionFunc(ThisHotkey) {
    global RepeatMap, DelayMap

    ;MsgBox("responsive")
    numkey := Number(ThisHotkey)
    key := ThisHotkey

    repeat := RepeatMap[numkey]
    delay  := DelayMap[numkey]
    ;MsgBox(numkey ", " delay ", " repeat)

    Send("{Numpad" numkey "}") ;Initial press
    Loop repeat {
        Sleep(delay)
        Send("{Numpad" numkey "}")
    }
}



/*actionFunc(ThisHotkey) {
    global RepeatMap, DelayMap
    if RepeatMap.has(Number(ThisHotkey)) {
        ;msgbox(DelayMap[Number(ThisHotkey)], "DELAY MAP CHECK")
        loopamount := RepeatMap[Number(ThisHotkey)]
    }
    if loopamount = 0
        return
    Loop loopamount {
        ;MsgBox(ThisHotkey)
        settimer sendFunc.Bind(ThisHotkey), DelayMap[Number(ThisHotkey)]
        loopAmount--
        ;MsgBox("Loops left: " loopAmount ", Key: " ThisHotkey, "Loop Info")
    }
    ;send ThisHotkey
}

sendFunc(key) {
    send(key)
}

;Detect which keys to wait for 
;Map keys to their dupe and delay values
;Wait for keypress
;Send the keystroke at the specified interval
;Repeat for dupe value



;																		Debug
;msgbox (timers.get(1) ", " timers.get(2) ", " timers.get(3) ", " timers.get(4) ", " timers.get(5) ", " timers.get(6) ", " timers.get(7) "," timers.Length ".")