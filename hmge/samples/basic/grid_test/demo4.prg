/*
 * MINIGUI - Harbour Win32 GUI library Demo
 *
*/

#include "hmg.ch"

FUNCTION Main
   LOCAL aItems := {}

   AEval( Array(29), {|| AAdd( aItems, { 0, '', '' } ) } )

   set font to _GetSysFont(), 10

   define window win_1 ;
      width 528 height 300 ;
      title 'Cell Navigation Demo' ;
      main ;
      nomaximize nosize

      define grid grid_1
         row 10
         col 10
         width 501
         height 250
         widths { 80, 200, 200 }
         headers { 'No.', 'Name', 'Description' }
         items aItems
         justify { GRID_JTFY_RIGHT, GRID_JTFY_LEFT, GRID_JTFY_LEFT }
         allowedit .t.
         cellnavigation .t.
         value {1, 1}
      end grid

      on key escape action thiswindow.release()

   end window

   win_1.grid_1.height := GetHeght_ListView(win_1.grid_1.HANDLE, 15)

   win_1.height := win_1.grid_1.height + GetTitleHeight() + 2*GetBorderHeight() + 10
   win_1.Title := (win_1.Title) + ' -> # visible rows: ' + hb_ntos(GetNumOfVisibleRows('grid_1', 'win_1'))
/*
   win_1.grid_1.cell(1, 1) := 1
   win_1.grid_1.cell(15,1) := 15
   win_1.grid_1.cell(29,1) := 29
*/
   win_1.center
   win_1.activate

Return Nil


Function GetNumOfVisibleRows ( ControlName , ParentForm )
   LOCAL i

   i := GetControlIndex ( ControlName , ParentForm )

Return ListviewGetCountPerPage ( GetControlHandleByIndex( i ) )


FUNCTION GetHeght_ListView( hBrw, nRows )  // height Grid \ Browse on the number of rows
   LOCAL a

   a    := ListViewApproximateViewRect( hBrw, nRows - 1 )  // { Width, Height }
   a[1] += Round( GetBorderWidth () / 2, 0 )               // Width
   a[2] += Round( GetBorderHeight() / 2, 0 )               // Height

RETURN a[2]

 
#pragma BEGINDUMP

#include <mgdefs.h>
#include <commctrl.h>

HB_FUNC( LISTVIEWAPPROXIMATEVIEWRECT )
{
  int iCount = hb_parni( 2 );
  DWORD Rc;

  Rc = ListView_ApproximateViewRect( ( HWND ) hb_parnl( 1 ), -1, -1, iCount );

  hb_reta( 2 );
  HB_STORNI( LOWORD( Rc ), -1, 1 );
  HB_STORNI( HIWORD( Rc ), -1, 2 );
}

#pragma ENDDUMP
