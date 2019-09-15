/*
 * MINIGUI - Harbour Win32 GUI library Demo
*/

#define _HMG_OUTLOG

#include "minigui.ch"
#include "i_winuser.ch"

*-----------------------------
Function MAIN( FontSize, ScaleWidth, ScaleHeight, FontName )
*-----------------------------
   LOCAL a, nScaleWidth, nScaleHeight, cFontName, nFontSize
   LOCAL cBrwFont, nBrwFont, nStbSize
   LOCAL Width_Keybrd

   If Empty(FontSize)              // Default

      FontSize    := Nil
      ScaleWidth  := Nil
      ScaleHeight := Nil
      FontName    := Nil

   ElseIf ! Empty(FontSize) .and. ',' $ FontSize

      a := hb_ATokens(FontSize, ','); ASize(a, 4)
     
      AEval(a, {|cv,nn| a[nn] := iif( empty(cv), '', alltrim(cv) ) })

      FontSize    := a[1]
      ScaleWidth  := a[2]
      ScaleHeight := a[3]
      FontName    := iif( empty(a[4]), Nil, a[4] )

   EndIf

   FontName    := hb_defaultvalue(FontName   , 'MS Sans Serif')
   FontSize    := hb_defaultvalue(FontSize   ,  '10')
   ScaleWidth  := hb_defaultvalue(ScaleWidth , '100')
   ScaleHeight := hb_defaultvalue(ScaleHeight, '100')

   cFontName    := FontName
   nFontSize    := val(FontSize   )
   nScaleWidth  := val(ScaleWidth )
   nScaleHeight := val(ScaleHeight)
   nBrwFont     := nFontSize - 1
   cBrwFont     := cFontName
   nStbSize     := nFontSize
   Width_Keybrd := 90

   If nFontSize > 12
      nStbSize := 12
   ElseIf nFontSize == 12
      nStbSize -= 1
   Else
      Width_Keybrd := NIL
      nStbSize     := NIL
   EndIf

   SET CENTURY ON
   SET DATE ANSI
   SET ShowDetailError ON
   SET DELETED ON
   SET BROWSESYNC ON
   SET CENTERWINDOW RELATIVE PARENT

//   SET OOP ON

   App.Object := { nScaleWidth, nScaleHeight }
   
   DEFINE FONT font_0  FONTNAME cFontName SIZE nFontSize DEFAULT
   DEFINE FONT font_1  FONTNAME cBrwFont  SIZE nBrwFont
   DEFINE FONT DlgFont FONTNAME "Tahoma"  SIZE nFontSize
   
   OPEN_TABLE()
   
   WITH OBJECT App.Object
   
   :O:BColorGet    := {{255,255,255},{255,255,200},{200,255,255}}
   :O:FColorGet    := {{  0,  0,  0},{255,255,200},{0  ,0  ,255}}
   :O:BClrGetFocus := :O:BColorGet[3]           // {200,255,255}
   :O:FClrGetFocus := :O:FColorGet[3]           // BLUE         
   :O:FColor1      := BLACK
   :O:FColor2      := RED

   SET GETBOX FOCUS BACKCOLOR TO :O:BClrGetFocus
   SET GETBOX FOCUS FONTCOLOR TO :O:FClrGetFocus
      
   :Event( 1, {|| HMG_Alert("MessageBox Info", , "Information", ICON_INFORMATION) } )
   :Event( 2, {|oa,ky,np,cp| ShellExecute( , 'open', App.ExeName, cp, , np ), ;
                             ReleaseAllWindows() } )
   :Event( 3, {|oa,ky,np| TONE( np ) } )
   :Event( 8, {|oa,ky,ni,ap| MsgBox(ap[1] + ' = ' + cValToChar(ap[2]) + CRLF + ;
                             'ControlIndex = ' + cValToChar(ni) + CRLF + ;
                             'FormName = ' + ap[3], 'DisplayValue' ) } )
   :Event( 9, {|oa,ky,ni,ap| MsgBox(ap[1] + ' = ' + cValToChar(ap[2]) + CRLF + ;
                             'ControlIndex = ' + cValToChar(ni) + CRLF + ;
                             'FormName = ' + ap[3], 'VALUE' ) } )
   :Event(10, {|oa,ky,ni,ap| iif( ni == 0, _DisableControl(ap[1], ap[2]),    ;
                                           _EnableControl (ap[1], ap[2]) ) } )

   :Event( 7, {|oa,ky,np,xp| _LogFile(.T., oa, ky, np, xp, oa:ClassName) } )

   END WITH

   DEFINE WINDOW Form_1 AT 0,0 WIDTH 600 HEIGHT 500 ;
      TITLE 'HMG GetBox Demo.' ;
      MAIN ;
      ON INIT ( _Restore( This.Handle ), DoEvents() ) ;
      ON INTERACTIVECLOSE iif( This.Button_3.Enabled, ;
              ( ButtonPress('Button_3', 'Browse_1'), .F. ), .T. )
      
      Main_Menu()

      WITH OBJECT App.Object
