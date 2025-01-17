/*----------------------------------------------------------------------------
MINIGUI - Harbour Win32 GUI library source code

Copyright 2002-2010 Roberto Lopez <harbourminigui@gmail.com>
http://harbourminigui.googlepages.com/

GETBOX Control Source Code
Copyright 2006 Jacek Kubica <kubica@wssk.wroc.pl>

Revision patch 2008 By Pierpaolo Martinello <pier.martinello[at]alice.it>

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with
   this software; see the file COPYING. If not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA (or
   visit the web site http://www.gnu.org/).

   As a special exception, you have permission for additional uses of the text
   contained in this release of Harbour Minigui.

   The exception is that, if you link the Harbour Minigui library with other
   files to produce an executable, this does not by itself cause the resulting
   executable to be covered by the GNU General Public License.
   Your use of that executable is in no way restricted on account of linking the
   Harbour-Minigui library code into it.

   Parts of this project are based upon:

   "Harbour GUI framework for Win32"
   Copyright 2001 Alexander S.Kresin <alex@kresin.ru>
   Copyright 2001 Antonio Linares <alinares@fivetech.com>
   www - https://harbour.github.io/

   "Harbour Project"
   Copyright 1999-2019, https://harbour.github.io/

   "WHAT32"
   Copyright 2002 AJ Wos <andrwos@aust1.net>

   "HWGUI"
   Copyright 2001-2018 Alexander S.Kresin <alex@kresin.ru>

---------------------------------------------------------------------------*/
//#define __CLIPPER_COMPAT__

#include "minigui.ch"
#include "i_winuser.ch"
#include "hblang.ch"

#define WM_INVALID   WM_USER + 50
#define WM_CARET     WM_USER + 51

#define GBB1   2
#define GBB2   3

#ifndef __XHARBOUR__
   SET PROCEDURE TO tget\tget.prg
   SET PROCEDURE TO tget\tgetint.prg
#endif

STATIC lInsert
STATIC lClrFocus := .F.
STATIC aClrFocus := { 235, 235, 145 }, aOldBackClr
STATIC aFntFocus, aOldFontClr

*-----------------------------------------------------------------------------*
FUNCTION _DefineGetBox ( ControlName, ParentFormName, x, y, w, h, Value, ;
   FontName, FontSize, aToolTip, lPassword, uLostFocus, uGotFocus, uChange, ;
   right, HelpId, readonly, bold, italic, underline, strikeout, field, backcolor, ;
   fontcolor, invisible, notabstop, nId, valid, cPicture, cmessage, cvalidmessage, ;
   when, ProcedureName, ProcedureName2, abitmap, BtnWidth, lNoMinus, noborder, bInit )
*-----------------------------------------------------------------------------*
   LOCAL ParentFormHandle, ControlHandle
   LOCAL aControlHandle := {}
   LOCAL mVar, lDialogInMemory
   LOCAL FontHandle, nMaxLength
   LOCAL WorkArea, blInit, cBmp, tmp
   LOCAL lBtns := ISBLOCK( ProcedureName ), lBtn2 := ISBLOCK( ProcedureName2 )
   LOCAL lModifyGotFocus := .F.
   LOCAL k, Style, aPicData, oGet
   LOCAL oc := NIL, ow := NIL
#ifdef _OBJECT_
   ow := oDlu2Pixel()
#endif

   IF Empty( field ) .AND. ValType( Value ) == "U"
      MsgMiniGUIError( "GETBOX: Initial Value or Field must be specified." )
   ENDIF

   IF ValType ( Field ) != 'U'
      IF  At ( '>', Field ) == 0
         MsgMiniGuiError ( "Control: " + ControlName + " Of " + ParentFormName + " : You must specify a fully qualified field name." )
      ELSE
         WorkArea := Left ( Field , At ( '>', Field ) - 2 )
         IF Select ( WorkArea ) != 0
            Value := &( Field )
         ENDIF
      ENDIF
   ENDIF

   hb_default( @w, 120 )
   hb_default( @h, 24 )
   __defaultNIL( @uGotFocus, "" )
   __defaultNIL( @uLostFocus, "" )
   hb_default( @lPassword, .F. )
   hb_default( @cPicture, "" )
   hb_default( @noborder, .F. )

   lInsert := IsInsertActive()
   cPicture := Upper( cPicture )

   DO CASE
   CASE ValType ( Value ) == "N" .AND. !( "B" $ cPicture )
      right := .T.
   CASE ValType ( Value ) == "D"
      nMaxLength := Len( DToC( Date() ) )
   CASE ValType ( Value ) == "L"
      nMaxLength := 1
   CASE ValType ( Value ) == "C"
      nMaxLength := Len( Value )
   ENDCASE

   IF ValType ( aBitmap ) != 'A'
      cBmp := aBitmap
      aBitmap := Array( 2 )
      aBitmap[1] := cBmp
   ENDIF

   IF ValType ( aToolTip ) != 'A'
      tmp := aToolTip
      aToolTip := Array( 3 )
      aToolTip[1] := tmp
   ELSE
      IF Len( aToolTip ) < 3
         aToolTip := ASize( aToolTip, 3 )
      ENDIF
   ENDIF

   IF ( FontHandle := GetFontHandle( FontName ) ) != 0
      GetFontParamByRef( FontHandle, @FontName, @FontSize, @bold, @italic, @underline, @strikeout )
   ENDIF

   IF _HMG_BeginWindowActive .OR. _HMG_BeginDialogActive
#ifdef _TSBROWSE_
      IF _HMG_BeginWindowMDIActive
         ParentFormHandle := GetActiveMdiHandle()
         ParentFormName := _GetWindowProperty ( ParentFormHandle, "PROP_FORMNAME" )
      ELSE
#endif
         ParentFormName := iif( _HMG_BeginDialogActive, _HMG_ActiveDialogName, _HMG_ActiveFormName )
#ifdef _TSBROWSE_
      ENDIF
