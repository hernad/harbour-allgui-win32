/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Copyright 2002 Roberto Lopez <harbourminigui@gmail.com>
 *
 * HMG GETBOX demo
 * (C) 2006 Jacek Kubica <kubica@wssk.wroc.pl>
*/

#define _HMG_OUTLOG

#include "minigui.ch"

*-----------------------------
Function MAIN()
*-----------------------------

   SET CENTURY ON
   SET DATE ANSI
   SET ShowDetailError ON
   SET DELETED ON
   SET BROWSESYNC ON
   
   OPEN_TABLE()

   WITH OBJECT App.Object

   :GetGaps(1.5)                   // create :LTRB default

   :Y   := :T
   :X   := :L
   :O:Y := :T  // left row browse
   :O:X := :L  // left col browse

   :O:BColorGet    := {{255,255,255},{255,255,200},{200,255,255}}
   :O:FColorGet    := {{  0,  0,  0},{255,255,200},{0  ,0  ,255}}
   :O:BClrGetFocus := :O:BColorGet[3]           // {200,255,255}
   :O:FClrGetFocus := :O:FColorGet[3]           // BLUE         
   :O:FColor1      := BLACK
   :O:FColor2      := RED

   SET GETBOX FOCUS BACKCOLOR TO :O:BClrGetFocus
   SET GETBOX FOCUS FONTCOLOR TO :O:FClrGetFocus

   END WITH

   DEFINE FONT font_0 FONTNAME 'MS Sans Serif' SIZE 9 DEFAULT

   DEFINE WINDOW Form_1 AT 0,0  WIDTH 500 HEIGHT 440 ;
      TITLE 'HMG GetBox Demo. Using of ON INIT <block> ' ;
      MAIN

      WITH OBJECT App.Object

      DEFINE GETBOX Text_1 // Alternate Syntax
         ROW     0
         COL     0
         HEIGHT 20
         VALUE   DATE()
         PICTURE '@K'
         TOOLTIP "Date Value: Must be greater or equal to "+DTOC(DATE())
         VALID {|| Compare(this.value)}
         VALIDMESSAGE "Must be greater or equal to "+DTOC(DATE())
         MESSAGE "Date Value"
         BACKCOLOR :O:BColorGet
         FONTCOLOR :O:FColorGet
         ON INIT   {|| This.Alignment := 'CENTER',  ;
                       :O:X += This.Width + :R * 3, ; // left col browse
                       bOnInit() } 
      END GETBOX

      @ 0,0 GETBOX Text_2 ;
            HEIGHT 20;
            VALUE 57639 ;
            ACTION MsgInfo( "Button Action");
            TOOLTIP {"Numeric input. RANGE -100,200000 PICTURE @Z 99,999.99","Button ToolTip"};
            PICTURE '@Z 99,999.99';
            RANGE -100,200000;
            BOLD;
            MESSAGE "Numeric input";
            VALIDMESSAGE "Value between -100 and 200000 " ;
            BACKCOLOR :O:BColorGet ;
            FONTCOLOR :O:FColorGet ;
            ON INIT   {|| bOnInit(), :GetGaps(3.0) }      // new :LTRB

      @ 0,0 GETBOX Text_3 ;
            VALUE "Jacek";
            ACTION  MsgInfo( "Button Action");
            ACTION2 MsgInfo( "Button2 Action");
            IMAGE {"folder.bmp","info.bmp"};
            BUTTONWIDTH :H1 ;
            PICTURE "@K !xxxxxxxxxxx";
            TOOLTIP {"Character Input. VALID {|| ( len(alltrim(This.Value)) >= 2)} PICTURE @K !xxxxxxxxxxx ","Button ToolTip","Button 2 ToolTip"};
            VALID {|| ( len(alltrim(This.Value)) >= 2)};
            VALIDMESSAGE "Minimum 2 characters" ;
            MESSAGE "Character Input";
            BACKCOLOR :O:BColorGet ;
            FONTCOLOR :O:FColorGet ;
            ON INIT   {|| bOnInit() }
      
      @ 0,0 GETBOX Text_4 WIDTH 30 HEIGHT 20;
            VALUE .t.;
            TOOLTIP "Logical Input VALID {|| (This.Value == .t.)}";
            PICTURE "Y";
            VALID {|| (This.Value == .t.)};
            VALIDMESSAGE "Only True is allowed here !!!";
            MESSAGE "Logical Input";
            BACKCOLOR :O:BColorGet ;
            FONTCOLOR :O:FColorGet ;
            ON INIT   {|| bOnInit(:W(.3)), This.Alignment := 'CENTER' }

      @ 0,0 GETBOX Text_2a HEIGHT 20;
            VALUE 234123.10 ;
            TOOLTIP "Numeric input PICTURE @ECX) $**,***.**" ;
            PICTURE '@ECX) $**,***.**' ;
            BACKCOLOR :O:BColorGet ;
            FONTCOLOR :O:FColorGet ;
            ON INIT   {|| bOnInit() }

      @ 0,0 GETBOX Text_2b HEIGHT 20;
            VALUE "Kowalski";
            PICTURE "@K !!!!!!!!!!";
            ON CHANGE {|| TONE(300)};
            BACKCOLOR :O:BColorGet ;
            FONTCOLOR :O:FColorGet ;
            ON INIT   {|| bOnInit() }

      DEFINE GETBOX Text_2c    // Alternate Syntax
          VALUE "MyPass"
          PICTURE "@K !!!!!!!!!"
          VALID {|| ( len(alltrim(This.Value)) >= 4)}
          TOOLTIP "Character input PASSWORD clause is set"
          VALIDMESSAGE "Password must contains minimum 4 characters"
          MESSAGE "Enter password (min 4 char.) "
          PASSWORD .T.
          BACKCOLOR :O:BColorGet 
          FONTCOLOR :O:FColorGet 
          ON INIT   {|| bOnInit(), :GetGaps(1.5), :Y := :O:Y, :X := :O:X }
      END GETBOX

      @ 10,160 BROWSE Browse_1 WIDTH 300 HEIGHT 180 ;
          WORKAREA TEST ;
          BACKCOLOR {255,255,200} ;
          HEADERS {"Date","Numeric","Character","Logical"};
          WIDTHS {70,60,99,50};
          FIELDS { 'Test->Datev' , 'Test->Numeric' , 'Test->Character' , 'Test->Logical'} ;
          JUSTIFY {BROWSE_JTFY_LEFT,BROWSE_JTFY_RIGHT, BROWSE_JTFY_LEFT,BROWSE_JTFY_CENTER} ;
          FONT "MS Sans serif" SIZE 09 ;
          Value 1;
          LOCK;
          TOOLTIP "Double Click to edit";
          ON DBLCLICK { || UnlockData( ) } ;
          ON CHANGE {|| ( SetProperty( "Form_1", "StatusBar", "Item", 2, alltrim(str(recno() ))), ;
                          Form_1.Text_5.Refresh , Form_1.Text_6.Refresh, Form_1.Text_7.Refresh, Form_1.Text_8.Refresh ) } ;
          ON INIT {|| This.Row := :Y, This.Col := :X, :Y += This.Height + :B*2, ;
                      :O:Y := :Y, :O:X := :X, :GetGaps(1.5) } // remember Y, X

      @ 0,0 LABEL Label_1a VALUE "Date"   BOLD VCENTERALIGN ON INIT {|| bOnInit(:W(.8)) }
      @ 0,0 LABEL Label_1b VALUE "Num."   BOLD VCENTERALIGN ON INIT {|| bOnInit(:W(.8)) }
      @ 0,0 LABEL Label_1c VALUE "Char."  BOLD VCENTERALIGN ON INIT {|| bOnInit(:W(.8)) }
      @ 0,0 LABEL Label_1d VALUE "Logic." BOLD VCENTERALIGN         ;
                  ON INIT {|| bOnInit(:W(.8)),  :O:X += This.Width, ;
                                                :Y   := :O:Y,       ;
                                                :X   := :O:X - :R }
      @ 0,0 GETBOX Text_5 ;
            TOOLTIP "Text_5" ;
            BACKCOLOR :O:BColorGet ;
            PICTURE '@D';
            FIELD test->Datev ;
            READONLY ;
            ON INIT {|| bOnInit(:D1), :O:Y := This.Row } // Row for buttons

    DEFINE GETBOX Text_6 // Alternate Syntax
        FIELD test->Numeric
        BACKCOLOR :O:BColorGet 
        VALID {|| (!EMPTY(This.Value).AND.This.Value<=99999)}
        WHEN {|| This.Value > 99}
        TOOLTIP "Numeric field. VALID {|| (!EMPTY(This.Value).AND.This.Value<=99999)} . WHEN {|| This.Value > 99}"
        READONLY .T.
        PICTURE "@KB 999999"
        ON INIT {|| bOnInit(:W1) }
    END GETBOX
  
    @ 0,0 GETBOX Text_7 ;
          BACKCOLOR :O:BColorGet ;
          TOOLTIP "Characters field. " ;
          VALIDMESSAGE "Can not be empty!. VALID {|| (!EMPTY(This.Value))} . PICTURE @K !XXXXXXXXXXXXXXXX ";
          VALID {|| (!EMPTY(This.Value))} ;
          FIELD test->Character  ;
          PICTURE "@K !XXXXXXXXXXXXXXXX";
          READONLY ;
          ON INIT {|| bOnInit(), :O:X := This.Col + This.Width + :R * 2 } // Column for buttons

    @ 0,0 GETBOX Text_8 ;
          BACKCOLOR :O:BColorGet ;
          FONTCOLOR RED     BOLD ;
          TOOLTIP "Logical field" ;
          FIELD test->Logical;
          READONLY ;
          ON INIT {|| bOnInit(:W(.3)), This.Alignment := 'CENTER', ;
                              :Y := :O:Y, :X := :O:X }
          
      @ 0,0 BUTTONEX Button_1 CAPTION "Save"   FONTCOLOR {200,0,0} BOLD ACTION saveDateNow() ;
                              ON INIT {|| bOnInit(:W1) }
      @ 0,0 BUTTONEX Button_2 CAPTION "Edit"   FONTCOLOR {200,0,0} BOLD ACTION UnlockData()  ;
                              ON INIT {|| bOnInit(:W1) }
      @ 0,0 BUTTONEX Button_3 CAPTION "Cancel" FONTCOLOR {200,0,0} BOLD ACTION CancelData()  ;
                              ON INIT {|| bOnInit(:W1) }

      @ 0,0 FRAME Frame_1 Caption "" WIDTH 3 HEIGHT 3 ;
            ON INIT {|| This.Row    := int( :T/2 ) - 2, ;
                        This.Col    := This.Browse_1.Col - :L, ;
                        This.Width  := This.Browse_1.Width + :L * 2, ;
                        This.Height := :Y + :T * 3 }

      END WITH

      DEFINE MAIN MENU
           POPUP '&Get Value'
           ITEM "Get Text_1  Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_1.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_1.Value)) MESSAGE "Vale and ValueType"
           ITEM "Get Text_2  Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_2.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_2.Value))
           ITEM "Get Text_3  Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_3.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_3.Value))
           ITEM "Get Text_4  Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_4.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_4.Value))
           ITEM "Get Text_2a Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_2a.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_2a.Value))
           ITEM "Get Text_2b Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_2b.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_2b.Value))
           ITEM "Get Text_2c Value" ACTION MsgBox("Value: "+chr(9)+_Trans(Form_1.Text_2c.Value)+CRLF+"Valtype: "+chr(9)+VALTYPE(Form_1.Text_2c.Value))

         END POPUP

         POPUP 'Get &DisplayValue'
         ITEM "Get Text_1 DisplayValue"  ACTION MsgBox(Form_1.Text_1.DisplayValue)
         ITEM "Get Text_2 DisplayValue"  ACTION MsgBox(Form_1.Text_2.DisplayValue)
         ITEM "Get Text_3 DisplayValue"  ACTION MsgBox(Form_1.Text_3.DisplayValue)
         ITEM "Get Text_4 DisplayValue"  ACTION MsgBox(Form_1.Text_4.DisplayValue)
         ITEM "Get Text_2a DisplayValue" ACTION MsgBox(Form_1.Text_2a.DisplayValue)
         ITEM "Get Text_2b DisplayValue" ACTION MsgBox(Form_1.Text_2b.DisplayValue)
         ITEM "Get Text_2c DisplayValue" ACTION MsgBox(Form_1.Text_2c.DisplayValue)

         END POPUP

         POPUP '&Set Value'
         ITEM "Set Text_1 Value" ACTION Form_1.Text_1.Value   := STOD('19620210')
         ITEM "Set Text_2 Value" ACTION Form_1.Text_2.Value   := 99999
         ITEM "Set Text_3 Value" ACTION Form_1.Text_3.Value   := 'janusz'
         ITEM "Set Text_4 Value" ACTION Form_1.Text_4.Value   := .f.
         ITEM "Set Text_2a Value to 200.123" ACTION Form_1.Text_2a.Value := 200.123
         ITEM "Set Text_2b Value to malinowski" ACTION Form_1.Text_2b.Value := 'malinowski'
         ITEM "Set Text_2c Value to new_pass" ACTION Form_1.Text_2c.Value := 'new_pass'
         END POPUP

         POPUP 'Set &Picture'
         ITEM "Set Text_1 Picture to '@D'" ACTION Form_1.Text_1.Picture:='@D'
         ITEM "Set Text_2 Picture to '@Z 999,999.99'" ACTION Form_1.Text_2.Picture:='@Z 999,999.99'
         ITEM "Set Text_3 Picture to '@K!'" ACTION Form_1.Text_3.Picture:='@K!'
         ITEM "Set Text_4 Picture to '@L'" ACTION Form_1.Text_4.Picture:='@L'

         SEPARATOR
         ITEM "Set Text_1 Picture to '@K'" ACTION Form_1.Text_1.Picture:='@K'
         ITEM "Set Text_2 Picture to '@Z 99,999.99'" ACTION Form_1.Text_2.Picture:='@Z 99,999.99'
         ITEM "Set Text_3 Picture to '@K !xxxxxxxxxxxxxx'" ACTION Form_1.Text_3.Picture:='@K !xxxxxxxxxxxxxx'
         ITEM "Set Text_4 Picture to '@Y'" ACTION Form_1.Text_4.Picture:='@Y'
         END POPUP

         POPUP 'Disable/Enable'
          ITEM "Enable Text_1" ACTION Form_1.Text_1.Enabled:=.t.
          ITEM "Enable Text_2" ACTION Form_1.Text_2.Enabled:=.t.
          ITEM "Enable Text_3" ACTION Form_1.Text_3.Enabled:=.t.
          ITEM "Enable Text_4" ACTION Form_1.Text_4.Enabled:=.t.
          ITEM "Enable Text_2a" ACTION Form_1.Text_2a.Enabled:=.t.
          ITEM "Enable Text_2b" ACTION Form_1.Text_2b.Enabled:=.t.
          ITEM "Enable Text_2c" ACTION Form_1.Text_2c.Enabled:=.t.

          SEPARATOR
          ITEM "Disable Text_1" ACTION Form_1.Text_1.Enabled:=.f.
          ITEM "Disable Text_2" ACTION Form_1.Text_2.Enabled:=.f.
          ITEM "Disable Text_3" ACTION Form_1.Text_3.Enabled:=.f.
          ITEM "Disable Text_4" ACTION Form_1.Text_4.Enabled:=.f.
          ITEM "Disable Text_2a" ACTION Form_1.Text_2a.Enabled:=.f.
          ITEM "Disable Text_2b" ACTION Form_1.Text_2b.Enabled:=.f.
          ITEM "Disable Text_2c" ACTION Form_1.Text_2c.Enabled:=.f.

         END POPUP

      END MENU

      DEFINE STATUSBAR
          STATUSITEM "Standard message" WIDTH 160
          STATUSITEM "1" WIDTH 40
          KEYBOARD
      END STATUSBAR

   END WINDOW

   Form_1.Button_1.Enabled:=.f.
   Form_1.Button_3.Enabled:=.f.
   Form_1.Center
   Form_1.Activate

