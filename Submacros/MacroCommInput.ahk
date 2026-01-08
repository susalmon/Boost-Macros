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
		;MsgBox(FileRead(ListenerFileName), ListenerFilePath)
		FileAppend(FileRead(ListenerFileName), ListenerFilePath)
	MsgBox("Text file successfully fixed." ,"Success!", "T2")
}
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
;CloseALL Button
btnClose := mygui.Add("Button", "x201 y265 w93 h30", "CloseALL")
btnClose.OnEvent("Click", CloseClicked)

;Even spacing of Text and Edit lines
StartY := 50
Spacing := 30
num := 7

Loop num {
	k := StartY + (A_Index - 1) * Spacing
	mygui.AddText("x5 y" k, A_Index)
	mygui.AddEdit("x30 y" (k - 4) " r1 vKeybindValue" A_Index " w260") ;
}


UpdateFile() {
	FileObj := FileOpen(textFilePath, "w" )
	for i, v in keydelayarray
		FileObj.WriteLine(v)
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

;This clears the text file,
;This makes listener close because of a lack of information,
;This closes the input menu and exits macro
CloseClicked(*) {
	global mygui, keydelayarray, num, textFilePath

	keydelayarray := []

	UpdateFile()
	
	ExitApp
}