#endif
      __defaultNIL( @FontName, _HMG_ActiveFontName )
      __defaultNIL( @FontSize, _HMG_ActiveFontSize )
   ENDIF

   IF _HMG_FrameLevel > 0 .AND. !_HMG_ParentWindowActive
      x += _HMG_ActiveFrameCol [_HMG_FrameLevel]
      y += _HMG_ActiveFrameRow [_HMG_FrameLevel]
      ParentFormName := _HMG_ActiveFrameParentFormName [_HMG_FrameLevel]
   ENDIF
   lDialogInMemory := _HMG_DialogInMemory

   IF ! _IsWindowDefined( ParentFormName ) .AND. ! lDialogInMemory
      MsgMiniGuiError( "Window: " + IFNIL( ParentFormName, "Parent", ParentFormName ) + " is not defined." )
   ENDIF

   IF _IsControlDefined( ControlName, ParentFormName ) .AND. ! lDialogInMemory
      MsgMiniGuiError( "Control: " + ControlName + " of " + ParentFormName + " already defined." )
   ENDIF

   mVar := '_' + ParentFormName + '_' + ControlName
   k := _GetControlFree()

   IF _HMG_BeginDialogActive
      ParentFormHandle := _HMG_ActiveDialogHandle

      Style := WS_CHILD + ES_AUTOHSCROLL + BS_FLAT + iif( noborder, 0, WS_BORDER )

      IF lPassword
         Style += ES_PASSWORD
      ENDIF

      IF right
         Style += ES_RIGHT
      ENDIF

      IF readonly
         Style += ES_READONLY
      ENDIF

      IF !invisible
         Style += WS_VISIBLE
      ENDIF

      IF !notabstop
         Style += WS_TABSTOP
      ENDIF

      IF Len( _HMG_aDialogTemplate ) > 0        //Dialog Template

         blInit := {|x, y, z| InitDialogTextBox( x, y, z ) }
         AAdd( _HMG_aDialogItems, { nId, k, "EDIT", style, 0, x, y, w, h, Value, HelpId, aTooltip, FontName, FontSize, bold, italic, underline, strikeout, blInit, _HMG_BeginTabActive, .F. , _HMG_ActiveTabPage } )

      ELSE

         ControlHandle := GetDialogItemHandle( ParentFormHandle, nId )

         x := GetWindowCol    ( ControlHandle )
         y := GetWindowRow    ( ControlHandle )
         w := GetWindowWidth  ( ControlHandle )
         h := GetWindowHeight ( ControlHandle )

         SetWindowStyle ( ControlHandle, Style, .T. )
      ENDIF

   ELSE

      ParentFormHandle  := GetFormHandle( ParentFormName )

      aControlHandle := InitGetBox ( ParentFormHandle, 0, x, y, w, h, '', 0, nMaxLength, ;
         .F. , .F. , .F. , lPassword , right , readonly , invisible , notabstop, abitmap[1], BtnWidth, lBtns, abitmap[2], lBtn2, noborder )

      ControlHandle := aControlHandle[1]

   ENDIF

   IF .NOT. lDialogInMemory

      IF FontHandle != 0
         _SetFontHandle( ControlHandle, FontHandle )
      ELSE
         __defaultNIL( @FontName, _HMG_DefaultFontName )
         __defaultNIL( @FontSize, _HMG_DefaultFontSize )
         IF IsWindowHandle( ControlHandle )
            FontHandle := _SetFont ( ControlHandle, FontName, FontSize, bold, italic, underline, strikeout )
         ENDIF
         SetTbBtnMargin ( ControlHandle, BtnWidth, lBtns, lBtn2 )
      ENDIF

      IF _HMG_BeginTabActive
         AAdd ( _HMG_ActiveTabCurrentPageMap , ControlHandle )
      ENDIF

      FOR tmp := 1 TO 3
         IF ValType( aToolTip[tmp] ) != "U"
            SetToolTip ( aControlHandle[tmp], aToolTip[tmp], GetFormToolTipHandle ( ParentFormName ) )
         ENDIF
      NEXT

   ENDIF

   oget := Get()
   oget:New( -1, -1, { | x | iif( x == NIL, oget:cargo, oget:cargo := x ) }, '', cPicture )
   oget:cargo     := Value
   oget:preblock  := when
   oget:postblock := valid
   oget:message   := cmessage
   oget:name      := mVar
   oget:control   := ControlHandle
   oget:SetFocus()
   oget:original  := oGet:Buffer

   aPicData := _GetPictureData( oGet, cPicture )

   IF cPicture == NIL .OR. !( '@K' $ cPicture )
      oget:Clear := .F.
   ENDIF

   IF ! Empty( aPicData[2] ) .AND. oget:type == "C"
      Value := PadR( Value, Len( aPicData[2] ) )
      oget:cargo := Value
   ENDIF

   oGet:UpdateBuffer()

   Public &mVar. := k

   _HMG_aControlType  [k] := "GETBOX"
   _HMG_aControlNames  [k] :=  ControlName
   _HMG_aControlHandles  [k] :=  ControlHandle
   _HMG_aControlParenthandles  [k] :=  ParentFormHandle
   _HMG_aControlIds  [k] :=  nId
   _HMG_aControlProcedures  [k] :=  iif( readonly, NIL, ProcedureName )
   _HMG_aControlPageMap  [k] :=  Field
   _HMG_aControlValue  [k] :=  Value
   _HMG_aControlInputMask  [k] :=  aPicData
   _HMG_aControlLostFocusProcedure [k] :=  uLostFocus
   _HMG_aControlGotFocusProcedure  [k] :=  uGotFocus
   _HMG_aControlChangeProcedure  [k] :=  uChange
   _HMG_aControlDeleted  [k] :=  .F.
   _HMG_aControlBkColor  [k] :=  backcolor
   _HMG_aControlFontColor  [k] :=  fontcolor
   _HMG_aControlDblClick  [k] :=  iif( readonly, NIL, ProcedureName2 )
   _HMG_aControlHeadClick  [k] :=  oGet
   _HMG_aControlRow  [k] :=  y
   _HMG_aControlCol  [k] :=  x
   _HMG_aControlWidth  [k] :=  w
   _HMG_aControlHeight  [k] :=  h
   _HMG_aControlSpacing  [k] :=  cValidMessage
   _HMG_aControlContainerRow  [k] :=  iif ( _HMG_FrameLevel > 0 , _HMG_ActiveFrameRow [_HMG_FrameLevel] , -1 )
   _HMG_aControlContainerCol  [k] :=  iif ( _HMG_FrameLevel > 0 , _HMG_ActiveFrameCol [_HMG_FrameLevel] , -1 )
   _HMG_aControlPicture  [k] :=  ""
   _HMG_aControlContainerHandle  [k] :=  0
   _HMG_aControlFontName  [k] :=  FontName
   _HMG_aControlFontSize  [k] :=  FontSize
   _HMG_aControlFontAttributes  [k] :=  { bold, italic, underline, strikeout }
   _HMG_aControlToolTip  [k] :=  aToolTip
   _HMG_aControlRangeMin  [k] :=  aControlHandle
   _HMG_aControlRangeMax  [k] :=  nMaxLength
   _HMG_aControlCaption  [k] :=  ''
   _HMG_aControlVisible  [k] :=  .NOT. invisible
   _HMG_aControlHelpId  [k] :=  HelpId
   _HMG_aControlFontHandle  [k] :=  FontHandle
   _HMG_aControlBrushHandle  [k] :=  0
   _HMG_aControlEnabled  [k] :=  .T.
   _HMG_aControlMiscData1  [k] :=  { 0, readonly, 0, ProcedureName, ProcedureName2, BtnWidth, lBtn2, lNoMinus }
   _HMG_aControlMiscData2  [k] :=  ''

   IF ISCHARACTER( cPicture ) .AND. ! Empty( cPicture ) .AND. '@K' $ cPicture
      lModifyGotFocus := .T.
   ENDIF

   IF lModifyGotFocus .AND. Empty( uGotFocus )
      IF ValType( Value ) == "C"
         _HMG_aControlGotFocusProcedure [k] := {|| SendMessage( _HMG_aControlHandles [k], EM_SETSEL, 0, iif( Empty( Value ), -1, Len( Trim( ( _HMG_aControlHeadClick [k] ):Cargo ) ) ) ) }
      ELSEIF ValType( Value ) $ "ND"
         _HMG_aControlGotFocusProcedure [k] := {|| SendMessage( _HMG_aControlHandles [k], EM_SETSEL, 0, -1 ) }
      ENDIF
   ENDIF

   IF .NOT. lDialogInMemory
      IF ! Empty( Value )
         IF oGet:type == "N" .AND. At( "B", aPicData[1] ) > 0
            oGet:buffer := LTrim( oGet:buffer )
         ENDIF
         _DispGetBoxText ( ControlHandle , oGet:buffer )
      ENDIF

      IF ValType ( Field ) != 'U'
         AAdd ( _HMG_aFormBrowseList [ GetFormIndex ( ParentFormName ) ] , k )
      ENDIF
   ENDIF

   IF _HMG_lOOPEnabled
      Eval ( _HMG_bOnControlInit, k, mVar )
#ifdef _OBJECT_
      ow := _WindowObj ( ParentFormHandle )
      oc := _ControlObj( ControlHandle )
