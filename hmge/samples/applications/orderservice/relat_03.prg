/*
  prop�sito |relat�rios de ordens de servi�o - abertas - por per�odo
  par�metros|nenhum
  retorno   |nil
*/

#include "minigui.ch"
#include "miniprint.ch"
*-------------------------------------------------------------------------------
function OS_tecnico_1()

		 local a_tecnico := {}
		 local n_i := 0
		 local oQuery, cQuery, oRow

  	   	 oQuery := oServer:Query('select * from funcionarios order by nome')
 	   	 for n_i := 1 to oQuery:LastRec()
	   	   	 oRow := oQuery:GetRow(n_i)
  		   	 aadd(a_tecnico,oRow:fieldGet(3))
		   	 oQuery:Skip(1)
	     next n_i

define window form_os_tecnico1;
       at 000,000;
       width 315;
       height 220;
       title 'Relat�rio: OS em Aberto (por t�cnico e per�odo)';
       icon 'icone';
       modal;
       nosize

       @ 010,005 label lbl_periodo;
                 width 160;
                 value 'Escolha o per�odo';
                 fontcolor BLUE bold
       @ 030,005 label lbl_de;
                 width 025;
                 value 'de';
                 fontcolor BLACK bold
       @ 030,160 label lbl_ate;
                 width 025;
                 value 'at�';
                 fontcolor BLACK bold
       @ 030,035 datepicker dpi_de;
                 width 100;
                 value date();
                 tooltip 'clicando na seta aparecer� um calend�rio'
       @ 030,205 datepicker dpi_ate;
                 width 100;
                 value date();
                 tooltip 'clicando na seta aparecer� um calend�rio'
                 
       @ 060,005 label lbl_tecnico;
                 width 160;
                 value 'Escolha o T�cnico';
                 fontcolor BLUE bold
       @ 080,005 comboboxex cbo_tecnico width 300 items a_tecnico height 400 listwidth 300 value 1 font 'verdana' size 10

       define buttonex btn_imprime
              row 135
              col 095
              width 100
              height 050
              caption 'Imprimir'
              picture 'imprimir'
              fontbold .T.
              lefttext .F.
              action Imprime_OS_tecnico_1()
       end buttonex
       define buttonex btn_volta
              row 135
              col 205
              width 100
              height 050
              caption 'Voltar'
              picture 'img_voltar'
              fontbold .T.
              lefttext .F.
              action form_os_tecnico1.release
       end buttonex

end window

form_os_tecnico1.center
form_os_tecnico1.activate

