/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Author: Igor Nazarov
 *
 * Revised by Grigory Filatov and Sergej Kiselev
*/

#include "minigui.ch"
#include "tsbrowse.ch"

STATIC aFont := {}

MEMVAR oBrw_1

FUNCTION Main()
   LOCAL cDbf := GetStartupFolder() + '\Test_1.dbf'

   REQUEST DBFCDX , DBFFPT

   SET CENTURY ON
   SET DELETED ON

   DEFINE FONT Font_1  FONTNAME "Times New Roman" SIZE 11
   DEFINE FONT Font_2  FONTNAME "Times New Roman" SIZE 10
   DEFINE FONT Font_3  FONTNAME "Times New Roman" SIZE 9 BOLD

   AAdd( aFont, GetFontHandle( "Font_1" ) )
   AAdd( aFont, GetFontHandle( "Font_2" ) )
   AAdd( aFont, GetFontHandle( "Font_3" ) )

   DEFINE WINDOW Form_0 ;
          At 0, 0 ;
          WIDTH 600 ;
          HEIGHT 400 ;
          TITLE 'TsBrowse sample: Incremental search' ;
          ICON 'lupa.ico' ;
          MAIN ;
          NOMAXIMIZE ;
          NOSIZE

      DEFINE LABEL Message
         ROW        7
         COL       10
         WIDTH     80
         HEIGHT    16
         VALUE  'Search for :'
         FONTBOLD .T.
      END LABEL

      DEFINE TEXTBOX Text_1
         ROW       5
         COL      90
         WIDTH   345
         HEIGHT   21
         ON CHANGE {|| RefreshBrowse()}
      END TEXTBOX

      ON KEY ESCAPE ACTION ThisWindow.Release

    END WINDOW

    DEFINE WINDOW Form_1 ;
         AT   0,0   ;
         WIDTH  600 ;
         HEIGHT  40 ;
         CHILD      ;
         NOSYSMENU  ;
         NOCAPTION

      DEFINE LABEL Label_1
         ROW     iif( IsVista().or.IsSeven(), 5, 10 )
         COL     10
         WIDTH  580
         HEIGHT  24
         VALUE   ''
         CENTERALIGN .T.
      END LABEL

    END WINDOW

   ScanSoft( cDbf )

   USE (cDbf) ALIAS 'B1' SHARED READONLY NEW

   CreateBrowse( "oBrw_1", 'Form_0', 30, 2, Form_0.Width-10, Form_0.Height-60, 'B1' )

      oBrw_1:aColumns[1]:cHeading := "Date of" + CRLF + "installation"
      oBrw_1:SetColSize(1, 70)
      oBrw_1:aColumns[1]:nAlign   := DT_CENTER

      oBrw_1:aColumns[2]:cHeading := "Application Name"
      oBrw_1:SetColSize(2, 350)
      oBrw_1:aColumns[2]:nAlign   := DT_LEFT

      oBrw_1:aColumns[3]:cHeading := "Version"
      oBrw_1:SetColSize(3, 120)
      oBrw_1:aColumns[3]:nAlign   := DT_RIGHT

   Form_0.Text_1.Setfocus

   CENTER WINDOW Form_0
   ACTIVATE WINDOW ALL

RETURN Nil