//------------------------------------------ for SET OOP ON
//    WITH OBJECT This.Object
//    :O:BColorGet   := :AO:BColorGet   // (App.Object):O:BColorGet
//    :O:FColorGet   := :AO:FColorGet   // (App.Object):O:FColorGet
//    :O:FColor1     := :AO:FColor1     // (App.Object):O:FColor1
//    :O:FColor2     := :AO:FColor2     // (App.Object):O:FColor2
//------------------------------------------ 
      
      :O:nDefLen     := :W(1.5)    // default width
      :O:nBrwLen     := :W(3.8)
      :O:nBrwSayLen  := :W(0.6)
      :O:nBoolLen    := :W(0.3)    // width logic. getbox browse

      DEFINE STATUSBAR  SIZE nStbSize
          STATUSITEM ""
          STATUSITEM "" WIDTH :W(.6)
          KEYBOARD      WIDTH  Width_Keybrd
      END STATUSBAR

      :GetGaps({ , , , })

      :T += :GapsHeight
      :L += :GapsWidth

      :O:nTop2  := :T
      :O:nLeft2 := :L + :O:nDefLen + :GapsWidth * 3
      
      DEFINE GETBOX Text_1 // Alternate Syntax
        ROW  ( :Y := :T )
        COL  ( :X := :L )
        WIDTH  :W(1.5)
        HEIGHT :H1
        VALUE DATE()
        PICTURE '@K'
        TOOLTIP "Date Value: Must be greater or equal to "+DTOC(DATE())
        VALID {|| Compare(this.value)}
        VALIDMESSAGE "Must be greater or equal to "+DTOC(DATE())
        MESSAGE "Date Value"
        ON INIT {|og| :Y += This.Height + :GapsHeight,  ;
                                          This.Alignment := 'CENTER', ;
                                          Set_KeyEvent(og) }
      END GETBOX //OBJECT oGet

      @ :Y, :X GETBOX Text_2 ;
               WIDTH  :O:nDefLen ;
               HEIGHT :H1 ;
               VALUE 57639 ;
               ACTION MsgInfo( "Button Action");
               TOOLTIP {"Numeric input. RANGE -100,200000 PICTURE @Z 99,999.99","Button ToolTip"};
               BUTTONWIDTH :H1 ;
               PICTURE '@Z 99,999.99';
               RANGE -100,200000;
               BOLD;
               MESSAGE "Numeric input";
               VALIDMESSAGE "Value between -100 and 200000 "  ;
               ON INIT {|og| :Y += This.Height + :GapsHeight, ;
                                   Set_KeyEvent(og) }

      @ :Y, :X GETBOX Text_3 WIDTH :O:nDefLen HEIGHT :H1 ; 
               VALUE "Jacek";
               ACTION MsgInfo( "Button Action");
               ACTION2 MsgInfo( "Button2 Action");
               IMAGE {"folder.bmp","info.bmp"};
               BUTTONWIDTH :H1;
               PICTURE "@K !xxxxxxxxxxx";
               TOOLTIP {"Character Input. VALID {|| ( len(alltrim(This.Value)) >= 2)} PICTURE @K !xxxxxxxxxxx ","Button ToolTip","Button 2 ToolTip"};
               VALID {|| ( len(alltrim(This.Value)) >= 2)};
               VALIDMESSAGE "Minimum 2 characters" ;
               MESSAGE "Character Input" ;
               ON INIT {|| :Y += This.Height + :GapsHeight * 2 }

      @ :Y, :X GETBOX Text_4 WIDTH :O:nBoolLen HEIGHT :H1 ; 
               VALUE .T.;
               TOOLTIP "Logical Input VALID {|| (This.Value == .t.)}";
               PICTURE "Y";
               VALID {|| (This.Value == .T.)};
               VALIDMESSAGE "Only True is allowed here !!!";
               MESSAGE "Logical Input" ;
               ON INIT {|| :Y += This.Height + :GapsHeight * 2, ;
                                 This.Alignment := 'CENTER' }
       
      @ :Y, :X GETBOX Text_2a WIDTH :O:nDefLen HEIGHT :H1 ; 
               VALUE 234123.10 ;
               TOOLTIP "Numeric input PICTURE @ECX) $**,***.**" ;
               PICTURE '@ECX) $**,***.**' ;
               ON INIT {|| :Y += This.Height + :GapsHeight * 2, ;
                           :O:nTop2 := :Y + :GapsHeight }

      @ :Y, :X GETBOX Text_2b WIDTH :O:nDefLen HEIGHT :H1 ; 
               VALUE "Kowalski";
               PICTURE "@K !!!!!!!!!!";
               ON CHANGE (App.Object):Send(This.Cargo, 300) ; //{|| TONE(300)};
               ON INIT {|| This.Cargo := 3, ;                   // :Event
                           :Y += This.Height + :GapsHeight * 2 }
                 
      DEFINE GETBOX Text_2c    // Alternate Syntax
             ROW    :Y
             COL    :X
             WIDTH  :O:nDefLen
             HEIGHT :H1 
             VALUE "MyPass"
             PICTURE "@K !!!!!!!!!"
             VALID {|| ( len(alltrim(This.Value)) >= 4)}
             TOOLTIP "Character input PASSWORD clause is set"
             VALIDMESSAGE "Password must contains minimum 4 characters"
             MESSAGE "Enter password (min 4 char.) "
             PASSWORD .T.
             ON INIT {|| :Y += This.Height + :GapsHeight * 3 }
       END GETBOX

       @ :T - :GapsHeight, :L - :GapsWidth FRAME Frame_1 Caption "" ;
               WIDTH :X + :O:nDefLen HEIGHT :Y - :GapsHeight * 3

       @ :Y, :X BUTTONEX OButton_4 WIDTH :O:nDefLen HEIGHT :H1 * 2 ;
                CAPTION "Test"+CRLF+"&Info"  ;
                PICTURE "info.bmp" ;
                FLAT ;
                FONTCOLOR BLUE BOLD  ;
                BACKCOLOR WHITE ;
                TOOLTIP "horizontal Bitmap BUTTONEX 4" ;
                ACTION ( (App.Object):Send(This.Cargo[1], 800), ; // TONE(800)
                         (App.Object):Post(This.Cargo[2]) ) ; 
                ON INIT {|| This.Cargo := { 3, 1 }, ;              // Events
                            :Y += This.Height + :GapsHeight * 2 }

        :Y := This.Text_1.Row
        :X := :O:nLeft2
      @ :Y, :X BROWSE Browse_1 ;
               WIDTH    :O:nBrwLen ;
               HEIGHT ( :O:nTop2 - :T + :GapsHeight * .5 ) ;
               WORKAREA TEST ;
               BACKCOLOR {255,255,200} ;
               HEADERS {"Date","Numeric","Character","Logical"};
               WIDTHS {70,60,99,50};
               FIELDS { 'Test->Datev' , 'Test->Numeric' , 'Test->Character' , 'Test->Logical'} ;
               JUSTIFY {BROWSE_JTFY_LEFT,BROWSE_JTFY_RIGHT, BROWSE_JTFY_LEFT,BROWSE_JTFY_CENTER} ;
               FONT 'font_1' ;
               Value 1;
               LOCK;
               TOOLTIP "Double Click to edit";
               ON DBLCLICK {|| UnlockData( ) } ;
               ON CHANGE   {|| RefreshData() }
               
        :Y += This.Browse_1.Height + :GapsHeight * 2
      @ :Y, :X LABEL Label_1a VALUE "Date" WIDTH :O:nBrwSayLen HEIGHT :H1 BOLD ;
               ON INIT {|| :X += This.Width + :GapsWidth * 2 }
      @ :Y, :X GETBOX Text_5 WIDTH :D1 HEIGHT :H1 ;
        TOOLTIP "Text_5. DoubleClick => Edit" ;
        BACKCOLOR {{255,255,255},{255,255,200},{200,255,255}} ;
        PICTURE '@KD';
        FIELD test->Datev ;
        ON LOSTFOCUS LostFocus2Get() ;
        READONLY ;
        ON INIT {|og| :Y += This.Height + :GapsHeight, ;
                            Set_KeyEvent(og) }
        :X := :O:nLeft2
      @ :Y, :X LABEL Label_1b VALUE "Num." WIDTH :O:nBrwSayLen HEIGHT :H1 BOLD ;
               ON INIT {|| :X += This.Width + :GapsWidth * 2 }
      DEFINE GETBOX Text_6 // Alternate Syntax
          ROW    :Y
          COL    :X
          WIDTH  :W1
          HEIGHT :H1
          FIELD test->Numeric
          ON LOSTFOCUS LostFocus2Get() 
          WHEN {|| This.Value > 99}
          TOOLTIP "Numeric field. WHEN {|| This.Value > 99}"
          BACKCOLOR :O:BColorGet
          READONLY .T.
          PICTURE "@KB 999999"
          ON INIT {|og| :Y += This.Height + :GapsHeight, ;
                                      Set_KeyEvent(og) }
      END GETBOX
        :X := :O:nLeft2
      @ :Y, :X LABEL Label_1c VALUE "Char." WIDTH :O:nBrwSayLen HEIGHT :H1 BOLD ;
               ON INIT {|| :X += This.Width + :GapsWidth * 2 }
      @ :Y, :X GETBOX Text_7  WIDTH :O:nDefLen HEIGHT :H1 ; 
        BACKCOLOR  :O:BColorGet ;
        TOOLTIP "Characters field. DoubleClick => Edit" ;
        VALIDMESSAGE "Can not be empty!. VALID {|| (!EMPTY(This.Value))} . PICTURE @K !XXXXXXXXXXXXXXXX ";
        VALID {|| (!EMPTY(This.Value))} ;
        FIELD test->Character  ;
        ON LOSTFOCUS LostFocus2Get() ;
        PICTURE "@K !XXXXXXXXXXXXXXXX" ;
        READONLY ;
        ON INIT {|og| :Y += This.Height + :GapsHeight, ;
                            Set_KeyEvent(og) }
        :X := :O:nLeft2
      @ :Y, :X LABEL Label_1d VALUE "Logic." WIDTH :O:nBrwSayLen HEIGHT :H1 BOLD ;
               ON INIT {|| :X += This.Width + :GapsWidth * 2 }
      @ :Y, :X GETBOX Text_8 WIDTH :O:nBoolLen HEIGHT :H1 ; 
        BACKCOLOR  :O:BColorGet ;
        FONTCOLOR  :O:FColor2   ;
        BOLD;
        TOOLTIP "Logical field. DoubleClick => Edit" ;
        FIELD test->Logical;
        ON LOSTFOCUS LostFocus2Get() ;
        READONLY ;
        ON INIT {|og| :Y += This.Height +  :GapsHeight, ;
                            This.Alignment := 'CENTER', ;
                            Set_KeyEvent(og) }
        :O:nTop2 := :Y
                  
        :X := This.Text_5.Col + :O:nDefLen + :GapsWidth * 2
        :Y := This.Text_5.Row
      @ :Y, :X BUTTONEX Button_1 WIDTH :W(1.4) HEIGHT :H1 CAPTION "Save"   ;
               FONTCOLOR {200,0,0} BOLD ACTION saveDateNow()
        :Y := This.Text_6.Row
      @ :Y, :X BUTTONEX Button_2 WIDTH :W(1.4) HEIGHT :H1 CAPTION "Edit"   ;
               FONTCOLOR {200,0,0} BOLD ACTION UnlockData() 
        :Y := This.Text_7.Row
      @ :Y, :X BUTTONEX Button_3 WIDTH :W(1.4) HEIGHT :H1 CAPTION "Cancel" ;
               FONTCOLOR {200,0,0} BOLD ACTION CancelData()

      @ :T - :GapsHeight, :O:nLeft2 - :GapsWidth FRAME Frame_2 Caption "" ;
              WIDTH :O:nBrwLen + :GapsWidth * 2 HEIGHT :O:nTop2 - :GapsHeight

        :O:nMaxX := :O:nLeft2 + :O:nBrwLen + :GapsWidth 
        :O:nMaxY := :O:nTop2  + :GapsHeight
      
        This.Width  := :O:nMaxX + :R + :GapsWidth + GetBorderWidth()
        This.Height := :O:nMaxY + :B + This.StatusBar.Height + ;
                    GetBorderHeight() + GetTitleHeight() + GetMenuBarHeight()

      END WITH

      EnabledBtn(.F.)
      This.Browse_1.ColumnsAutoFitH
      RefreshData()

   END WINDOW
   
   Form_1.Center
   Form_1.Activate

