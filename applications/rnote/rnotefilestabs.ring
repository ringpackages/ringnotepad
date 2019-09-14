# The Ring Notepad Application (RNote)
# Author : Mahmoud Fayed <msfclipper@yahoo.com>

class RNoteFilesTabs

	func SetFileTab cFile 
		filestabs.blocksignals(True)
		if len(aFilesLines) = 1
			filestabs.setTabText(0,JustFileName(cFile))
		else 
			if filestabs.count() != len(aFilesLines)
				filestabs.addtab(new qWidget(),JustFileName(cFile))
				filestabs { setcurrentindex( count() - 1 ) }
			else 
				nPos = find(aFilesLines,cFile,1)
				filestabs.setcurrentindex(nPos-1)
			ok
		ok
		filestabs.blocksignals(False)

	func ChangeFileTab
		CheckSaveBeforeChange()	# To ask to saving a file
		nIndex = filestabs.currentindex() + 1
		cFile = aFilesLines[nIndex][1]
		nRow = aFilesLines[nIndex][2]		
		if cFile != NULL
			if not fexists(FileNameEncoding(cFile))
				CloseFileTabByIndex(filestabs.currentindex())
				return 
			ok
		ok
		cActiveFileName = cFile 
		openFile(cFile)
		GotoLine(nRow)		
		displayFunctionsList()
		displayClassesList()
		lAsktoSave = False
		cTextHash  = sha256(textedit1.toplaintext())

	func CloseFileTab
		filestabs.blocksignals(True)
		nIndex = filestabs.geteventparameters()[1]
		CloseFileTabByIndex(nIndex)
		filestabs.blocksignals(False)

	func CloseFileTabByIndex nIndex
		filestabs.blocksignals(True)
		if filestabs.count() != 1
			filestabs.removetab(nIndex)
			del(aFilesLines,nIndex+1)
			if nIndex > 0
				filestabs.setcurrentindex(nIndex-1)
			else 
				filestabs.setcurrentindex(nIndex)
			ok
			ChangeFileTab()
		else 
			cActiveFileName  = ""
			this.aFilesLines = []
			lAskToSave 	 = false
			cTextHash	 = sha256("")
			filestabs.setTabText(0,"noname")
			textedit1.blocksignals(True)
			textedit1.setPlaintext("")
			textedit1.blocksignals(False)
		ok
		filestabs.blocksignals(False)

	func TabsContextMenu
 		new qMenu(win1) {
	                oAction = new qAction(this.win1) {
	                        settext("Close Other Files")
	                        SetCLickevent(Method(:TabsCMCloseOtherFiles))
				if this.filestabs.count() = 1
					setenabled(False)
				ok
	                }
	                addaction(oAction)
			addseparator()
	                oAction = new qAction(this.win1) {
	                        settext("Close Active File")
	                        SetCLickevent(Method(:TabsCMCloseActiveFile))
				if len(this.aFilesLines) = 0
					setenabled(False)
				ok
	                }
	                addaction(oAction)
			addseparator()
	                oAction = new qAction(this.win1) {
	                        settext("Close All")
	                        SetCLickevent(Method(:TabsCMCloseAll))
				if len(this.aFilesLines) <= 1
					setenabled(False)
				ok
	                }
	                addaction(oAction)
	                oCursor  = new qCursor()
	                exec(oCursor.pos())
        	}

	func TabsCMCloseActiveFile
		CloseFileTabByIndex(filestabs.currentindex())

	func TabsCMCloseOtherFiles
		if cActiveFileName = NULL return ok
		nIndex = filestabs.currentindex()
		# Close Tabs before this one 
			if nIndex > 0
				for x = 0 to nIndex-1
					CloseFileTabByIndex(0)
				next 
			ok
		# Close Tabs after this one 
			nMax = filestabs.count() 
			if nMax > 1
				for x=1 to nMax-1
					CloseFileTabByIndex(1)
				next 			
			ok

	func TabsCMCloseAll
		for nIndex = filestabs.count() to 1 step -1
			TabsCMCloseActiveFile()
		next
