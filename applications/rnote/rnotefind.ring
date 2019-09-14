# The Ring Notepad Application (RNote)
# Author : Mahmoud Fayed <msfclipper@yahoo.com>
# FindPrevValue() Added by Gal Zsolt 

class RNoteFind

	func OpenFindWindow
		if isobject(oSearch)
			oSearch.activatewindow()
			return
		ok
		oSearch = new qWidget()
		{
			oLblFindWhat = new qLabel(this.oSearch)
			{
				setText("Find What : ")
			}
			this.oSearchValue = new qlineedit(this.oSearch)
			{
				setText(this.cSearchText)
				setReturnPressedEvent(Method(:FindValue))
			}
			oLayout1 = new qHBoxLayout()
			{
				addWidget(oLblFindWhat)
				addWidget(this.oSearchValue)
			}
			oLblReplaceWith = new qLabel(this.oSearch)
			{
				setText("Replace with ")
			}
			this.oReplaceValue = new qlineedit(this.oSearch)
			{
				setText(this.cReplaceText)
			}

			oLayout2 = new qHBoxLayout()
			{
				addWidget(oLblReplaceWith)
				addWidget(this.oReplaceValue)
			}
			this.oSearchCase = new qCheckbox(this.oSearch)
			{
				setText("Case Sensitive")
			}
			oLayout3 = new qHBoxLayout()
			{
				addWidget(this.oSearchCase)
			}
			oBtnFind = new qPushButton(this.oSearch)
			{
				setText("Find/Find Next")
				setclickEvent(Method(:FindValue))
			}
			oBtnFindPrev = new qPushButton(this.oSearch)
			{
				setText("Find/Find Prev")
				setclickEvent(Method(:FindPrevValue))
			}
			oBtnReplace = new qPushButton(this.oSearch)
			{
				setText("Replace")
				setclickEvent(Method(:Replace))
			}
			oBtnReplaceAll = new qPushButton(this.oSearch)
			{
				setText("Replace All")
				setclickEvent(Method(:ReplaceAll))
			}
			oBtnClose = new qPushButton(this.oSearch)
			{
				setText("Close")
				setclickEvent(Method(:SearchClose))
			}
			oLayout4 = new qHBoxLayout()
			{
				addWidget(oBtnFind)
				addWidget(oBtnFindPrev)
				addWidget(oBtnReplace)
				addWidget(oBtnReplaceAll)
				addWidget(oBtnClose)
			}
			oLayout5 = new qVBoxLayout()
			{
				AddLayout(oLayout1)
				AddLayout(oLayout2)
				AddLayout(oLayout3)
				AddLayout(oLayout4)
			}
			setLayout(oLayout5)
			setwinicon(this.oSearch,"image/notepad.png")
			setWindowTitle("Find/Replace")
			setFixedsize(550,160)
			setwindowflags(Qt_CustomizeWindowHint | Qt_WindowTitleHint) 
			this.oSearchFilter = new qallevents(this.oSearch)
			this.oSearchFilter.setKeyPressEvent(Method(:SearchKeyPress))
			installeventfilter(this.oSearchFilter)
			show()
		}

	func Replace
		oCursor = textedit1.textCursor()
		if oCursor.HasSelection() = false
			new qMessagebox(oSearch)
			{
				SetWindowTitle("Replace")
				SetText("No Selection")
				show()
			}
			return false
		ok
		cValue = oSearchValue.text()
		if len(cValue) < 1 return ok
		cSelected = oCursor.SelectedText()
		if oSearchCase.checkState() = Qt_Unchecked
			cValue = lower(cValue)
			cSelected = lower(cSelected)
		ok
		if cSelected != cValue
			new qMessagebox(oSearch)
			{
				SetWindowTitle("Replace")
				SetText("No Match")
				show()
			}
			return false
		ok
		cValue = oReplaceValue.text()
		nStart = oCursor.SelectionStart()
		nEnd = oCursor.SelectionEnd()
		cStr = textedit1.toPlainText()
		cStr = left(cStr,nStart)+cValue+substr(cStr,nEnd+1)
		setTextAllowUndo(cStr)
		oCursor.setposition(nEnd+1,1)
		textedit1.settextcursor(oCursor)
		return FindValue()

	func ReplaceAll
		cStr = textedit1.toPlainText()
		cOldValue = oSearchValue.text()
		cNewValue = oReplaceValue.text()
		cnt = count(cStr,cOldValue)
		if len(cStr) < 1 or len(cOldValue) < 1 return ok
		if oSearchCase.checkState() = Qt_Unchecked
			# Not Case Sensitive
			cStr = SubStr(cStr,cOldValue,cNewValue,true)
		else
			# Case Sensitive
			cStr = SubStr(cStr,cOldValue,cNewValue)
		ok
		if cStr != textedit1.toPlainText()
			cMsg = "Operation Done"
			cMsg = cMsg + " - Replaced : " + cnt
		else 
			cMsg = "Nothing to replace!"
		ok
		setTextAllowUndo(cStr)
		new qMessagebox(oSearch)
		{
			SetWindowTitle("Replace All")
			SetText(cMsg)
			show()
		}

	func SearchClose
		oSearch.close()
		oSearch = NULL
		cSearchText = oSearchValue.text()
		cReplaceText = oReplaceValue.text()


	func SearchKeyPress
		if oSearchFilter.getKeyCode() = Qt_Key_Escape
			SearchClose()
		ok

	func FindValue
		oCursor = textedit1.textcursor()
		nPosStart = oCursor.Position() + 1
		cValue = oSearchValue.text()
		cStr = textedit1.toplaintext()
		if len(cStr) < 1 or len(cValue) < 1 return ok
		cStr = substr(cStr,nPosStart)
		if oSearchCase.checkState() = Qt_Unchecked
			cStr = lower(cStr)  cValue = lower(cValue)
		ok
		nPos = substr(cStr,cValue)
		if nPos > 0
			nPos += nPosStart - 2
			oCursor = textedit1.textcursor()
			oCursor.setposition(nPos,0)
			textedit1.settextcursor(oCursor)
			oCursor = textedit1.textcursor()
			oCursor.setposition(nPos+len(cValue),1)
			textedit1.settextcursor(oCursor)
			return true
		else
			new qMessagebox(oSearch)
			{
				SetWindowTitle("Search")
				SetText("Cannot find : " + cValue)
				show()
			}
			return false
		ok

	func FindPrevValue
		oCursor = textedit1.textcursor()
		nPosStart = oCursor.Position()
		cValue = oSearchValue.text()
		cStr = textedit1.toplaintext()
		if len(cStr) < 1 or len(cValue) < 1 return ok  
		if nPosStart < 1 nPosStart = len(cStr) ok
		cStr = substr(cStr,1,nPosStart-1)
		if oSearchCase.checkState() = Qt_Unchecked
			cStr = lower(cStr)  cValue = lower(cValue)
		ok
                cnt = count(cStr,cValue)
                postemp = 0
		nPos = 0
                for n = 1 to cnt
                      nPos = substring(cStr,cValue,postemp+1)
                      postemp = nPos
                next
		if nPos > 0
                        nPos--
			oCursor = textedit1.textcursor()
			oCursor.setposition(nPos,0)
			textedit1.settextcursor(oCursor)
			oCursor = textedit1.textcursor()
			oCursor.setposition(nPos+len(cValue),1)
			textedit1.settextcursor(oCursor)
			return true
		else
			new qMessagebox(oSearch)
			{
				SetWindowTitle("Search")
				SetText("Cannot find : " + cValue)
				show()
			}
			return false
		ok

        func count(cString,dString)
		sum = 0
		while substr(cString,dString) > 0
			sum++
			cString = substr(cString,substr(cString,dString)+len(dString))
		end
		return sum

	func setTextAllowUndo cText 
		# Get the Text Size 
			nTextSize = len(textedit1.toplaintext())
		# Select All of the Text 
			oCursor = textedit1.textcursor()
			# Save the current position 
				nPosStart = oCursor.Position()
			oCursor.setposition(0,0)
			textedit1.settextcursor(oCursor)
			oCursor = textedit1.textcursor()
			oCursor.setposition(nTextSize,1)
			textedit1.settextcursor(oCursor)
		# Set the new text using InsertPlainText() that support the Undo process 
			textedit1.InsertPlainText(cText)
		# Restore the Cursor Position 
			oCursor = textedit1.textcursor()
			oCursor.setposition(nPosStart,1)
			textedit1.settextcursor(oCursor)