#endif
   ENDIF

   Do_ControlEventProcedure ( bInit, k, oGet, ow, oc )

RETURN oGet

*-----------------------------------------------------------------------------*
STATIC PROCEDURE _GetBoxSetNextFocus( lPrevious )
*-----------------------------------------------------------------------------*
   LOCAL NextControlHandle, i

   NextControlHandle := GetNextDlgTabITem ( GetActiveWindow() , GetFocus() , lPrevious )
   setfocus ( NextControlHandle )
   i := AScan ( _HMG_aControlHandles , NextControlHandle )
   IF i > 0
      IF _HMG_aControlType [i] == 'BUTTON'
         SendMessage ( NextControlHandle , BM_SETSTYLE , LOWORD ( BS_DEFPUSHBUTTON ) , 1 )
      ENDIF
   ENDIF

RETURN

*-----------------------------------------------------------------------------*
PROCEDURE _DataGetBoxRefresh ( i )
*-----------------------------------------------------------------------------*
   LOCAL Field := _HMG_aControlPageMap [i], hWnd := _HMG_aControlHandles [i]

   IF ValType ( Field ) != 'U'
      _SetGetBoxValue( i, hWnd, &( Field ) )
   ELSE
      _SetGetBoxValue( i, hWnd, _HMG_aControlValue [i] )
   ENDIF

RETURN

*-----------------------------------------------------------------------------*
PROCEDURE _DataGetBoxSave ( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
   LOCAL Field , i
   LOCAL oGet

   i := GetControlIndex ( ControlName , ParentForm )
   oGet := _HMG_aControlHeadClick [i]

   oGet:SetFocus()
   Field := _HMG_aControlPageMap [i]
   &( Field ) := _GetValue ( ControlName , ParentForm )

   oGet:VarPut( &( Field ) )
   oGet:cargo := &( Field )

   IF oGet:type == "D"
      oGet:Buffer := DToC( oGet:cargo )
   ENDIF

RETURN

*-----------------------------------------------------------------------------*
FUNCTION OGETEVENTS( hWnd, nMsg, wParam, lParam )
*-----------------------------------------------------------------------------*
   LOCAL ParentHandle, lshift, lCtrl
   LOCAL nStart, nEnd, coldbuff, h, oGet, ipp, nlen
   LOCAL cText, cPicMask, cPicFunc, lCleanZero, MinDec
   LOCAL aHandle, HwndBtn
   LOCAL lAllowEdit := .T.
#ifndef __XHARBOUR__
   LOCAL aKey
#endif
   LOCAL i := AScan ( _HMG_aControlHandles, hWnd )

   STATIC lInValid := .F.
   STATIC readonly := .F.

   IF i <= 0
      RETURN( 0 )
   ENDIF

   ParentHandle := AScan( _HMG_aFormHandles, _HMG_aControlParentHandles [i] )

   IF ParentHandle <= 0
      RETURN( 0 )
   ENDIF

   cPicFunc   := _HMG_aControlInputMask [i,1]
   cPicMask   := _HMG_aControlInputMask [i,2]
   lCleanZero := _HMG_aControlInputMask [i,3]

   oGet       := _HMG_aControlHeadClick [i]
   readonly   := _HMG_aControlMiscData1 [i,2]

   _HMG_ThisFormName := _HMG_aFormNames [ ParentHandle ]
   _HMG_ThisControlName := _HMG_aControlNames [i]

   IF ValType( oGet:preblock ) == 'B'
      IF !Eval( oGet:preblock, oGet, .F. )
         IF oGet:VarGet() == oGet:UnTransform( oGet:Original )
            lAllowEdit := .F.
         ENDIF
      ENDIF
   ENDIF

   DO CASE

   CASE nMsg == WM_SETFOCUS

      nStart := LoWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) )
      nStart := Min( nStart, Len( Trim( oGet:buffer ) ) )

      nEnd := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) )
      nEnd := Min( nEnd, Len( Trim( oGet:buffer ) ) )

      coldbuff := oGet:buffer

      IF ValType( oGet:preblock ) == 'B'
         IF !Eval( oGet:preblock, oGet, .F. )
            IF oGet:VarGet() == oGet:UnTransform( oGet:Original )
               lAllowEdit := .F.
#ifdef __CLIPPER_COMPAT__
               Tone( 400 )
               PostMessage( hWnd, WM_KEYDOWN, VK_DOWN, 0 )
