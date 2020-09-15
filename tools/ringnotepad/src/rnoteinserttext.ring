oInsert 	= NULL
templateList 	= NULL

load "templates.ring"

class RNoteInsertText

	func OpenInsertWindow

		oInsert = new QWidget() {
			setwindowtitle("Insert Text")
			resize(400,350)
			setwindowflags(Qt_WindowStaysOnTopHint)


			templateLabel = new QLabel(oInsert) {
				setGeometry(50,30,100,20)
				settext("Insert Text : ")
			}
          
			templateList = new QListWidget(oInsert) {
				setGeometry(150,30,200,200)
				for aCodeTemplate in aCodeTemplates
					addItem(aCodeTemplate[1])
				next	
				templateList.setitemactivatedEvent(Method(:insertText))
			}
 
			BtntnOk = new qpushbutton(oInsert) {
				setgeometry(180,250,50,50)
				setText(T_FROMDESIGNER_WF_OK)
				setClickEvent(Method(:insertText))
			}

			BtnCancel = new qpushbutton(oInsert) {
				setgeometry(250,250,50,50)
				setText(T_FROMDESIGNER_WF_CANCEL)
				setClickEvent(Method(:pCancel))
			}

			oInsertLayout1 = new qVBoxlayout() {
				AddWidget(templateLabel)
				AddWidget(templateList)
			}

			oInsertLayout2 = new qVBoxlayout() {
				AddWidget(BtntnOk)
				AddWidget(BtnCancel)
			}

			LayoutButtonMain = new QHBoxLayout()			
			LayoutButtonMain.AddLayout(oInsertLayout1)
			LayoutButtonMain.AddLayout(oInsertLayout2)

			setLayout(LayoutButtonMain)
			setwindowflags(Qt_CustomizeWindowHint | Qt_WindowTitleHint) 
			show()

		}

       func insertText

		nr = templateList.currentRow()+1
		function = aCodeTemplates[nr][2]
		output = call function()
		cTextContent = textedit1.toplaintext()
		oCursor = textedit1.textcursor()
		nPosStart = oCursor.Position()
		nPosEnd = len(cTextContent) - nPosStart
		cNewContent = substr(cTextContent,1,nPosStart)+ output +
			substr(cTextContent,nPosStart+1,nPosEnd)
		textedit1.setPlaintext(cNewContent)
		oCursor.setposition(nPosStart+len(output),0)
		textedit1.settextcursor(oCursor)

	func pCancel

		oInsert.close()
