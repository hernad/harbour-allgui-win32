/*
 * MiniGUI Grid Demo
 * (c) 2005 Roberto Lopez
 *
 * ListView SORT ORDER COLUMN 
 * Author: BADIK <badik@mail.ru>
*/

#include "minigui.ch"

Memvar fColor

Function Main

Local aRows [20] [3]

	Private fColor := { |x, CellRowIndex| if ( CellRowIndex/2 == int(CellRowIndex/2) , RGB( 0,0,255 ) , RGB( 0,255,0 ) ) }	

	DEFINE WINDOW Form_1 ;
		AT 0,0 ;
		WIDTH 640 ;
		HEIGHT 400 ;
		TITLE 'Mixed Data Type Grid Test' ;
		MAIN 

		DEFINE MAIN MENU
			DEFINE POPUP 'File'
				MENUITEM 'Set New Columns Order'	ACTION SetOrder()
				MENUITEM 'Get Columns Order'		ACTION GetOrder()
				MENUITEM 'Refresh Grid'			ACTION Form_1.Grid_1.Refresh
				SEPARATOR
				MENUITEM 'Exit'				ACTION Form_1.Release
			END POPUP
		END MENU

		aRows [1]	:= { 113.12,date(),1,1 , .t. }
		aRows [2]	:= { 123.12,date(),2,2 , .f. } 
		aRows [3]	:= { 133.12,date(),3,3, .t. } 
		aRows [4]	:= { 143.12,date(),1,4, .f. } 
		aRows [5]	:= { 153.12,date(),2,5, .t. } 
		aRows [6]	:= { 163.12,date(),3,6, .f. } 
		aRows [7]	:= { 173.12,date(),1,7, .t. } 
		aRows [8]	:= { 183.12,date(),2,8, .f. } 
		aRows [9]	:= { 193.12,date(),3,9, .t. } 
		aRows [10]	:= { 113.12,date(),1,10, .f. } 
		aRows [11]	:= { 123.12,date(),2,11, .t. } 
		aRows [12]	:= { 133.12,date(),3,12, .f. } 
		aRows [13]	:= { 143.12,date(),1,13, .t. } 
		aRows [14]	:= { 153.12,date(),2,14, .f. } 
		aRows [15]	:= { 163.12,date(),3,15, .t. } 
		aRows [16]	:= { 173.12,date(),1,16, .f. } 
		aRows [17]	:= { 183.12,date(),2,17, .t. } 
		aRows [18]	:= { 193.12,date(),3,18, .f. } 
		aRows [19]	:= { 113.12,date(),1,19, .t. } 
		aRows [20]	:= { 123.12,date(),2,20, .f. } 

		@ 10,10 GRID Grid_1 ;
			WIDTH 620 ;
			HEIGHT 330 ;
			HEADERS {'Column 1','Column 2','Column 3','Column 4','Column 5'} ;
			WIDTHS {140,140,140,140,140} ;
			ITEMS aRows ;
			EDIT ;
			INPLACE { ;
				{'TEXTBOX' , 'NUMERIC' , '$ 999,999.99'} , ;
				{'DATEPICKER' , 'DROPDOWN'} , ;
				{'COMBOBOX' , {'One' , 'Two' , 'Three'}} , ;
				{ 'SPINNER' , 1 , 20 } , ;
				{ 'CHECKBOX' , 'Yes' , 'No' } ;
				} ;
			COLUMNWHEN { ;
				{ || This.CellValue > 120 } , ;
				{ || This.CellValue = Date() } , ;
				Nil , ;
				Nil , ;
				Nil ;
				} ;
			DYNAMICFORECOLOR { fColor , fColor, fColor, fColor, fColor } 

	END WINDOW

	CENTER WINDOW Form_1

	ACTIVATE WINDOW Form_1

Return Nil

PROCEDURE SetOrder()
local aColumns := { 5, 4, 3, 2, 1 }

	_SetColumnOrderArray( "Grid_1", "Form_1", aColumns )

	Form_1.Grid_1.Refresh

RETURN

PROCEDURE GetOrder()

	aEval( _GetColumnOrderArray( "Grid_1", "Form_1" ), {|x,i| MsgInfo ( "Column " + hb_ntos ( x ), hb_ntos ( i ) )} )

RETURN

*--------------------------------------------------------------------
Function _GetColumnOrderArray( ControlName, ParentForm )
*--------------------------------------------------------------------
Local i, nColumns, aSort
	i := GetControlIndex( ControlName, ParentForm )
	nColumns := ListView_GetColumnCount( _HMG_aControlHandles [i] )
	aSort := Array( nColumns )
	ListView_GetColumnOrderArray( _HMG_aControlHandles [i], nColumns, @aSort )
Return aSort

*--------------------------------------------------------------------
Function _SetColumnOrderArray( ControlName, ParentForm, aSort )
*--------------------------------------------------------------------
Local i, nColumns
	i := GetControlIndex( ControlName, ParentForm )
	nColumns := ListView_GetColumnCount( _HMG_aControlHandles [i] )
	ListView_SetColumnOrderArray( _HMG_aControlHandles [i], nColumns, aSort )
Return Nil

*--------------------------------------------------------------------
#include <sortcolumns.c>
*--------------------------------------------------------------------
