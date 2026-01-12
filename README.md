# Boost Macros

A macro that allows you to start using items on alt accounts. Instant stop when the boost is done, personalized defaults per account and millisecond-accurate delays that accurately use items on your main and alts without tab switching and reconfigureing, allowing boosting to be a simple 1 click process.
This macro was designed to be used with other existing macros such as Revoltion macro to take advantage of its AI gather to be more efficient, while handling automatic item usage seperately.

## Interface Overview

![Annotated macro interface](images/macro_overview.png)


How to install the macro:

0. Download AHK only if you're using the .ahk version.

1. Download the file and extract the zip.
2. Launch 'MacroCommInput'
3. Once the macro has been started, it will start creating the necessary files for it to work.
4. Once the messages have all disappeared, there will be a text box with info, close the text box after it has been read.

 	i. The macro will now attempt to copy files to all desktops however there is a chance of failure.

 	ii. In the event of this part of the setup failing, it will open file explorer and the user has to copy 'MacroCommListener' into 'Public Desktop'

5. Once this is done, open a accounts that are connected via RDP that you want set up, such as FuzzyAltAccount.
6. Launch the macro called 'MacroCommListener.ahk' that is found on that accounts desktop, FuzzyAltAccount in this example.
7. Select which file it should read from.
8. Setup complete! Now you can launch 'MacroCommListener' before a boost or even set it to launch on start (exclusive to the .exe version), more detailed information below.


MacroCommInput.ahk currently is the program that sets up these macros and creates a GUI that allows for the user to input certain values which allows for main or alt accounts to use items in their hotbar at certain delays.

MacroCommListener.ahk currently is needed to be active on all local accounts that the user wants to use items on, both main and alt accounts.

## Details for nerds.

'MacroCommInput' macro writes the information inputted through the GUI onto a text file in the '\\Users\\Public\\AltItemUser' folder which allows all local accounts to read it. There are 3 buttons in the macro: Submit, Stop and Set Default.
The 'Submit' button submits the information from the GUI into the text file to be interpreted. The 'Stop' button sets all of timer values to 0, this nearly instantly stops the listener from using more items. The Set Default button uses the inputted values of the inputs and writes them to a text file. Upon launch, the text file is read and the default values are already inputted into the GUI.
The GUI now includes multiple tabs that write to their own text file. This allows for better control over what account should perform with what delays.

The macro reads the text file in '\\Users\\Public\\AltItemUser' and interprets the information to automatically press the buttons needed.When setting up, MacroCommListener is copied to \\Public\\Public Desktop meaning it will appear on all local desktops, when launched from the local desktop it creates a copy to the active desktop and is used from then on.

BoostMacro2.ahk has been replaced by 'MacroCommInput'.

All the delay values are in milliseconds.
The delays automatically become slightly larger than the inputted values to account for any lag/desync between the game and the macro.

Not tested on other OS other than Win 11

Created by susalmon,
Official download is exclusively on GitHub.

