/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
 * Data provided by netmarketshare.com for August 2018
 */

#include "hmg.ch"

// define the static arrays for graph show and print routines
STATIC aSeries, aSerieNames, aColors

/////////////////////////////////////////////////////////////
FUNCTION Main

   aSeries := { ;
      40.27, ;
      37.80, ;
      5.86, ;
      5.10, ;
      3.30, ;
      1.51, ;
      1.47, ;
      1.04, ;
      0.98, ;
      2.52  ;
      }

   aSerieNames := { ;
      "Windows 7", ;
      "Windows 10", ;
      "Mac OS X 10.13", ;
      "Windows 8.1", ;
      "Windows XP", ;
      "Linux", ;
      "Mac OS X 10.12", ;
      "Windows 8", ;
      "Mac OS X 10.11", ;
      "Others: Ubuntu, Mac OS X 10.10, Windows Vista" ;
      }

   // using of Netscape 216 color's scheme (51 * n)
   aColors := { ;
      { 51, 102, 153 }, ;
      { 51, 153, 51 }, ;
      { 204, 51, 51 }, ;
      { 204, 153, 0 }, ;
      { 51, 153, 204 }, ;
      { 204, 102, 0 }, ;
      { 102, 102, 153 }, ;
      { 0, 51, 102 }, ;
      { 204, 51, 102 }, ;
      { 102, 51, 204 } ;
      }

   SET FONT TO GetDefaultFontName(), 10

   DEFINE WINDOW m ;
      AT 0, 0 ;
      WIDTH 720 HEIGHT 600 ;
      MAIN ;
      TITLE "Print Pie Graph" ;
      BACKCOLOR { 216, 208, 200 }

   DEFINE BUTTON d
      ROW 10
      COL 10
      CAPTION "Draw"
      ACTION showpie()
   END BUTTON

   DEFINE BUTTON p
      ROW 40
      COL 10
      CAPTION "Print"
      ACTION ( showpie(), printpie() )
   END BUTTON

   DEFINE IMAGE GRAPHAREA
      ROW 10
      COL 160
      WIDTH 400
      HEIGHT 540
      STRETCH .T.
   END IMAGE

   DEFINE BUTTON d2
      ROW 80
      COL 10
      CAPTION "Draw in Bitmap"
      ACTION showpieinBitmap()
   END BUTTON

   DEFINE BUTTON p2
      ROW 110
      COL 10
      CAPTION "Print Bitmap"
      ACTION ( showpieinBitmap(), printgraph() )
   END BUTTON

   END WINDOW

   m.Center()
   m.Activate()

RETURN NIL

/////////////////////////////////////////////////////////////
FUNCTION showpie

   m.grapharea.HIDE
   ERASE WINDOW m

   Create_CONTEXT_Menu( ThisWindow.Name )

   // initialise a default font name
   IF Empty( _HMG_DefaultFontName )
      _HMG_DefaultFontName := GetDefaultFontName()
   ENDIF

   // initialise a default font size
   IF Empty( _HMG_DefaultFontSize )
      _HMG_DefaultFontSize := GetDefaultFontSize()
   ENDIF

   DEFINE PIE IN WINDOW m
      ROW 10
      COL 160
      BOTTOM 550
      RIGHT 560
      TITLE "Desktop Operating System Market Share"
      SERIES aSeries
      DEPTH 25
      SERIENAMES aSerieNames
      COLORS aColors
      3DVIEW .T.
      SHOWXVALUES .T.
      SHOWLEGENDS .T.
      DATAMASK "99.99"
   END PIE

RETURN NIL

/////////////////////////////////////////////////////////////
FUNCTION printpie

   PRINT GRAPH IN WINDOW m ;
      AT 10, 160 ;
      TO 550, 560 ;
      TITLE "Desktop Operating System Market Share" ;
      TYPE PIE ;
      SERIES aSeries ;
      DEPTH 25 ;
      SERIENAMES aSerieNames ;
      COLORS aColors ;
      3DVIEW ;
      SHOWXVALUES ;
      SHOWLEGENDS DATAMASK "99.99"

RETURN NIL

/////////////////////////////////////////////////////////////
FUNCTION showpieinBitmap
   LOCAL hBitmap

   ERASE WINDOW m
   m.grapharea.SHOW

   Create_CONTEXT_Menu( ThisWindow.Name )

   // initialise a default font name
   IF Empty( _HMG_DefaultFontName )
      _HMG_DefaultFontName := GetDefaultFontName()
   ENDIF

   // initialise a default font size
   IF Empty( _HMG_DefaultFontSize )
      _HMG_DefaultFontSize := GetDefaultFontSize()
   ENDIF

   GRAPH BITMAP PIE ;
         SIZE        400, 540 ;
         SERIEVALUES aSeries ;
         SERIENAMES  aSerieNames ;
         SERIECOLORS aColors ;
         PICTURE     "99.99" ;
         TITLE       "Desktop Operating System Market Share" ;
         TITLECOLOR  BLACK ;
         DEPTH       25 ;
         3DVIEW      .T. ;
         SHOWXVALUES .T. ;
         SHOWLEGENDS .T. ;
         NOBORDER    .F. ;
         STOREIN     hBitmap

   m.grapharea.HBITMAP := hBitmap

   m.grapharea.Cargo := { 14 , iif(IsWinNT(), 8, 2) , 262 , 194 }

RETURN hBitmap

/////////////////////////////////////////////////////////////
FUNCTION printgraph

   LOCAL aLocation, cFileName := 'PRINT.PNG'

   BT_BitmapSaveFile( m.grapharea.HBITMAP, cFileName, BT_FILEFORMAT_PNG )

   aLocation := m.grapharea.Cargo

   SELECT PRINTER DEFAULT PREVIEW

   START PRINTDOC

      START PRINTPAGE

         @ aLocation [1], aLocation [2] PRINT IMAGE cFileName WIDTH aLocation [4] HEIGHT aLocation [3] STRETCH

      END PRINTPAGE

   END PRINTDOC

   FErase( cFileName )

RETURN NIL

/////////////////////////////////////////////////////////////
PROCEDURE Create_CONTEXT_Menu ( cForm )

   IF IsContextMenuDefined () == .T.
      Release_CONTEXT_Menu ( cForm )
   ENDIF

   IsContextMenuDefined ( .T. )

   DEFINE CONTEXT MENU OF &cForm

      ITEM 'Change Graph Font Name' ACTION ;
         ( _HMG_DefaultFontName := GetFont ( _HMG_DefaultFontName, _HMG_DefaultFontSize, .F., .F., { 0, 0, 0 }, .F., .F., 0 ) [ 1 ], showpie() )

      ITEM 'Change Graph Font Size' ACTION ;
         ( _HMG_DefaultFontSize := GetFont ( _HMG_DefaultFontName, _HMG_DefaultFontSize, .F., .F., { 0, 0, 0 }, .F., .F., 0 ) [ 2 ], showpie() )

   END MENU

RETURN

/////////////////////////////////////////////////////////////
PROCEDURE Release_CONTEXT_Menu ( cForm )

   IF IsContextMenuDefined () == .F.
      MsgInfo ( "Context Menu not defined" )
      RETURN
   ENDIF

   IsContextMenuDefined ( .F. )

   RELEASE CONTEXT MENU OF &cForm

RETURN

/////////////////////////////////////////////////////////////
FUNCTION IsContextMenuDefined ( lNewValue )

   STATIC IsContextMenuDefined := .F.
   LOCAL lOldValue := IsContextMenuDefined

   IF ISLOGICAL( lNewValue )
      IsContextMenuDefined := lNewValue
   ENDIF

RETURN lOldValue
