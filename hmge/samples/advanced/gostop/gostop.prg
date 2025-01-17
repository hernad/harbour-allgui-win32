/*
 * MiniGUI Shutdown Process Demo
 *
 * Last modifed 2007.11.07 by
 * Grigory Filatov <gfilatov@inbox.ru> and
 * Kevin Carmody <i@kevincarmody.com>
 *
*/

ANNOUNCE RDDSYS

// Choose a file to open and optionally attempt to shut program down from
// this program.

#include "minigui.ch"

// ***************************************************************************

PROCEDURE Main

   LOCAL lProcess := .N.
   LOCAL nProcess := 0

   DEFINE WINDOW wMain ;
      AT 100, 200 WIDTH 230 HEIGHT 100 ;
      TITLE "Go Stop" ;
      ICON "Toad.ico" ;
      MAIN ;
      NOMAXIMIZE NOSIZE

   DEFINE BUTTON btOpen
      ROW 10
      COL 20
      WIDTH 80
      HEIGHT 50
      CAPTION 'Open file'
      ACTION OpenFile( @lProcess, @nProcess )
   END BUTTON

   DEFINE BUTTON btClose
      ROW 10
      COL 120
      WIDTH 80
      HEIGHT 50
      CAPTION 'Close file'
      ACTION CloseFile( @lProcess, @nProcess )
   END BUTTON

   END WINDOW

   ACTIVATE WINDOW wMain

RETURN

// ***************************************************************************

PROCEDURE OpenFile( lProcess, nProcess )

   LOCAL hProcErr := { ;
      2 => 'File not found',;
      3 => 'Path not found',;
      5 => 'Access denied',;
      8 => 'Out of memory',;
      11 => 'Corrupt EXE file',;
      26 => 'Sharing violation',;
      27 => 'Invalid file association', ;
      28 => 'DDE timeout',;
      29 => 'DDE transaction failed',;
      30 => 'DDE busy',;
      31 => 'No file association',;
      32 => 'DLL not found' }

   LOCAL cFile, cExt, cOpen

   IF lProcess

      MsgStop( 'Program is already running.' )

   ELSE

      cFile := GetFile( { { 'Executive files (*.exe)', '*.exe' }, { 'All files (*.*)', '*.*' } }, ;
         'Open file', iif( IsWinNT(), GetSystemFolder(), GetWindowsFolder() ) )

      IF ! Empty( cFile )

         IF ( cExt := GetExt( cFile ) ) # ".exe"
            cOpen := cFile
            cFile := GetOpenCommand( cExt )
         ENDIF

         nProcess := _Execute( GetActiveWindow(),, AddQuote( cFile ), IFEMPTY( cOpen, NIL, cOpen ),, 5 )
         IF nProcess > 32

            SysWait()

            nProcess := GetProcessID( Upper( cFile ) )

            IF Empty( nProcess )
               MsgStop( 'Can not find process ID.', 'Error' )
            ENDIF

            lProcess := .Y.

         ELSE

            IF nProcess $ hProcErr
               MsgStop( 'Run error ' + LTrim( Str( nProcess ) ) + ': ' + ;
                  hProcErr[ nProcess ], 'Error' )
            ELSE
               MsgStop( 'Unknown run error ' + LTrim( Str( nProcess ) ), 'Error' )
            ENDIF

         ENDIF

      ENDIF

   ENDIF

RETURN

// ***************************************************************************

