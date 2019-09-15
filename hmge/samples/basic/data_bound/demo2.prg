/*
 * MiniGUI DATA-BOUND Controls Demo
 * (c) 2003 Roberto Lopez
 *
 * Revised by Grigory Filatov, 2006-2019
*/

#include "minigui.ch"

#define LSILVER		{ 180 , 180 , 180 }

PROCEDURE Main

   SET DELETED ON

   SET FONT TO _GetSysFont(), 12

   DEFINE WINDOW Win_1 ;
      WIDTH 428 ;
      HEIGHT 400 ;
      TITLE 'Data-Bound Controls Test' ;
      MAIN ;
      NOMAXIMIZE ;
      NOSIZE ;
      ON INIT OpenTables() ;
      ON RELEASE CloseTables()

   CREATE_CONTROLS()

   END WINDOW

   CREATE_TOOLBAR()

   ACTIVATE WINDOW Win_1 ON INIT This.Center

RETURN


PROCEDURE CREATE_TOOLBAR

   DEFINE TOOLBAR ToolBar_1 OF Win_1 BUTTONSIZE 20, 20 FLAT /*RIGHTTEXT BORDER*/ BOTTOM

   BUTTON TOP    ;
      TOOLTIP '&Top'   ;
      PICTURE 'primero.bmp'  ;
      ACTION  ( TEST->( dbGoTop() ), Refresh() )

   BUTTON PREVIOUS    ;
      TOOLTIP '&Previous'  ;
      PICTURE 'anterior.bmp'  ;
      ACTION  ( TEST->( dbSkip( -1 ) ), Refresh() )

   BUTTON NEXT    ;
      TOOLTIP '&Next'   ;
      PICTURE 'siguiente.bmp'  ;
      ACTION  ( TEST->( dbSkip( 1 ) ), iif ( TEST->( Eof() ), TEST->( dbGoBottom() ), Nil ), Refresh() )

   BUTTON BOTTOM    ;
      TOOLTIP '&Bottom'  ;
      PICTURE 'ultimo.bmp'  ;
      ACTION  ( TEST->( dbGoBottom() ), Refresh() ) GROUP

   BUTTON ADD    ;
      TOOLTIP '&Append'  ;
      PICTURE 'agregar.bmp'  ;
      ACTION  New()

   BUTTON DEL    ;
      TOOLTIP '&Delete'  ;
      PICTURE 'suprimir.bmp'  ;
      ACTION  DelRec() GROUP

   BUTTON SAVE    ;
      TOOLTIP '&Save'   ;
      PICTURE 'guardar.bmp'  ;
      ACTION  Save()

   BUTTON UNDO    ;
      TOOLTIP '&Undo'   ;
      PICTURE 'deshacer.bmp'  ;
      ACTION  Refresh()

   END TOOLBAR

RETURN


PROCEDURE CREATE_CONTROLS

   LOCAL lChecked

   @ 10, 20 LABEL LABEL_0 VALUE 'EDIT test' WIDTH 380 CENTERALIGN

   @ 60, 20 LABEL LABEL_1 VALUE 'Code:' WIDTH 100 RIGHTALIGN
   @ 90, 20 LABEL LABEL_2 VALUE 'First Name:' WIDTH 100 RIGHTALIGN
   @ 120, 20 LABEL LABEL_3 VALUE 'Last Name:' WIDTH 100 RIGHTALIGN
   @ 150, 20 LABEL LABEL_4 VALUE 'Birth Date:' WIDTH 100 RIGHTALIGN
   @ 180, 20 LABEL LABEL_5 VALUE 'Married:' WIDTH 100 RIGHTALIGN
   @ 206, 20 LABEL LABEL_6 VALUE 'Bio:' WIDTH 100 RIGHTALIGN

   @ 60, 130 TEXTBOX TEXT_1;
      WIDTH 100 ;
      HEIGHT 26 ;
      FIELD TEST->CODE ;
      NUMERIC ;
      MAXLENGTH 10 ;
      BACKCOLOR LSILVER

   @ 90, 130 TEXTBOX TEXT_2;
      WIDTH 250 ;
      HEIGHT 26 ;
      FIELD TEST->FIRST ;
      MAXLENGTH 30 ;
      BACKCOLOR LSILVER

   @ 120, 130 TEXTBOX TEXT_3;
      WIDTH 250 ;
      HEIGHT 26 ;
      FIELD TEST->LAST ;
      MAXLENGTH 30 ;
      BACKCOLOR LSILVER

   @ 150, 130 DATEPICKER DATE_4 ;
      WIDTH 130 ;
      HEIGHT 26 ;
      FIELD TEST->BIRTH ;
      SHOWNONE

   @ 180, 130 SWITCHER CHECK_5 ;
      HEIGHT 46 IMAGE { 'MINIGUI_SWITCH_ON', 'MINIGUI_SWITCH_OFF' } ;
      LEFTCHECK ;
      FIELD TEST->MARRIED ;
      ONCLICK ( lChecked := Win_1.Check_5.Checked, Win_1.Check_5.Value := iif( lChecked, 'No', 'Yes' ), ;
         Win_1.Check_5.Checked := !lChecked )
/*
   DEFINE SWITCHER CHECK_5
	ROW	180
	COL	200
	LEFTCHECK .T.
	FIELD TEST->MARRIED
	ONCLICK ( lChecked := Win_1.Check_5.Checked, Win_1.Check_5.Value := iif( lChecked, 'No', 'Yes' ), ;
		Win_1.Check_5.Checked := !lChecked )
   END SWITCHER
*/
   @ 206, 130 EDITBOX EDIT_6 ;
      WIDTH 250 ;
      FIELD TEST->BIO ;
      HEIGHT 100 ;
      NOHSCROLL ;
      BACKCOLOR LSILVER

   DRAW RECTANGLE IN WINDOW Win_1 AT 40, 19 TO 325, 402 PENCOLOR BLACK

RETURN


PROCEDURE Refresh

   LOCAL Ctrl
   LOCAL aControls := { 'Text_1', 'Text_2', 'Text_3', 'Date_4', 'Check_5', 'Edit_6' }

   FOR EACH Ctrl IN aControls
      Win_1.&(Ctrl).Refresh
   NEXT

   Win_1.Check_5.Value := iif( TEST->MARRIED, 'Yes', 'No' )

   Win_1.Text_1.SetFocus

RETURN


PROCEDURE Save

   LOCAL Ctrl
   LOCAL aControls := { 'Text_1', 'Text_2', 'Text_3', 'Date_4', 'Check_5', 'Edit_6' }

   IF TEST->( NetRecLock() )

      FOR EACH Ctrl IN aControls
         Win_1.&(Ctrl).Save
      NEXT

      TEST->( dbRUnLock() )

   ENDIF

   Refresh()

RETURN


PROCEDURE New

   LOCAL n

   TEST->( dbGoBottom() )
   n := TEST->CODE

   TEST->( NetAppend() )
   TEST->CODE := ++n

   Refresh()

RETURN


PROCEDURE DelRec

   IF TEST->( NetDelete() )

      TEST->( dbRUnLock() )

   ENDIF

   WHILE TEST->( Deleted() )

      TEST->( dbSkip( -1 ) )

   END

   Refresh()

RETURN


PROCEDURE OpenTables

   USE TEST SHARED

   INDEX ON FIELD->CODE TO TEST MEMORY

   GO TOP
   Win_1.Check_5.Value := iif( TEST->MARRIED, 'Yes', 'No' )

   SELECT 0

RETURN


PROCEDURE CloseTables

   CLOSE test

RETURN
