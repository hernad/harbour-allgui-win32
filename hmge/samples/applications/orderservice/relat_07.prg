/*
  propósito |relatório posição estoque dos produtos
  parâmetros|nenhum
  retorno   |nil
*/
#include "minigui.ch"
#include "miniprint.ch"
*-------------------------------------------------------------------------------
function Posicao_Estoque()

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

               Cabecalho_Estoque_Produtos(nPagina)
               
               nLinha := 40

			   for n_i := 1 to oQuery:LastRec()

			   	   	 oRow := oQuery:GetRow(n_i)

                     @ nLinha,010 PRINT strzero(oRow:fieldGet(1),6) font 'courier new' size 8
                     @ nLinha,030 PRINT alltrim(oRow:fieldGet(2)) font 'courier new' size 8
                     @ nLinha,110 PRINT str(oRow:fieldGet(11),6) font 'courier new' size 8
                     @ nLinha,130 PRINT trans(oRow:fieldGet(7),'@E 99,999.99') font 'courier new' size 8
                     @ nLinha,160 PRINT trans(oRow:fieldGet(7)*oRow:fieldGet(11),'@E 999,999.99') font 'courier new' size 8

                     nLinha += 5
               		 if nLinha >= u_linha
			   	  	 	END PRINTPAGE
                  		START PRINTPAGE
    		   	  		nPagina ++
                        Cabecalho_Estoque_Produtos(nPagina)
       		   	  		nLinha := 40
                     endif

                     nTotal_Qtd   := ( nTotal_Qtd + oRow:fieldGet(11) )
                     nTotal_Custo := ( nTotal_Custo + ( oRow:fieldGet(7) * oRow:fieldGet(11) ) )

                     oQuery:Skip(1)
                     
               next n_i
               
               nLinha += 10
			   if nLinha >= u_linha
	  	 	   	  END PRINTPAGE
          		  START PRINTPAGE
 	  			  nPagina ++
         		  Cabecalho_Estoque_Produtos(nPagina)
	   	  		  nLinha := 40
               endif

               @ nLinha,020 PRINT 'Total Quantidade : '+alltrim(str(nTotal_Qtd)) font 'courier new' size 10 bold

               nLinha += 5
			   if nLinha >= u_linha
	  	 	   	  END PRINTPAGE
          		  START PRINTPAGE
 	  			  nPagina ++
         		  Cabecalho_Estoque_Produtos(nPagina)
	   	  		  nLinha := 40
               endif

               @ nLinha,020 PRINT 'Total Estoque    : '+alltrim(trans(nTotal_Custo,'@E 999,999,999.99')) font 'courier new' size 10 bold

         END PRINTPAGE
         END PRINTDOC

	   	 endif

	   	 oQuery:Destroy()

         return(nil)
*-------------------------------------------------------------------------------
function Cabecalho_Estoque_Produtos(pPagina)

         @ 010,010 PRINT 'RELAÇÃO DA POSIÇÃO DE ESTOQUE DOS PRODUTOS' font 'courier new' size 10 bold
         @ 015,010 PRINT 'EMISSÃO: '+Chk_DiaSem(date(),2)+', '+alltrim(str(day(date())))+' de '+Chk_Mes(month(date()),1)+' de '+strzero(year(date()),4)+' - '+time()+'h.' font 'courier new' size 10
         @ 020,010 PRINT 'PÁGINA : '+strzero(pPagina,3) font 'courier new' size 10
         
         @ 025,000 PRINT LINE TO 025,205 PENWIDTH 0.5 COLOR BLACK
         
         @ 030,010 PRINT 'CÓD.' font 'courier new' size 8 bold
         @ 030,030 PRINT 'DESCRIÇÃO' font 'courier new' size 8 bold
         @ 030,110 PRINT 'QUANT.' font 'courier new' size 8 bold
         @ 030,130 PRINT 'VALOR CUSTO R$' font 'courier new' size 8 bold
         @ 030,160 PRINT 'TOTAL CUSTO R$' font 'courier new' size 8 bold

         return(nil)