Return NIL
      
*-----------------------------
STATIC FUNC _HMG_Value()
*-----------------------------
   LOCAL s := ''

   s += '_HMG_ThisFormIndex   = ' + cValToChar( _HMG_ThisFormIndex   ) + CRLF
   s += '_HMG_ThisEventType   = ' + cValToChar( _HMG_ThisEventType   ) + CRLF
   s += '_HMG_ThisType        = ' + cValToChar( _HMG_ThisType        ) + CRLF
   s += '_HMG_ThisIndex       = ' + cValToChar( _HMG_ThisIndex       ) + CRLF
   s += '_HMG_ThisFormName    = ' + cValToChar( _HMG_ThisFormName    ) + CRLF
   s += '_HMG_ThisControlName = ' + cValToChar( _HMG_ThisControlName ) + CRLF

RETURN s

*-----------------------------
STAT FUNC Set_KeyEvent( oGet )
*-----------------------------

   If     This.Name == 'Text_1'

      oGet:SetKeyEvent( VK_F5, {|o| MsgBox( 'VK_F5 : ' + cValToChar( o:VarGet() ), This.Name ) } ) 
      oGet:SetKeyEvent( , {|o| MsgBox( 'LDblClick : ' + cValToChar( o:VarGet() ), This.Name ) } )

   ElseIf This.Name == 'Text_2'
               
      oGet:SetKeyEvent( VK_F5, {|o| MsgBox( 'VK_F5 : ' + cValToChar( o:VarGet() ), This.Name ) } ) 
      oGet:SetKeyEvent(  , {|o| MsgBox( 'LDblClick : ' + cValToChar( o:VarGet() ), This.Name ) } )

   ElseIf This.Name $  'Text_5,Text_6,Text_7,Text_8'

      oGet:SetKeyEvent(  , {|| DoublClick2Get() } )
      
   EndIf

