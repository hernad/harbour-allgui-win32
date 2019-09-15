/*
  sistema     : ordem de serviço
  programa    : produtos
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'

function produtos()

         define window form_produtos;
                at 000,000;
                width 800;
                height 605;
                title 'Produtos';
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
           			   action form_produtos.release
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
                define grid grid_produtos
                       parent form_produtos
                       col 000
                       row 105
                       width 795
                       height 430
                       headers {'Código','Tipo','Descrição','Unidade'}
                       widths {080,100,350,100}
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       backcolor WHITE
                       fontcolor {105,105,105}
                       ondblclick dados(2)
                end grid
                end splitbox
                
                define label rodape_001
                       parent form_produtos
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
                          of form_produtos;
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
                       parent form_produtos
                       col form_produtos.width - 270
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

         form_produtos.center
         form_produtos.activate

         return(nil)
*-------------------------------------------------------------------------------
static function dados(parametro)

	   local oQuery
       local oRow := {}

	   local x_id          := alltrim(valor_coluna('grid_produtos','form_produtos',1))
       local titulo        := 'Incluir'
       local x_nome        := ''
       local x_tipo        := 1
       local x_codbarras   := ''
       local x_unidade     := 1
       local x_id_grupo    := 0
       local x_custo       := 0
       local x_preco       := 0
       local x_cmedio      := 0
       local x_comissao    := 0
       local x_est_atual   := 0
       local x_est_minimo  := 0
       local x_aplicacao   := ''
       local x_fiscal      := ''
       local x_icms        := 0
       local x_ipi         := 0
       local x_iss         := 0
       local x_bxa_estoque := 1

       if parametro == 2
       	  if empty(x_id)
       	  	 msginfo('Faça uma pesquisa antes','Atenção')
       	  	 return(nil)
  		  else
	  	     oQuery := oServer:Query('select * from produtos where id = '+x_id)
	   	  	 if oQuery:NetErr()
       	  	 	msginfo('Erro de Pesquisa : '+oQuery:Error())
          	 	return(nil)
  		     endif
  		  endif
  		  titulo        := 'Alterar'
          oRow          := oQuery:GetRow(1)
       	  x_nome        := alltrim(oRow:fieldGet(2))
       	  x_tipo        := oRow:fieldGet(3)
       	  x_codbarras   := alltrim(oRow:fieldGet(4))
       	  x_unidade     := oRow:fieldGet(5)
       	  x_id_grupo    := oRow:fieldGet(6)
       	  x_custo       := oRow:fieldGet(7)
       	  x_preco       := oRow:fieldGet(8)
       	  x_cmedio      := oRow:fieldGet(9)
       	  x_comissao    := oRow:fieldGet(10)
       	  x_est_atual   := oRow:fieldGet(11)
       	  x_est_minimo  := oRow:fieldGet(12)
       	  x_aplicacao   := alltrim(oRow:fieldGet(13))
       	  x_fiscal      := alltrim(oRow:fieldGet(14))
       	  x_icms        := oRow:fieldGet(15)
       	  x_ipi         := oRow:fieldGet(16)
       	  x_iss         := oRow:fieldGet(17)
       	  x_bxa_estoque := oRow:fieldGet(18)
          oQuery:Destroy()
       endif

       define window form_dados;
              at 000,000;
       		  width 440;
       		  height 460;
              title (titulo);
              icon 'icone';
       		  modal;
       		  nosize

              * entrada de dados
         	  @ 010,010 label lbl_nome;
                   value 'Descrição';
                   bold
              @ 010,330 label lbl_tipo;
                   value 'Tipo';
                   bold
              @ 060,010 label lbl_codigo_barras;
                   value 'Código Barras';
                   bold
              @ 060,230 label lbl_unidade;
                   value 'Unidade';
                   bold
              @ 060,310 label lbl_bxa_estoque;
                   value 'Baixar do Estoque ?';
                   bold
              @ 110,010 label lbl_grupo;
                   value 'Grupo';
                   bold
              @ 160,010 label lbl_custo;
                   value 'Custo R$';
                   bold
              @ 160,150 label lbl_preco;
                   value 'Preço R$';
                   bold
              @ 160,300 label lbl_custo_medio;
                   value 'Custo Médio R$';
                   bold
              @ 210,010 label lbl_estoque_atual;
                   value 'Estoque Atual';
                   bold
              @ 210,150 label lbl_estoque_minimo;
                   value 'Estoque Mínimo';
                   bold
              @ 210,300 label lbl_comissao;
                   value 'Comissão (%)';
                   bold
              @ 260,010 label lbl_aplicacao;
                   value 'Aplicação';
                   bold
              @ 310,010 label lbl_classificacao_fiscal;
                   value 'Classif. Fiscal';
                   bold
              @ 310,120 label lbl_icms;
                   value 'ICMS';
                   bold
              @ 310,210 label lbl_ipi;
                   value 'IPI';
                   bold
              @ 310,300 label lbl_iss;
                   value 'ISS';
                   bold

              @ 030,010 textbox txt_nome;
                   width 300;
                   maxlength 40;
                   value x_nome;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   uppercase
              @ 030,330 comboboxex cbo_tipo;
                   width 080;
                   items aTipo;
                   value x_tipo
              @ 080,010 textbox txt_codigo_barras;
                   width 200;
                   value x_codbarras;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1
              @ 080,230 comboboxex cbo_unidade;
                   width 060;
                   items aUnidade;
                   value x_unidade
              @ 080,310 comboboxex cbo_baixa_estoque;
                   width 060;
                   items aSimNao;
                   value x_bxa_estoque
              @ 130,010 textbox tbox_grupo;
                        width 50;
                        value x_id_grupo;
                        numeric;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        on enter pesq_grupo()
              @ 130,075 label lbl_nome_grupo;
                        value '';
                        autosize;
                        bold;
                        fontcolor BLUE;
                        transparent
              @ 180,010 textbox txt_custo;
                   width 100;
                   value x_custo;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999,999.99'
              @ 180,150 textbox txt_preco;
                   width 100;
                   value x_preco;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999,999.99'
              @ 180,300 textbox txt_custo_medio;
                   width 100;
                   value x_cmedio;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999,999.99'
              @ 230,010 textbox txt_estoque_atual;
                   width 100;
                   value x_est_atual;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999999'
              @ 230,150 textbox txt_estoque_minimo;
                   width 100;
                   value x_est_minimo;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999999'
              @ 230,300 textbox txt_comissao;
                   width 100;
                   value x_comissao;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999.99'
              @ 280,010 textbox txt_aplicacao;
                   width 390;
                   maxlength 50;
                   value x_aplicacao;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   uppercase
              @ 330,010 textbox txt_classificacao_fiscal;
                   width 100;
                   maxlength 10;
                   value x_fiscal;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   uppercase
              @ 330,120 textbox txt_icms;
                   width 080;
                   value x_icms;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999.99'
              @ 330,210 textbox txt_ipi;
                   width 080;
                   value x_ipi;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999.99'
              @ 330,300 textbox txt_iss;
                   width 080;
                   value x_iss;
                   backcolor _fundo_get;
                   fontcolor _letra_get_1;
                   numeric inputmask '999.99'

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

	   local v_id   := alltrim(valor_coluna('grid_produtos','form_produtos',1))
	   local v_nome := alltrim(valor_coluna('grid_produtos','form_produtos',3))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a exclusão de : '+v_nome+' ?')
       	  cQuery := 'delete from produtos where id = '+v_id
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

  	   oQuery := oServer:Query('select * from produtos order by nome')

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
     	   @ linha,150 PRINT aTipo[oRow:fieldGet(3)] FONT 'courier new' SIZE 10

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
       @ 010,050 PRINT 'RELAÇÃO DE PRODUTOS' FONT 'courier new' SIZE 018 BOLD
       @ 018,050 PRINT 'Ordem Alfabética' FONT 'courier new' SIZE 014
       @ 024,050 PRINT 'Página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012

       @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR _preto_001

       @ 035,025 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
       @ 035,045 PRINT 'DESCRIÇÃO' FONT 'courier new' SIZE 010 BOLD
       @ 035,150 PRINT 'TIPO' FONT 'courier new' SIZE 010 BOLD

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

	   local v_id          := alltrim(valor_coluna('grid_produtos','form_produtos',1))

	   local v_nome        := alltrim(form_dados.txt_nome.value)
       local v_tipo        := alltrim(str(form_dados.cbo_tipo.value))
	   local v_codbarras   := alltrim(form_dados.txt_codigo_barras.value)
       local v_unidade     := alltrim(str(form_dados.cbo_unidade.value))
       local v_grupo       := alltrim(str(form_dados.tbox_grupo.value))
       local v_custo       := str(form_dados.txt_custo.value,12,2)
       local v_preco       := str(form_dados.txt_preco.value,12,2)
       local v_custo_medio := str(form_dados.txt_custo_medio.value,12,2)
       local v_comissao    := str(form_dados.txt_comissao.value,10,2)
       local v_est_atual   := alltrim(str(form_dados.txt_estoque_atual.value))
       local v_est_minimo  := alltrim(str(form_dados.txt_estoque_minimo.value))
       local v_aplicacao   := alltrim(form_dados.txt_aplicacao.value)
       local v_fiscal      := alltrim(form_dados.txt_classificacao_fiscal.value)
       local v_icms        := str(form_dados.txt_icms.value,10,2)
       local v_ipi         := str(form_dados.txt_ipi.value,10,2)
       local v_iss         := str(form_dados.txt_iss.value,10,2)
       local v_bxa_estoque := alltrim(str(form_dados.cbo_baixa_estoque.value))
       
       if parametro == 1
          if empty(v_nome)
             msginfo('Obrigatório preencher o campo : Nome','Atenção')
             return(nil)
		  else
       		 cQuery := "insert into produtos (nome,tipo,codigo_barras,unidade,id_grupo,custo,preco,custo_medio,comissao,estoque_atual,estoque_minimo,aplicacao,cla_fiscal,icms,ipi,iss,baixa_estoque,data_cad,hora_cad) values ('"
       		 cQuery += v_nome +"','"
       		 cQuery += v_tipo +"','"
       		 cQuery += v_codbarras +"','"
       		 cQuery += v_unidade +"','"
       		 cQuery += v_grupo +"','"
       		 cQuery += v_custo +"','"
       		 cQuery += v_preco +"','"
       		 cQuery += v_custo_medio +"','"
       		 cQuery += v_comissao +"','"
       		 cQuery += v_est_atual +"','"
       		 cQuery += v_est_minimo +"','"
       		 cQuery += v_aplicacao +"','"
       		 cQuery += v_fiscal +"','"
       		 cQuery += v_icms +"','"
       		 cQuery += v_ipi +"','"
       		 cQuery += v_iss +"','"
       		 cQuery += v_bxa_estoque +"','"
       		 cQuery += td(date()) +"','"
       		 cQuery += time() +"')"
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
             cQuery := "update produtos set "
       		 cQuery += "nome='"           + v_nome        + "',"
       		 cQuery += "tipo='"           + v_tipo        + "',"
       		 cQuery += "codigo_barras='"  + v_codbarras   + "',"
       		 cQuery += "unidade='"        + v_unidade     + "',"
       		 cQuery += "id_grupo='"       + v_grupo       + "',"
       		 cQuery += "custo='"          + v_custo       + "',"
       		 cQuery += "preco='"          + v_preco       + "',"
       		 cQuery += "custo_medio='"    + v_custo_medio + "',"
       		 cQuery += "comissao='"       + v_comissao    + "',"
       		 cQuery += "estoque_atual='"  + v_est_atual   + "',"
       		 cQuery += "estoque_minimo='" + v_est_minimo  + "',"
       		 cQuery += "aplicacao='"      + v_aplicacao   + "',"
       		 cQuery += "cla_fiscal='"     + v_fiscal      + "',"
       		 cQuery += "icms='"           + v_icms        + "',"
       		 cQuery += "ipi='"            + v_ipi         + "',"
       		 cQuery += "iss='"            + v_iss         + "',"
       		 cQuery += "baixa_estoque='"  + v_bxa_estoque + "'"
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

	   local v_conteudo := form_produtos.tbox_pesquisa.value
       local v_pesquisa := '"'+upper(alltrim(form_produtos.tbox_pesquisa.value))+'%"'
       local n_i        := 0
       local oRow       := {}

       delete item all from grid_produtos of form_produtos

	   if empty(v_conteudo)
       	  oQuery := oServer:Query('select id,tipo,nome,unidade from produtos order by nome')
 	   else
          oQuery := oServer:Query('select id,tipo,nome,unidade from produtos where nome like '+v_pesquisa+' order by nome')
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
           add item {str(oRow:fieldGet(1)),aTipo[oRow:fieldGet(2)],alltrim(oRow:fieldGet(3)),aUnidade[oRow:fieldGet(4)]} to grid_produtos of form_produtos
           oQuery:Skip(1)
       next n_i

	   oQuery:Destroy()

       return(nil)
*-------------------------------------------------------------------------------
static function pesq_grupo()

	   local x_grupo := form_dados.tbox_grupo.value
	   local x_nome   := ''
	   local oQuery
       local oRow := {}

	   if x_grupo <> 0
       	  oQuery := oServer:Query('select * from grupos where id = '+alltrim(str(x_grupo)))
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
       	  x_nome := alltrim(oRow:fieldGet(2))
	   	  setproperty('form_dados','lbl_nome_grupo','value',x_nome)
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Grupo';
              icon 'icone';
		      modal;
		      nosize;
		      on init alimenta_pesquisa()

        	  define grid grid_pesquisa
           	  		 parent form_pesquisa
                     col 0
                     row 0
                     width form_pesquisa.width
                     height form_pesquisa.height
                     headers {'Cód.','Nome'}
                     widths {50,400}
                     fontname 'verdana'
                     fontsize 10
                     backcolor WHITE
                     fontcolor {0,0,0}
                     ondblclick passa_pesquisa()
              end grid

			  on key escape action form_pesquisa.release

	   end window

	   form_pesquisa.center
	   form_pesquisa.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function alimenta_pesquisa()

	   local i := 0
	   local oQuery
       local oRow := {}

  	   oQuery := oServer:Query('select * from grupos order by nome')

	   for i := 1 to oQuery:LastRec()
 	   	   oRow := oQuery:GetRow(i)
           add item {alltrim(str(oRow:fieldGet(1),6)),alltrim(oRow:fieldGet(2))} to grid_pesquisa of form_pesquisa
           oQuery:Skip(1)
       next i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function passa_pesquisa()

	   local v_id   := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',1))
	   local v_nome := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',2))

	   setproperty('form_dados','tbox_grupo','value',val(v_id))
	   setproperty('form_dados','lbl_nome_grupo','value',v_nome)

	   form_pesquisa.release

	   return(nil)