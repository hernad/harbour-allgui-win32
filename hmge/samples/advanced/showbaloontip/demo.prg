/*
 * MiniGUI Show Baloon Tip Demo
*/

/*
// constant types of icons available for the balloon tip
// see: https://docs.microsoft.com/en-us/windows/desktop/api/commctrl/ns-commctrl-_tageditballoontip
#define TTI_NONE              0
#define TTI_INFO              1
#define TTI_WARNING           2
#define TTI_ERROR             3
#define TTI_INFO_LARGE        4
#define TTI_WARNING_LARGE     5
#define TTI_ERROR_LARGE       6
*/

#include "hmg.ch"

FUNCTION Main

   SET TOOLTIPSTYLE BALLOON

   DEFINE WINDOW Form_1 ;
      WIDTH 460 HEIGHT 360 ;
      TITLE 'Harbour MiniGUI ShowBaloonTip Demo' ;
      ICON 'demo.ico' ;
      MAIN ;
      ON INIT ( Form_1.Edit_1.Value := 'ShowBaloonTip Demo' ) ;
      FONT 'Arial' SIZE 10

      DEFINE STATUSBAR
         STATUSITEM 'HMG Power Ready!' WIDTH 100
         STATUSITEM 'ShowBaloonTip Demo' WIDTH 300
      END STATUSBAR
      
      DEFINE BUTTON Button_1
         ROW 30
         COL 10
         CAPTION 'Edit'
         ACTION ( Form_1.Edit_1.SetFocus )
      END BUTTON
      
      @ 80, 10 EDITBOX Edit_1 ;
         WIDTH 410 ;
         HEIGHT 140 ;
         VALUE '' ;
         TOOLTIP 'EditBox' ;
         MAXLENGTH 255 ;
         ON GOTFOCUS  iif( this.VALUE == 'ShowBaloonTip Demo', ;
                      ShowBaloonTip( this.HANDLE, "Entering editbox zone...", "Warning!", TTI_WARNING_LARGE ), ) ;
         ON LOSTFOCUS HideBalloonTip( this.HANDLE )

      @ 230, 10 TEXTBOX Text_1 ;
         WIDTH 410 ;
         HEIGHT 24 ;
         VALUE '' ;
         TOOLTIP 'Textbox : type some value' ;
         MAXLENGTH 255 ;
         CUEBANNER "Name" ;
         ON GOTFOCUS  iif( Empty( this.VALUE ), ShowBaloonTip( this.HANDLE, "Please, type your name here.", "Hi!", TTI_INFO ), ) ;
         ON LOSTFOCUS HideBalloonTip( this.HANDLE )

   END WINDOW

   Form_1.Center()
   Form_1.Activate()

RETURN NIL


PROCEDURE ShowBaloonTip( hControlHandle, cMessage, cTitle, nType )
   hb_Default( @cMessage, "" )
   hb_Default( @cTitle, "Info" )
   hb_Default( @nType, TTI_NONE )

   MsgBalloon( hControlHandle, cMessage, cTitle, nType )

RETURN


#pragma BEGINDUMP

#define _WIN32_WINNT 0x0600

#include "hbapi.h"
#include "hbapicdp.h"
#include <windows.h>
#include <commctrl.h>

typedef struct _tagEDITBALLOONTIP
{
   DWORD   cbStruct;
   LPCWSTR pszTitle;
   LPCWSTR pszText;
   INT     ttiIcon; // From TTI_*
} EDITBALLOONTIP, *PEDITBALLOONTIP;

#define ECM_FIRST               0x1500      // Edit control messages

#define EM_SHOWBALLOONTIP   (ECM_FIRST + 3)     // Show a balloon tip associated to the edit control
#define Edit_ShowBalloonTip(hwnd, peditballoontip)  (BOOL)SNDMSG((hwnd), EM_SHOWBALLOONTIP, 0, (LPARAM)(peditballoontip))
#define EM_HIDEBALLOONTIP   (ECM_FIRST + 4)     // Hide any balloon tip associated with the edit control
#define Edit_HideBalloonTip(hwnd)  (BOOL)SNDMSG((hwnd), EM_HIDEBALLOONTIP, 0, 0)

// ToolTip Icons (Set with TTM_SETTITLE)
#define TTI_NONE                0
#define TTI_INFO                1
#define TTI_WARNING             2
#define TTI_ERROR               3
#if (_WIN32_WINNT >= 0x0600)
  #define TTI_INFO_LARGE        4
  #define TTI_WARNING_LARGE     5
  #define TTI_ERROR_LARGE       6
#endif  // (_WIN32_WINNT >= 0x0600)

HB_FUNC( MSGBALLOON )
{
   int i, k;
   const char *s;
   WCHAR Text[512];
   WCHAR Title[512];

   EDITBALLOONTIP bl;

   PHB_CODEPAGE  s_cdpHost = hb_vmCDP();

   HWND hWnd = ( HWND ) hb_parnl( 1 );

   if( ! IsWindow( hWnd ) )
      return;

   bl.cbStruct = sizeof( EDITBALLOONTIP );
   bl.pszTitle = NULL;
   bl.pszText  = NULL;
   bl.ttiIcon  = hb_parnidef( 4, TTI_NONE );

   if( HB_ISCHAR( 2 ) )
   {
       ZeroMemory( Text,  sizeof( Text ) );
       k = hb_parclen(2);
       s = (const char *) hb_parc( 2 );
       for(i=0;i<k;i++) 
          Text[i] = hb_cdpGetU16(s_cdpHost, s[i] );
          
       bl.pszText  = Text;
   }

   if( HB_ISCHAR( 3 ) )
   {
      ZeroMemory( Title,  sizeof( Title ) );
      k = hb_parclen(3);
      s = (const char *) hb_parc( 3 );
      for(i = 0; i < k; i++) 
         Title[i] = hb_cdpGetU16( s_cdpHost, s[i] );

      bl.pszTitle  = Title;
   }

   Edit_ShowBalloonTip( hWnd, &bl );
   
}

HB_FUNC( HIDEBALLOONTIP )
{
   HWND hWnd = ( HWND ) hb_parnl( 1 );

   if( IsWindow( hWnd ) )
   {
      Edit_HideBalloonTip( hWnd );
   }
}

#pragma ENDDUMP