RETURN Nil
      
*-----------------------------
STATIC FUNC LostFocus2Get()
*-----------------------------
   LOCAL cCtl := This.FocusedControl
   LOCAL cGet := This.Name

   If     This.ReadOnly
   ElseIf cCtl == 'Browse_1'
      ButtonPress('Button_3')
   ElseIf ! cCtl $ 'Text_5,Text_6,Text_7,Text_8,Button_1,Button_3'
      This.&(cGet).SetFocus
   EndIf

RETURN Nil

*-----------------------------
FUNC ButtonPress( cName, cFocus )
*-----------------------------

//   (ThisWindow.Object):Send( This.&(cName).Cargo  )
   This.&(cName).SetFocus
   _PushKey( VK_SPACE )
   DO EVENTS

   If !Empty(cFocus)
      This.&(cFocus).SetFocus
   EndIf

RETURN Nil

*-----------------------------
STATIC FUNC DoublClick2Get()
*-----------------------------
   LOCAL cGet := This.FocusedControl

   If This.ReadOnly
      ButtonPress('Button_2', cGet)
   EndIf
   
RETURN Nil

*-----------------------------
STAT PROC RefreshData()
*-----------------------------

  SetProperty( "Form_1", "StatusBar", "Item", 2, hb_ntos(RecNo()) )

  Form_1.Text_5.FontColor := (App.Object):O:FColor1
  Form_1.Text_6.FontColor := (App.Object):O:FColor1
  Form_1.Text_7.FontColor := (App.Object):O:FColor1
  Form_1.Text_8.FontColor := (App.Object):O:FColor2

  Form_1.Text_5.Refresh
  Form_1.Text_6.Refresh
  Form_1.Text_7.Refresh
  Form_1.Text_8.Refresh
  DO EVENTS

