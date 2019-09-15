/*
  sistema     : ordem de serviço
  programa    : formas de pagamento
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'

function fpagamentos()

         define window form_fpagamentos;
                at 000,000;
                width 800;
                height 605;
                title 'Formas de Pagamento';
                icon 'icone';
                modal;
                nosize;
                on init pesquisar()

                * botões (toolbar)
				define buttonex button_incluir
		  			   picture 'img_inclui'
     			  	   col 005
         			   row 002
          			   width 100
           			   height 100
       			  	   caption 'Incluir'
           			   action dados(1)
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _preto_001
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
	   			end buttonex
       			define buttonex button_alterar
    	 		  	   picture 'img_altera'
         			   col 107
          			   row 002
           			   width 100
           			   height 100
           			   caption 'Alterar'
           			   action dados(2)
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _preto_001
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
			 	end buttonex
     			define buttonex button_excluir
  	 		  		   picture 'img_exclui'
        			   col 209
         			   row 002
          			   width 100
           			   height 100
           			   caption 'Excluir'
           			   action excluir()
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _preto_001
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
			 	end buttonex
     			define buttonex button_imprimir
  	 		  		   picture 'img_imprime'
        			   col 311
         			   row 002
          			   width 100
           			   height 100
           			   caption 'Imprimir'
           			   action relacao()
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _preto_001
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
			 	end buttonex
     			define buttonex button_sair
  	 		  		   picture 'img_sair'
   			  		   col 413
        			   row 002
         			   width 100
          			   height 100
           			   caption 'ESC-Voltar'
           			   action form_fpagamentos.release
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _preto_001
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
			 	end buttonex

                define splitbox
                define grid grid_fpagamentos
                       parent form_fpagamentos
                       col 000
                       row 105
                       width 795
                       height 430
                       headers {'Código','Nome'}
                       widths {100,600}
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       backcolor WHITE
                       fontcolor {105,105,105}
                       ondblclick dados(2)
                end grid
                end splitbox
                
                define label rodape_001
                       parent form_fpagamentos
                       col 005
                       row 545
                       value 'Digite sua pesquisa'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _cinza_001
                       transparent .T.
                end label
                @ 540,160 textbox tbox_pesquisa;
                          of form_fpagamentos;
                          height 027;
                          width 300;
                          value '';
                          maxlength 040;
                          font 'verdana' size 010;
                          backcolor _fundo_get;
                          fontcolor _letra_get_1;
                          uppercase;
                          on change pesquisar()
                define label rodape_002
                       parent form_fpagamentos
                       col form_fpagamentos.width - 270
                       row 545
                       value 'DUPLO CLIQUE : Alterar informação'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _verde_002
                       transparent .T.
                end label

                on key escape action thiswindow.release

         end window

         form_fpagamentos.center
         form_fpagamentos.activate

         return(nil)
*-------------------------------------------------------------------------------
static function dados(parametro)

	   local oQuery
       local oRow := {}

	   local x_id   := alltrim(valor_coluna('grid_fpagamentos','form_fpagamentos',1))
       local titulo := 'Incluir'
       local x_nome := ''

       if parametro == 2
       	  if empty(x_id)
       	  	 msginfo('Faça uma pesquisa antes','Atenção')
       	  	 return(nil)
  		  else
	  	     oQuery := oServer:Query('select * from fpagamentos where id = '+x_id)
	   	  	 if oQuery:NetErr()
       	  	 	msginfo('Erro de Pesquisa : '+oQuery:Error())
          	 	return(nil)
  		     endif
  		  endif
  		  titulo := 'Alterar'
          oRow   := oQuery:GetRow(1)
          x_nome := alltrim(oRow:fieldGet(2))
          oQuery:Destroy()
       endif

       define window form_dados;
              at 000,000;
       		  width 365;
       		  height 180;
              title (titulo);
              icon 'icone';
       		  modal;
       		  nosize

              * entrada de dados
              @ 010,005 label lbl_001;
                        of form_dados;
                        value 'Nome';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,005 textbox tbox_001;
                        of form_dados;
                        height 027;
                        width 350;
                        value x_nome;
                        maxlength 030;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase

              * linha separadora
              define label linha_rodape
                     col 000
                     row form_dados.height-090
                     value ''
                     width form_dados.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label

              * botões
              define buttonex button_ok
                     picture 'img_gravar'
                     col form_dados.width-225
                     row form_dados.height-085
                     width 120
                     height 050
                     caption 'Ok, gravar'
                     action gravar(parametro)
                     fontbold .T.
                     tooltip 'Confirmar as informações digitadas'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_cancela
                     picture 'img_voltar'
                     col form_dados.width-100
                     row form_dados.height-085
                     width 090
                     height 050
                     caption 'Voltar'
                     action form_dados.release
                     fontbold .T.
                     tooltip 'Sair desta tela sem gravar informações'
                     flat .F.
                     noxpstyle .T.
              end buttonex

       end window

       sethandcursor(getcontrolhandle('button_ok','form_dados'))
       sethandcursor(getcontrolhandle('button_cancela','form_dados'))

       form_dados.center
       form_dados.activate

       return(nil)
*-------------------------------------------------------------------------------
static function excluir()

	   local cQuery
       local oQuery

	   local v_id   := alltrim(valor_coluna('grid_fpagamentos','form_fpagamentos',1))
	   local v_nome := alltrim(valor_coluna('grid_fpagamentos','form_fpagamentos',2))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a exclusão de : '+v_nome+' ?')
       	  cQuery := 'delete from fpagamentos where id = '+v_id
          oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
          	 msginfo('Erro na Exclusão : '+oQuery:Error())
             return(nil)
          endif
          oQuery:Destroy()
          msginfo('A informação : '+v_nome+' - foi excluída')
          pesquisar()
 	   endif

       return(nil)
*-------------------------------------------------------------------------------
static function relacao()

	   define window form_relatorio_001;
	  		  at 000,000;
              width 320;
              height 150;
              title 'Relatório:por ordem alfabética';
              icon 'icone';
              modal;
              nosize

              @ 010,010 label label_tipo value 'Clique no botão Ok para ver o relatório' bold autosize

              define label linha_horizontal
              		 col 000
                     row form_relatorio_001.height-090
                     value ''
                     width form_relatorio_001.width
                     height 001
                     backcolor {128,128,128}
                     transparent .F.
              end label

              define buttonex button_relatorio
                     picture 'relatorio'
                     col form_relatorio_001.width-305
                     row form_relatorio_001.height-085
                     width 160
                     height 050
                     caption 'Ok, imprimir'
                     action executa_relatorio_001()
                     fontbold .T.
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_voltar
                     picture 'img_voltar'
                     col form_relatorio_001.width-140
                     row form_relatorio_001.height-085
                     width 130
                     height 050
                     caption 'Voltar'
                     action form_relatorio_001.release
                     fontbold .T.
                     flat .F.
                     noxpstyle .T.
              end buttonex

			  on key escape action form_relatorio_001.release

	   end window

	   form_relatorio_001.center
	   form_relatorio_001.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function executa_relatorio_001()

	   local oQuery, oQuery_setor, oQuery_local
       local oRow := {}

	   local n_i := 0

       local pagina  := 1
       local p_linha := 045
       local u_linha := 260
       local linha   := p_linha

  	   oQuery := oServer:Query('select * from fpagamentos order by nome')

	   if oQuery:Eof()
	   	  msginfo('Não existem informações para serem impressas','Atenção')
		  return(nil)
	   endif

       SELECT PRINTER DIALOG PREVIEW
       START PRINTDOC NAME 'Gerenciador de impressão'
       START PRINTPAGE

	   cabecalho_1(pagina)

 	   for n_i := 1 to oQuery:LastRec()

	   	   oRow := oQuery:GetRow(n_i)

		   @ linha,030 PRINT alltrim(str(oRow:fieldGet(1),6)) FONT 'courier new' SIZE 10
     	   @ linha,045 PRINT alltrim(oRow:fieldGet(2)) FONT 'courier new' SIZE 10

      	   linha += 5

       	   if linha >= u_linha
         	  pagina ++
       	  	  rodape()
           	  END PRINTPAGE
           	  START PRINTPAGE
           	  cabecalho_1(pagina)
           	  linha := p_linha
           endif

		   oQuery:Skip(1)

	   next n_i

       rodape()

       END PRINTPAGE
       END PRINTDOC

	   oQuery:Destroy()

	   form_relatorio_001.release

	   return(nil)
*-------------------------------------------------------------------------------
static function cabecalho_1(p_pagina)

       @ 007,010 PRINT IMAGE 'logotipo' WIDTH 030 HEIGHT 025 STRETCH
       @ 010,050 PRINT 'RELAÇÃO DE FORMAS DE PAGAMENTO' FONT 'courier new' SIZE 018 BOLD
       @ 018,050 PRINT 'Ordem Alfabética' FONT 'courier new' SIZE 014
       @ 024,050 PRINT 'Página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012

       @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR _preto_001

       @ 035,025 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
       @ 035,045 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD

       return(nil)
*-------------------------------------------------------------------------------
static function rodape()

       @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR _preto_001
       @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008

       return(nil)
*-------------------------------------------------------------------------------
static function gravar(parametro)

	   local cQuery
       local oQuery

	   local v_id   := alltrim(valor_coluna('grid_fpagamentos','form_fpagamentos',1))
	   local v_nome := alltrim(form_dados.tbox_001.value)

       if parametro == 1
          if empty(v_nome)
             msginfo('Obrigatório preencher o campo : Nome','Atenção')
             return(nil)
		  else
       		 cQuery := "insert into fpagamentos (nome) values ('"
       		 cQuery += v_nome +"')"
       	     oQuery := oQuery := oServer:Query( cQuery )
             if oQuery:NetErr()
             	msginfo('Erro na Inclusão : '+oQuery:Error())
              	return(nil)
             endif
       	     oQuery:Destroy()
       	     form_dados.release
       	     pesquisar()
		  endif
	   elseif parametro == 2
          if empty(v_nome)
             msginfo('Obrigatório preencher o campo : Nome','Atenção')
             return(nil)
		  else
             cQuery := "update fpagamentos set "
       		 cQuery += "nome='"+v_nome+"'"
       	  	 cQuery += " where id='"+v_id+"'"
       	     oQuery := oQuery := oServer:Query( cQuery )
             if oQuery:NetErr()
             	msginfo('Erro na Alteração : '+oQuery:Error())
              	return(nil)
             endif
       	     oQuery:Destroy()
       	     form_dados.release
       	     pesquisar()
		  endif
 	   endif

       return(nil)
*-------------------------------------------------------------------------------
static function pesquisar()

	   local oQuery

	   local v_conteudo := form_fpagamentos.tbox_pesquisa.value
       local v_pesquisa := '"'+upper(alltrim(form_fpagamentos.tbox_pesquisa.value))+'%"'
       local n_i        := 0
       local oRow       := {}

       delete item all from grid_fpagamentos of form_fpagamentos

	   if empty(v_conteudo)
       	  oQuery := oServer:Query('select id,nome from fpagamentos order by nome')
 	   else
          oQuery := oServer:Query('select id,nome from fpagamentos where nome like '+v_pesquisa+' order by nome')
       endif

       if oQuery:NetErr()
       	  msginfo('Erro de Pesquisa : '+oQuery:Error())
		  return(nil)
       endif

	   if oQuery:Eof()
		  return(nil)
	   endif

       for n_i := 1 to oQuery:LastRec()
       	   oRow := oQuery:GetRow(n_i)
           add item {str(oRow:fieldGet(1)),alltrim(oRow:fieldGet(2))} to grid_fpagamentos of form_fpagamentos
           oQuery:Skip(1)
       next n_i

	   oQuery:Destroy()

       return(nil)