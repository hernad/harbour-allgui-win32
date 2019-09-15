/*
  sistema     : ordem de serviço
  programa    : contas a pagar
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'

function cpagar()

         define window form_cpag;
                at 000,000;
                width 1000;
                height 605;
                title 'Contas a Pagar';
                icon 'icone';
                modal;
                nosize

				/*
				  toolbar
				*/
				define buttonex button_incluir
		  			   picture 'img_inclui'
     			  	   col 002
         			   row 002
          			   width 90
           			   height 90
           			   caption 'Novo'
           			   action dados_cpag(1)
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
    			  	   col 94
        			   row 002
         			   width 90
          			   height 90
           			   caption 'Modificar'
           			   action dados_cpag(2)
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
         			   col 186
          			   row 002
           			   width 90
           			   height 90
           			   caption 'Apagar'
           			   action excluir_cpag()
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _vermelho_002
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
			 	end buttonex
	  		    define buttonex button_baixa
   	 		  		   picture 'img_baixa'
         			   col 278
          			   row 002
           			   width 90
           			   height 90
           			   caption 'Baixar'
           			   action baixar_cpag()
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
        			   col 370
         			   row 002
          			   width 90
           			   height 90
           			   caption 'Sair (ESC)'
           			   action form_cpag.release
           			   fontname 'verdana'
           			   fontsize 009
           			   fontbold .T.
           			   fontcolor _preto_001
           			   vertical .T.
           			   flat .T.
           			   noxpstyle .T.
                       backcolor _branco_001
			 	end buttonex

				/*
				  grid
				*/
                define grid grid_cpag
                       parent form_cpag
                       col 0
                       row 94
                       width form_cpag.width-10
                       height 480
                       headers {'id','Vencimento','Fornecedor','Forma Pagamento','Valor R$','Nº Documento'}
                       widths {001,120,300,220,120,130}
                       fontname 'verdana'
                       fontsize 010
                       fontbold .F.
                       backcolor WHITE
                       fontcolor {105,105,105}
                       ondblclick dados_cpag(2)
                end grid

				/*
				  filtro
				*/
                define label rodape_001
                       parent form_cpag
                       col 470
                       row 5
                       value 'Escolha o período'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _cinza_001
                       transparent .T.
                end label
                define label rodape_002
                       parent form_cpag
                       col 580
                       row 25
                       value 'até'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _cinza_001
                       transparent .T.
                end label
                @ 025,470 datepicker dp_inicio;
                          parent form_cpag;
                          value date();
                          width 100;
                          font 'verdana' size 010
                @ 025,610 datepicker dp_final;
                          parent form_cpag;
                          value date();
                          width 100;
                          font 'verdana' size 010
		        @ 025,720 radiogroup radio_tipo;
                  		  options {'Mostrar PENDENTES','Mostrar BAIXADAS'};
                 		  value 1;
                 		  width 140;
          				  leftjustify

                @ 025,870 buttonex botao_filtrar;
						  picture 'img_filtro';
                          caption 'Filtrar';
                          width 85 height 50;
                          action pesquisar();
                          bold

		 	  	on key escape action form_cpag.release

         end window

         form_cpag.center
         form_cpag.activate

         return(nil)
