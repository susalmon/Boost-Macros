#Requires AutoHotkey v2.0
#SingleInstance
Persistent
global mygui

										;Definitions
			;Name of the text file, where the folder is located and where the child file is located.
TextFileName := "altacc1"
folderPath := EnvGet("PUBLIC") . "\AltItemUser"
textFilePath := (folderPath "\" TextFileName ".txt")

			;Name of the listener file path and where it is located
ListenerFileName := "MacroCommListener.ahk"
ListenerFilePath := (folderPath "\" ListenerFileName)

DefaultFilePath := A_ScriptDir "\defaultSettings\default.txt"


tabNames := ["Main", "Alt_1", "Alt_2", "Alt_3"]
lengthVal := tabNames.Length

;File and Folder Creation
	;Error message if file does not exist, automatically creates missing components

Loop lengthVal {
	DirCreate(folderPath)
    filePath := folderPath "\AccSettings" A_Index ".txt"
    if !FileExist(filePath) {
		FileAppend("", filePath)
		MsgBox("Missing file created at `n" filePath ".", "Info", "T1")
    }
}
;MsgBox("Successfully checked and created missing files and/or folders.", "Info", "T1")

if !FileExist(ListenerFilePath){
	MsgBox("Listener file not found at " ListenerFilePath ". Creating missing component...", "Error", "T3.5")
		FileAppend(FileRead(ListenerFileName), ListenerFilePath)
	MsgBox("Listener file added." ,"Success!", "T2")
}
Loop lengthVal {			;Creates missing default files if they do not exist.
    filePath := A_ScriptDir "\defaultSettings" A_Index ".txt"
    if !FileExist(filePath) {
		FileAppend("`n`n`n`n`n`n`n", filePath)
		MsgBox("Missing file created at `n" filePath ".", "Info", "T1")
    }
}
;MsgBox("Successfully checked and created missing default files.", "Info", "T1")

;Link Tabs and Text files
	;Create arrays of files for every tab
defaultArr := []
settingsArr := []

Loop lengthVal {
	defaultArr.Push(A_ScriptDir "\defaultSettings" A_Index ".txt") ;Creates array of default file names
	settingsArr.Push(folderPath "\AccSettings" A_Index ".txt") ;Creates array of settings file names
}

tabSettingsMap := Map()
tabDefaultMap := Map()

Loop lengthVal {
    tabSettingsMap.Set(tabNames.Get(A_Index), settingsArr.Get(A_Index)) ;Maps tab names to their respective settings file names
    tabDefaultMap.Set(tabNames.Get(A_Index), defaultArr.Get(A_Index)) ;Maps tab names to their respective default file names
}

/*Loop 3 {       ;DEBUGGING PURPOSES
	testLabels := tabNames.Get(A_Index)
	MsgBox( testLabels " maps to " tabSettingsMap.Get(testLabels) ".", "Default Settings" A_Index ".txt")
	MsgBox( testLabels " maps to " tabDefaultMap.Get(testLabels) ".", "AccSettings" A_Index ".txt")
}*/


;UI STARTS HERE
mygui := GUI(,"BSS Alt Item User") ; Create GUI window

;Creates Tabs
tab := mygui.AddTab3("x0 y0 w299 h260", tabNames)

;Variables for UI layout
StartY := 50
Spacing := 30
num := 7

TabUI(TabIndex, suffix) {			;Function to create the tab UI
    global mygui, DefaultFilePath, tab, StartY, Spacing, num 

    tab.UseTab(TabIndex) ;Switch to the specified tab

    ; Read default.txt into an array
    defaultValue := []
    	loop read defaultArr[TabIndex] {
       		line := Trim(A_LoopReadLine)
       		if (line = "")
           		 defaultValue.Push("")   ;only numerates if not empty to not give errors and to allow blank defaults
      		else
         		defaultValue.Push(Number(line))
    }

    ; Create the UI for this tab
    Loop num {
        k := StartY + (A_Index - 1) * Spacing
        mygui.AddText("x5 y" k, A_Index)
        vName := ("Keybindvalue" A_Index "_" suffix)
        mygui.AddEdit("Number x30 y" (k - 4) " w260 v" vName, defaultValue[A_Index]) ;"defaultValue[A_Index]" sets default value from file
    }
}

Loop tabNames.Length {			;Create each tab's UI, the amount changes with how many tab names are in the array
		TabUI(A_Index, tabNames.Get(A_Index))
}
	tab.UseTab()  ; Stop assigning controls to tabs

;Submit Button
btnSubmit := mygui.Add("Button", "x5 y265 w93 h30", "Submit")
btnSubmit.OnEvent("Click", SubmitClicked)
;Stop Button
btnStop := mygui.Add("Button", "x103 y265 w93 h30", "Stop")
btnStop.OnEvent("Click", StopClicked)
;SetDefault Button
btnSetDefault := mygui.Add("Button", "x201 y265 w93 h30", "Set Default")
btnSetDefault.OnEvent("Click", SetDefaultClicked)


;Renders GUI
mygui.show("w299 h300")

										;FUNCTIONS
;fileUpdaterFunction(suffix)

;folderPath "\AccSettings" A_Index ".txt"

UpdateFiles() {
	global keydelayarray, tabSettingsMap, tabNames
	FileObj := FileOpen(tabSettingsMap.Get(tabNames.Get(A_Index)), "w" )
	for i, v in keydelayarray
		FileObj.WriteLine(v)
	FileObj.Close()
}

UpdateDefaults() {
	global keydelayarray, tabDefaultMap, tabNames
	FileObj := FileOpen(tabDefaultMap.Get(tabNames.Get(A_Index)), "w" )
	for i, v in keydelayarray
		FileObj.WriteLine(v)
	FileObj.Close()
	;MsgBox(tabDefaultMap.Get(tabNames.Get(A_Index)))			;Debug, Filepath announcer
}



						;BUTTON FUNCTIONS
;Saves inputted values to their respective files when Submit is pressed
SubmitClicked(*) {
	global mygui, keydelayarray, num
	loop lengthVal {
		suffix := tabNames.Get(A_Index)
		guidata := mygui.Submit()
		keydelayarray := []
		Loop num {
			varName := "Keybindvalue" A_Index "_" suffix
			value := Trim(guidata.%varName%)
			if value == ""
				value := "0"
			keydelayarray.Push(value)
		}																					;Debug
		;MsgBox(keydelayarray.Get(1) ", " keydelayarray.Get(2) ", " keydelayarray.Get(3) ", " keydelayarray.Get(4) ", " keydelayarray.Get(5) ", " keydelayarray.Get(6) ", " keydelayarray.Get(7) ".","Debug")
		UpdateFiles()
	}
}

;Sets all lines to 0 when Stop is pressed
StopClicked(*) {
	global mygui, keydelayarray, num
	loop lengthVal {
		suffix := tabNames.Get(A_Index)
		keydelayarray := []
		value := "0"
		Loop num {
			keydelayarray.Push(value)
		}
		UpdateFiles()
	}
}

;Saves the current values to default
SetDefaultClicked(*) {
	global mygui, keydelayarray, num
	loop lengthVal {
		suffix := tabNames.Get(A_Index)
		guidata := mygui.Submit()
		keydelayarray := []
		Loop num {
			varName := "Keybindvalue" A_Index "_" suffix
			value := Trim(guidata.%varName%)
			keydelayarray.Push(value)
		}																					;Debug
		;MsgBox(keydelayarray.Get(1) ", " keydelayarray.Get(2) ", " keydelayarray.Get(3) ", " keydelayarray.Get(4) ", " keydelayarray.Get(5) ", " keydelayarray.Get(6) ", " keydelayarray.Get(7) ".","Debug")
		UpdateDefaults()
	}
}