Return

*-----------------------------
STAT PROC ReadOnlyData( lROnly )
*-----------------------------

  Form_1.Text_5.Readonly := lROnly
  Form_1.Text_6.Readonly := lROnly
  Form_1.Text_7.Readonly := lROnly
  Form_1.Text_8.Readonly := lROnly
  DO EVENTS

Return

*-----------------------------
STAT PROC EnabledBtn( lEnable )
*-----------------------------

  Form_1.Button_1.Enabled :=   lEnable
  Form_1.Button_2.Enabled := ! lEnable
  Form_1.Button_3.Enabled :=   lEnable
  DO EVENTS

Return

*-----------------------------
Procedure UnlockData()
*-----------------------------

   IF !RLOCK()
      MsgStop("Record occupied by another user")
      return
   endif

  RefreshData()
  ReadOnlyData(.F.)
  EnabledBtn(.T.)

  Form_1.Text_5.SetFocus

Return

*-----------------------------
Procedure saveDateNow()
*-----------------------------
  IF RLOCK()
     Form_1.Text_5.Save
     Form_1.Text_6.Save
     Form_1.Text_7.Save
     Form_1.Text_8.Save
     UNLOCK
  else
     RETURN
  endif

  RefreshData()
  ReadOnlyData(.T.)
  EnabledBtn(.F.)

  Form_1.Browse_1.Refresh
  Form_1.Browse_1.SetFocus

