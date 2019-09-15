/*
  propósito |relatório produtos em falta
  parâmetros|nenhum
  retorno   |nil
*/
#include "minigui.ch"
#include "miniprint.ch"
*-------------------------------------------------------------------------------
function Produtos_em_Falta()

		 local nTotal_Qtd   := 0
   		 local nTotal_Custo := 0

	   	 local lSuccess
       	 local nLinha  := 40
       	 local u_linha := 260
       	 local nPagina := 1

	   	 local oQuery, cQuery
       	 local oRow   := {}
       	 local n_i := 0

		 oQuery := oServer:Query("select * from produtos order by nome")

	   	 SELECT PRINTER DIALOG TO lSuccess PREVIEW

	   	 if lSuccess == .T.

       	  	START PRINTDOC NAME 'Gerenciador de impressão'
       	  	START PRINTPAGE

               Cabecalho_Produtos_Falta(nPagina)

               nLinha := 40

			   for n_i := 1 to oQuery:LastRec()

			   	   	 oRow := oQuery:GetRow(n_i)

                     if oRow:fieldGet(11) < oRow:fieldGet(12)
                     
                     	@ nLinha,010 PRINT strzero(oRow:fieldGet(1),6) font 'courier new' size 8
                     	@ nLinha,030 PRINT alltrim(oRow:fieldGet(2)) font 'courier new' size 8
                     	@ nLinha,110 PRINT str(oRow:fieldGet(11),6) font 'courier new' size 8
                     	@ nLinha,130 PRINT str(oRow:fieldGet(12),6) font 'courier new' size 8
                     	@ nLinha,160 PRINT str(oRow:fieldGet(11)-oRow:fieldGet(12),6) font 'courier new' size 8

                        nLinha += 5
               		 	if nLinha >= u_linha
			   	  	 	   END PRINTPAGE
                  		   START PRINTPAGE
    		   	  		   nPagina ++
                           Cabecalho_Produtos_Falta(nPagina)
       		   	  		   nLinha := 40
                        endif

                     endif
                     
                     oQuery:Skip(1)
                     
               next n_i
               
         END PRINTPAGE
         END PRINTDOC

	   	 endif

	   	 oQuery:Destroy()

         return(nil)
*-------------------------------------------------------------------------------
function Cabecalho_Produtos_Falta(pPagina)

         @ 010,010 PRINT 'RELAÇÃO DE PRODUTOS EM FALTA' font 'courier new' size 10 bold
         @ 015,010 PRINT 'EMISSÃO: '+Chk_DiaSem(date(),2)+', '+alltrim(str(day(date())))+' de '+Chk_Mes(month(date()),1)+' de '+strzero(year(date()),4)+' - '+time()+'h.' font 'courier new' size 10
         @ 020,010 PRINT 'PÁGINA : '+strzero(pPagina,3) font 'courier new' size 10

         @ 025,000 PRINT LINE TO 025,205 PENWIDTH 0.5 COLOR BLACK

         @ 030,010 PRINT 'CÓD.' font 'courier new' size 8 bold
         @ 030,030 PRINT 'DESCRIÇÃO' font 'courier new' size 8 bold
         @ 030,110 PRINT 'EST.ATUAL' font 'courier new' size 8 bold
         @ 030,130 PRINT 'EST.MINIMO' font 'courier new' size 8 bold
         @ 030,160 PRINT 'DIFERENÇA' font 'courier new' size 8 bold

         return(nil)