#endif
            ENDIF
         ENDIF
      ENDIF

      IF lClrFocus .AND. !readonly .AND. lAllowEdit
         aOldBackClr := _HMG_aControlBkColor [i]
         IF _HMG_aControlBkColor [i] == NIL
            _HMG_aControlBkColor [i] := nRGB2Arr ( GetSysColor ( COLOR_WINDOW ) )
         ENDIF
         IF ValType( _HMG_aControlBkColor [i, 1] ) == "N"
            _HMG_aControlBkColor [i] := iif( ISBLOCK ( aClrFocus ), Eval( aClrFocus ), aClrFocus )
         ELSEIF ValType( _HMG_aControlBkColor [i, 1] ) == "A" .AND. Len( _HMG_aControlBkColor [i] ) == 3
            _HMG_aControlBkColor [i][3] := iif( ISBLOCK ( aClrFocus ), Eval( aClrFocus ), aClrFocus )
         ENDIF
         aOldFontClr := _HMG_aControlFontColor [i]
         IF _HMG_aControlFontColor [i] == NIL
            _HMG_aControlFontColor [i] := nRGB2Arr ( GetSysColor ( COLOR_WINDOWTEXT ) )
         ENDIF
         IF aFntFocus != NIL
            IF ValType( _HMG_aControlFontColor [i, 1] ) == "N"
               _HMG_aControlFontColor [i] := iif( ISBLOCK ( aFntFocus ), Eval( aFntFocus ), aFntFocus )
            ELSEIF ValType( _HMG_aControlFontColor [i, 1] ) == "A" .AND. Len( _HMG_aControlFontColor [i] ) == 3
               _HMG_aControlFontColor [i][3] := iif( ISBLOCK ( aFntFocus ), Eval( aFntFocus ), aFntFocus )
            ENDIF
         ENDIF
      ENDIF

      IF !( coldbuff == oGet:buffer )
         IF oGet:BadDate
            _DispGetBoxText( hWnd, CToD( "" ) )
         ELSE
            _DispGetBoxText( hWnd, oGet:buffer )
         ENDIF
      ENDIF

      InvalidateRect( hWnd, 0 )
      PostMessage( hWnd, WM_CARET, 0, 0 )
      _HMG_aControlMiscData1 [i][1] := 1

      IF '@K' $ oGet:Picture .OR. oGet:type == "N"
         oGet:pos := 1 ; nStart := oGet:pos - 1
      ELSE
         oGet:pos := nEnd + 1
      ENDIF
      oGet:changed := .F.
      oGet:UpdateBuffer()

      IF !readonly .AND. lAllowEdit
         _DispGetBoxText( hWnd, oGet:buffer )
      ELSE
         IF oGet:type == "N" .AND. At( "B", cPicFunc ) > 0
            oGet:buffer := LTrim( oGet:buffer )
            _DispGetBoxText( hWnd, oGet:buffer )
         ENDIF
      ENDIF

      SendMessage( hWnd, EM_SETSEL, nStart, nStart )
      _SetGetBoxCaret( hWnd )
      SendMessage( hWnd, EM_SETSEL, nStart, nStart )

      // show message if any
      IF ParentHandle > 0
         IF _IsControlDefined( "StatusBar", _HMG_aFormNames [ ParentHandle ] )
            IF ! Empty( oGet:message )
               SetProperty( _HMG_aFormNames [ ParentHandle ], "StatusBar", "Item", 1, oGet:message )
            ENDIF
         ENDIF
      ENDIF

      RETURN( 0 )

   CASE nMsg == WM_INVALID

      IF _IsChildOfActiveWindow( hWnd ) .AND. !readonly .AND. lAllowEdit

         IF ! lInValid
            lInValid := .T.

            IF ValType( oGet:postblock ) == 'B'
               coldbuff := oGet:buffer

               h := GetFocus()
               HideCaret( hWnd )
               HideCaret( h )

               IF ! Eval( oGet:postblock, oGet )
                  SetFocus( hWnd )
                  IF Empty( _HMG_aControlSpacing [i] )
                     oGet:changed := .T.
                  ELSE
                     oGet:changed := MsgRetryCancel( _HMG_aControlSpacing [i], _HMG_BRWLangError [11], , .F. )
                     IF ! oGet:changed
                        PostMessage( hWnd, WM_KEYDOWN, VK_ESCAPE, 0 )
                     ENDIF
                     SetFocus( hWnd )
                  ENDIF
               ELSE
                  oGet:changed := .T.
                  oGet:original := oGet:buffer
                  ShowCaret( h )
               ENDIF

               IF !( coldbuff == oGet:buffer )
                  _DispGetBoxText( hWnd, oGet:buffer )
               ENDIF
            ELSE
               oGet:changed := .T.
               oGet:original := oGet:buffer
               IF lClrFocus
                  _HMG_aControlBkColor [i] := aOldBackClr
                  _HMG_aControlFontColor [i] := aOldFontClr
               ENDIF
            ENDIF

            lInValid := .F.
         ENDIF

      ENDIF

   CASE nMsg == WM_KILLFOCUS

      IF oGet:Changed
         oGet:assign()
         // Patch By Pier July 2008
         // Add By Pier patch for the smaller negative numbers of zero START
         IF oGet:type == "N" .AND. oGet:minus .AND. Val( SubStr( oget:buffer, 1, At( ",", oget:buffer ) - 1 ) ) == 0
            IF Val( SubStr( oget:buffer, At( ",", oget:buffer ) + 1 ) ) # 0
               MinDec := StrTran( oget:buffer, iif( At( "E", cPicFunc ) > 0, ",", ", " ), "." )
               MinDec := StrTran( MinDec,  " ", "" )
               oget:VarPut( Val( MinDec ) * iif( Val( MinDec ) > 0, -1, 1 ) )
            ENDIF
            oget:buffer := oget:VarGet()
         ENDIF
         // Add By Pier patch for the smaller negative numbers of zero STOP
         oGet:UpdateBuffer()
      ENDIF

      IF ValType( oGet:cargo ) == "D" .AND. oGet:BadDate
         PostMessage( hWnd, WM_INVALID, wParam, 0 )
         RETURN( 0 )
      ENDIF

      IF lCleanZero .AND. oGet:type == "N" .AND. oGet:VarGet() == 0
         oGet:buffer := Space( Len( oGet:buffer ) )
      ENDIF

      IF oGet:type == "N" .AND. At( "B", cPicFunc ) > 0
         oGet:buffer := LTrim( oGet:buffer )
      ENDIF

      IF lClrFocus .AND. !readonly .AND. lAllowEdit
         _HMG_aControlBkColor [i] := aOldBackClr
         _HMG_aControlFontColor [i] := aOldFontClr
      ENDIF
      _DispGetBoxText( hWnd, oGet:buffer )
      SendMessage( hWnd, EM_SETSEL, oGet:pos - 1, oGet:pos - 1 )

      // message
      IF ParentHandle > 0

         IF _IsControlDefined ( "StatusBar" , _HMG_aFormNames [ParentHandle] )

            IF ValType( _HMG_DefaultStatusBarMessage ) == "C" .AND. _IsOwnerDrawStatusBarItem( _HMG_aControlContainerHandle [i], 1 )
               SetProperty( _HMG_aFormNames [ParentHandle], "StatusBar", "Item", 1, _HMG_DefaultStatusBarMessage )
            ELSEIF ValType( cText := _GetDefinedStatusBarItemValue( _HMG_aControlParenthandles [i], 1 ) ) == "C"
               SetProperty( _HMG_aFormNames [ParentHandle], "StatusBar", "Item", 1, cText )
            ELSE
               SetProperty( _HMG_aFormNames [ParentHandle], "StatusBar", "Item", 1, "" )
            ENDIF

         ENDIF

      ENDIF

      // check post-validation
      IF ! lInValid
         PostMessage( hWnd, WM_INVALID, wParam, 0 )
      ENDIF

      RETURN( 0 )

   CASE nMsg == WM_CHAR

      nStart := LoWord ( SendMessage( _HMG_aControlhandles [ i ] , EM_GETSEL , 0 , 0 ) ) + 1
      nEnd   := HiWord ( SendMessage( _HMG_aControlhandles [ i ] , EM_GETSEL , 0 , 0 ) ) + 1
      oGet:pos := nEnd
      _HMG_aControlMiscData1 [i,3] := wParam  //JP

      DO CASE

      CASE wParam == 1  // CTRL+A SelectAll

         SendMessage( _HMG_aControlhandles [ i ] , EM_SETSEL , 0 , -1 )
         RETURN( 0 )

      CASE wParam == 22 // CTRL+V Paste

         SendMessage( _HMG_aControlhandles [ i ] , WM_PASTE , 0 , 0 )
         RETURN( 0 )

      CASE wParam == 3  // CTRL+C Copy

         CopyToClipboard( SubStr( oGet:Buffer, nStart, nEnd - nStart ) )
         RETURN( 0 )

      CASE wParam == 24 .AND. !readonly // CTRL+X Cut

         IF !lAllowEdit .OR. oGet:type == "L"
            RETURN( 0 )
         ENDIF

         CopyToClipboard( SubStr( oGet:Buffer, nStart, nEnd - nStart ) ) //Franz
         nStart := LoWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         nEnd   := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1

         oGet:pos := nEnd

         IF nStart # nEnd

            IF nEnd > Len( oGet:buffer )
               oGet:Delete()
            ENDIF

            FOR ipp := nStart TO nEnd

               IF oGet:pos > nStart
                  oGet:BackSpace()
               ELSE
                  EXIT
               ENDIF

            NEXT

         ELSE

            IF _IsEditable( oGet:pos, i )
               oGet:Delete()
            ENDIF

         ENDIF

         oGet:Assign()
         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL, oGet:pos - 1, oGet:pos - 1 )

         RETURN( 0 )

      CASE wParam == 25 .AND. !readonly // CTRL+Y Clear

         IF !lAllowEdit .OR. oGet:type == "L"
            RETURN( 0 )
         ENDIF

         oGet:DelEnd()

         oGet:Assign()
         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL, oGet:pos - 1, oGet:pos - 1 )

         RETURN( 0 )

      CASE wParam == 0x0D .OR. wParam == 0x09    // Return key or TAB key pressed

         IF ValType( oGet:cargo ) == "D" .AND. oGet:BadDate .AND. !readonly .AND. lAllowEdit
            SendMessage( hWnd, EM_SETSEL, 0, 0 )
            oGet:Pos := 1
         ELSE
            lShift := CheckBit( GetKeyState( VK_SHIFT ), 32768 ) // Shift key pressed (or not)
            _GetBoxSetNextFocus( lShift )
         ENDIF

         RETURN( 0 )

      CASE ( wParam == VK_BACK .AND. lParam # 0 .AND. !readonly .AND. lAllowEdit .AND. oGet:type != "L" )

         IF nEnd > nStart

            IF nEnd > Len( oGet:Buffer ) + 1
               IF oGet:type == "N" .AND. SubStr( oGet:buffer, oGet:pos, 1 ) $ "(-"
                  oGet:minus := .F.
               ENDIF
               oGet:delete()
            ENDIF

            FOR ipp := nStart TO nEnd
               IF oGet:pos > nStart
                  IF oGet:type == "N" .AND. SubStr( oGet:buffer, oGet:pos - 1, 1 ) $ "(-"
                     oGet:minus := .F.
                  ENDIF
                  oGet:backSpace()
               ELSE
                  EXIT
               ENDIF
            NEXT ipp

         ELSE

            IF nEnd > Len( oGet:buffer ) + 1
               IF oGet:type == "N" .AND. SubStr( oGet:buffer, oGet:pos, 1 ) $ "(-"
                  oGet:minus := .F.
               ENDIF
               oGet:Delete()
            ELSE
               IF oGet:type == "N" .AND. SubStr( oGet:buffer, oGet:pos - 1, 1 ) $ "(-"
                  oGet:minus := .F.
               ENDIF
               oGet:BackSpace()
            ENDIF

         ENDIF

         oGet:Assign()
         _HMG_aControlValue[i] := oGet:VarGet()
         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL, ( oGet:pos - 1 ), ( oGet:pos - 1 ) )

         RETURN( 0 )

      CASE wParam >= 32 .AND. wParam < 256  // regular input
         _HMG_aControlMiscData1 [i,3] := 0

         IF readonly .OR. !lAllowEdit
            RETURN( 0 )
         ENDIF

         IF oGet:type == "L"
            nStart := 0
            nEnd := 0
            SendMessage( hWnd, EM_SETSEL, nStart, nEnd )
            oGet:Pos := 1
         ENDIF

         IF wParam <> 46 .AND. wParam <> 44 .AND. Asc( _Input( Chr( wParam ), i ) ) <= 0  // dot and coma
            RETURN( 0 )
         ENDIF

         IF ( "A" $ cPicFunc ) .AND. !IsAlpha( Chr( wParam ) )
            RETURN ( 0 )
         ENDIF

         oGet:changed := .T.

         IF nStart # nEnd
            IF nEnd > Len( oGet:Buffer ) + 1
               oGet:Delete()
            ENDIF
            FOR ipp := nStart TO nEnd  // clear selection by backspacing
               IF oGet:pos > nStart
                  oGet:BackSpace()
               ELSE
                  EXIT
               ENDIF
            NEXT ipp
         ENDIF

         IF oGet:pos == 1
            oGet:home()
         ENDIF

         IF oGet:pos == _FirstEditable( i ) .AND. _HMG_aControlMiscData1 [i][1] == 1 .AND. ( oGet:type == "N" .OR. At( "K", cPicFunc ) > 0 )
            _HMG_aControlMiscData1 [i][1] := 0
            oGet:minus   := .F.
            oGet:clear   := .T.
            oGet:changed := .T.
            oGet:Assign()
            _DispGetBoxText( hWnd, oGet:buffer )
         ELSE
            _HMG_aControlMiscData1 [i][1] := 1
         ENDIF

         IF oGet:type == "N" .AND. ( wParam == 46 .OR. wParam == 44 )

            IF oGet:type == "N"
               nlen := Len( oGet:buffer )
               IF ( ipp := At( '.' , oGet:buffer ) ) > 0
                  oGet:buffer := PadL( StrTran( Left( oGet:Buffer , ipp - 1 ) , " " , "" ) , ipp - 1 ) + ;
                     '.' + PadR( StrTran( SubStr( oGet:Buffer , ipp + 1 ) , " " , "" ) , nlen - ipp , "0" )

               ELSE
                  oGet:buffer := PadL( StrTran( oGet:Buffer , " " , "" ) , nlen )
               ENDIF
            ENDIF

         ELSE

            IF IsInsertActive()
               oGet:Insert( Chr( wParam ) )
            ELSE
               oGet:Overstrike( Chr( wParam ) )
            ENDIF

            IF oGet:Rejected
