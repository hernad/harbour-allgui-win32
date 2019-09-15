/*
   Marcelo Torres, Noviembre de 2006.
   TActivex para [x]Harbour Minigui.
   Adaptacion del trabajo de:
   ---------------------------------------------
   Oscar Joel Lira Lira [oSkAr]
   Clase TAxtiveX_FreeWin para Fivewin
   Noviembre 8 del 2006
   email: oscarlira78@hotmail.com
   http://freewin.sytes.net
   CopyRight 2006 Todos los Derechos Reservados
   ---------------------------------------------
   Adapted by Grigory Filatov <gfilatov@inbox.ru> from
   http://msdn2.microsoft.com/en-us/library/Aa752043.aspx
*/

#include "hmg.ch"
#include "ax_events.ch"

#ifndef __XHARBOUR__
#include "hbcompat.ch"
#endif

STATIC oWActiveX
STATIC oActiveX
STATIC bVerde := .T.
STATIC lThemed := .F.

FUNCTION Main()

   lThemed := IsThemed()

   DEFINE WINDOW WinDemo ;
         AT 0, 0 ;
         WIDTH 808 ;
         HEIGHT 534 + IF( lThemed, 10, 0 ) ;
         TITLE 'Minigui ActiveX Support Demo' ;
         ICON 'DEMO.ICO' ;
         MAIN ;
         ON INIT fOpenActivex() ;
         ON RELEASE fCloseActivex() ;
         ON SIZE Adjust() ;
         ON MAXIMIZE Adjust() ;
         FONT 'Verdana' ;
         SIZE 10

      @ GetProperty( "WinDemo", "height" ) - 60 - IF( lThemed, GetBorderHeight() + 1, 0 ), 08 LABEL LSemaforo ;
         VALUE " " ;
         WIDTH 27 ;
         HEIGHT 27 ;
         BACKCOLOR { 0, 255, 0 }

      @ GetProperty( "WinDemo", "height" ) - 57 - IF( lThemed, GetBorderHeight() + 1, 0 ), 43 TEXTBOX URL_ToNavigate ;
         HEIGHT 23 ;
         WIDTH GetProperty( "WinDemo", "width" ) - 170 ;
         ON ENTER Navegar()

      @ GetProperty( "WinDemo", "height" ) - 60 - IF( lThemed, GetBorderHeight() + 1, 0 ), ;
         GetProperty( "WinDemo", "width" ) - 115 - IF( lThemed, GetBorderHeight() + 1, 0 ) BUTTON BNavigate ;
         CAPTION 'Navigate' ;
         ACTION Navegar() ;
         WIDTH 100 ;
         HEIGHT 28

      ON KEY F5 ACTION oWActiveX:Refresh()

      @ 5, 10 BUTTON BBack ;
         CAPTION 'Back' ;
         ACTION fGoBack() ;
         WIDTH 74 ;
         HEIGHT 21

      @ 5, 95 BUTTON BForward ;
         CAPTION 'Forward' ;
         ACTION fGoForward() ;
         WIDTH 74 ;
         HEIGHT 21

      @ 5, 180 BUTTON BHome ;
         CAPTION 'Home' ;
         ACTION ( oActiveX:GoHome(), WinDemo.BBack.Enabled := .T. ) ;
         WIDTH 74 ;
         HEIGHT 21

      @ 5, 265 BUTTON BSearch ;
         CAPTION 'Search' ;
         ACTION ( oActiveX:GoSearch(), WinDemo.BBack.Enabled := .T. ) ;
         WIDTH 74 ;
         HEIGHT 21

      @ 5, 350 BUTTON BPrint ;
         CAPTION 'Print' ;
         ACTION Show_DropDownMenu() ;
         WIDTH 74 ;
         HEIGHT 21

      DEFINE CONTEXT MENU CONTROL BPrint
         MENUITEM "Preview..." ACTION fPrint( .T. )
         MENUITEM "Print" ACTION fPrint( .F. )
      END MENU

   END WINDOW

   SET CONTEXT MENU CONTROL BPrint OF WinDemo OFF

   WinDemo.BBack.Enabled := .F.
   WinDemo.BForward.Enabled := .F.

   CENTER WINDOW WinDemo

   ACTIVATE WINDOW WinDemo

RETURN NIL