return(nil)
*-------------------------------------------------------------------------------
function Imprime_OS_tecnico_1()

         local nLinha       := 35
         local Pagina       := 1
         local nCod_Cliente := 0
         local nSub_Servico := 0
         local nTot_Servico := 0
         local nSub_Peca    := 0
         local nTot_Peca    := 0
         local nTotal_OS    := 0
         local nGT_Servico  := 0
         local nGT_Peca     := 0
         local nNumOS       := 0
         local dData_01
         local dData_02

	   	 local lSuccess
       	 local v_linha  := 50
       	 local u_linha  := 260
       	 local v_pagina := 1
       	 
	   	 local oQuery, cQuery
	   	 local oQuery_1, cQuery_1
	   	 local oQuery_2, cQuery_2
       	 local oRow   := {}
       	 local oRow_1 := {}
       	 local oRow_2 := {}
       	 local n_i := 0
       	 local n_1 := 0
       	 local n_2 := 0
       	 
	   	 private v_tecnico := alltrim(form_os_tecnico1.cbo_tecnico.item(form_os_tecnico1.cbo_tecnico.value))

		 dData_01 := td(form_os_tecnico1.dpi_de.value)
  		 dData_02 := td(form_os_tecnico1.dpi_ate.value)

		 oQuery := oServer:Query("select * from os where data>='"+dData_01+"' and data<='"+dData_02+"' and nome_atendente='"+v_tecnico+"' and encerrado=0 order by data")

	   	 SELECT PRINTER DIALOG TO lSuccess PREVIEW

	   	 if lSuccess == .T.

       	  	START PRINTDOC NAME 'Gerenciador de impress�o'
       	  	START PRINTPAGE

          	cabecalho_os_periodo(pagina,form_os_tecnico1.dpi_de.value,form_os_tecnico1.dpi_ate.value)

                for n_i := 1 to oQuery:LastRec()
	   	     		    oRow := oQuery:GetRow(n_i)
                        nNumOS := oRow:fieldGet(2)
                        @ nLinha,010 PRINT 'N�: '+alltrim(str(nNumOS)) font 'courier new' size 8 bold
                        @ nLinha,040 PRINT 'Data-Hora: '+dtoc(oRow:fieldGet(3))+'-'+alltrim(oRow:fieldGet(4)) font 'courier new' size 8
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Cliente : '+alltrim(oRow:fieldGet(6)) font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Aparelho: '+alltrim(oRow:fieldGet(16)) font 'courier new' size 8
                        @ nLinha,100 PRINT 'Marca: '+alltrim(oRow:fieldGet(17)) font 'courier new' size 8
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Modelo  : '+alltrim(oRow:fieldGet(18)) font 'courier new' size 8
                        @ nLinha,100 PRINT 'N� S�rie: '+alltrim(oRow:fieldGet(19)) font 'courier new' size 8
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Defeito : '+alltrim(oRow:fieldGet(22)) font 'courier new' size 8
                        nLinha += 5
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
						/*
						  cabe�alho : servi�os e pe�as
						*/
                        @ nLinha,010 PRINT 'C�D.' font 'courier new' size 8 bold
                        @ nLinha,020 PRINT 'DESCRI��O' font 'courier new' size 8 bold
                        @ nLinha,100 PRINT 'QTD.' font 'courier new' size 8 bold
                        @ nLinha,120 PRINT 'UNIT.R$' font 'courier new' size 8 bold
                        @ nLinha,150 PRINT 'SUB-TOTAL R$' font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
						/*
						  servi�os
						*/
						n_1 := 0
	     				oQuery_1 := oServer:Query("select * from os_servicos where numero_os='"+alltrim(str(nNumOS))+"' order by data")
                		for n_1 := 1 to oQuery_1:LastRec()
	   	     		    	     oRow_1 := oQuery_1:GetRow(n_1)
                                 nSub_Servico := (nSub_Servico + (oRow_1:fieldGet(6)*oRow_1:fieldGet(7)) )
                                 nTot_Servico := (nTot_Servico + nSub_Servico)
                                 @ nLinha,010 PRINT strzero(oRow_1:fieldGet(4),4) font 'courier new' size 8
                                 @ nLinha,020 PRINT alltrim(oRow_1:fieldGet(5)) font 'courier new' size 8
                                 @ nLinha,100 PRINT strzero(oRow_1:fieldGet(6),4) font 'courier new' size 8
                                 @ nLinha,120 PRINT trans(oRow_1:fieldGet(7),'@E 9,999.99') font 'courier new' size 8
                                 @ nLinha,150 PRINT trans(oRow_1:fieldGet(8),'@E 99,999.99') font 'courier new' size 8
                                 nSub_Servico := 0
								 oQuery_1:Skip(1)
                                 if oRow_1:fieldGet(3) <> nNumOS
                                    exit
                                 endif
                                 nLinha += 4
                                 if nLinha >= u_linha
                		   		 	END PRINTPAGE
                		   			START PRINTPAGE
                		   			pagina ++
                           			cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   			nLinha := 35
                                 endif
                		next n_1
                        nSub_Servico := 0
                        if nLinha <> 35
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        endif
                        /*
                          pe�as
                        */
						n_2 := 0
	     				oQuery_2 := oServer:Query("select * from os_pecas where numero_os='"+alltrim(str(nNumOS))+"' order by data")
                		for n_2 := 1 to oQuery_2:LastRec()
	   	     		    	     oRow_2 := oQuery_2:GetRow(n_2)
                                 nSub_Peca := (nSub_Peca + (oRow_2:fieldGet(6)*oRow_2:fieldGet(7)) )
                                 nTot_Peca := (nTot_Peca + nSub_Peca)
                                 @ nLinha,010 PRINT strzero(oRow_2:fieldGet(4),4) font 'courier new' size 8
                                 @ nLinha,020 PRINT alltrim(oRow_2:fieldGet(5)) font 'courier new' size 8
                                 @ nLinha,100 PRINT strzero(oRow_2:fieldGet(6),4) font 'courier new' size 8
                                 @ nLinha,120 PRINT trans(oRow_2:fieldGet(7),'@E 9,999.99') font 'courier new' size 8
                                 @ nLinha,150 PRINT trans(oRow_2:fieldGet(8),'@E 99,999.99') font 'courier new' size 8
                                 nSub_Peca := 0
								 oQuery_2:Skip(1)
                                 if oRow_2:fieldGet(3) <> nNumOS
                                    exit
                                 endif
                                 nLinha += 4
                                 if nLinha >= u_linha
                		   		 	END PRINTPAGE
                		   			START PRINTPAGE
                		   			pagina ++
                           			cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   			nLinha := 35
                                 endif
                		next n_2
                        nSub_Peca := 0
						/*
						  totais : parciais
						*/
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,020 PRINT 'TOTAL Servi�o(s) R$ :'+trans(nTot_Servico,'@E 999,999.99') font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,020 PRINT 'TOTAL Pe�a(s)    R$ :'+trans(nTot_Peca,'@E 999,999.99') font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,020 PRINT 'TOTAL GERAL (OS) R$ :'+trans(nTot_Servico+nTot_Peca,'@E 999,999.99') font 'courier new' size 8 bold
						/*
						  acumular valores para totaliza��o geral
						*/
                        nGT_Servico  := (nGT_Servico + nTot_Servico)
                        nGT_Peca     := (nGT_Peca + nTot_Peca)
                        nTot_Servico := 0
                        nTot_Peca    := 0
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        /*
                          linha separadora
                        */
         				@ nlinha,010 PRINT LINE TO nLinha,205 PENWIDTH 0.5 COLOR BLACK
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif

                     oQuery:Skip(1)
                     
 	   		next n_i
			/*
			  final do relat�rio
			*/
               nLinha += 4
               if nLinha >= u_linha
			   	  END PRINTPAGE
                  START PRINTPAGE
    		   	  pagina ++
            	  cabecalho_os_periodo(Pagina,dData_01,dData_02)
       		   	  nLinha := 35
               endif
               @ nLinha,020 PRINT 'TOTAL SERVI�O R$ :'+trans(nGT_Servico,'@E 999,999.99') font 'courier new' size 8 bold
               nLinha += 4
               if nLinha >= u_linha
			   	  END PRINTPAGE
    		   	  START PRINTPAGE
       		   	  pagina ++
               	  cabecalho_os_periodo(Pagina,dData_01,dData_02)
				  nLinha := 35
               endif
               @ nLinha,020 PRINT 'TOTAL PE�A    R$ :'+trans(nGT_Peca,'@E 999,999.99') font 'courier new' size 8 bold
               nLinha += 4
               if nLinha >= u_linha
			   	  END PRINTPAGE
    		   	  START PRINTPAGE
       		   	  pagina ++
               	  cabecalho_os_periodo(Pagina,dData_01,dData_02)
				  nLinha := 35
               endif
               @ nLinha,020 PRINT 'TOTAL GERAL   R$ :'+trans(nGT_Servico+nGT_Peca,'@E 999,999.99') font 'courier new' size 8 bold

         END PRINTPAGE
         END PRINTDOC

	   	 endif
	   	 
	   	 oQuery:Destroy()

	   	 form_os_tecnico1.release

	   	 return(nil)
*-------------------------------------------------------------------------------
static function cabecalho_os_periodo(pPagina,dData1,dData2)

		 @ 005,010 PRINT 'RELA��O DE ORDENS DE SERVI�O ABERTAS - (Por T�CNICO e por Per�odo)' font 'courier new' size 10 bold
		 @ 010,010 PRINT 'T�CNICO : '+v_tecnico font 'courier new' size 10 bold
         @ 015,010 PRINT 'PER�ODO : '+dtoc(dData1)+' at� '+dtoc(dData2) font 'courier new' size 10
         @ 020,010 PRINT 'EMISS�O : '+Chk_DiaSem(date(),2)+', '+alltrim(str(day(date())))+' de '+Chk_Mes(month(date()),1)+' de '+strzero(year(date()),4)+' - '+time()+'h.' font 'courier new' size 10
         @ 025,010 PRINT 'P�GINA  : '+strzero(pPagina,3) font 'courier new' size 10

         @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR BLACK

         return(nil)