# Boost Macros
A Bee Swarm Simulator macro that will help with boosting using alt accounts by allowing the user to input delays of when to press hotbar keybinds on alt accounts.
Another macro will also include a macro that presses hotbar buttons to maintain as many buffs as possible during boosts.

Recommended to use with gathering macros such as Revolution Macro or Natro Macro.

More macros may be added later.

How to start:
1) Download the project.
2) Run BoostPrepKey_v1.1.ahk.
3) Once it is open press the 'Home' key to open the other macros. Pressing 'End' will close all macros opened by BoostPrepKey_v1.1



BoostMacro2.ahk currently automatically uses glitter after 15 minutes once '6' is pressed to refresh 4x and automatically presses '4' twice after the inital press to get star saw ready. When 'k' is pressed the macro will automatically press '5' every 3 minutes for cloud vials and press '1' every 30 seconds for jelly beans. There is currently no way to quickly change the keybinds or delays. The delays are slightly larger than what is described in this macro to account for any lag or desync between the macro and game.

MacroCommListener.ahk currently is needed to be active on all local accounts that the user wants to use items on. The macro reads the text file in '\Users\Public\AltItemUser\' and interprets the information to automatically press the buttons needed.

MacroCommInput.ahk currently creates a GUI that allows for the user to input certain values which allows for alt accounts to use items in their hotbar at certain delays, similar to the automatic jelly beans and cloud vials of BoostMacro2. The macro writes the information inputted through the GUI onto a text file in the '\Users\Public\AltItemUser\' folder which allows all local accounts to read it. There are 3 buttons in the macro: Submit, Stop and CloseALL. The 'Submit' button submits the information from the GUI into the text file to be interpreted. The 'Stop' button sets all of timer values to 0, this nearly instantly stops the listener from using more items. The CloseALL button erases all information on the text file which closes all of the instances of MacroCommListener.ahk and MacroCommInput.ahk. All the delay values are currently in milliseconds. The delays should be slightly larger than what you want to account for any lag or desync between the macro and game, usually about 1 second or 1000 ms extra.



Created by susalmon,
Official download is exclusively on GitHub.