#ifdef __CLIPPER_COMPAT__
               Tone( 400 )
#endif
            ELSE
               oGet:Assign()
               _HMG_aControlValue[i] := oGet:VarGet()
            ENDIF

         ENDIF

         IF oGet:type == "L"
            oGet:buffer := Upper( oGet:buffer )
            oGet:pos := 1
         ENDIF

         IF oGet:type == "N" .AND. ( wParam == 46 .OR. wParam == 44 )

            oGet:UpdateBuffer()

            IF oGet:DecPos != 0
               IF ( oGet:DecPos == Len( cPicMask ) )
                  oGet:pos := oGet:DecPos - 1   //9999.
               ELSE
                  oGet:pos := oGet:DecPos + 1   //9999.9
               ENDIF
            ELSE
               oGet:pos := oGet:nDispLen
            ENDIF

         ENDIF

         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL , oGet:pos - 1 , oGet:pos - 1 )

         RETURN( 0 )

      ENDCASE

   CASE nMsg == WM_LBUTTONDBLCLK

      IF wParam == MK_LBUTTON
#ifndef __XHARBOUR__
         IF Len( oGet:aKeyEvent ) > 0
            FOR EACH aKey IN oGet:aKeyEvent
               IF Val( aKey[ 1 ] ) == nMsg
                  RETURN oGet:DoKeyEvent( nMsg )
               ENDIF
            NEXT
         ENDIF
#endif
         SendMessage( _HMG_aControlhandles [i] , EM_SETSEL , 0 , -1 )
      ENDIF

   CASE nMsg == WM_KEYDOWN

      IF wParam == 110 .OR. wParam == 190
         RETURN( 0 )
      ENDIF

      nStart := LoWord ( SendMessage( _HMG_aControlhandles [i] , EM_GETSEL , 0 , 0 ) )
      nEnd   := HiWord ( SendMessage( _HMG_aControlhandles [i] , EM_GETSEL , 0 , 0 ) )
      oGet:pos := nEnd + 1
      _HMG_aControlMiscData1 [i,3] := wParam  //JP

#ifndef __XHARBOUR__
      IF Len( oGet:aKeyEvent ) > 0
         FOR EACH aKey IN oGet:aKeyEvent
            IF Val( aKey[ 1 ] ) == wParam
               RETURN oGet:DoKeyEvent( wParam )
            ENDIF
         NEXT
      ENDIF
