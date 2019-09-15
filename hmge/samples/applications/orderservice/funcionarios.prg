/*
  sistema     : ordem de serviço
  programa    : funcionários
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'

function funcionarios()

         define window form_funcionarios;
                at 000,000;
                width 800;
                height 605;
                title 'Funcionários';
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
           			   action form_funcionarios.release
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
                define grid grid_funcionarios
                       parent form_funcionarios
                       col 000
                       row 105
                       width 795
                       height 430
                       headers {'Código','Nome','Telefone fixo','Telefone celular'}
                       widths {080,400,140,140}
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       backcolor WHITE
                       fontcolor {105,105,105}
                       ondblclick dados(2)
                end grid
                end splitbox
                
                define label rodape_001
                       parent form_funcionarios
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
                          of form_funcionarios;
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
                       parent form_funcionarios
                       col form_funcionarios.width - 270
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

         form_funcionarios.center
         form_funcionarios.activate

         return(nil)
*-------------------------------------------------------------------------------
static function dados(parametro)

	   local oQuery
       local oRow := {}

	   local x_id         := alltrim(valor_coluna('grid_funcionarios','form_funcionarios',1))
       local titulo       := 'Incluir'
       local x_nome       := ''
       local x_fixo       := ''
       local x_celular    := ''
       local x_endereco   := ''
       local x_numero     := ''
       local x_complem    := ''
       local x_bairro     := ''
       local x_cidade     := ''
       local x_uf         := ''
       local x_cep        := ''
       local x_email      := ''
       local x_cpf        := ''

       if parametro == 2
       	  if empty(x_id)
       	  	 msginfo('Faça uma pesquisa antes','Atenção')
       	  	 return(nil)
  		  else
	  	     oQuery := oServer:Query('select * from funcionarios where id = '+x_id)
	   	  	 if oQuery:NetErr()
       	  	 	msginfo('Erro de Pesquisa : '+oQuery:Error())
          	 	return(nil)
  		     endif
  		  endif
  		  titulo       := 'Alterar'
          oRow         := oQuery:GetRow(1)
          x_nome       := alltrim(oRow:fieldGet(3))
          x_fixo       := alltrim(oRow:fieldGet(4))
          x_celular    := alltrim(oRow:fieldGet(5))
          x_endereco   := alltrim(oRow:fieldGet(6))
          x_numero     := alltrim(oRow:fieldGet(7))
          x_complem    := alltrim(oRow:fieldGet(8))
          x_bairro     := alltrim(oRow:fieldGet(9))
          x_cidade     := alltrim(oRow:fieldGet(10))
          x_uf         := alltrim(oRow:fieldGet(11))
          x_cep        := alltrim(oRow:fieldGet(12))
          x_email      := alltrim(oRow:fieldGet(13))
          x_cpf        := alltrim(oRow:fieldGet(2))
          oQuery:Destroy()
       endif

       define window form_dados;
              at 000,000;
       		  width 585;
       		  height 370;
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
                        width 310;
                        value x_nome;
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 010,325 label lbl_002;
                        of form_dados;
                        value 'Telefone fixo';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,325 textbox tbox_002;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_fixo;
                        maxlength 010;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 010,455 label lbl_003;
                        of form_dados;
                        value 'Telefone celular';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,455 textbox tbox_003;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_celular;
                        maxlength 010;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 060,005 label lbl_004;
                        of form_dados;
                        value 'Endereço';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,005 textbox tbox_004;
                        of form_dados;
                        height 027;
                        width 310;
                        value x_endereco;
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 060,325 label lbl_005;
                        of form_dados;
                        value 'Número';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,325 textbox tbox_005;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_numero;
                        maxlength 006;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 060,395 label lbl_006;
                        of form_dados;
                        value 'Complemento';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,395 textbox tbox_006;
                        of form_dados;
                        height 027;
                        width 180;
                        value x_complem;
                        maxlength 020;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,005 label lbl_007;
                        of form_dados;
                        value 'Bairro';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,005 textbox tbox_007;
                        of form_dados;
                        height 027;
                        width 180;
                        value x_bairro;
                        maxlength 020;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,195 label lbl_008;
                        of form_dados;
                        value 'Cidade';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,195 textbox tbox_008;
                        of form_dados;
                        height 027;
                        width 180;
                        value x_cidade;
                        maxlength 020;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,385 label lbl_009;
                        of form_dados;
                        value 'UF';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,385 textbox tbox_009;
                        of form_dados;
                        height 027;
                        width 040;
                        value x_uf;
                        maxlength 002;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,435 label lbl_010;
                        of form_dados;
                        value 'CEP';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,435 textbox tbox_010;
                        of form_dados;
                        height 027;
                        width 080;
                        value x_cep;
                        maxlength 008;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1
              @ 160,005 label lbl_011;
                        of form_dados;
                        value 'e-mail';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 180,005 textbox tbox_011;
                        of form_dados;
                        height 027;
                        width 450;
                        value x_email;
                        maxlength 050;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        lowercase
              @ 210,005 label lbl_015;
                        of form_dados;
                        value 'CPF';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 230,005 textbox tbox_015;
                        of form_dados;
                        height 027;
                        width 135;
                        value x_cpf;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
						inputmask '999.999.999-99'

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

	   local v_id   := alltrim(valor_coluna('grid_funcionarios','form_funcionarios',1))
	   local v_nome := alltrim(valor_coluna('grid_funcionarios','form_funcionarios',2))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a exclusão de : '+v_nome+' ?')
       	  cQuery := 'delete from funcionarios where id = '+v_id
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

  	   oQuery := oServer:Query('select * from funcionarios order by nome')

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
     	   @ linha,045 PRINT alltrim(oRow:fieldGet(3)) FONT 'courier new' SIZE 10
     	   @ linha,150 PRINT oRow:fieldGet(4)+'-'+oRow:fieldGet(5) FONT 'courier new' SIZE 10

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
       @ 010,050 PRINT 'RELAÇÃO DE FUNCIONÁRIOS' FONT 'courier new' SIZE 018 BOLD
       @ 018,050 PRINT 'Ordem Alfabética' FONT 'courier new' SIZE 014
       @ 024,050 PRINT 'Página : '+strzero(p_pagina,4) FONT 'courier new' SIZE 012

       @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR _preto_001

       @ 035,025 PRINT 'CÓDIGO' FONT 'courier new' SIZE 010 BOLD
       @ 035,045 PRINT 'NOME' FONT 'courier new' SIZE 010 BOLD
       @ 035,150 PRINT 'TELEFONE' FONT 'courier new' SIZE 010 BOLD

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

	   local v_id         := alltrim(valor_coluna('grid_funcionarios','form_funcionarios',1))
	   local v_nome       := alltrim(form_dados.tbox_001.value)
       local v_fixo       := alltrim(form_dados.tbox_002.value)
	   local v_celular    := alltrim(form_dados.tbox_003.value)
       local v_endereco   := alltrim(form_dados.tbox_004.value)
       local v_numero     := alltrim(form_dados.tbox_005.value)
       local v_complem    := alltrim(form_dados.tbox_006.value)
       local v_bairro     := alltrim(form_dados.tbox_007.value)
       local v_cidade     := alltrim(form_dados.tbox_008.value)
       local v_uf         := alltrim(form_dados.tbox_009.value)
       local v_cep        := alltrim(form_dados.tbox_010.value)
       local v_email      := alltrim(form_dados.tbox_011.value)
       local v_cpf        := alltrim(form_dados.tbox_015.value)

       if parametro == 1
          if empty(v_nome)
             msginfo('Obrigatório preencher o campo : Nome','Atenção')
             return(nil)
		  else
       		 cQuery := "insert into funcionarios (nome,fixo,celular,endereco,numero,complemento,bairro,cidade,uf,cep,email,cpf,data_cad,hora_cad) values ('"
       		 cQuery += v_nome +"','"
       		 cQuery += v_fixo +"','"
       		 cQuery += v_celular +"','"
       		 cQuery += v_endereco +"','"
       		 cQuery += v_numero +"','"
       		 cQuery += v_complem +"','"
       		 cQuery += v_bairro +"','"
       		 cQuery += v_cidade +"','"
       		 cQuery += v_uf +"','"
       		 cQuery += v_cep +"','"
       		 cQuery += v_email +"','"
       		 cQuery += v_cpf +"','"
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
             cQuery := "update funcionarios set "
       		 cQuery += "nome='"+v_nome+"',"
       		 cQuery += "fixo='"+v_fixo+"',"
       		 cQuery += "celular='"+v_celular+"',"
       		 cQuery += "endereco='"+v_endereco+"',"
       		 cQuery += "numero='"+v_numero+"',"
       		 cQuery += "complemento='"+v_complem+"',"
       		 cQuery += "bairro='"+v_bairro+"',"
       		 cQuery += "cidade='"+v_cidade+"',"
       		 cQuery += "uf='"+v_uf+"',"
       		 cQuery += "cep='"+v_cep+"',"
       		 cQuery += "email='"+v_email+"',"
       		 cQuery += "cpf='"+v_cpf+"'"
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

	   local v_conteudo := form_funcionarios.tbox_pesquisa.value
       local v_pesquisa := '"'+upper(alltrim(form_funcionarios.tbox_pesquisa.value))+'%"'
       local n_i        := 0
       local oRow       := {}

       delete item all from grid_funcionarios of form_funcionarios

	   if empty(v_conteudo)
       	  oQuery := oServer:Query('select id,nome,fixo,celular from funcionarios order by nome')
 	   else
          oQuery := oServer:Query('select id,nome,fixo,celular from funcionarios where nome like '+v_pesquisa+' order by nome')
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
           add item {str(oRow:fieldGet(1)),alltrim(oRow:fieldGet(2)),alltrim(oRow:fieldGet(3)),alltrim(oRow:fieldGet(4))} to grid_funcionarios of form_funcionarios
           oQuery:Skip(1)
       next n_i

	   oQuery:Destroy()

       return(nil)