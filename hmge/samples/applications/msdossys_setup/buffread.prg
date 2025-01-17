
#define BUFFLEN  4096

*ΥΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΈ
*³ Function Bopen( <cFileName>, [nAccessMode] )                 ³
*³ Return:   .t. if file was opened                             ³
*³ Assumes:  All file access will be done with the B* functions ³
*ΤΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΎ
function Bopen( cFileName, nAccMode )

default nAccMode to FO_READ // default access mode is Read Only

nHandle := fopen( cFileName, nAccMode )
cLineBuffer := ''
lFullBuff := .t.
nTotBytes := 0
lIsOpen := .t.

return ( nHandle != -1 )

*ΥΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΈ
*³ Function BReadLine()                                         ³
*³ Return:   The next line of the file read buffer              ³
*³ Assumes:  The file pointer will be left as last positioned   ³
*ΤΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΎ
Function BReadLine( cDelimiter )

local ThisLine
local nCrLfAt

default cDelimiter to chr( 13 ) + chr( 10 )

do While .t.
   
   nCrLfAt := at( cDelimiter, cLineBuffer )
   
   if empty( nCrLfAt ) .and. lFullBuff
      BDisk2Buff()
      loop
   endif
   
   if empty( nCrLfAt )
      ThisLine := strtran( cLineBuffer, chr( 26 ) )
      cLineBuffer := ''
   else
      ThisLine := left( cLineBuffer, nCrLfAt - 1 )
      cLineBuffer := substr( cLineBuffer, nCrLfAt + len( cdelimiter ) )
   endif
   
   exit
   
EndDo

Return ThisLine

*ΥΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΈ
*³ Function BDisk2Buff()                                        ³
*³ Return:   .t. if there was no read error                     ³
*ΤΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΎ
STATIC FUNCTION BDisk2Buff()

STATIC cDiskBuffer := ''

if len( cDiskBuffer ) != BUFFLEN
   cDiskBuffer := space( BUFFLEN )
endif

nBytesRead := fread( nHandle, @cDiskBuffer, BUFFLEN )

nTotBytes += nBytesRead

lFullBuff := ( nBytesRead == BUFFLEN )

if lFullBuff
   cLineBuffer += cDiskBuffer
else
   cLineBuffer += left( cDiskBuffer, nBytesRead )
endif

return ferror()

*ΥΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΈ
*³ Function BEof()                                              ³
*³ Return:   TRUE  if End of buffered file                      ³
*³           FALSE if not                                       ³
*ΤΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΎ
Function BEof()

Return !lFullBuff .and. len( cLineBuffer ) == 0

*ΥΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΈ
*³ Function BClose()                                            ³
*ΤΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΎ
Function BClose()

if lIsOpen
   fclose( nHandle )
   lIsOpen := .f.
endif

Return FError()

*ΥΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΈ
*³ Function BPosition()                                         ³
*³ Returns the position of virtual file pointer                 ³
*ΤΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΝΎ
Function BPosition()

Return nTotBytes
