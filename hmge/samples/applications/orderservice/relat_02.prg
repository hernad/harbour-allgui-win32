/*
  propósito |relatórios de ordens de serviço - encerradas - por período
  parâmetros|nenhum
  retorno   |nil
*/

#include "minigui.ch"
#include "miniprint.ch"
*-------------------------------------------------------------------------------
function OS_af2_periodo()

define window form_os_periodo_2;
       at 000,000;
       width 315;
       height 160;
       title 'Relatório: OS Encerradas (por período)';
       icon 'icone';
       modal;
       nosize

       @ 010,005 label lbl_periodo;
                 width 160;
                 value 'Escolha o período';
                 fontcolor BLUE bold
       @ 030,005 label lbl_de;
                 width 025;
                 value 'de';
                 fontcolor BLACK bold
       @ 030,160 label lbl_ate;
                 width 025;
                 value 'até';
                 fontcolor BLACK bold
       @ 030,035 datepicker dpi_de;
                 width 100;
                 value date();
                 tooltip 'clicando na seta aparecerá um calendário'
       @ 030,205 datepicker dpi_ate;
                 width 100;
                 value date();
                 tooltip 'clicando na seta aparecerá um calendário'

       define buttonex btn_imprime
              row 075
              col 095
              width 100
              height 050
              caption 'Imprimir'
              picture 'imprimir'
              fontbold .T.
              lefttext .F.
              action Imprime_OS_Periodo_2()
       end buttonex
       define buttonex btn_volta
              row 075
              col 205
              width 100
              height 050
              caption 'Voltar'
              picture 'img_voltar'
              fontbold .T.
              lefttext .F.
              action form_os_periodo_2.release
       end buttonex

end window

form_os_periodo_2.center
form_os_periodo_2.activate

return(nil)
*-------------------------------------------------------------------------------
function Imprime_OS_Periodo_2()

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

		 dData_01 := td(form_os_periodo_2.dpi_de.value)
  		 dData_02 := td(form_os_periodo_2.dpi_ate.value)

		 oQuery := oServer:Query("select * from os where data>='"+dData_01+"' and data<='"+dData_02+"' and encerrado=1 order by data")

	   	 SELECT PRINTER DIALOG TO lSuccess PREVIEW

	   	 if lSuccess == .T.

       	  	START PRINTDOC NAME 'Gerenciador de impressão'
       	  	START PRINTPAGE

          	cabecalho_os_periodo_2(pagina,form_os_periodo_2.dpi_de.value,form_os_periodo_2.dpi_ate.value)

                for n_i := 1 to oQuery:LastRec()
	   	     		    oRow := oQuery:GetRow(n_i)
                        nNumOS := oRow:fieldGet(2)
                        @ nLinha,010 PRINT 'Nº: '+alltrim(str(nNumOS)) font 'courier new' size 8 bold
                        @ nLinha,040 PRINT 'Data-Hora: '+dtoc(oRow:fieldGet(3))+'-'+alltrim(oRow:fieldGet(4)) font 'courier new' size 8
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Cliente : '+alltrim(oRow:fieldGet(6)) font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Aparelho: '+alltrim(oRow:fieldGet(16)) font 'courier new' size 8
                        @ nLinha,100 PRINT 'Marca: '+alltrim(oRow:fieldGet(17)) font 'courier new' size 8
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Modelo  : '+alltrim(oRow:fieldGet(18)) font 'courier new' size 8
                        @ nLinha,100 PRINT 'Nº Série: '+alltrim(oRow:fieldGet(19)) font 'courier new' size 8
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,010 PRINT 'Defeito : '+alltrim(oRow:fieldGet(22)) font 'courier new' size 8
                        nLinha += 5
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
						/*
						  cabeçalho : serviços e peças
						*/
                        @ nLinha,010 PRINT 'CÓD.' font 'courier new' size 8 bold
                        @ nLinha,020 PRINT 'DESCRIÇÃO' font 'courier new' size 8 bold
                        @ nLinha,100 PRINT 'QTD.' font 'courier new' size 8 bold
                        @ nLinha,120 PRINT 'UNIT.R$' font 'courier new' size 8 bold
                        @ nLinha,150 PRINT 'SUB-TOTAL R$' font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
						/*
						  serviços
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
                           			cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
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
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        endif
                        /*
                          peças
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
                           			cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
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
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,020 PRINT 'TOTAL Serviço(s) R$ :'+trans(nTot_Servico,'@E 999,999.99') font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,020 PRINT 'TOTAL Peça(s)    R$ :'+trans(nTot_Peca,'@E 999,999.99') font 'courier new' size 8 bold
                        nLinha += 4
                        if nLinha >= u_linha
                		   END PRINTPAGE
                		   START PRINTPAGE
                		   pagina ++
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif
                        @ nLinha,020 PRINT 'TOTAL GERAL (OS) R$ :'+trans(nTot_Servico+nTot_Peca,'@E 999,999.99') font 'courier new' size 8 bold
						/*
						  acumular valores para totalização geral
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
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
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
                           cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
                		   nLinha := 35
                        endif

                     oQuery:Skip(1)
                     
 	   		next n_i
			/*
			  final do relatório
			*/
               nLinha += 4
               if nLinha >= u_linha
			   	  END PRINTPAGE
                  START PRINTPAGE
    		   	  pagina ++
            	  cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
       		   	  nLinha := 35
               endif
               @ nLinha,020 PRINT 'TOTAL SERVIÇO R$ :'+trans(nGT_Servico,'@E 999,999.99') font 'courier new' size 8 bold
               nLinha += 4
               if nLinha >= u_linha
			   	  END PRINTPAGE
    		   	  START PRINTPAGE
       		   	  pagina ++
               	  cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
				  nLinha := 35
               endif
               @ nLinha,020 PRINT 'TOTAL PEÇA    R$ :'+trans(nGT_Peca,'@E 999,999.99') font 'courier new' size 8 bold
               nLinha += 4
               if nLinha >= u_linha
			   	  END PRINTPAGE
    		   	  START PRINTPAGE
       		   	  pagina ++
               	  cabecalho_os_periodo_2(Pagina,dData_01,dData_02)
				  nLinha := 35
               endif
               @ nLinha,020 PRINT 'TOTAL GERAL   R$ :'+trans(nGT_Servico+nGT_Peca,'@E 999,999.99') font 'courier new' size 8 bold

         END PRINTPAGE
         END PRINTDOC

	   	 endif
	   	 
	   	 oQuery:Destroy()

	   	 form_os_periodo_2.release

	   	 return(nil)
*-------------------------------------------------------------------------------
function cabecalho_os_periodo_2(pPagina,dData1,dData2)

		 @ 005,010 PRINT 'RELAÇÃO DE ORDENS DE SERVIÇO ENCERRADAS - (Por Período)' font 'courier new' size 10 bold
         @ 010,010 PRINT 'PERÍODO : '+dtoc(dData1)+' até '+dtoc(dData2) font 'courier new' size 10
         @ 015,010 PRINT 'EMISSÃO : '+Chk_DiaSem(date(),2)+', '+alltrim(str(day(date())))+' de '+Chk_Mes(month(date()),1)+' de '+strzero(year(date()),4)+' - '+time()+'h.' font 'courier new' size 10
         @ 020,010 PRINT 'PÁGINA  : '+strzero(pPagina,3) font 'courier new' size 10

         @ 025,000 PRINT LINE TO 025,205 PENWIDTH 0.5 COLOR BLACK

         return(nil)