#endif
      IF wParam == VK_ESCAPE .AND. !readonly

         IF oGet:Type == "N" .AND. oGet:minus == .T. .AND. At( "-", oGet:original ) <= 0
            oGet:Buffer := oGet:Original
            oGet:VarPut( ( oGet:unTransform() ) * ( -1 ), .T. )
            oGet:minus := .F.
            IF oGet:Changed
               oGet:Assign()
               oGet:UpdateBuffer()
            ENDIF
            _HMG_aControlValue[ i ] := oGet:VarGet()
         ELSE
            IF oGet:Changed
               oGet:Buffer := oGet:Original
               oGet:Assign()
               oGet:UpdateBuffer()
            ENDIF
            _HMG_aControlValue[ i ] := oGet:VarGet()
         ENDIF

         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd , EM_SETSEL , 0 , 0 )

         oGet:BadDate := .F.
         lInValid := .F.
         oGet:Pos := 1

         IF ! oGet:changed
            oGet:Buffer := oGet:Original
            IF oGet:Type == "N" .AND. oGet:minus == .T. .AND. At( "-", oGet:original ) <= 0
               oGet:VarPut( ( oGet:unTransform() ) * ( -1 ), .T. )
               oGet:minus := .F.
            ENDIF
            oGet:Assign()
            oGet:UpdateBuffer()
            _HMG_aControlValue[ i ] := oGet:VarGet()
            _GetBoxSetNextFocus( .F. )
         ENDIF

         oGet:Changed := .F.

         RETURN( 0 )

      ENDIF

      lShift := CheckBit( GetKeyState( VK_SHIFT ) , 32768 )
      lCtrl  := CheckBit( GetKeyState( VK_CONTROL ) , 32768 )

      IF lCtrl .AND. wParam == VK_INSERT
         CopyToClipboard( SubStr( oGet:Buffer, nStart, nEnd - nStart ) )
         RETURN( 0 )

      ELSEIF lShift .AND. wParam == VK_INSERT
         SendMessage( hWnd , WM_PASTE , 0 , 0 )
         RETURN( 0 )

      ELSEIF wParam == VK_DOWN

         IF !lCtrl .AND. !lShift
            SendMessage( hWnd , EM_SETSEL , nEnd , nEnd )
            IF ValType( oGet:cargo ) == "D" .AND. oGet:BadDate
               RETURN( 0 )
            ELSE
               _GetBoxSetNextFocus( .F. )
               RETURN( 0 )
            ENDIF
         ELSE
            IF lCtrl .AND. !readonly .AND. lAllowEdit
               IF oGet:type == "D" .OR. oGet:type == "N"
                  oGet:VarPut( oGet:VarGet() - 1 )
                  oGet:UpdateBuffer()
                  _DispGetBoxText( hWnd, oGet:Buffer )
                  oGet:changed := .T.
               ENDIF
               IF oGet:type == "L"
                  oGet:VarPut( ! oGet:VarGet() )
                  oGet:UpdateBuffer()
                  _DispGetBoxText( hWnd, oGet:Buffer )
                  oGet:changed := .T.
               ENDIF
            ENDIF
         ENDIF

         RETURN( 0 )

      ELSEIF wParam == VK_UP

         IF !lCtrl .AND. !lShift
            SendMessage( hWnd , EM_SETSEL , nEnd , nEnd )
            IF ValType( oGet:cargo ) == "D" .AND. oGet:BadDate
               RETURN( 0 )
            ELSE
               _GetBoxSetNextFocus( .T. )
               RETURN( 0 )
            ENDIF
         ELSE
            IF lCtrl .AND. !readonly .AND. lAllowEdit
               IF oGet:type == "D" .OR. oGet:type == "N"
                  oGet:VarPut( oGet:VarGet() + 1 )
                  oGet:UpdateBuffer()
                  _DispGetBoxText( hWnd, oGet:Buffer )
                  oGet:changed := .T.
               ENDIF
               IF oGet:type == "L"
                  oGet:VarPut( ! oGet:VarGet() )
                  oGet:UpdateBuffer()
                  _DispGetBoxText( hWnd, oGet:Buffer )
                  oGet:changed := .T.
               ENDIF
            ENDIF
         ENDIF

         RETURN( 0 )

      ELSEIF wParam == VK_LEFT
         IF lShift
            IF nEnd > nStart
               nEnd --
            ENDIF
            SendMessage( hWnd , EM_SETSEL , nStart , nEnd )
         ELSE
            SendMessage( hWnd , EM_SETSEL , nEnd - 1 , nEnd - 1 )
            _HMG_aControlMiscData1 [i][1] := 0
         ENDIF
         oGet:pos := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1

      ELSEIF wParam == VK_RIGHT
         IF lShift
            nEnd := oGet:Pos
            SendMessage( hWnd , EM_SETSEL , nStart , nEnd )
         ELSE
            SendMessage( hWnd , EM_SETSEL , nStart + 1 , nStart + 1 )
            _HMG_aControlMiscData1 [i][1] := 0
         ENDIF
         oGet:pos := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1

      ELSEIF wParam == VK_HOME
         nStart := 0
         IF !lShift
            nEnd := 0
         ENDIF
         SendMessage( hWnd , EM_SETSEL , nStart , nEnd )

         RETURN( 1 )

      ELSEIF wParam == VK_END
         nEnd := Len( Trim( oGet:Buffer ) )
         IF !lShift
            nStart := nEnd
         ENDIF
         SendMessage( hWnd , EM_SETSEL , nStart , nEnd )

         RETURN( 1 )

      ELSEIF wParam == VK_INSERT
         lInsert := ! lInsert
         _SetGetBoxCaret( hWnd )

      ELSEIF wParam == VK_DELETE

         IF readonly .OR. ! lAllowEdit .OR. oGet:type == "L"
            RETURN( 0 )
         ENDIF

         nStart := LoWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         nEnd   := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         oGet:pos := nEnd

         IF nStart # nEnd

            IF nEnd > Len( oGet:buffer )
               oGet:Delete()
            ENDIF

            FOR ipp := nStart TO nEnd

               IF oGet:pos > nStart
                  IF oGet:type == "N" .AND. SubStr( oGet:buffer, oGet:pos, 1 ) $ "(-"
                     oGet:minus := .F.
                  ENDIF
                  oGet:BackSpace()
               ELSE
                  EXIT
               ENDIF

            NEXT

         ELSE

            IF _IsEditable( oGet:pos , i )
               IF oGet:type == "N" .AND. SubStr( oGet:buffer, oGet:pos, 1 ) $ "(-"
                  oGet:minus := .F.
               ENDIF
               oGet:Delete()
            ENDIF

         ENDIF

         oGet:Assign()

         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL, oGet:pos - 1, oGet:pos - 1 )

         RETURN( 0 )

      ENDIF

   CASE nMsg == WM_PASTE

      IF readonly .OR. ! lAllowEdit
         RETURN( 0 )
      ENDIF

      IF ( cText := RetrieveTextFromClipboard() ) <> NIL

         nStart := LoWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         nEnd   := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         nLen   := Len( oGet:Buffer )

         IF nStart # nEnd
            FOR i := nStart TO nEnd  // clear selection by backspacing
               IF oGet:pos > nStart
                  oGet:BackSpace()
               ELSE
                  EXIT
               ENDIF
            NEXT
         ENDIF

         h := oGet:pos

         FOR i := 1 TO Len( cText )

            wParam := Asc( SubStr( cText, i, 1 ) )

            IF oGet:type == "N" .AND. wParam == 46
               oGet:toDecPos()
            ELSE
               IF IsInsertActive()
                  oGet:Insert( Chr( wParam ) )
               ELSE
                  oGet:Overstrike( Chr( wParam ) )
               ENDIF
            ENDIF

            IF h + i > nLen
               EXIT
            ENDIF

         NEXT
         oGet:Assign()
         oGet:VarPut( oGet:unTransform() )

         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL, oGet:pos - 1, oGet:pos - 1 )

      ENDIF

      RETURN( 0 )

   CASE nMsg == WM_CUT .OR. nMsg == WM_CLEAR

      IF IsWindowEnabled( hWnd ) .AND. !readonly .AND. lAllowEdit

         nStart := LoWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         nEnd := HiWord( SendMessage( hWnd, EM_GETSEL, 0, 0 ) ) + 1
         oGet:pos := nEnd

         IF nStart # nEnd
            IF nEnd > Len( oGet:buffer )
               oGet:delete()
            ENDIF

            FOR i := nStart TO nEnd
               IF oGet:pos > nStart
                  oGet:BackSpace()
               ELSE
                  EXIT
               ENDIF
            NEXT
         ELSE
            oGet:delete()
         ENDIF

         _DispGetBoxText( hWnd, oGet:buffer )
         SendMessage( hWnd, EM_SETSEL, oGet:pos - 1, oGet:pos - 1 )

      ENDIF

      RETURN( 0 )

   CASE nMsg == WM_CARET

      _SetGetBoxCaret( hWnd )

   CASE nMsg == WM_COMMAND

      IF ( HwndBtn := lParam ) > 0

         aHandle := _HMG_aControlRangeMin [i]

         IF ValType( aHandle ) == 'A' .AND. Len( aHandle ) >= 1 .AND. aHandle [1] == hWnd

            SWITCH AScan ( aHandle , HwndBtn )
            CASE GBB1
               _DoControlEventProcedure ( _HMG_aControlProcedures [i] , i )
               EXIT
            CASE GBB2
               _DoControlEventProcedure ( _HMG_aControlDblClick [i] , i )
            ENDSWITCH

            SendMessage ( HwndBtn , BM_SETSTYLE , LOWORD ( BS_PUSHBUTTON ) , 1 )
            setfocus ( aHandle [1] )

         ENDIF

      ENDIF

   ENDCASE

