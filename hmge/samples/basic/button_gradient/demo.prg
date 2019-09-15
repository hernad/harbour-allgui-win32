/*
 * MINIGUI - Harbour Win32 GUI library Demo
*/

#include "minigui.ch"

FUNCTION Main()

   LOCAL aButtonBackColor1, aButtonBackColor2, aButtonBackColor3, ;
      aButtonBackColor4, aButtonBackColor5
   LOCAL aGradientFill1, aGradientFill2, aGradientFill3, ;
      aGradientFill4, aGradientFill5, nProcenatGrad
   LOCAL cButtonName, aButtonBackColor := {}, aGradientFill := {}, i

   aButtonBackColor1 := { 21, 10, 245 }
   nProcenatGrad := 10
   aGradientFill1 := GetGradient( aButtonBackColor1, .T., nProcenatGrad, , , 2, .F. )
   AAdd( aButtonBackColor, aButtonBackColor1 )
   AAdd( aGradientFill, aGradientFill1 )

   aButtonBackColor2 := { 222, 180, 250 }
   nProcenatGrad := 15
   aGradientFill2 := GetGradient( aButtonBackColor2, .T., nProcenatGrad, , , 2, .F. )
   AAdd( aButtonBackColor, aButtonBackColor2 )
   AAdd( aGradientFill, aGradientFill2 )

   aButtonBackColor3 := { 68, 146, 208 }
   nProcenatGrad := 20
   aGradientFill3 := GetGradient( aButtonBackColor3, .T., nProcenatGrad, , , 2, .F. )
   AAdd( aButtonBackColor, aButtonBackColor3 )
   AAdd( aGradientFill, aGradientFill3 )

   aButtonBackColor4 := { 22, 91, 194 }
   nProcenatGrad := 25
   aGradientFill4 := GetGradient( aButtonBackColor4, .T., nProcenatGrad, , , 2, .F. )
   AAdd( aButtonBackColor, aButtonBackColor4 )
   AAdd( aGradientFill, aGradientFill4 )

   aButtonBackColor5 := { 22, 91, 194 }
   nProcenatGrad := 30
   aGradientFill5 := GetGradient( aButtonBackColor5, .T., nProcenatGrad, , , 2, .T. )
   AAdd( aButtonBackColor, aButtonBackColor5 )
   AAdd( aGradientFill, aGradientFill5 )

   DEFINE WINDOW Test ;
      WIDTH 610 ;
      HEIGHT 300 ;
      TITLE 'Button Gradient Test' ;
      MAIN

      FOR i := 1 TO 5

         cButtonName := 'Button_' + hb_ntos( i )

         DEFINE BUTTONEX &cButtonName
           ROW 100
           COL 50 + 100 * ( i - 1 )
           WIDTH 80
           HEIGHT 50
           CAPTION cButtonName
           BACKCOLOR aButtonBackColor[ i ]
           FONTCOLOR WHITE
           GRADIENTFILL aGradientFill[ i ]
           NOTRANSPARENT .F.
           HORIZONTAL .F.
           NOHOTLIGHT .F.
           NOXPSTYLE .T.
           ONMOUSEHOVER this.FontColor := YELLOW
           ONMOUSELEAVE iif( ThisWindow.FocusedControl == this.Name, , this.FontColor := WHITE )
         END BUTTONEX

         Test.&( cButtonName ).Action := hb_macroBlock( "AlertInfo( '" + cButtonName + " pressed' )" )

      NEXT

      ON KEY ESCAPE ACTION ThisWindow.Release()

   END WINDOW

   CENTER WINDOW Test
   ACTIVATE WINDOW Test

RETURN NIL


/*
 * Function GetGradient() returns gradient info for input color depending on number of gradients (1 or 2),
 * percentage of color change (to lighter and darker color from input color).
*/
FUNCTION GetGradient( aBackColor, lAutoGradient, nGradPercent, ;
   aGradFrom, aGradTo, nGradPreliv, lInvert )

   LOCAL aColorFrom, aColorTo, nGradientFrom, nGradientTo, nTmp, aGradientFill

   DEFAULT nGradPreliv TO 2
   DEFAULT lInvert TO .T.

   IF lAutoGradient
      aColorFrom := Lighter( aBackColor, 100 - nGradPercent )
      aColorTo := Darker( aBackColor, 100 - nGradPercent )
   ELSE
      aColorFrom := aGradFrom
      aColorTo := aGradTo
   ENDIF

   nGradientFrom := RGB( aColorFrom[ 1 ], aColorFrom[ 2 ], aColorFrom[ 3 ] )
   nGradientTo := RGB( aColorTo[ 1 ], aColorTo[ 2 ], aColorTo[ 3 ] )

   IF lInvert
      nTmp := nGradientTo
      nGradientTo := nGradientFrom
      nGradientFrom := nTmp
   ENDIF

   aGradientFill := iif( nGradPreliv == 1, ;
      { { 1, nGradientFrom, nGradientTo } }, ;
      { { 0.5, nGradientFrom, nGradientTo }, { 0.5, nGradientTo, nGradientFrom } } )

RETURN aGradientFill