FUNCTION CreateBrowse( cBrw, cParent, nRow, nCol, nWidth, nHeight, cAlias )
   LOCAL oBrw

   PUBLIC &cBrw

   DEFINE TBROWSE &cBrw ;
          AT nRow, nCol ;
          ALIAS cAlias ;
          OF &cParent ;
          WIDTH  nWidth ;
          HEIGHT nHeight ;
          COLORS { CLR_BLACK, CLR_WHITE } ;
          FONT "MS Sans Serif" ;
          SIZE 8 ;
          SELECTOR .T.

      :SetAppendMode( .F. )
      :SetDeleteMode( .F. )

      :lNoHScroll := .T.
      :lCellBrw := .F.
      :nSelWidth := 16

   END TBROWSE

   LoadFields( cBrw, cParent )

   oBrw := TBrw_Obj( cBrw, cParent )

   WITH OBJECT oBrw
      :ChangeFont( aFont[ 1 ],   , 1 )
      :ChangeFont( aFont[ 3 ], 1 , 1 )
      :ChangeFont( aFont[ 3 ],   , 2 )

      :nHeightCell += 6
      :nHeightHead += 18
      :nWheelLines := 1

      :SetColor( { 16 },  {        RGB(  43, 149, 168 )})                             //  SyperHeader backcolor
      :SetColor( {  3 },  {        RGB( 255, 255, 255 )})                             //  Header font color
      :SetColor( {  4 },  { { || { RGB(  43, 149, 168 ), RGB(   0,  54,  94 )}}})     //  Header backcolor
      :SetColor( { 17 },  {        RGB( 255, 255, 255 )})                             //  Font color in SyperHeader
      :SetColor( {  6 },  { { || { RGB( 255, 255,  74 ), RGB( 240, 240,   0 )}}})     //  Cursor backcolor
      :SetColor( { 12 },  { { || { RGB( 128, 128, 128 ), RGB( 250, 250, 250 )}}})     //  Inactive cursor backcolor
      :SetColor( {  2 },  { { ||   RGB( 230, 240, 255 )}})                            //  Grid backcolor
      :SetColor( {  1 },  { { ||   RGB(   0,   0,   0 )}})                            //  Text color in grid
      :SetColor( {  5 },  { { ||   RGB(   0,   0, 255 )}})                            //  Text color of cursor in grid
      :SetColor( { 11 },  { { ||   RGB(   0,   0,   0 )}})                            //  Text color of inactive cursor in grid

      :nClrLine := COLOR_GRID

      :ResetVScroll()
   END OBJECT

RETURN Nil


STATIC FUNCTION TBrw_Obj( cBrw, cParent )          
   Local oBrw, i

   If ( i := GetControlIndex( cBrw, cParent ) ) > 0
      oBrw := _HMG_aControlIds [ i ]
   EndIf

RETURN oBrw


STATIC FUNCTION RefreshBrowse() 
   LOCAL cSeek := Alltrim( Form_0.Text_1.Value )

   IF ! Empty(cSeek)
      oBrw_1:FilterFTS(cSeek, .T.)
   ELSE
      oBrw_1:FilterFTS( Nil )
   ENDIF

RETURN Nil


STATIC FUNCTION ScanSoft(cDbf)
 LOCAL oWmi, oItem
 LOCAL cSW_Name, dSW_InstallDate, cSW_Version
 LOCAL aStr := {}, cAlias

 IF ! File( cDbf )
    AAdd( aStr, { 'F1', 'D',  8, 0 } )
    AAdd( aStr, { 'F2', 'C', 60, 0 } )
    AAdd( aStr, { 'F3', 'C', 20, 0 } )

    DbCreate( cDbf, aStr )

    cAlias := cFileNoExt(cDbf)
    USE (cDbf) ALIAS (cAlias) NEW

    Form_1.Label_1.Value := 'Reading the list of installed programs... Wait, please!'
    Form_1.Center
    Form_1.Show

    oWmi := WmiService()
    FOR EACH oItem IN oWmi:ExecQuery( "SELECT * FROM Win32_Product" )
           dSW_InstallDate := iif( ISSTRING(oItem:InstallDate), STOD( Left( oItem:InstallDate, 8 ) ), Date() )
           cSW_Name := oItem:Caption
           cSW_Version := oItem:Version
           (cAlias)->( DbAppend() )
           (cAlias)->F1 := dSW_InstallDate
           If HB_ISCHAR( cSW_Name )
              (cAlias)->F2 := cSW_Name
           EndIf
           If HB_ISCHAR( cSW_Version )
              (cAlias)->F3 := cSW_Version
           EndIf
    NEXT
    (cAlias)->( DbCloseArea() )

    Form_1.Hide
 ENDIF

RETURN Nil


FUNCTION WMIService()
   Local oLocator
   Static oWmi

   IF oWmi == NIL
         oLocator := CreateObject( "wbemScripting.SwbemLocator" )
         oWmi     := oLocator:ConnectServer()
   ENDIF

RETURN oWmi