return

*-----------------------------
Function CancelData()
*-----------------------------

  RefreshData()
  ReadOnlyData(.T.)
  EnabledBtn(.F.)

  Form_1.Browse_1.SetFocus

   UNLOCK

return NIL

*-----------------------------
Function OPEN_TABLE()
*-----------------------------
Local i

   If !FILE("test.dbf")

      DBTESTCREATE("test")

      USE TEST NEW EXCLUSIVE

      FOR i=1 to 10
         APPEND BLANK
         test->Datev := date()+i
         test->Numeric := i*10
         test->Character := "Character "+ltrim(str(i))
         test->Logical := ( int(i/2) == i/2 )
      next i

      USE

   ENDIF

   USE TEST NEW SHARED

Return NIL

*-----------------------------
Function DBTESTCREATE(ufile)
*-----------------------------
  Local aDbf := {}

  AADD (aDbf,{"Datev"      , "D",  8,0})
  AADD (aDbf,{"Numeric"    , "N",  5,0})
  AADD (aDbf,{"Character"  , "C",  20,0})
  AADD (aDbf,{"Logical"    , "L",  1,0})
  dbcreate( ufile, aDbf, 'DBFNTX' )

Return NIL

*-----------------------------
Function Compare(dDate)
*-----------------------------
   if empty(dDate) .or. dDate < date()
      return .f.
   endif
