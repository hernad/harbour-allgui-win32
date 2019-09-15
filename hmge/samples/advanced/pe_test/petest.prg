/******************************************************************************
   Filename        : PeTest.prg

   Created         : 1 September 2019 (12:00:20)
   Created by      : Pierpaolo Martinello

   Comments        : Free for all purposes
                     This Program is intended for discover the architectural type
                     of executables or dll.
                     You can drag the file to check directly over PeTest.exe, or
                     type it as the PeTest.exe parameter.

*******************************************************************************/

#include "Minigui.ch"
#include "Fileio.ch"

#define IMAGE_FILE_MACHINE_I386  0x14c
#define IMAGE_FILE_MACHINE_IA64  0x200
#define IMAGE_FILE_MACHINE_AMD64 0x8664

PROCEDURE Main(ArgIn)
LOCAL cBuffer, nHandle, nBytes, nPointer
LOCAL cMachineType, hHex
LOCAL cText := "It has a UNKNOWN architecture."

   IF !FILE(ArgIn)
      ArgIn := GetFile({{"dll","*.dll"},{"exe","*.exe"}} ,'OpenFiles(s)',GetcurrentFolder(),.F.,.T. )
      if Empty(ArgIn) // Do not require any action and terminate the prg
         Quit
      Endif
   ENDIF

   nHandle  := FOpen( ArgIn , FO_READ )
   cBuffer  := Space(528) // some executables have the PE string allocated over 512 bits
   nBytes   := FRead(nHandle, @cBuffer, 528)
   FClose( nHandle )

   nPointer := AT( "PE"+CHR(0)+CHR(0), cBuffer )

   IF nPointer > 0
      cMachineType := SUBSTR(cBuffer,nPointer+4,2)

      hHex := Bin2L (cMachineType)

      DO CASE
         CASE hHex = IMAGE_FILE_MACHINE_I386
              cText := "With a 32 Bit architecture."

         CASE hHex = IMAGE_FILE_MACHINE_IA64 .OR. ;
              hHex = IMAGE_FILE_MACHINE_AMD64
              cText := "With a 64 Bit architecture."

      ENDCASE
      MsgInfo(cText,Space(3)+cFilenopath(ArgIn)+ " is build" )
   Else
      MsgStop(cText,Space(3)+cFilenopath(ArgIn))
   Endif

RETURN