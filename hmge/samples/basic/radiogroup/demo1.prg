/*
 * HMG RadioGroup Demo
 * (c) 2010 Roberto Lopez <mail.box.hmg@gmail.com>
*/

#include "minigui.ch"

Function Main

	Define Window Win1			;	
		Row	10			;
		Col	10			;
		Width	400			;	
		Height	400			;	
		Title	'HMG RadioGroup Demo'	;
		WindowType MAIN			;
		On Init	Win1.Center()
		
		Define Main Menu
			Define Popup "&Properties"
				MenuItem "Change Value" action Win1.RadioGroup2.Value := 3
				MenuItem "Get Value" action Msginfo(Win1.RadioGroup2.Value)
				Separator
				MenuItem "Change Options" action Win1.RadioGroup2.Options := {"New Item 1","New Item 2","New Item 3","New Item 4"}
				MenuItem "Get Options" action MsgDebug(Win1.RadioGroup2.Options)
				Separator
				MenuItem "Change Spacing" action SetProperty('Win1','RadioGroup2','Spacing',32)
				MenuItem "Get Spacing" action Msginfo(Win1.RadioGroup2.Spacing,'RadioGroup2 Spacing')
				Separator
				MenuItem "Set Horizontal orientation" action sethorizontal('RadioGroup2','Win1')
			End Popup
		End Menu
      
		@ 40,10 RadioGroup RadioGroup1;   		      
			Options {"Item 1","Item 2","Item 3"};
			Width	60;
			Spacing 20;
			Value	2;
			Horizontal;
			Tooltip	'Horizontal Radiogroup';
			On Change MsgInfo("Radiogroup 1 Value Changed!")

		@ 110, 10 RadioGroup Radiogroup2;
			Options {"Option 1","Option 2","Option 3","Option 4"};
			Width 240;
			Tooltip	'Vertical Radiogroup';
			On Change {||MsgInfo("Radiogroup 2 Value Changed!")}

	End Window

	Activate Window Win1

Return Nil


Procedure sethorizontal(control,form)
local i:=getcontrolindex(control,form)
local aoptions:=_HMG_aControlCaption [i]
local nvalue:=_HMG_aControlValue [i]

	domethod(Form, Control, 'release')
	do events

	@ 110, 10 RadioGroup Radiogroup2 of &form ;
		Options aoptions ;
		Horizontal;
		Width 80;
		Spacing 12;
		Value nvalue;
		Tooltip	'Horizontal Radiogroup' ;
		On Change {||MsgInfo("Radiogroup 2 Value Changed!")}

Return
