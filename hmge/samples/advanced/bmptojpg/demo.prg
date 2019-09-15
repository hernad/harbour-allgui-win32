/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Copyright 2002-05 Roberto Lopez <harbourminigui@gmail.com>
 * http://harbourminigui.googlepages.com/
 *
 * Copyright 2007-2018 Grigory Filatov <gfilatov@inbox.ru>
*/

#include "minigui.ch"
#include "BosTaurus.ch"

*-----------------------------------------------------------------------------*
Procedure Main
*-----------------------------------------------------------------------------*
Local nQ := 80, nP := 1

   DEFINE WINDOW Form_1 ;
      AT 0,0 ;
      WIDTH 400 ;
      HEIGHT 350 ;
      TITLE 'BMP To JPG sample by Grigory Filatov' ;
      MAIN ;
      NOMAXIMIZE NOSIZE ;
      ON RELEASE FErase( "demo.jpg" )

	DEFINE BUTTON Button_1
		ROW	25
		COL	295
		CAPTION 'Press Me'
		ACTION ( SaveToJPG(), SetProperty( "Form_1", "Image_2", "Picture", "demo.jpg" ) )
		WIDTH 90 
		HEIGHT 26
		DEFAULT .T.
		TOOLTIP 'Save to JPG'
	END BUTTON

	DEFINE BUTTON Button_2
		ROW	55
		COL	295
		CAPTION 'Cancel'
		ACTION ThisWindow.Release
		WIDTH 90 
		HEIGHT 26
		TOOLTIP 'Exit'
	END BUTTON

	DEFINE LABEL Label_1
		ROW	5
		COL	10
		WIDTH	130
		VALUE 'Source:'
		CENTERALIGN .T.
	END LABEL

	@ 25,5 FRAME Frame_1 WIDTH 130 HEIGHT 130 

	DEFINE IMAGE Image_1
		ROW	30
		COL	10
		HEIGHT	120
		WIDTH	120
		PICTURE	'demo.png'
		STRETCH	.T.
	END IMAGE

	DEFINE LABEL Label_2
		ROW	5
		COL	150
		WIDTH	130
		VALUE 'Destination:'
		CENTERALIGN .T.
	END LABEL

	@ 25,150 FRAME Frame_2 WIDTH 130 HEIGHT 130 

	DEFINE IMAGE Image_2
		ROW	30
		COL	155
		HEIGHT	120
		WIDTH	120
		PICTURE	NIL
		STRETCH	.F.
	END IMAGE

	@ 170,5 FRAME Frame_3 CAPTION "JPEG:" WIDTH 380 HEIGHT 140

	DEFINE LABEL Label_3
		ROW	225
		COL	20
		WIDTH	100
		VALUE 'Save quality:'
	END LABEL

	DEFINE LABEL Label_4
		ROW	190
		COL	120
		WIDTH	50
		VALUE 'lowest'
	END LABEL

	DEFINE LABEL Label_5
		ROW	190
		COL	320
		WIDTH	40
		VALUE 'best'
		RIGHTALIGN .T.
	END LABEL

	DEFINE LABEL Label_6
		ROW	190
		COL	240
		WIDTH	40
		VALUE Ltrim(Str(nQ))
	END LABEL

	DEFINE SLIDER Slider_1
		ROW	220
		COL	110
		VALUE	nQ
		WIDTH	260
		HEIGHT	30
		RANGEMIN 0
		RANGEMAX 100
		NOTICKS .T.
		BOTH .T.
		ON SCROLL ( nQ := Form_1.Slider_1.Value, Form_1.Label_6.Value := Ltrim(Str(nQ)) )
		ON CHANGE ( nQ := Form_1.Slider_1.Value, Form_1.Label_6.Value := Ltrim(Str(nQ)), Form_1.Button_1.OnClick )
	END SLIDER

	DEFINE CHECKBOX Check_1
		ROW	270
		COL	20
		CAPTION 'Save as &progressive JPG' 
		WIDTH	160
		VALUE ( nP == 1 )
		ON CHANGE nP := IFEMPTY(Form_1.Check_1.Value, 0, 1)
	END CHECKBOX

   END WINDOW

   Form_1.Height := 155 + GetTitleHeight() + 2 * GetBorderHeight()

   CENTER WINDOW Form_1

   ACTIVATE WINDOW Form_1

Return

*-----------------------------------------------------------------------------*
Function SaveToJPG()
*-----------------------------------------------------------------------------*
Local nResult, cBmp := GetStartupFolder() + "\tmp.bmp", cJpg := GetStartupFolder() + "\demo.jpg"

	Form_1.Image_1.SaveAs( cBmp )				// Create temporary file which reguired for DIjpg.dll

	nResult := BmpToJpg( cBmp, cJpg )			// Save to JPEG

	If nResult # 1						// An error occured
		MsgStop( "Conversion did not succeed!", "Error" )
	EndIf

	FErase( cBmp )						// Remove temporary file

Return nResult

*-----------------------------------------------------------------------------*
Function BmpToJpg( cFileName, cJpg )
*-----------------------------------------------------------------------------*
Local Result, hBitmap := BT_BitmapLoadFile( cFileName )

	Result := BT_BitmapSaveFile( hBitmap, cJpg, BT_FILEFORMAT_JPG )
	BT_BitmapRelease( hBitmap )

Return iif( Result, 1, 0 )
