#SingleInstance
#Requires AutoHotkey v2.0
#^x::ExitApp  ;Script Termination (CtrlWinX)

filePath := EnvGet("PUBLIC") "\AltItemUser\altacc1.txt"

lastTimer := [0,0,0,0,0,0,0]

global boundFuncs := []
Loop 7 {
    boundFuncs.Push(Send.Bind(A_Index))
}

T0 := 0

if not FileExist(filePath) {
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