FUNCTION GetProcessID( cFileName )

   LOCAL cExeName := "", nProcessID := 0, i
   LOCAL aProcessInfo := iif( IsWinNT(), GetProcessesNT(), GetProcessesW9x() )
   LOCAL lWin64 := IsWin64()

   FOR i := 1 TO Len( aProcessInfo ) STEP 2

      IF !Empty( aProcessInfo[ i ] )

         cExeName := Upper( aProcessInfo[ i + 1 ] )
         IF lWin64
            cExeName := StrTran( cExeName, "\SYSWOW64\", "\SYSTEM32\" )
         ENDIF
         IF cExeName == cFileName
            nProcessID := aProcessInfo[ i ]
            EXIT
         ENDIF

      ENDIF

   NEXT

RETURN nProcessID

// ***************************************************************************

FUNCTION GetOpenCommand( cExt )

   LOCAL oReg, cVar1 := "", cVar2 := "", nPos

   IF ! ValType( cExt ) == "C"
      RETURN ""
   ENDIF

   IF ! Left( cExt, 1 ) == "."
      cExt := "." + cExt
   ENDIF

   oReg := TReg32():New( HKEY_CLASSES_ROOT, cExt, .F. )
   cVar1 := RTrim( StrTran( oReg:Get( Nil, "" ), Chr( 0 ), " " ) ) // i.e look for (Default) key
   oReg:close()

   IF ! Empty( cVar1 )

      oReg := TReg32():New( HKEY_CLASSES_ROOT, cVar1 + "\shell\open\command", .F. )
      cVar2 := RTrim( StrTran( oReg:Get( Nil, "" ), Chr( 0 ), " " ) )  // i.e look for (Default) key
      oReg:close()

      IF ( nPos := RAt( " %1", cVar2 ) ) > 0        // look for param placeholder without the quotes (ie notepad)
         cVar2 := SubStr( cVar2, 1, nPos )
      ELSEIF ( nPos := RAt( '"%', cVar2 ) ) > 0     // look for stuff like "%1", "%L", and so forth (ie, with quotes)
         cVar2 := SubStr( cVar2, 1, nPos -1 )
      ELSEIF ( nPos := RAt( '%', cVar2 ) ) > 0      // look for stuff like "%1", "%L", and so forth (ie, without quotes)
         cVar2 := SubStr( cVar2, 1, nPos -1 )
      ELSEIF ( nPos := RAt( ' /', cVar2 ) ) > 0     // look for stuff like "/"
         cVar2 := SubStr( cVar2, 1, nPos -1 )
      ENDIF

   ENDIF

RETURN StrTran( RTrim( cVar2 ), '"', '' )

// ***************************************************************************

PROCEDURE CloseFile( lProcess, nProcess )

   LOCAL nShutdown

   IF lProcess

      // ShutdownProcess(ProcessID, Timeout for WM_CLOSE message)
      nShutdown := ShutdownProcess( nProcess, 2000 )
      DO CASE
      CASE nShutdown > 0
         IF nShutdown == 1
            MsgInfo( 'Program terminated normally.', 'Success' )
         ELSE
            MsgInfo( 'Program killed normally.', 'Success' )
         ENDIF
      CASE nShutdown == 0
         MsgAlert( 'Unable to terminate program.', 'Warning' )
      CASE nShutdown == -1
         MsgStop( 'Unable to access program.', 'Error' )
      OTHERWISE
         MsgStop( 'Unknown shutdown code ' + LTrim( Str( nShutdown ) ), 'Error' )
      ENDCASE

      lProcess := .N.

   ELSE

      MsgAlert( 'No program is running.', 'Warning' )

   ENDIF

RETURN

// ***************************************************************************

FUNCTION AddQuote( cInPath )

   LOCAL cOutPath := AllTrim( cInPath )
   LOCAL cQuote := '"'
   LOCAL cSpace := Space( 1 )

   IF cSpace $ cOutPath .AND. ;
      !( Left( cOutPath, 1 ) == cQuote ) .AND. !( Right( cOutPath, 1 ) == cQuote )

      cOutPath := cQuote + cOutPath + cQuote

   ENDIF

RETURN cOutPath

// ***************************************************************************

FUNCTION GetExt( cFileName )

   LOCAL cTrim  := AllTrim( cFileName )
   LOCAL nDot   := RAt( '.', cTrim )
   LOCAL nSlash := RAt( '\', cTrim )
   LOCAL cExt   := IF( nDot <= nSlash .OR. nDot == nSlash + 1, ;
      '', SubStr( cTrim, nDot ) )

RETURN Lower( cExt )

// ***************************************************************************

PROCEDURE SysWait( nWait )

   DEFAULT nWait TO .5

   hb_IdleSleep( nWait )

RETURN

// ***************************************************************************

/*
   ShutdownProcess()
   Adapted from http://support.microsoft.com/kb/178893
   by Kevin Carmody <i@kevincarmody.com>
*/

#pragma BEGINDUMP

#include <windows.h>
#include "hbapi.h"

#define TA_NOACCESS -1
#define TA_FAILED 0
#define TA_SUCCESS_CLEAN 1
#define TA_SUCCESS_KILL 2

BOOL CALLBACK TerminateAppEnum( HWND hwnd, LPARAM lParam )
{
   DWORD dwID;
   GetWindowThreadProcessId( hwnd, &dwID );
   if( dwID == (DWORD) lParam )
      PostMessage( hwnd, WM_CLOSE, 0, 0 );
   return TRUE;
}

HB_FUNC( SHUTDOWNPROCESS )
{
   HANDLE hProc;
   DWORD dwRet;
   DWORD dwPID;
   DWORD dwTimeoutMsec;

   dwPID = hb_parnl(1);
   dwTimeoutMsec = hb_parnl(2);

   // If we can't open the process with PROCESS_TERMINATE rights,
   // then we give up immediately.
   hProc = OpenProcess( SYNCHRONIZE | PROCESS_TERMINATE, FALSE, dwPID );
   if( hProc == NULL )
      hb_retnl( TA_NOACCESS );

   // TerminateAppEnum() posts WM_CLOSE to all windows whose PID
   // matches your process's.
   EnumWindows( (WNDENUMPROC) TerminateAppEnum, (LPARAM) dwPID );

   // Wait on the handle. If it signals, great. If it times out,
   // then you kill it.
   if( WaitForSingleObject( hProc, dwTimeoutMsec ) != WAIT_OBJECT_0 )
      dwRet = ( TerminateProcess(hProc, 0) ? TA_SUCCESS_KILL : TA_FAILED );
   else
      dwRet = TA_SUCCESS_CLEAN;

   CloseHandle( hProc );
   hb_retnl( dwRet );
}

#pragma ENDDUMP