return .t.

*-----------------------------
Function _Trans(xval)
*-----------------------------
   Local RetVal

   if valtype(xVAL)=="C"
      RetVal := xval
   elseif valtype(xVal)=="D"
      RetVal := DTOC(xVal)
   elseif valtype(xVal)=="N"
      RetVal := alltrim(str(xVal))
   elseif valtype(xVal)=="L"
      RetVal := if(xVal,"True","False")
   else
      RetVal := "Unknown"
   endif

return RetVal

*-----------------------------
STATIC FUNC Main_Menu()
*-----------------------------

   DEFINE MAIN MENU

      POPUP 'Set Parameters'
      ITEM "Set parameters: 12 110 100" ACTION {|cp| cp := ["12,110,100"], ;
                                                (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 14 120 110" ACTION {|cp| cp := ["14,120,110"], ;
                                                (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 16 140 120" ACTION {|cp| cp := ["16,140,120"], ;
                                                (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 18 150 130" ACTION {|cp| cp := ["18,150,130"], ;
                                                (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 20 170 140" ACTION {|cp| cp := ["20,170,140"], ;
                                                (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 22 180 150" ACTION {|cp| cp := ["22,180,150"], ;
                                                (App.Object):Send(2, 2, cp) }
      SEPARATOR
      ITEM "Set parameters: 12 110 100 Arial" ACTION {|cp| cp := ["12,110,100, Arial"], ;
                                                       (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 14 120 110 Arial" ACTION {|cp| cp := ["14,120,110, Arial"], ;
                                                       (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 16 140 120 Arial" ACTION {|cp| cp := ["16,140,120, Arial"], ;
                                                       (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 18 150 130 Arial" ACTION {|cp| cp := ["18,150,130, Arial"], ;
                                                       (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 20 170 140 Arial" ACTION {|cp| cp := ["20,170,140, Arial"], ;
                                                       (App.Object):Send(2, 2, cp) }
      ITEM "Set parameters: 22 180 150 Arial" ACTION {|cp| cp := ["22,180,150, Arial"], ;
                                                       (App.Object):Send(2, 2, cp) }
      SEPARATOR
      ITEM "Set parameters: Default" ACTION {|cp| cp := [""], (App.Object):Send(2, 2, cp) }
      END POPUP

      POPUP '&Get Value'
      ITEM "Get Text_1  Value" ACTION (App.Object):Post(9, This.Text_1.Index , {'Text_1' , This.Text_1.Value , ThisWindow.Name}) MESSAGE "Vale and ValueType"
      ITEM "Get Text_2  Value" ACTION (App.Object):Post(9, This.Text_2.Index , {'Text_2' , This.Text_2.Value , ThisWindow.Name}) MESSAGE "Vale and ValueType"
      ITEM "Get Text_3  Value" ACTION (App.Object):Post(9, This.Text_3.Index , {'Text_3' , This.Text_3.Value , ThisWindow.Name}) MESSAGE "Vale and ValueType"
      ITEM "Get Text_4  Value" ACTION (App.Object):Post(9, This.Text_4.Index , {'Text_4' , This.Text_4.Value , ThisWindow.Name}) MESSAGE "Vale and ValueType"
      ITEM "Get Text_2a Value" ACTION (App.Object):Post(9, This.Text_2a.Index, {'Text_2a', This.Text_2a.Value, ThisWindow.Name}) MESSAGE "Vale and ValueType"
      ITEM "Get Text_2b Value" ACTION (App.Object):Post(9, This.Text_2b.Index, {'Text_2b', This.Text_2b.Value, ThisWindow.Name}) MESSAGE "Vale and ValueType"
      ITEM "Get Text_2c Value" ACTION (App.Object):Post(9, This.Text_2c.Index, {'Text_2c', This.Text_2c.Value, ThisWindow.Name}) MESSAGE "Vale and ValueType"
      END POPUP

      POPUP 'Get &DisplayValue'
      ITEM "Get Text_1 DisplayValue"  ACTION (App.Object):Post(8, This.Text_1.Index , {'Text_1' , This.Text_1.DisplayValue , ThisWindow.Name})
      ITEM "Get Text_2 DisplayValue"  ACTION (App.Object):Post(8, This.Text_2.Index , {'Text_2' , This.Text_2.DisplayValue , ThisWindow.Name})
      ITEM "Get Text_3 DisplayValue"  ACTION (App.Object):Post(8, This.Text_3.Index , {'Text_3' , This.Text_3.DisplayValue , ThisWindow.Name})
      ITEM "Get Text_4 DisplayValue"  ACTION (App.Object):Post(8, This.Text_4.Index , {'Text_4' , This.Text_4.DisplayValue , ThisWindow.Name})
      ITEM "Get Text_2a DisplayValue" ACTION (App.Object):Post(8, This.Text_2a.Index, {'Text_2a', This.Text_2a.DisplayValue, ThisWindow.Name})
      ITEM "Get Text_2b DisplayValue" ACTION (App.Object):Post(8, This.Text_2b.Index, {'Text_2b', This.Text_2b.DisplayValue, ThisWindow.Name})
      ITEM "Get Text_2c DisplayValue" ACTION (App.Object):Post(8, This.Text_2c.Index, {'Text_2c', This.Text_2c.DisplayValue, ThisWindow.Name})
      END POPUP

      POPUP 'Disable/Enable'
      ITEM "Enable Text_1"   ACTION (App.Object):Post(10, 1, {'Text_1' , ThisWindow.Name}) 
      ITEM "Enable Text_2"   ACTION (App.Object):Post(10, 1, {'Text_2' , ThisWindow.Name}) 
      ITEM "Enable Text_3"   ACTION (App.Object):Post(10, 1, {'Text_3' , ThisWindow.Name}) 
      ITEM "Enable Text_4"   ACTION (App.Object):Post(10, 1, {'Text_4' , ThisWindow.Name}) 
      ITEM "Enable Text_2a"  ACTION (App.Object):Post(10, 1, {'Text_2a', ThisWindow.Name})
      ITEM "Enable Text_2b"  ACTION (App.Object):Post(10, 1, {'Text_2b', ThisWindow.Name})
      ITEM "Enable Text_2c"  ACTION (App.Object):Post(10, 1, {'Text_2c', ThisWindow.Name})

      SEPARATOR
      ITEM "Disable Text_1"  ACTION (App.Object):Post(10, 0, {'Text_1' , ThisWindow.Name})
      ITEM "Disable Text_2"  ACTION (App.Object):Post(10, 0, {'Text_2' , ThisWindow.Name}) 
      ITEM "Disable Text_3"  ACTION (App.Object):Post(10, 0, {'Text_3' , ThisWindow.Name}) 
      ITEM "Disable Text_4"  ACTION (App.Object):Post(10, 0, {'Text_4' , ThisWindow.Name}) 
      ITEM "Disable Text_2a" ACTION (App.Object):Post(10, 0, {'Text_2a', ThisWindow.Name})
      ITEM "Disable Text_2b" ACTION (App.Object):Post(10, 0, {'Text_2b', ThisWindow.Name})
      ITEM "Disable Text_2c" ACTION (App.Object):Post(10, 0, {'Text_2c', ThisWindow.Name})
      END POPUP

   END MENU

RETURN Nil
