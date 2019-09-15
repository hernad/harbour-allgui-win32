/*
  sistema     : ordem de serviço
  programa    : calendário
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'

function Calendario()

         define window form_calendario;
                at     000,000;
                width  780;
                height 640;
                title  'Calendário';
                icon   'icone';
                modal ;
                nosize

         @ 0,0 monthcalendar month1

         form_calendario.month1.width  := form_calendario.width
         form_calendario.month1.height := form_calendario.height

		 on key escape action form_calendario.release
		 
         end window

         form_calendario.center
         form_calendario.activate

		 return(nil)