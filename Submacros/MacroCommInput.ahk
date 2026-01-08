#Requires AutoHotkey v2.0
#SingleInstance
Persistent

global mygui

;Name of the text file, where the folder is located and where the child file is located.
TextFileName := "altacc1"
folderPath := EnvGet("PUBLIC") . "\AltItemUser"
textFilePath := (folderPath "\" TextFileName ".txt")

;Name of the listener file path and where it is located
ListenerFileName := "MacroCommListener.ahk"
ListenerFilePath := (folderPath "\" ListenerFileName)

DefaultFilePath := A_ScriptDir "\defaults.txt"

;MsgBox(textFilePath)


;Error message if file does not exist, automatically creates missing components
if not FileExist(textFilePath) {
    MsgBox("Text file not found at " textFilePath " or folder does not exist. Creating missing components...", "Error", "T5")
		DirCreate(folderPath)
		FileAppend("", textFilePath)
	MsgBox("Text file successfully fixed." ,"Success!", "T2")
}
if !FileExist(ListenerFilePath){
	MsgBox("Listener file not found at " ListenerFilePath ". Creating missing component...", "Error", "T4")
		FileAppend(FileRead(ListenerFileName), ListenerFilePath)
	MsgBox("Listener file added." ,"Success!", "T2")
}


FileAppend("", DefaultFilePath) ;Creates a file that contains the default delays if it does not exist


;gui base
mygui := GUI(,"BSS Alt Item User")
mygui.show("w299 h300")

;mygui.AddTab()

;Submit Button
btnSubmit := mygui.Add("Button", "x5 y265 w93 h30", "Submit")
btnSubmit.OnEvent("Click", SubmitClicked)
;Stop Button
btnStop := mygui.Add("Button", "x103 y265 w93 h30", "Stop")
btnStop.OnEvent("Click", StopClicked)
;SetDefault Button
btnSetDefault := mygui.Add("Button", "x201 y265 w93 h30", "Set Default")
btnSetDefault.OnEvent("Click", SetDefaultClicked)

;Converts the default.txt file into an array to be used in the GUI edit boxes.

	defaultValue := []
loop read DefaultFilePath {
    line := Trim(A_LoopReadLine)

    if (line = "")
        defaultValue.Push("")   ; keep index alignment
    else
        defaultValue.Push(Number(line))
}

;Even spacing of Text and Edit lines
StartY := 50
Spacing := 30
num := 7

Loop num {
	k := StartY + (A_Index - 1) * Spacing
	mygui.AddText("x5 y" k, A_Index)
	mygui.AddEdit("x30 y" (k - 4) " r1 vKeybindValue" A_Index " w260", defaultValue[A_Index]) ;
}


UpdateFile() {
	global keydelayarray, textFilePath
	FileObj := FileOpen(textFilePath, "w" )
	for i, v in keydelayarray
		FileObj.WriteLine(v)
	FileObj.Close()
}
;Updates the text file when submit is pressed
SubmitClicked(*) { 
	global mygui, keydelayarray, num, textFilePath
	guiData := mygui.Submit("NoHide")

	keydelayarray := []

	Loop num {
		varName := "Keybindvalue" A_Index
		value := Trim(guiData.%varName%)
		if value == ""
			value := "0"
		keydelayarray.Push(value)
	}

	UpdateFile()
}

;Sets all lines to 0 when Stop is pressed
StopClicked(*) {
	global mygui, keydelayarray, num, textFilePath

	keydelayarray := []
	Loop num 
		keydelayarray.Push(0)

	UpdateFile()

}

;Saves the current values to default
SetDefaultClicked(*) {
	global mygui, keydelayarray, num, DefaultFilePath

	guiData := mygui.Submit()

	keydelayarray := []

	Loop num {
		varName := "Keybindvalue" A_Index
		value := Trim(guiData.%varName%)
		keydelayarray.Push(value)
	}
	FileObj := FileOpen(DefaultFilePath, "w" )
for i, v in keydelayarray
	FileObj.WriteLine(v)
}