RETURN( 0 )

*-----------------------------------------------------------------------------*
PROCEDURE _SetGetBoxValue( nId, hWnd, Value )
*-----------------------------------------------------------------------------*
   LOCAL aPicData
   LOCAL oGet       := _HMG_aControlHeadClick [nId]
   LOCAL cPicFunc   := _HMG_aControlInputMask [nId, 1]
   LOCAL lCleanZero := _HMG_aControlInputMask [nId, 3]

   IF ValType( Value ) == ValType( oGet:VarGet() )

      _HMG_ThisFormIndex   := AScan ( _HMG_aFormHandles , _HMG_aControlParentHandles [nId] )
      _HMG_ThisFormName    := _HMG_aFormNames [ _HMG_ThisFormIndex ]
      _HMG_ThisControlName := _HMG_aControlNames [nId]

      oGet:VarPut( Value )
      oGet:UpdateBuffer()
      oget:original := oget:buffer

      _HMG_aControlValue [nId] := Value

      IF oGet:type == "N" .AND. Value >= 0
         oGet:minus := .F.
      ENDIF

      IF oGet:type == "N" .AND. ( At( "B", cPicFunc ) > 0 .OR. lCleanZero )
         oGet:buffer := LTrim( oGet:buffer )
      ENDIF

      aPicData := _GetPictureData( oGet, oGet:Picture )

      IF oGet:Picture == NIL .OR. ! ( '@K' $ oGet:Picture )
         oGet:Clear := .F.
      ENDIF

      IF ! Empty( aPicData[2] ) .AND. oGet:type == "C"
         Value := PadR( Value, Len( aPicData [2] ) )
         oGet:cargo := Value
      ENDIF
      IF aPicData [3] .AND. oGet:type == "N" .AND. oGet:VarGet() == 0
         oGet:buffer := Space( Max( Len( oGet:buffer ), Len( aPicData [2] ) ) )
      ENDIF

      _DispGetBoxText( hWnd, oget:buffer )

   ELSE

      MsgMiniGuiError( 'GETBOX: Value Type Mismatch.' )

   ENDIF

RETURN

*-----------------------------------------------------------------------------*
PROCEDURE _SetGetBoxValidMessage( ControlName, ParentForm, cNewMessage )
*-----------------------------------------------------------------------------*
   LOCAL ix := GetControlIndex ( ControlName, ParentForm )

   IF ix > 0 .AND. _HMG_aControlType [ix] == "GETBOX"
      _HMG_aControlSpacing [ix] := cNewMessage
   ENDIF

RETURN

*-----------------------------------------------------------------------------*
FUNCTION _GetGetBoxValidMessage( ControlName, ParentForm )
*-----------------------------------------------------------------------------*
   LOCAL ix := GetControlIndex ( ControlName, ParentForm )
   LOCAL cValidMsg := ""

   IF ix > 0 .AND. _HMG_aControlType [ix] == "GETBOX"
      cValidMsg := _HMG_aControlSpacing [ix]
   ENDIF

RETURN cValidMsg

*-----------------------------------------------------------------------------*
FUNCTION _RangeCheck( oGet, lo, hi )
*-----------------------------------------------------------------------------*
   LOCAL value := oGet:VarGet()

   IF ! oGet:changed
      RETURN .T.
   ENDIF

RETURN ( value >= lo .AND. value <= hi )

*-----------------------------------------------------------------------------*
FUNCTION _SetGetBoxColorFocus( aBackColor, aFontColor )
*-----------------------------------------------------------------------------*
   LOCAL aOldClrFocus := { aClrFocus, aFntFocus }

   lClrFocus := .T.

   IF aBackColor != NIL
      aClrFocus := aBackColor
   ENDIF

   IF aFontColor != NIL
      aFntFocus := aFontColor
   ENDIF

RETURN aOldClrFocus

*-----------------------------------------------------------------------------*
PROCEDURE _DispGetBoxText( hWnd, cText )
*-----------------------------------------------------------------------------*
   LOCAL ControlHandle
   LOCAL i

   IF ( i := AScan ( _HMG_aControlHandles, hWnd ) ) > 0

      ControlHandle := _HMG_aControlHandles [i]

      IF IsWindowHandle( ControlHandle )

         IF And ( GetWindowLong( ControlHandle, GWL_STYLE ), ES_PASSWORD ) == ES_PASSWORD
            SetWindowText ( ControlHandle, Replicate( "*", Len( Trim( cText ) ) ) )
         ELSE
            SetWindowText ( ControlHandle, cText )
         ENDIF

      ENDIF

   ENDIF

RETURN

*-----------------------------------------------------------------------------*
STATIC PROCEDURE _SetGetBoxCaret( hWnd )
*-----------------------------------------------------------------------------*
   HideCaret( hWnd )
   DestroyCaret()

   IF ! IsWindowHasStyle ( hWnd, ES_READONLY )
      CreateCaret( hWnd, 0, iif( lInsert, 2, 4 ), GetWindowHeight( hWnd ) )
      ShowCaret( hWnd )
   ENDIF

RETURN

*-----------------------------------------------------------------------------*
FUNCTION _GetPictureData( oGet, cPicture )
*-----------------------------------------------------------------------------*
   LOCAL nAt
   LOCAL nFor
   LOCAL cNum
   LOCAL cPicFunc
   LOCAL cPicMask
   LOCAL lCleanZero
   LOCAL lDecRev

   IF Left( cPicture, 1 ) == "@"

      nAt := At( " ", cPicture )

      IF nAt == 0
         cPicFunc := Upper( cPicture )
         cPicMask := ""
      ELSE
         cPicFunc := Upper( SubStr( cPicture, 1, nAt - 1 ) )
         cPicMask := LTrim( SubStr( cPicture, nAt + 1 ) )
      ENDIF

      IF "D" $ cPicFunc

         cPicMask := Set( _SET_DATEFORMAT )
         cPicMask := StrTran( cPicmask, "y", "9" )
         cPicMask := StrTran( cPicmask, "Y", "9" )
         cPicMask := StrTran( cPicmask, "m", "9" )
         cPicMask := StrTran( cPicmask, "M", "9" )
         cPicMask := StrTran( cPicmask, "d", "9" )
         cPicMask := StrTran( cPicmask, "D", "9" )

      ENDIF

      IF ( nAt := At( "S", cPicFunc ) ) > 0

         FOR nFor := nAt + 1 TO Len( cPicFunc )
            IF ! IsDigit( SubStr( cPicFunc, nFor, 1 ) )
               EXIT
            ENDIF
         NEXT

         cPicFunc := SubStr( cPicFunc, 1, nAt - 1 ) + SubStr( cPicFunc, nFor )

      ENDIF

      lCleanZero := ( "Z" $ cPicFunc )
      cPicFunc := StrTran( cPicFunc, "Z", "" )

      IF cPicFunc == "@"
         cPicFunc := ""
      ENDIF

   ELSE

      cPicFunc   := ""
      cPicMask   := cPicture
      lCleanZero := .F.

   ENDIF

   IF oGet:type == "D"
      cPicMask := LTrim( cPicMask )
   ENDIF

   IF Empty( cPicMask )

      DO CASE
      CASE oGet:type == "D"

         cPicMask := Set( _SET_DATEFORMAT )
         cPicMask := StrTran( cPicmask, "y", "9" )
         cPicMask := StrTran( cPicmask, "Y", "9" )
         cPicMask := StrTran( cPicmask, "m", "9" )
         cPicMask := StrTran( cPicmask, "M", "9" )
         cPicMask := StrTran( cPicmask, "d", "9" )
         cPicMask := StrTran( cPicmask, "D", "9" )

      CASE oGet:type == "N"

         lDecRev := "," $ Transform( 1.1, "9.9" )
         cNum := Str( oGet:VarGet() )
         IF ( nAt := At( iif( lDecRev, ",", "." ), cNum ) ) > 0
            cPicMask := Replicate( "9", nAt - 1 ) + iif( lDecRev, ",", "." )
            cPicMask += Replicate( "9", Len( cNum ) - Len( cPicMask ) )
         ELSE
            cPicMask := Replicate( "9", Len( cNum ) )
         ENDIF

      CASE oGet:type == "C" .AND. cPicFunc == "@9"

         cPicMask := Replicate( "9", Len( oGet:VarGet() ) )
         cPicFunc := ""
      ENDCASE

   ENDIF