STATIC PROCEDURE fOpenActivex()

   oWActiveX := TActiveX():New( "WinDemo", "Shell.Explorer.2", 32, 0, ;
      GetProperty( "WinDemo", "width" ) - 2 * GetBorderHeight(), GetProperty( "WinDemo", "height" ) - 102 - IF( lThemed, GetBorderHeight(), 0 ) )

   oWActiveX:EventMap( AX_SE2_PROGRESSCHANGE, "SwitchSemaforo" )
   oWActiveX:EventMap( AX_SE2_TITLECHANGE, {|| TitleChange() } )
   oWActiveX:EventMap( AX_SE2_COMMANDSTATECHANGE, {|| CmdChange() } )
   oWActiveX:EventMap( AX_SE2_DOCUMENTCOMPLETE, "SwitchSemaforo" )

   oActiveX := oWActiveX:Load()

   ChangeStyle( oWActiveX:hWnd, WS_EX_STATICEDGE, , .T. )

   oActiveX:Silent := 1
   oActiveX:Navigate( "www.google.com" )

RETURN

PROCEDURE TitleChange()

   IF oActiveX:ReadyState() < 4
      WinDemo.Title := oActiveX:LocationURL()
      bVerde := .F.
   ENDIF

RETURN

PROCEDURE CmdChange()

   IF oActiveX:ReadyState() < 4
      SetProperty( "WinDemo", "URL_ToNavigate", "value", oActiveX:LocationURL() )
      bVerde := .F.
   ENDIF
   WinDemo.BBack.Enabled := .T.

RETURN

STATIC PROCEDURE fCloseActivex()

   IF ValType( oWActiveX ) <> "U"
      oWActiveX:Release()
   ENDIF

RETURN

PROCEDURE SwitchSemaforo()

   IF oActiveX:Busy()
      IF bVerde
         bVerde := .F.
         WinDemo.LSemaforo.BackColor := { 255, 0, 0 }
      ENDIF
   ELSE
      IF ! bVerde
         bVerde := .T.
         IF oActiveX:ReadyState() < 4
            WinDemo.LSemaforo.BackColor := { 255, 255, 0 }
         ELSE
            WinDemo.LSemaforo.BackColor := { 0, 255, 0 }
            SetProperty( "WinDemo", "URL_ToNavigate", "value", oActiveX:LocationURL() )
         ENDIF
      ENDIF
   ENDIF

RETURN

PROCEDURE Navegar()

   oActiveX:Navigate( GetProperty( "WinDemo", "URL_ToNavigate", "value" ) )

RETURN

STATIC PROCEDURE fGoBack()

   IF ValType( oActiveX ) <> "U"
      Try
         oActiveX:GoBack()
         WinDemo.BForward.Enabled := .T.
      Catch
         WinDemo.BBack.Enabled := .F.
      End
   ENDIF

RETURN

STATIC PROCEDURE fGoForward()

   IF ValType( oActiveX ) <> "U"
      Try
         oActiveX:GoForward()
         WinDemo.BBack.Enabled := .T.
      Catch
         WinDemo.BForward.Enabled := .F.
      End
   ENDIF

RETURN

#define OLECMDID_PRINT 6
#define OLECMDID_PRINTPREVIEW 7
#define OLECMDEXECOPT_DODEFAULT 0

STATIC PROCEDURE fPrint( lPreview )

   IF ValType( oWActiveX ) <> "U"
      IF lPreview
         oActiveX:ExecWB( OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_DODEFAULT )
      ELSE
         oActiveX:ExecWB( OLECMDID_PRINT, OLECMDEXECOPT_DODEFAULT )
      ENDIF
   ENDIF

RETURN

STATIC PROCEDURE Show_DropDownMenu()

   LOCAL aPos := { 0, 0, 0, 0 }

   GetWindowRect( GetControlHandle( "BPrint", "WinDemo" ), aPos )
   TrackPopupMenu( _HMG_xContextMenuHandle, aPos[ 1 ], aPos[ 2 ] + WinDemo.BPrint.Height, GetFormHandle( "WinDemo" ) )

RETURN

PROCEDURE Adjust()

   SetProperty( "WinDemo", "LSemaforo", "row", GetProperty( "WinDemo", "height" ) - 60 - IF( lThemed, GetBorderHeight() + 1, 0 ) )
   SetProperty( "WinDemo", "URL_ToNavigate", "row", GetProperty( "WinDemo", "height" ) - 57 - IF( lThemed, GetBorderHeight() + 1, 0 ) )
   SetProperty( "WinDemo", "URL_ToNavigate", "width", GetProperty( "WinDemo", "width" ) - 170 )
   SetProperty( "WinDemo", "BNavigate", "row", GetProperty( "WinDemo", "height" ) - 60 - IF( lThemed, GetBorderHeight() + 1, 0 ) )
   SetProperty( "WinDemo", "BNavigate", "col", GetProperty( "WinDemo", "width" ) - 115 - IF( lThemed, GetBorderHeight() + 1, 0 ) )
   oWActiveX:Adjust()

RETURN