Return NIL

*-----------------------------
STAT FUNC bOnInit( w, h, b )
*-----------------------------
   WITH OBJECT App.Object

   DEFAULT w := :W(1.5), h := :H1, b := :B

   This.Row    := :Y
   This.Col    := :X
   This.Width  :=  w
   This.Height :=  h
   :Y          +=  b + This.Height

   END WITH

RETURN Nil

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
Procedure UnlockData()
*-----------------------------
   IF !RLOCK()
      MsgStop("Record occupied by another user")
      return
   endif

  Form_1.Text_5.Refresh
  Form_1.Text_6.Refresh
  Form_1.Text_7.Refresh
  Form_1.Text_8.Refresh
  Form_1.Text_5.Readonly:=.f.
  Form_1.Text_6.Readonly:=.f.
  Form_1.Text_7.Readonly:=.f.
  Form_1.Text_8.Readonly:=.f.
  Form_1.Button_1.Enabled:=.t.
  Form_1.Button_2.Enabled:=.f.
  Form_1.Button_3.Enabled:=.t.
 // Form_1.Browse_1.Enabled:=.f.
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

  Form_1.Text_5.Readonly:=.t.
  Form_1.Text_6.Readonly:=.t.
  Form_1.Text_7.Readonly:=.t.
  Form_1.Text_8.Readonly:=.t.

  Form_1.Browse_1.Refresh

  Form_1.Text_5.Refresh
  Form_1.Text_6.Refresh
  Form_1.Text_7.Refresh
  Form_1.Text_8.Refresh

  Form_1.Button_1.Enabled:=.f.
  Form_1.Button_2.Enabled:=.t.
  Form_1.Button_3.Enabled:=.f.
  Form_1.Browse_1.Enabled:=.t.
  Form_1.Browse_1.SetFocus

return

*-----------------------------
Function CancelData()
*-----------------------------
  Form_1.Text_5.Readonly:=.t.
  Form_1.Text_6.Readonly:=.t.
  Form_1.Text_7.Readonly:=.t.
  Form_1.Text_8.Readonly:=.t.

   Form_1.Text_5.Refresh
   Form_1.Text_6.Refresh
   Form_1.Text_7.Refresh
   Form_1.Text_8.Refresh


   Form_1.Button_1.Enabled:=.f.
   Form_1.Button_2.Enabled:=.t.
   Form_1.Browse_1.Enabled:=.t.
   Form_1.Button_3.Enabled:=.f.
   Form_1.Browse_1.SetFocus
   UNLOCK

return NIL

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