*-------------------------------------------------------------------------------
static function pesquisar()

	   local oQuery
       local n_i  := 0
       local oRow := {}

	   local x_data_inicio := td(form_cpag.dp_inicio.value)
	   local x_data_final  := td(form_cpag.dp_final.value)
	   local x_tipo        := alltrim(str(form_cpag.radio_tipo.value))
	   
       delete item all from grid_cpag of form_cpag
       
	   oQuery := oServer:Query("select * from cpagar where vencimento>='"+x_data_inicio+"' and vencimento<='"+x_data_final+"' and baixado='"+x_tipo+"' order by vencimento")

       if oQuery:NetErr()
       	  msginfo('Erro de Pesquisa : '+oQuery:Error())
		  return(nil)
       endif

	   if oQuery:Eof()
	   	  msginfo('Sua pesquisa não foi encontrada, tecle ENTER','Atenção')
		  return(nil)
	   endif

       for n_i := 1 to oQuery:LastRec()
       	   oRow := oQuery:GetRow(n_i)
           add item {alltrim(str(oRow:fieldGet(1),6)),dtoc(oRow:fieldGet(9)),alltrim(oRow:fieldGet(6)),alltrim(oRow:fieldGet(8)),str(oRow:fieldGet(10),12,2),alltrim(oRow:fieldGet(11))} to grid_cpag of form_cpag
           oQuery:Skip(1)
       next n_i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function dados_cpag(parametro)

	   local oQuery
       local oRow := {}

	   local x_id         := alltrim(valor_coluna('grid_cpag','form_cpag',1))
       local titulo       := 'Incluir'
       local x_fornecedor := 0
       local x_forma      := 0
       local x_data       := date()
       local x_valor      := 0
       local x_numero     := ''
       local x_obs        := ''

 	   if parametro == 2
       	  if empty(x_id)
       	  	 msginfo('Faça uma pesquisa antes','Atenção')
       	  	 return(nil)
  		  else
	  	     oQuery := oServer:Query('select * from cpagar where id = '+x_id)
	   	  	 if oQuery:NetErr()
       	  	 	msginfo('Erro de Pesquisa : '+oQuery:Error())
          	 	return(nil)
  		     endif
  		  endif
  		  x_titulo     := 'Alterar'
          oRow         := oQuery:GetRow(1)
       	  x_fornecedor := oRow:fieldGet(5)
       	  x_forma      := oRow:fieldGet(7)
       	  x_data       := oRow:fieldGet(9)
       	  x_valor      := oRow:fieldGet(10)
       	  x_numero     := alltrim(oRow:fieldGet(11))
       	  x_obs        := alltrim(oRow:fieldGet(12))
          oQuery:Destroy()
	   endif

       define window form_dados;
              at 000,000;
       		  width 430;
		      height 330;
              title (titulo);
              icon 'icone';
		      modal;
		      nosize

              * entrada de dados
              @ 010,005 label lbl_001;
                        of form_dados;
                        value 'Fornecedor';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 030,005 textbox tbox_001;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_fornecedor;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric;
                        on enter pesq_fornecedor()
              @ 030,075 label lbl_nome_fornecedor;
                        of form_dados;
                        value '';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              *----------
              @ 060,005 label lbl_002;
                        of form_dados;
                        value 'Forma Pagamento';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 080,005 textbox tbox_002;
                        of form_dados;
                        height 027;
                        width 060;
                        value x_forma;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        numeric;
                        on enter pesq_fpagamento()
              @ 080,075 label lbl_nome_forma_pagamento;
                        of form_dados;
                        value '';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLUE;
                        transparent
              *----------
              @ 110,005 label lbl_003;
                        of form_dados;
                        value 'Data';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLACK;
                        transparent
              @ 130,005 textbox tbox_003;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_data;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        date
              *----------
              @ 110,140 label lbl_004;
                        of form_dados;
                        value 'Valor R$';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _vermelho_002;
                        transparent
              @ 130,140 getbox tbox_004;
                        of form_dados;
                        height 027;
                        width 120;
                        value x_valor;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        picture '@E 999,999.99'
              *----------
              @ 110,270 label lbl_005;
                        of form_dados;
                        value 'Número documento';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 130,270 textbox tbox_005;
                        of form_dados;
                        height 027;
                        width 150;
                        value x_numero;
                        maxlength 015;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              *----------
              @ 160,005 label lbl_006;
                        of form_dados;
                        value 'Observação';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor _preto_001;
                        transparent
              @ 180,005 textbox tbox_006;
                        of form_dados;
                        height 027;
                        width 415;
                        value x_obs;
                        maxlength 040;
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
                     action gravar_cpag(parametro)
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
static function gravar_cpag(parametro)

	   local cQuery
       local oQuery
	   local v_id

       local x_fornecedor      := alltrim(str(form_dados.tbox_001.value))
       local x_forma           := alltrim(str(form_dados.tbox_002.value))
       local x_data            := form_dados.tbox_003.value
       local x_valor           := str(form_dados.tbox_004.value,12,2)
       local x_numero          := alltrim(form_dados.tbox_005.value)
       local x_obs             := alltrim(form_dados.tbox_006.value)
       local x_nome_fornecedor := alltrim(form_dados.lbl_nome_fornecedor.value)
       local x_nome_fpagamento := alltrim(form_dados.lbl_nome_forma_pagamento.value)

       if parametro == 1
          if empty(x_fornecedor) .or. empty(x_forma) .or. empty(x_data) .or. empty(x_valor)
             msginfo('Obrigatório preencher os campos : Fornecedor, Forma Pagamento, Data e Valor','Atenção')
             return(nil)
		  else
       		 cQuery := "insert into cpagar (data_inclusao,hora_inclusao,baixado,id_fornecedor,nome_fornecedor,id_fpagamento,nome_fpagamento,vencimento,valor,numero_doc,observacao) values ('"
       		 cQuery += td(date())	+"','"
       		 cQuery += time()	+"','"
       		 cQuery += '1'	+"','"
       		 cQuery += x_fornecedor	+"','"
       		 cQuery += x_nome_fornecedor	+"','"
       		 cQuery += x_forma	+"','"
       		 cQuery += x_nome_fpagamento	+"','"
       		 cQuery += td(x_data)	+"','"
       		 cQuery += x_valor	+"','"
       		 cQuery += x_numero	+"','"
       		 cQuery += x_obs +"')"
       	     oQuery := oQuery := oServer:Query( cQuery )
             if oQuery:NetErr()
             	msginfo('Erro na Inclusão : '+oQuery:Error())
              	return(nil)
             endif
       	     oQuery:Destroy()
       	     form_dados.release
		  endif
	   elseif parametro == 2
	   	  v_id := alltrim(valor_coluna('grid_cpag','form_cpag',1))
          if empty(x_fornecedor) .or. empty(x_forma) .or. empty(x_data) .or. empty(x_valor)
             msginfo('Obrigatório preencher os campos : Fornecedor, Forma Pagamento, Data e Valor','Atenção')
             return(nil)
		  else
             cQuery := "update cpagar set "
       	  	 cQuery += "id_fornecedor='"+x_fornecedor	+"',"
       	  	 cQuery += "nome_fornecedor='"+x_nome_fornecedor	+"',"
       	  	 cQuery += "id_fpagamento='"+x_forma	+"',"
       	  	 cQuery += "nome_fpagamento='"+x_nome_fpagamento	+"',"
       	  	 cQuery += "vencimento='"+td(x_data)	+"',"
       	  	 cQuery += "valor='"+x_valor	+"',"
       	  	 cQuery += "numero_doc='"+x_numero	+"',"
       	  	 cQuery += "observacao='"+x_obs +"'"
       	  	 cQuery += " where id='"+v_id	+"'"
       	     oQuery := oQuery := oServer:Query( cQuery )
             if oQuery:NetErr()
             	msginfo('Erro na Alteração : '+oQuery:Error())
              	return(nil)
             endif
       	     oQuery:Destroy()
       	     form_dados.release
		  endif
 	   endif

       return(nil)
