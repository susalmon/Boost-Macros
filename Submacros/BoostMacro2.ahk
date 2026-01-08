;////////////////////////////////////
;Input Keybinds and delays for the program.
;All delays are in milliseconds.

StingerKeyBind := 4
StingerCD := 1250

CloudVialKeybind := 5
CloudVialCD := 180000

JellyBeansKeybind := 1
JellyBeanCD := 31000

GlitterKeybind := 6
GlitterCD := 906000
;////////////////////////////////////

#Requires AutoHotkey v2.0
#SingleInstance

#^x::ExitApp  ;Script Termination (CtrlWinX)

Toggle := false
;Auto item user: Jelly Beans, cloud vials
k::{
	global Toggle
	Toggle := !Toggle

	if (Toggle) {
		Tooltip "Loop ON"
		JBLoop
		SetTimer CloudLoop, CloudVialCD
		SetTimer JBLoop, JellyBeanCD
	} else {
		ToolTip "Loop OFF"
		SetTimer JBLoop, 0
		SetTimer CloudLoop, 0
		SetTimer () => Tooltip(""), 1000
	}
}
;Jelly Bean user loop
JBLoop() {
	Send JellyBeansKeybind
}
;Cloud Vial user loop
CloudLoop() {
	Send CloudVialKeybind
}

;Auto Stinger, Uses 2 stingers automatically for star saw
~$4:: {
	loop 2 {
		Sleep StingerCD
		Send StingerKeyBind
	}
}

;Auto-Glitter, Automatically uses a glitter immediately of cooldown for boosting.
~$6:: {
	Sleep GlitterCD
	Send GlitterKeybind
}