RETURN { cPicFunc, cPicMask, lCleanZero }

*-----------------------------------------------------------------------------*
STATIC FUNCTION _FirstEditable( nId )
*-----------------------------------------------------------------------------*
   LOCAL nFor
   LOCAL oGet := _HMG_aControlHeadClick [nId]
   LOCAL nMaxLen := Len( oGet:Buffer )

   IF nMaxLen != NIL

      IF _IsEditable( 1, nId )
         RETURN 1
      ENDIF

      FOR nFor := 2 TO nMaxLen
         IF _IsEditable( nFor, nId )
            RETURN nFor
         ENDIF
      NEXT

   ENDIF

   oGet:TypeOut := .T.

RETURN 0

*-----------------------------------------------------------------------------*
STATIC FUNCTION _IsEditable( nPos, nId )
*-----------------------------------------------------------------------------*
   LOCAL cChar
   LOCAL oGet
   LOCAL nMaxLen
   LOCAL cPicMask := _HMG_aControlInputMask [nId, 2]

   IF Empty( cPicMask )
      RETURN .T.
   ENDIF

   oGet := _HMG_aControlHeadClick [nId]
   nMaxLen := Len( oGet:Buffer )

   IF nPos > Len( cPicMask ) .AND. nPos <= nMaxLen
      RETURN .T.
   ENDIF

   cChar := SubStr( cPicMask, nPos, 1 )

   IF oGet:type != NIL

      SWITCH  oGet:type

      CASE "C" ; RETURN ( cChar $ "!ANX9#LY" )
      CASE "N" ; RETURN ( cChar $ "9#$*" )
      CASE "D"
      CASE "T" ; RETURN ( cChar == "9" )
      CASE "L" ; RETURN ( cChar $ "LY#" )

      ENDSWITCH

   ENDIF

RETURN .F.

*-----------------------------------------------------------------------------*
STATIC FUNCTION _Input( cChar , nID )
*-----------------------------------------------------------------------------*
   LOCAL oGet     := _HMG_aControlHeadClick [nId]
   LOCAL cPicFunc := _HMG_aControlInputMask [nId, 1]
   LOCAL cPicMask := _HMG_aControlInputMask [nId, 2]
   LOCAL cLangItem_1 := hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 1 )
   LOCAL cLangItem_2 := hb_langMessage( HB_LANG_ITEM_BASE_TEXT + 2 )
   LOCAL cPic

   SWITCH oGet:type
   CASE "N"
      DO CASE
      CASE cChar == "-" .AND. ! _HMG_aControlMiscData1 [nId, 8]
         oGet:minus := .T.  /* The minus symbol can be write in any place */
      CASE cChar == "."
      CASE cChar == ","
         oGet:toDecPos()
         RETURN ""
      CASE !( cChar $ "0123456789+" )
         RETURN ""
      ENDCASE
      EXIT
   CASE "D"
      IF !( cChar $ "0123456789" )
         RETURN ""
      ENDIF
      EXIT
   CASE "L"
      cPic := Upper( cChar )
      IF !( cPic $ "YNTF" + cLangItem_1 + cLangItem_2 )
         RETURN ""
      ENDIF
      IF cPic == cLangItem_1
         cChar := "Y"
      ELSEIF cPic == cLangItem_2
         cChar := "N"
      ENDIF
   ENDSWITCH

   IF ! Empty( cPicFunc )
      IF "R" $ cPicFunc .AND. "E" $ cPicFunc
         cChar := SubStr( Transform( cChar, cPicFunc ), 4, 1 ) // Needed for @RE
      ELSE
         cChar := Left( Transform( cChar, cPicFunc ), 1 ) // Left needed for @D
      ENDIF
   ENDIF

   IF ! Empty( cPicMask )

      cPic := SubStr( cPicMask, oGet:pos, 1 )
#ifdef __XHARBOUR__
      IF ! Empty( cPic )
#endif
         SWITCH cPic
         CASE "A"
           IF ! IsAlpha( cChar )
             cChar := ""
           ENDIF
           EXIT
         CASE "N"
           IF ! IsAlpha( cChar ) .AND. ! IsDigit( cChar )
             cChar := ""
           ENDIF
           EXIT
         CASE "9"
           IF ! IsDigit( cChar ) .AND. cChar != "-"
             cChar := ""
           ENDIF
           EXIT
         CASE "#"
           IF ! IsDigit( cChar ) .AND. !( cChar == " " ) .AND. !( cChar $ ".+-" )
             cChar := ""
           ENDIF
           EXIT
         CASE "L"
           IF !( Upper( cChar ) $ "YNTF" + cLangItem_1 + cLangItem_2 )
             cChar := ""
           ENDIF
           EXIT
         CASE "Y"
           IF !( Upper( cChar ) $ "YN" )
             cChar := ""
           ENDIF
           EXIT
         CASE "$"
           EXIT
         CASE "*"
           IF oGet:type == "N"
             IF ! IsDigit( cChar ) .AND. cChar != "-"
               cChar := ""
             ENDIF
           ELSE
             cChar := Transform( cChar, cPic )
           ENDIF
           EXIT
         DEFAULT
           cChar := Transform( cChar, cPic )
         ENDSWITCH
#ifdef __XHARBOUR__
      ENDIF
#endif
   ENDIF

RETURN cChar

// (JK) HMG 1.1 Experimental Build 12
*-----------------------------------------------------------------------------*
STATIC FUNCTION _GetDefinedStatusBarItemValue( ParentHandle, ItemID )
*-----------------------------------------------------------------------------*
   LOCAL h
   LOCAL nLocID := 0
   LOCAL i

   hb_default( @ItemID, 1 )

   FOR EACH h IN _HMG_aControlParentHandles

      i := hb_enumindex( h )

      IF _HMG_aControlType [i] == "ITEMMESSAGE" .AND. h == ParentHandle
         IF ++nLocID == ItemID
            EXIT
         ENDIF
      ENDIF

   NEXT

RETURN ( _HMG_aControlCaption [i] )