*-------------------------------------------------------------------------------
static function excluir_cpag()

	   local cQuery
       local oQuery

	   local v_id   := alltrim(valor_coluna('grid_cpag','form_cpag',1))
	   local v_nome := alltrim(valor_coluna('grid_cpag','form_cpag',3))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a exclusão de : '+v_nome+' ?')
       	  cQuery := 'delete from cpagar where id = '+v_id
          oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
          	 msginfo('Erro na Exclusão : '+oQuery:Error())
             return(nil)
          endif
          oQuery:Destroy()
          msginfo('A informação : '+v_nome+' - foi excluída')
 	   endif

       return(nil)
*-------------------------------------------------------------------------------
static function pesq_fornecedor()

	   local x_fornec := form_dados.tbox_001.value
	   local x_nome   := ''
	   local oQuery
       local oRow := {}

	   if x_fornec <> 0
       	  oQuery := oServer:Query('select * from fornecedores where id = '+alltrim(str(x_fornec)))
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
       	  x_nome := alltrim(oRow:fieldGet(5))
	   	  setproperty('form_dados','lbl_nome_fornecedor','value',x_nome)
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Fornecedor';
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

  	   oQuery := oServer:Query('select * from fornecedores order by nome')

	   for i := 1 to oQuery:LastRec()
 	   	   oRow := oQuery:GetRow(i)
           add item {alltrim(str(oRow:fieldGet(1),6)),alltrim(oRow:fieldGet(5))} to grid_pesquisa of form_pesquisa
           oQuery:Skip(1)
       next i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function passa_pesquisa()

	   local v_id   := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',1))
	   local v_nome := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',2))

	   setproperty('form_dados','tbox_001','value',val(v_id))
	   setproperty('form_dados','lbl_nome_fornecedor','value',v_nome)

	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function pesq_fpagamento()

	   local x_fpagamento := form_dados.tbox_002.value
	   local x_nome := ''
	   local oQuery
       local oRow := {}

	   if x_fpagamento <> 0
       	  oQuery := oServer:Query('select * from fpagamentos where id = '+alltrim(str(x_fpagamento)))
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
       	  x_nome := alltrim(oRow:fieldGet(2))
	   	  setproperty('form_dados','lbl_nome_forma_pagamento','value',x_nome)
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Forma Pagamento';
              icon 'icone';
		      modal;
		      nosize;
		      on init alimenta_pesquisa_2()

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
                     ondblclick passa_pesquisa_2()
              end grid

			  on key escape action form_pesquisa.release

	   end window

	   form_pesquisa.center
	   form_pesquisa.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function alimenta_pesquisa_2()

	   local i := 0
	   local oQuery
       local oRow := {}

  	   oQuery := oServer:Query('select * from fpagamentos order by nome')

	   for i := 1 to oQuery:LastRec()
 	   	   oRow := oQuery:GetRow(i)
           add item {alltrim(str(oRow:fieldGet(1),6)),alltrim(oRow:fieldGet(2))} to grid_pesquisa of form_pesquisa
           oQuery:Skip(1)
       next i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function passa_pesquisa_2()

	   local v_id   := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',1))
	   local v_nome := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',2))

	   setproperty('form_dados','tbox_002','value',val(v_id))
	   setproperty('form_dados','lbl_nome_forma_pagamento','value',v_nome)

	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function baixar_cpag()

	   local cQuery
       local oQuery

	   local v_id     := alltrim(valor_coluna('grid_cpag','form_cpag',1))
	   local v_fornec := alltrim(valor_coluna('grid_cpag','form_cpag',3))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a baixa de : '+v_fornec+' ?')
       	  cQuery := "update cpagar set "
  	 	  cQuery += "baixado='"+'2' +"'"
  	  	  cQuery += " where id='"+v_id	+"'"
  	      oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
         	 msginfo('Erro na Alteração : '+oQuery:Error())
          	 return(nil)
          endif
   	      oQuery:Destroy()
          msginfo('A informação : '+v_fornec+' - foi baixada')
 	   endif

       return(nil)