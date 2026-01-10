#SingleInstance
#Requires AutoHotkey v2.0
#^x::ExitApp  ;Script Termination (CtrlWinX)

mygui := GUI(,"Macro Command Listener")

Prefix := "AccSettings"
folder := EnvGet("PUBLIC") "\AltItemUser"

CombineTextFileArr() {
	global mygui, folder, Prefix, textfileArr
	textfileArr := []
	Loop Files, folder "\" prefix "*.txt" {
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

if !FileExist("launched.flag") {
    FileAppend("0`n0`n0`n0`n0`n0`n0", "launched.flag")
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
	addSettings.write("0`n0`n0`n0`n0`n0`n0`n" Filepath)
}

;------------------------------------------------------------Listener Functionality------------------------------------------------------------

lastTimer := [0,0,0,0,0,0,0]

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
		sleep 500
   } ;Loop is ending at readfilepath2 under some conditions
}
MsgBox("Exitcode 1, You shouldn't be here.")
ExitApp(Exitcode := 1)

ReadFilePath2() {
	global lastTimer, timers, filePath
	timers := []
		loop read filePath {
			if (A_Index > 7)
        		break
			timers.Push(Number(Trim(A_LoopReadLine)))
		}
	if timers.Length < 1 {
    	MsgBox("No valid numeric timers found in file. Use the input application (MacroCommInput.ahk). Exiting." ,, "T5")
    	ExitApp
		}

	Loop timers.Length {
		ct := timers.get(A_Index)
		if lastTimer.Get(A_Index) != ct {
			if ct = 0
				SetTimer(boundFuncs[A_Index], 0)  ; disable timer
			else
				SetTimer(boundFuncs[A_Index], ct)     ; set new interval
			;msgbox ( "processing A_Index="  A_Index "Item :" ct)
			;SetTimer(Send.Bind(A_Index), ct)
		}
	}
	lastTimer := timers
}

;																		Debug
;msgbox (timers.get(1) ", " timers.get(2) ", " timers.get(3) ", " timers.get(4) ", " timers.get(5) ", " timers.get(6) ", " timers.get(7) "," timers.Length ".")