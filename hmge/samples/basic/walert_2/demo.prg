/*
 * HMG_Alert() Demo
 *
 * Direct replacement for Clipper Alert() function
 *
 * Copyright (c) Francisco Garcia Fernandez
 *
 * Last Modified by Grigory Filatov at 26-08-2019
 */

ANNOUNCE RDDSYS

#include "minigui.ch"

PROCEDURE MAIN

   LOCAL aBack
   LOCAL bOnInit
   LOCAL lCheck := .F., lResp

   AlertInfo( ;
      AlertYesNoCancel( "This is a first line of your choice.;This is a second line of your choice.", "Please, Select" ), ;
      3 /*timeout in sec*/ )

   AlertStop( "MessageBox Stop", "Stop!" )

   AlertExclamation( "MessageBox Alert" )

   SET MSGALERT BACKCOLOR TO BLUE STOREIN aBack
   SET MSGALERT FONTCOLOR TO YELLOW

   DEFINE FONT DlgFont FONTNAME "Tahoma" SIZE 16

   AlertOKCancel( "MessageBox with the Big Font and Icon Size.", /*title*/, /*def_btn*/, ;
      "demo.ico", 64, { LGREEN, RED }, .T. /*topmost*/ )

   RELEASE FONT DlgFont

   SET MSGALERT BACKCOLOR TO aBack [1]
   SET MSGALERT FONTCOLOR TO aBack [2]

   DEFINE FONT DlgFont FONTNAME "Verdana" SIZE 12

   AlertInfo( ";MessageBox with the user's defined Font and Icon.", "Warning", "alert.ico", 64 )

   RELEASE FONT DlgFont

   SET MSGALERT BACKCOLOR TO { 205, 220, 235 }

   DEFINE FONT DlgFont FONTNAME "Tahoma" SIZE 9

   bOnInit := {||
            HMG_DrawIcon( This.Name, "doc.ico", 100, 25, 32, 34, .F. )
            @ 105, 70 CHECKBOX check1 CAPTION "Delete the real files and folders from the disk(s)" VALUE lCheck ;
                   FONT "Tahoma" SIZE 8 ON CHANGE lCheck := This.Value AUTOSIZE TRANSPARENT
            This.Btn_01.OnGotFocus := {|| This.Btn_01.BackColor := { 241, 220, 144 } }
            This.Btn_01.OnLostFocus := {|| This.Btn_01.BackColor := { 210, 225, 240 } }
            This.Btn_02.OnGotFocus := {|| This.Btn_02.BackColor := { 241, 220, 144 } }
            This.Btn_02.OnLostFocus := {|| This.Btn_02.BackColor := { 210, 225, 240 } }
            AEval( HMG_GetFormControls( This.Name, "OBUTTON" ), ;
                   {|ctl| This.&(ctl).Height := (This.&(ctl).Height) / 1.8, ;
                          This.&(ctl).Row := (This.&(ctl).Row) + 24, ;
                          This.Btn_02.SetFocus, This.Btn_01.SetFocus } )
           }

   lResp := AlertYesNo( "Are you sure you want to remove the selected items from the catalog?", "Confirmation", ;
      /*def_btn*/, "stop.ico", , { { 210, 225, 240 }, { 210, 225, 240 } }, .T. /*topmost*/, bOnInit )

   MsgDebug( lCheck, lResp )

RETURN
