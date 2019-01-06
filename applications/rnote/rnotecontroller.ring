# The Ring Notepad Application (RNote)
# Author : Mahmoud Fayed <msfclipper@yahoo.com>

class RNoteController from RNoteControllerBase 

	LoadSettings()

	oApp = New qApp 
	# Custom Editor Style Color
		CheckCustomColors()
		PrepareAutoComplete()	
	# Create the Main Window
		CreateMainWindow()
	# Default Settings
		SetMode(nDefaultMode) 
		RestoreSettings()
		win1.showmaximized()
	oApp.exec()
