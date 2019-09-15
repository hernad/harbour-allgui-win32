/*
  sistema     : ordem de serviço
  programa    : acompanhamento
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'

function acompanha()

		 local cNumero
		 private nNumOS
		 
		 public m_nome_servico := ''
		 public m_nome_peca    := ''
		 public m_nome_tecnico := ''
		 
		 public n_soma_total := 0

         define window form_acompanhamento;
                at 0,0;
                width 1000;
                height 700;
                title 'Acompanhamento';
                icon 'icone';
                modal;
                nosize

       @ 005,005 label lbl_001;
                 value 'Pesquisar por'
       @ 005,140 label lbl_002;
                 value 'Digite sua pesquisa'
       @ 025,005 comboboxex cbo_001;
                 width 120;
                 items {'Nº da OS','Nome do Cliente'};
                 value 1
       @ 025,140 textbox txt_pesquisa;
                 width 300;
                 maxlength 30;
                 uppercase
       define buttonex button_filtra
       		  col 460
           	  row 7
              width 100
              height 040
              caption 'Pesquisar'
              action filtra_os()
              fontbold .T.
              fontcolor WHITE
              backcolor BLUE
              flat .F.
              noxpstyle .T.
       end buttonex
	   /*
		 mostrar resultado do filtro
	   */
       @ 050,005 grid grid_os;
                 of form_andamento;
                 width 980;
                 height 140;
                 headers {'ID','Nº OS','Data','Hora','Aparelho','Nº Série','Marca','Modelo','Cliente'};
                 widths {1,60,80,70,200,130,130,130,130};
                 backcolor WHITE;
                 fontcolor BLUE;
                 tooltip 'Para implantar a DATA/HORA de saída e DATA de GARANTIA, dê um duplo-clique sobre a OS';
                 on dblclick Inserir_Datas();
                 on change(Mostra_Servicos_Pecas())
       @ 195,005 label lbl_003;
                 value 'Cliente'
       @ 195,400 label lbl_data_prevista;
                 value 'Previsão Entrega'
       @ 195,055 label lbl_nome_cliente;
                 value '';
                 bold;
                 fontcolor BLUE
       @ 195,510 label lbl_data_hora_previsao;
                 value '';
                 bold;
                 fontcolor BLUE
       @ 195,720 label lbl_encerrada;
                 value '';
                 bold;
                 fontcolor RED

			  /*
              	linha separadora - meio da tela
              */
              define label linha_rodape_1
                     col 0
                     row 220
                     value ''
                     width form_acompanhamento.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label
			  /*
			    serviços
			  */
              @ 225,250 label lbl_servicos;
                        value 'SERVIÇOS';
                        autosize;
                        font 'tahoma' size 14 bold;
                        fontcolor _preto_001 transparent
              define buttonex button_inc_servico
                     col 5
                     row 225
                     width 110
                     height 30
                     caption 'Incluir Serviço'
                     action servico_incluir_2(_numero_os)
                     fontname 'tahoma'
                     fontcolor BLUE
                     fontbold .T.
                     tooltip 'Clique aqui para INCLUIR um serviço na Ordem de Serviço'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_exc_servico
                     col 120
                     row 225
                     width 110
                     height 30
                     caption 'Excluir Serviço'
                     action servico_excluir_2()
                     fontname 'tahoma'
                     fontcolor BLUE
                     fontbold .T.
                     tooltip 'Clique aqui para EXCLUIR um serviço na Ordem de Serviço'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              @ 260,005 grid grid_servicos;
                 		width 700;
                 		height 150;
                 		headers {'ID','Descrição','Qtd.','Unit.R$','Sub-Total R$','ID Tec.'};
                 		widths {1,300,60,100,120,1};
                       	font 'courier new' size 10 bold;
                 		backcolor WHITE;
                 		fontcolor BLACK
			  /*
			    peças
			  */
              @ 420,250 label lbl_pecas;
                        value 'PEÇAS';
                        autosize;
                        font 'tahoma' size 14 bold;
                        fontcolor _preto_001 transparent
              define buttonex button_inc_peca
                     col 5
                     row 420
                     width 110
                     height 30
                     caption 'Incluir Peça'
                     action pecas_incluir_2(_numero_os)
                     fontname 'tahoma'
                     fontcolor BLUE
                     fontbold .T.
                     tooltip 'Clique aqui para INCLUIR uma peça na Ordem de Serviço'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_exc_peca
                     col 120
                     row 420
                     width 110
                     height 30
                     caption 'Excluir Peça'
                     action pecas_excluir_2()
                     fontname 'tahoma'
                     fontcolor BLUE
                     fontbold .T.
                     tooltip 'Clique aqui para EXCLUIR uma peça na Ordem de Serviço'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              @ 455,005 grid grid_pecas;
                 		width 700;
                 		height 150;
                 		headers {'ID','Descrição','Qtd.','Unit.R$','Sub-Total R$','ID Tec.'};
                 		widths {1,300,60,100,120,1};
                       	font 'courier new' size 10 bold;
                 		backcolor WHITE;
                 		fontcolor BLACK
			  /*
			    total da OS
			  */
       		  define frame frame_total
              		 col 720
              		 row 440
              		 width 270
              		 height 160
              		 opaque .F.
              		 transparent .F.
			  end frame
              @ 450,790 label lbl_total;
                        value 'TOTAL DA OS';
                        autosize;
                        font 'tahoma' size 12 bold;
                        fontcolor BLUE transparent
              @ 520,750 label lbl_total_os;
                        value trans(n_soma_total,'@E 999,999.99');
                        autosize;
                        font 'tahoma' size 20 bold;
                        fontcolor {0,106,53} transparent
              /*
                rodapé
              */
              define label linha_rodape_2
                     col 000
                     row form_acompanhamento.height-090
                     value ''
                     width form_acompanhamento.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label
              /*
                botões
              */
              define buttonex button_imprime
                     picture 'imprimir'
                     col form_acompanhamento.width-370
                     row form_acompanhamento.height-085
                     width 140
                     height 050
                     caption 'Imprime OS'
                     action imprime_os_2(_numero_os)
                     fontbold .T.
                     tooltip 'Imprimir esta Ordem de Serviço'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_ok
                     col form_acompanhamento.width-225
                     row form_acompanhamento.height-085
                     width 120
                     height 050
                     caption 'Encerrar OS'
                     action encerrar_os()
                     fontbold .T.
                     fontcolor WHITE
                     backcolor RED
                     tooltip 'Encerrar OS'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_cancela
                     picture 'img_voltar'
                     col form_acompanhamento.width-100
                     row form_acompanhamento.height-085
                     width 090
                     height 050
                     caption 'Voltar'
                     action form_acompanhamento.release
                     fontbold .T.
                     tooltip 'Sair desta tela sem gravar informações'
                     flat .F.
                     noxpstyle .T.
              end buttonex

			  on key escape action thiswindow.release

         end window

         form_acompanhamento.center
         form_acompanhamento.activate

         return(nil)
*-------------------------------------------------------------------------------
function Filtra_OS()

	   	 local oQuery
       	 local oRow := {}

         local chave
         local cNome_Anterior := space(40)

         if form_acompanhamento.cbo_001.value == 1 //nº da OS
         
            chave := alltrim(form_acompanhamento.txt_pesquisa.value)
            oQuery := oServer:Query('select id,numero,data,hora,aparelho,numero_serie,marca,modelo,nome_cliente from os where numero = '+chave+' and encerrado = 0 order by numero')
	   		if oQuery:Eof()
               msgstop('Este Nº de OS não existe','Atenção')
               form_acompanhamento.txt_pesquisa.setfocus
		  	   return(nil)
   		    else
       	   	   oRow := oQuery:GetRow(1)
               nNumOS := str(oRow:fieldGet(2))
               delete item all from grid_os of form_acompanhamento
               add item {str(oRow:fieldGet(1)),str(oRow:fieldGet(2)),dtoc(oRow:fieldGet(3)),oRow:fieldGet(4),oRow:fieldGet(5),oRow:fieldGet(6),oRow:fieldGet(7),oRow:fieldGet(8),oRow:fieldGet(9)} to grid_os of form_acompanhamento
               form_acompanhamento.lbl_nome_cliente.value := alltrim(oRow:fieldGet(9))
            endif
            oQuery:Destroy()
            
         elseif form_acompanhamento.cbo_001.value == 2 //nome do cliente

            chave := '"'+upper(alltrim(form_acompanhamento.txt_pesquisa.value))+'%"'
            oQuery := oServer:Query('select id,numero,data,hora,aparelho,numero_serie,marca,modelo,nome_cliente from os where nome_cliente like '+chave+' and encerrado = 0 order by nome_cliente')
	   		if oQuery:Eof()
               msgstop('Não existe(m) OS(s) para este Cliente','Atenção')
               form_acompanhamento.txt_pesquisa.setfocus
		  	   return(nil)
   		    else
       	       oRow := oQuery:GetRow(1)
               cNome_Anterior := upper(alltrim(oRow:fieldGet(9)))
               delete item all from grid_os of form_acompanhamento
               n_conta := 1
               while .not. oQuery:Eof()
       	       		 oRow := oQuery:GetRow(n_conta)
               		 add item {str(oRow:fieldGet(1)),str(oRow:fieldGet(2)),dtoc(oRow:fieldGet(3)),alltrim(oRow:fieldGet(4)),alltrim(oRow:fieldGet(5)),alltrim(oRow:fieldGet(6)),alltrim(oRow:fieldGet(7)),alltrim(oRow:fieldGet(8)),alltrim(oRow:fieldGet(9))} to grid_os of form_acompanhamento
                     oQuery:Skip(1)
                     n_conta ++
                     if alltrim(oRow:fieldGet(9)) <> cNome_Anterior
                        exit
                     endif
               end
            endif
            oQuery:Destroy()
            
         endif

         return(nil)
*-------------------------------------------------------------------------------
static function servico_excluir_2()

	   local cQuery, cQuery_1
       local oQuery, oQuery_1
       local oRow_1
       local n_i := 0
       local nSub_Total := 0

	   local v_id   := alltrim(valor_coluna('grid_servicos','form_acompanhamento',1))
	   local v_nome := alltrim(valor_coluna('grid_servicos','form_acompanhamento',2))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a exclusão de : '+v_nome+' ?')
       	  cQuery := 'delete from os_servicos where id = '+v_id
          oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
          	 msginfo('Erro na Exclusão : '+oQuery:Error())
             return(nil)
          endif
          oQuery:Destroy()
		  /*
		    atualizar informações
		  */
	   	 oQuery_1 := oServer:Query('select * from os_servicos where numero_os = '+_numero_os)
  	   	 if oQuery_1:NetErr()
 	 	  	msginfo('Erro de Pesquisa : '+oQuery_1:Error())
   	 	  	return(nil)
	     else
	 	    delete item all from grid_servicos of form_acompanhamento
 	   		for n_i := 1 to oQuery_1:LastRec()
    	  		oRow_1 := oQuery_1:GetRow(n_i)
	  			nSub_Total := (oRow_1:fieldGet(7)*oRow_1:fieldGet(6))
      			add item {alltrim(str(oRow_1:fieldGet(1))),alltrim(oRow_1:fieldGet(5)),str(oRow_1:fieldGet(6),4),trans(oRow_1:fieldGet(7),'@E 9,999.99'),trans(nSub_Total,'@E 99,999.99'),alltrim(str(oRow_1:fieldGet(9)))} to grid_servicos of form_acompanhamento
				oQuery_1:Skip(1)
			next n_i
            oQuery_1:Destroy()
         endif
 	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function servico_incluir_2(p_numero_os)

	   define window form_inclui_servico;
       		  at 0,0;
              width 280;
              height 225;
              title 'Incluir Serviço';
              icon 'icone';
              modal;
              nosize

			  /*
			    label
			  */
              @ 010,010 label lbl_servico;
                        value 'Serviço';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 060,010 label lbl_quantidade;
                        value 'QTD';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 060,120 label lbl_unitario;
                        value 'UNIT.R$';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 110,010 label lbl_tecnico;
                        value 'Técnico';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 030,080 label lbl_nome_servico;
                        value '';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor BLUE transparent
              @ 130,080 label lbl_nome_tecnico;
                        value '';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor BLUE transparent

			  /*
			    textbox
			  */
              @ 030,010 textbox tbox_servico;
                        width 50;
                        value 0;
                        numeric;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        on enter pesq_servico()
              @ 080,010 textbox txt_quantidade;
              			width 100;
                        value 0;
                        numeric inputmask '999999'
              @ 080,120 textbox txt_unitario;
                        width 100;
                        value 0;
                        numeric inputmask '9,999.99'
              @ 130,010 textbox tbox_tecnico;
                        width 50;
                        value 0;
                        numeric;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        on enter pesq_tecnico()

                define buttonex btn_grava
                       row 160
                       col 086
                       width 080
                       height 030
                       caption 'Gravar'
                       picture 'ok'
                       fontbold .T.
                       lefttext .F.
                       action (grava_servico(p_numero_os),form_inclui_servico.tbox_servico.setfocus)
                end buttonex
                define buttonex btn_cancela
                       row 160
                       col 170
                       width 100
                       height 030
                       caption 'Cancelar'
                       picture 'cancela'
                       fontbold .T.
                       lefttext .F.
                       action form_inclui_servico.release
                end buttonex

         end window

         form_inclui_servico.tbox_servico.setfocus
		 form_inclui_servico.center
	 	 form_inclui_servico.activate

         return(nil)
*-------------------------------------------------------------------------------
static function pesq_servico()

	   local x_servico := form_inclui_servico.tbox_servico.value
	   local x_nome    := ''
	   local oQuery
       local oRow := {}
       local x_2  := '2'

	   if x_servico <> 0
       	  oQuery := oServer:Query("select id,nome,preco from produtos where id='"+alltrim(str(x_servico))+"' and tipo='"+x_2+"' order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
	   	  x_nome := alltrim(oRow:fieldGet(2))
	   	  m_nome_servico := x_nome
	   	  setproperty('form_inclui_servico','lbl_nome_servico','value',x_nome)
	   	  setproperty('form_inclui_servico','txt_unitario','value',oRow:fieldGet(3))
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Serviço';
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
static function grava_servico(p_numero_os)

	   local cQuery
       local oQuery

	   local x_1 := alltrim(str(form_inclui_servico.tbox_servico.value))
	   local x_2 := alltrim(str(form_inclui_servico.txt_quantidade.value))
	   local x_3 := alltrim(str(form_inclui_servico.txt_unitario.value,12,2))
	   local x_4 := alltrim(str(form_inclui_servico.tbox_tecnico.value))

	   local n_quantidade := form_inclui_servico.txt_quantidade.value
	   local n_unitario   := form_inclui_servico.txt_unitario.value
	   local n_subtotal   := ( n_quantidade * n_unitario )

	   if x_1 == '0'
       	  msginfo('Obrigatório preencher os campos','Atenção')
          return(nil)
       else
	   	  cQuery := "insert into os_servicos (numero_os,servico,nome_servico,quantidade,unitario,subtotal,tecnico,data) values ('"
		  cQuery += p_numero_os +"','"
 		  cQuery += x_1 +"','"
 		  cQuery += m_nome_servico +"','"
  		  cQuery += x_2 +"','"
   		  cQuery += x_3 +"','"
   		  cQuery += alltrim(str(n_subtotal,12,2)) +"','"
	 	  cQuery += x_4 +"','"
  		  cQuery += td(date()) +"')"

     	  oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
         	 msginfo('Erro na Inclusão : '+oQuery:Error())
          	 return(nil)
          endif

  	      oQuery:Destroy()

		  add item {alltrim(p_numero_os),m_nome_servico,str(form_inclui_servico.txt_quantidade.value,4),trans(form_inclui_servico.txt_unitario.value,'@E 9,999.99'),trans(n_subtotal,'@E 99,999.99'),x_4} to grid_servicos of form_acompanhamento

          n_soma_total := n_soma_total + n_subtotal
          setproperty('form_acompanhamento','lbl_total_os','value',trans(n_soma_total,'@E 999,999.99'))
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function alimenta_pesquisa_2()

	   local i := 0
	   local oQuery
       local oRow := {}
       local x_2  := '2'

  	   oQuery := oServer:Query("select id,nome from produtos where tipo='"+x_2+"' order by nome")

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

	   local x_servico := val(v_id)
	   local x_nome    := ''
	   local oQuery
       local oRow := {}
       local x_2  := '2'

       	  oQuery := oServer:Query("select id,nome,preco from produtos where id='"+alltrim(str(x_servico))+"' and tipo='"+x_2+"' order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow       := oQuery:GetRow(1)
	   	  x_nome     := alltrim(oRow:fieldGet(2))
	   	  m_nome_servico := x_nome
	   	  setproperty('form_inclui_servico','tbox_servico','value',val(v_id))
	   	  setproperty('form_inclui_servico','lbl_nome_servico','value',x_nome)
	   	  setproperty('form_inclui_servico','txt_unitario','value',oRow:fieldGet(3))

	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function pesq_tecnico()

	   local x_servico := form_inclui_servico.tbox_tecnico.value
	   local x_nome    := ''
	   local oQuery
       local oRow := {}

	   if x_servico <> 0
       	  oQuery := oServer:Query("select id,nome from funcionarios order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
	   	  x_nome := alltrim(oRow:fieldGet(2))
	   	  m_nome_tecnico := x_nome
	   	  setproperty('form_inclui_servico','lbl_nome_tecnico','value',x_nome)
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Técnico';
              icon 'icone';
		      modal;
		      nosize;
		      on init alimenta_pesquisa_3()

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
                     ondblclick passa_pesquisa_3()
              end grid

			  on key escape action form_pesquisa.release

	   end window

	   form_pesquisa.center
	   form_pesquisa.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function alimenta_pesquisa_3()

	   local i := 0
	   local oQuery
       local oRow := {}

  	   oQuery := oServer:Query("select id,nome from funcionarios order by nome")

	   for i := 1 to oQuery:LastRec()
 	   	   oRow := oQuery:GetRow(i)
           add item {alltrim(str(oRow:fieldGet(1),6)),alltrim(oRow:fieldGet(2))} to grid_pesquisa of form_pesquisa
           oQuery:Skip(1)
       next i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function passa_pesquisa_3()

	   local v_id   := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',1))
	   local v_nome := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',2))

	   local x_servico := val(v_id)
	   local x_nome    := ''
	   local oQuery
       local oRow := {}

       	  oQuery := oServer:Query("select id,nome from funcionarios order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow       := oQuery:GetRow(1)
	   	  x_nome     := alltrim(oRow:fieldGet(2))
	   	  m_nome_tecnico := x_nome
	   	  setproperty('form_inclui_servico','tbox_tecnico','value',val(v_id))
	   	  setproperty('form_inclui_servico','lbl_nome_tecnico','value',x_nome)

	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function pecas_excluir_2()

	   local cQuery
       local oQuery

	   local v_id   := alltrim(valor_coluna('grid_pecas','form_acompanhamento',1))
	   local v_nome := alltrim(valor_coluna('grid_pecas','form_acompanhamento',2))

       if empty(v_id)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   if msgyesno('Confirma a exclusão de : '+v_nome+' ?')
       	  cQuery := 'delete from os_pecas where id = '+v_id
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
static function pecas_incluir_2(p_numero_os)

	   define window form_inclui_peca;
       		  at 0,0;
              width 280;
              height 225;
              title 'Incluir Peças';
              icon 'icone';
              modal;
              nosize

			  /*
			    label
			  */
              @ 010,010 label lbl_peca;
                        value 'Peça';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 060,010 label lbl_quantidade;
                        value 'QTD';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 060,120 label lbl_unitario;
                        value 'UNIT.R$';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 110,010 label lbl_tecnico;
                        value 'Técnico';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 030,080 label lbl_nome_peca;
                        value '';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor BLUE transparent
              @ 130,080 label lbl_nome_tecnico;
                        value '';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor BLUE transparent

			  /*
			    textbox
			  */
              @ 030,010 textbox tbox_peca;
                        width 50;
                        value 0;
                        numeric;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        on enter pesq_peca()
              @ 080,010 textbox txt_quantidade;
              			width 100;
                        value 0;
                        numeric inputmask '999999'
              @ 080,120 textbox txt_unitario;
                        width 100;
                        value 0;
                        numeric inputmask '9,999.99'
              @ 130,010 textbox tbox_tecnico;
                        width 50;
                        value 0;
                        numeric;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        on enter pesq_tecnico_2()

                define buttonex btn_grava
                       row 160
                       col 086
                       width 080
                       height 030
                       caption 'Gravar'
                       picture 'ok'
                       fontbold .T.
                       lefttext .F.
                       action (grava_peca(p_numero_os),form_inclui_peca.tbox_peca.setfocus)
                end buttonex
                define buttonex btn_cancela
                       row 160
                       col 170
                       width 100
                       height 030
                       caption 'Cancelar'
                       picture 'cancela'
                       fontbold .T.
                       lefttext .F.
                       action form_inclui_peca.release
                end buttonex

         end window

         form_inclui_peca.tbox_peca.setfocus
		 form_inclui_peca.center
	 	 form_inclui_peca.activate

         return(nil)
*-------------------------------------------------------------------------------
static function grava_peca(p_numero_os)

	   local cQuery
       local oQuery

	   local x_1 := alltrim(str(form_inclui_peca.tbox_peca.value))
	   local x_2 := alltrim(str(form_inclui_peca.txt_quantidade.value))
	   local x_3 := alltrim(str(form_inclui_peca.txt_unitario.value,12,2))
	   local x_4 := alltrim(str(form_inclui_peca.tbox_tecnico.value))

	   local n_quantidade := form_inclui_peca.txt_quantidade.value
	   local n_unitario   := form_inclui_peca.txt_unitario.value
	   local n_subtotal   := ( n_quantidade * n_unitario )

	   if x_1 == '0'
       	  msginfo('Obrigatório preencher os campos','Atenção')
          return(nil)
       else
	   	  cQuery := "insert into os_pecas (numero_os,peca,nome_peca,quantidade,unitario,subtotal,tecnico,data) values ('"
		  cQuery += p_numero_os +"','"
 		  cQuery += x_1 +"','"
 		  cQuery += m_nome_peca +"','"
  		  cQuery += x_2 +"','"
   		  cQuery += x_3 +"','"
   		  cQuery += alltrim(str(n_subtotal,12,2)) +"','"
	 	  cQuery += x_4 +"','"
  		  cQuery += td(date()) +"')"

     	  oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
         	 msginfo('Erro na Inclusão : '+oQuery:Error())
          	 return(nil)
          endif

  	      oQuery:Destroy()
  	      
		  add item {alltrim(p_numero_os),m_nome_peca,str(form_inclui_peca.txt_quantidade.value,4),trans(form_inclui_peca.txt_unitario.value,'@E 9,999.99'),trans(n_subtotal,'@E 99,999.99'),x_4} to grid_pecas of form_acompanhamento

          n_soma_total := n_soma_total + n_subtotal
          setproperty('form_acompanhamento','lbl_total_os','value',trans(n_soma_total,'@E 999,999.99'))
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function pesq_peca()

	   local x_peca  := form_inclui_peca.tbox_peca.value
	   local x_nome  := ''
	   local oQuery
       local oRow := {}
       local x_2  := '1'

	   if x_peca <> 0
       	  oQuery := oServer:Query("select id,nome,preco from produtos where id='"+alltrim(str(x_peca))+"' and tipo='"+x_2+"' order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
	   	  x_nome := alltrim(oRow:fieldGet(2))
	   	  m_nome_peca := x_nome
	   	  setproperty('form_inclui_peca','lbl_nome_peca','value',x_nome)
	   	  setproperty('form_inclui_peca','txt_unitario','value',oRow:fieldGet(3))
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Peça';
              icon 'icone';
		      modal;
		      nosize;
		      on init alimenta_pesquisa_4()

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
                     ondblclick passa_pesquisa_4()
              end grid

			  on key escape action form_pesquisa.release

	   end window

	   form_pesquisa.center
	   form_pesquisa.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function alimenta_pesquisa_4()

	   local i := 0
	   local oQuery
       local oRow := {}
       local x_2  := '1'

  	   oQuery := oServer:Query("select id,nome from produtos where tipo='"+x_2+"' order by nome")

	   for i := 1 to oQuery:LastRec()
 	   	   oRow := oQuery:GetRow(i)
           add item {alltrim(str(oRow:fieldGet(1),6)),alltrim(oRow:fieldGet(2))} to grid_pesquisa of form_pesquisa
           oQuery:Skip(1)
       next i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function passa_pesquisa_4()

	   local v_id   := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',1))
	   local v_nome := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',2))

	   local x_peca := val(v_id)
	   local x_nome := ''
	   local oQuery
       local oRow := {}
       local x_2  := '1'

       	  oQuery := oServer:Query("select id,nome,preco from produtos where id='"+alltrim(str(x_peca))+"' and tipo='"+x_2+"' order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow        := oQuery:GetRow(1)
	   	  x_nome      := alltrim(oRow:fieldGet(2))
	   	  m_nome_peca := x_nome
	   	  setproperty('form_inclui_peca','tbox_peca','value',val(v_id))
	   	  setproperty('form_inclui_peca','lbl_nome_peca','value',x_nome)
	   	  setproperty('form_inclui_peca','txt_unitario','value',oRow:fieldGet(3))
	   	  
	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function pesq_tecnico_2()

	   local x_servico := form_inclui_peca.tbox_tecnico.value
	   local x_nome    := ''
	   local oQuery
       local oRow := {}

	   if x_servico <> 0
       	  oQuery := oServer:Query("select id,nome from funcionarios order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow   := oQuery:GetRow(1)
	   	  x_nome := alltrim(oRow:fieldGet(2))
	   	  m_nome_tecnico := x_nome
	   	  setproperty('form_inclui_peca','lbl_nome_tecnico','value',x_nome)
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Técnico';
              icon 'icone';
		      modal;
		      nosize;
		      on init alimenta_pesquisa_5()

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
                     ondblclick passa_pesquisa_5()
              end grid

			  on key escape action form_pesquisa.release

	   end window

	   form_pesquisa.center
	   form_pesquisa.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function alimenta_pesquisa_5()

	   local i := 0
	   local oQuery
       local oRow := {}

  	   oQuery := oServer:Query("select id,nome from funcionarios order by nome")

	   for i := 1 to oQuery:LastRec()
 	   	   oRow := oQuery:GetRow(i)
           add item {alltrim(str(oRow:fieldGet(1),6)),alltrim(oRow:fieldGet(2))} to grid_pesquisa of form_pesquisa
           oQuery:Skip(1)
       next i

	   oQuery:Destroy()

	   return(nil)
*-------------------------------------------------------------------------------
static function passa_pesquisa_5()

	   local v_id   := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',1))
	   local v_nome := alltrim(valor_coluna('grid_pesquisa','form_pesquisa',2))

	   local x_servico := val(v_id)
	   local x_nome    := ''
	   local oQuery
       local oRow := {}

       	  oQuery := oServer:Query("select id,nome from funcionarios order by nome")
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow       := oQuery:GetRow(1)
	   	  x_nome     := alltrim(oRow:fieldGet(2))
	   	  m_nome_tecnico := x_nome
	   	  setproperty('form_inclui_peca','tbox_tecnico','value',val(v_id))
	   	  setproperty('form_inclui_peca','lbl_nome_tecnico','value',x_nome)

	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function imprime_os_2(p_numero_os)

	   local oQuery, oQuery_1, oQuery_2, oQuery_3
       local n_i := 0
       local oRow   := {}
       local oRow_1 := {}
       local oRow_2 := {}
       local oRow_3 := {}
       
       local n_linha := 50

	   local nCod_Cliente := 0
       local nSub_Servico := 0
	   local nTot_Servico := 0
       local nSub_Peca    := 0
       local nTot_Peca    := 0
       local nTotal_OS    := 0
       
       local v_id_cliente
       
       if empty(p_numero_os)
		  return(nil)
	   endif

	   /*
	     seleciona OS
	   */
	   oQuery := oServer:Query("select * from os where numero = '"+p_numero_os+"' order by data")
       oRow := oQuery:GetRow(1)
	   v_id_cliente := alltrim(str(oRow:fieldGet(5)))
	   /*
	     seleciona cliente
	   */
	   oQuery_3 := oServer:Query("select * from clientes where id = '"+v_id_cliente+"' order by id")
       oRow_3 := oQuery_3:GetRow(1)

       SELECT PRINTER DIALOG PREVIEW
       START PRINTDOC NAME 'Gerenciador de impressão'
       START PRINTPAGE

	   cabecalho_os(p_numero_os)

	   @ n_linha,020 PRINT 'Data/Hora Atendimento' FONT 'courier new' SIZE 10
       @ n_linha,100 PRINT 'Data/Hora Previsão Entrega' FONT 'courier new' SIZE 10
       n_linha += 5
	   @ n_linha,020 PRINT dtoc(oRow:fieldGet(3))+' / '+oRow:fieldGet(4) FONT 'courier new' SIZE 10 BOLD
       @ n_linha,100 PRINT dtoc(oRow:fieldGet(11))+' / '+alltrim(oRow:fieldGet(12)) FONT 'courier new' SIZE 10 BOLD

	   n_linha += 8

	   @ n_linha,020 PRINT 'DADOS DO CLIENTE' FONT 'courier new' SIZE 10 BOLD
	   n_linha += 6
	   @ n_linha,040 PRINT alltrim(oRow_3:fieldGet(5)) FONT 'courier new' SIZE 10 BOLD
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(oRow_3:fieldGet(8)) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(oRow_3:fieldGet(11))+' - '+alltrim(oRow_3:fieldGet(12)) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(oRow_3:fieldGet(10)) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(oRow_3:fieldGet(6))+' - '+alltrim(oRow_3:fieldGet(7)) FONT 'courier new' SIZE 10

	   n_linha += 5
       @ n_linha,010 PRINT LINE TO n_linha,205 PENWIDTH 0.5 COLOR _preto_001
       n_linha += 5

	   @ n_linha,040 PRINT 'Aparelho             : '+alltrim(oRow:fieldGet(16)) FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Marca                : '+alltrim(oRow:fieldGet(17)) FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Modelo               : '+alltrim(oRow:fieldGet(18)) FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Nº de Série          : '+alltrim(oRow:fieldGet(19)) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT 'Defeito Apresentado  : '+alltrim(oRow:fieldGet(22)) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT 'Estado do Aparelho   : '+aEstado[oRow:fieldGet(20)] FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Condição do Aparelho : '+aCondicao[oRow:fieldGet(21)] FONT 'courier new' SIZE 10

	   n_linha += 5
       @ n_linha,010 PRINT LINE TO n_linha,205 PENWIDTH 0.5 COLOR _preto_001
       n_linha += 5
	   /*
		 serviços
	   */
	   @ n_linha,020 PRINT 'SERVIÇOS' FONT 'courier new' SIZE 10 BOLD
	   n_linha += 8
	   @ n_linha,020 PRINT 'Descrição' FONT 'courier new' SIZE 10 BOLD
	   @ n_linha,100 PRINT 'QTD.' FONT 'courier new' SIZE 10 BOLD
	   @ n_linha,130 PRINT 'Unitário R$' FONT 'courier new' SIZE 10 BOLD
	   @ n_linha,170 PRINT 'Sub-Total R$' FONT 'courier new' SIZE 10 BOLD
	   n_linha += 5
	   
	   oQuery_1 := oServer:Query("select nome_servico,quantidade,unitario,subtotal from os_servicos where numero_os = '"+p_numero_os+"' order by data")
       if oQuery_1:NetErr()
       	  msginfo('Erro de Pesquisa : '+oQuery_1:Error())
		  return(nil)
       endif
	   if oQuery_1:Eof()
	   	  msginfo('Sua pesquisa não foi encontrada, tecle ENTER','Atenção')
		  return(nil)
	   endif
	   n_total_servicos := 0
 	   for n_i := 1 to oQuery_1:LastRec()
	   	     oRow_1 := oQuery_1:GetRow(n_i)
             @ n_linha,020 PRINT alltrim(oRow_1:fieldGet(1)) FONT 'courier new' SIZE 010
             @ n_linha,100 PRINT alltrim(str(oRow_1:fieldGet(2))) FONT 'courier new' SIZE 010
             @ n_linha,130 PRINT trans(oRow_1:fieldGet(3),'@E 999,999.99') FONT 'courier new' SIZE 010
             @ n_linha,170 PRINT trans(oRow_1:fieldGet(4),'@E 999,999.99') FONT 'courier new' SIZE 010
             n_total_servicos := ( n_total_servicos + oRow_1:fieldGet(4) )
             n_linha += 5
		     oQuery_1:Skip(1)
	   next n_i
       @ n_linha,170 PRINT trans(n_total_servicos,'@E 999,999.99') FONT 'courier new' SIZE 010 BOLD
	   oQuery_1:Destroy()

	   n_linha += 10
	   n_i := 0
	   /*
	     peças
	   */
	   @ n_linha,020 PRINT 'PEÇAS' FONT 'courier new' SIZE 10 BOLD
	   n_linha += 8
	   @ n_linha,020 PRINT 'Descrição' FONT 'courier new' SIZE 10 BOLD
	   @ n_linha,100 PRINT 'QTD.' FONT 'courier new' SIZE 10 BOLD
	   @ n_linha,130 PRINT 'Unitário R$' FONT 'courier new' SIZE 10 BOLD
	   @ n_linha,170 PRINT 'Sub-Total R$' FONT 'courier new' SIZE 10 BOLD
	   n_linha += 5

	   oQuery_2 := oServer:Query("select nome_peca,quantidade,unitario,subtotal from os_pecas where numero_os = '"+p_numero_os+"' order by data")
       if oQuery_2:NetErr()
       	  msginfo('Erro de Pesquisa : '+oQuery_2:Error())
		  return(nil)
       endif
	   if oQuery_2:Eof()
	   	  msginfo('Sua pesquisa não foi encontrada, tecle ENTER','Atenção')
		  return(nil)
	   endif
	   n_total_pecas := 0
 	   for n_i := 1 to oQuery_2:LastRec()
	   	     oRow_2 := oQuery_2:GetRow(n_i)
             @ n_linha,020 PRINT alltrim(oRow_2:fieldGet(1)) FONT 'courier new' SIZE 010
             @ n_linha,100 PRINT alltrim(str(oRow_2:fieldGet(2))) FONT 'courier new' SIZE 010
             @ n_linha,130 PRINT trans(oRow_2:fieldGet(3),'@E 999,999.99') FONT 'courier new' SIZE 010
             @ n_linha,170 PRINT trans(oRow_2:fieldGet(4),'@E 999,999.99') FONT 'courier new' SIZE 010
             n_total_pecas := ( n_total_pecas + oRow_2:fieldGet(4) )
             n_linha += 5
		     oQuery_2:Skip(1)
	   next n_i
       @ n_linha,170 PRINT trans(n_total_pecas,'@E 999,999.99') FONT 'courier new' SIZE 010 BOLD
	   oQuery_2:Destroy()
	   
	   n_linha += 8
       @ n_linha,140 PRINT 'TOTAL DA OS :' FONT 'courier new' SIZE 010 BOLD
       @ n_linha,170 PRINT trans(n_total_servicos+n_total_pecas,'@E 999,999.99') FONT 'courier new' SIZE 010 BOLD
       
	   n_linha += 30

       @ n_linha,070 PRINT LINE TO n_linha,205 PENWIDTH 0.5 COLOR _preto_001
       n_linha += 3
	   @ n_linha,120 PRINT 'Assinatura do Cliente' FONT 'courier new' SIZE 10

       rodape()

       END PRINTPAGE
       END PRINTDOC

	   return(nil)
*-------------------------------------------------------------------------------
static function cabecalho_os(p_numero_os)

       @ 007,010 PRINT IMAGE 'logotipo' WIDTH 030 HEIGHT 025 STRETCH
       @ 010,050 PRINT 'Empresa Teste & Teste Ltda' FONT 'verdana' SIZE 012 BOLD
       @ 015,050 PRINT 'CNPJ : 99.999.999/9999-99 - Insc.Estadual : 154954554620-XX' FONT 'verdana' SIZE 010
       @ 018,050 PRINT 'Rua Mal Floriano Peixoto, 8437 - Centro - São Paulo/SP' FONT 'verdana' SIZE 010
	   @ 021,050 PRINT 'Telefone : (11) 9999-9999 - empresateste@empresa.com.br' FONT 'verdana' SIZE 010

       @ 030,000 PRINT LINE TO 030,205 PENWIDTH 0.5 COLOR _preto_001

       @ 037,040 PRINT 'ORDEM DE SERVIÇO Nº : '+alltrim(p_numero_os) FONT 'verdana' SIZE 018 BOLD

	   return(nil)
*-------------------------------------------------------------------------------
static function rodape()

       @ 275,000 PRINT LINE TO 275,205 PENWIDTH 0.5 COLOR _preto_001
       @ 276,010 PRINT 'impresso em '+dtoc(date())+' as '+time() FONT 'courier new' SIZE 008

       return(nil)
*-------------------------------------------------------------------------------
function Inserir_Datas()

         local x_data_saida, x_hora_saida, x_data_garantia

	   local cQuery
       local oQuery
       local oRow

	   local nCodigo := alltrim(valor_coluna('grid_os','form_acompanhamento',1))
	   local v_nome  := alltrim(valor_coluna('grid_os','form_acompanhamento',9))

       if empty(nCodigo)
       	  msginfo('Faça uma pesquisa antes, tecle ENTER','Atenção')
       	  return(nil)
	   endif

	   oQuery := oServer:Query('select * from os where id = '+nCodigo)
  	   if oQuery:NetErr()
 	 	  msginfo('Erro de Pesquisa : '+oQuery:Error())
   	 	  return(nil)
	   else
          oRow            := oQuery:GetRow(1)
          x_data_saida    := oRow:fieldGet(13)
          x_hora_saida    := alltrim(oRow:fieldGet(14))
          x_data_garantia := oRow:fieldGet(15)
          oQuery:Destroy()
       endif

         define window form_data;
                at 000,000;
                width 250;
                height 200;
                title 'Saída do aparelho';
                icon 'icone';
                modal;
                nosize

                @ 010,005 label lbl_001;
                          value 'Data Entrega'
                @ 040,005 label lbl_002;
                          value 'Hora Entrega'
                @ 070,005 label lbl_003;
                          value 'Data Garantia';
                          bold
                @ 010,100 datepicker dpi_data_entrega;
                          width 100;
                          value x_data_saida
                @ 040,100 textbox txt_hora_entrega;
                          width 45;
                          value x_hora_saida;
                          inputmask '99:99'
                @ 070,100 datepicker dpi_data_garantia;
                          width 100;
                          value x_data_garantia

                define buttonex btn_grava
                       col form_data.width-225
                       row form_data.height-085
                       width 120
                       height 050
                       caption 'Gravar'
                       picture 'img_gravar'
                       fontbold .T.
                       lefttext .F.
                       action Gravar_Datas(nCodigo)
                end buttonex
                define buttonex btn_cancela
                       col form_data.width-100
                       row form_data.height-085
                       width 090
                       height 050
                       caption 'Voltar'
                       picture 'img_voltar'
                       fontbold .T.
                       lefttext .F.
                       action form_data.release
                end buttonex

         end window

	 	 form_data.center
	 	 form_data.activate

         return(nil)
*-------------------------------------------------------------------------------
static function gravar_datas(p_id)

	   local cQuery
       local oQuery

	   local v_data_entrega  := form_data.dpi_data_entrega.value
	   local v_hora_entrega  := alltrim(form_data.txt_hora_entrega.value)
	   local v_data_garantia := form_data.dpi_data_garantia.value

	   cQuery := "update os set "
	   cQuery += "data_saida='"+td(v_data_entrega)+"',"
	   cQuery += "hora_saida='"+v_hora_entrega+"',"
	   cQuery += "data_garantia='"+td(v_data_garantia)+"'"
	   cQuery += " where id='"+p_id+"'"

	   oQuery := oQuery := oServer:Query( cQuery )

	   if oQuery:NetErr()
   	   	  msginfo('Erro na Alteração : '+oQuery:Error())
		  return(nil)
       endif

	   oQuery:Destroy()

	   form_data.release

	   return(nil)
*-------------------------------------------------------------------------------
function Mostra_Servicos_Pecas()

	   	 local cQuery, cQuery_1, cQuery_2
       	 local oQuery, oQuery_1, oQuery_2
       	 local oRow, oRow_1, oRow_2

         local cNumero_OS := alltrim(valor_coluna('grid_os','form_acompanhamento',2))
         local nSub_Total     := 0
         local nTotal_servico := 0
         local nTotal_peca    := 0
         
         local n_i := 0

       	 if empty(cNumero_OS)
       	  	return(nil)
	     endif

		 /*
		   atribui o número da OS para variável pública
		 */
		 _numero_os := cNumero_OS

		 /*
		   pesquisa : os
		 */
	   	 oQuery := oServer:Query('select * from os where numero = '+cNumero_OS)
  	   	 if oQuery:NetErr()
 	 	  	msginfo('Erro de Pesquisa : '+oQuery:Error())
   	 	  	return(nil)
	     else
            oRow := oQuery:GetRow(1)
         	form_acompanhamento.lbl_nome_cliente.value       := alltrim(oRow:fieldGet(6))
         	form_acompanhamento.lbl_data_hora_previsao.value := dtoc(oRow:fieldGet(11))+' - '+substr(oRow:fieldGet(12),1,5)
         	if oRow:fieldGet(24) == 2
               form_acompanhamento.lbl_encerrada.value := 'ENCERRADA'
               lEncerrada := .T.
            else
               form_acompanhamento.lbl_encerrada.value := ''
               lEncerrada := .F.
            endif
            oQuery:Destroy()
         endif
		 /*
		   pesquisa : serviço os
		 */
	   	 oQuery_1 := oServer:Query('select * from os_servicos where numero_os = '+cNumero_OS)
  	   	 if oQuery_1:NetErr()
 	 	  	msginfo('Erro de Pesquisa : '+oQuery_1:Error())
   	 	  	return(nil)
	     else
	 	    delete item all from grid_servicos of form_acompanhamento
 	   		for n_i := 1 to oQuery_1:LastRec()
    	  		oRow_1 := oQuery_1:GetRow(n_i)
	  			nSub_Total     := (oRow_1:fieldGet(7)*oRow_1:fieldGet(6))
   				nTotal_servico := (nTotal_servico + nSub_Total)
      			add item {alltrim(str(oRow_1:fieldGet(1))),alltrim(oRow_1:fieldGet(5)),str(oRow_1:fieldGet(6),4),trans(oRow_1:fieldGet(7),'@E 9,999.99'),trans(nSub_Total,'@E 99,999.99'),alltrim(str(oRow_1:fieldGet(9)))} to grid_servicos of form_acompanhamento
				oQuery_1:Skip(1)
			next n_i
            oQuery_1:Destroy()
         endif
         /*
           zera variável
         */
         n_i := 0
		 /*
		   pesquisa : peças
		 */
	   	 oQuery_2 := oServer:Query('select * from os_pecas where numero_os = '+cNumero_OS)
  	   	 if oQuery_2:NetErr()
 	 	  	msginfo('Erro de Pesquisa : '+oQuery_2:Error())
   	 	  	return(nil)
	     else
	 	    delete item all from grid_pecas of form_acompanhamento
 	   		for n_i := 1 to oQuery_2:LastRec()
            	oRow_2 := oQuery_2:GetRow(n_i)
				nSub_Total  := (oRow_2:fieldGet(7)*oRow_2:fieldGet(6))
   				nTotal_peca := (nTotal_peca + nSub_Total)
      			add item {alltrim(str(oRow_2:fieldGet(1))),alltrim(oRow_2:fieldGet(5)),str(oRow_2:fieldGet(6),4),trans(oRow_2:fieldGet(7),'@E 9,999.99'),trans(nSub_Total,'@E 99,999.99'),alltrim(str(oRow_2:fieldGet(9)))} to grid_pecas of form_acompanhamento
				oQuery_2:Skip(1)
			next n_i
            oQuery_2:Destroy()
         endif
         
         n_soma_total := ( nTotal_servico + nTotal_peca )

         lLog_IAE := .T.
         setproperty('form_acompanhamento','lbl_total_os','value',trans(n_soma_total,'@E 999,999.99'))

	 	 return(nil)
*-------------------------------------------------------------------------------
static function encerrar_os()

         local nCodigo_Confirma := HB_RANDOM(1649738,9999999)

		 local nNumOS := alltrim(valor_coluna('grid_os','form_acompanhamento',2))
         
         if !lLog_IAE
            msgexclamation('Selecione uma OS primeiro','Atenção')
            return(nil)
         endif

         define window form_encerra;
                at 000,000;
                width 260;
                height 160;
                title 'Encerrar OS';
                icon 'icone';
                modal;
                nosize

                @ 005,005 label lbl_001;
                          width 170;
                          value 'Digite aqui o código ao lado'
                @ 030,005 textbox txt_digita;
                          width 100;
                          maxlength 10;
                          uppercase
                @ 030,150 label lbl_codigo_confirma;
                          value substr(alltrim(str(nCodigo_Confirma)),1,7);
                          font 'verdana' size 14;
                          bold;
                          fontcolor _AZUL_ESCURO

                define buttonex btn_grava
                       row 090
                       col 065
                       width 080
                       height 030
                       caption 'Ok'
                       fontbold .T.
                       lefttext .F.
                       action Grava_Encerra(substr(alltrim(str(nCodigo_Confirma)),1,7),nNumOS)
                end buttonex
                define buttonex btn_cancela
                       row 090
                       col 150
                       width 100
                       height 030
                       caption 'Cancelar'
                       fontbold .T.
                       lefttext .F.
                       action form_encerra.release
                end buttonex
         end window

         form_encerra.txt_digita.setfocus
	 	 form_encerra.center
	 	 form_encerra.activate

         return(nil)
*-------------------------------------------------------------------------------
static function Grava_Encerra(cParametro,p_os)

		 local v_os := alltrim(p_os)
	   	 local cQuery
       	 local oQuery
         local cDigitado := substr(alltrim(form_encerra.txt_digita.value),1,7)

         if cDigitado <> cParametro
            msgstop('O código digitado não corresponde ao fornecido pelo sistema','Atenção')
            return(nil)
         else
            cQuery := "update os set encerrado=1 where numero='"+v_os+"'"
   	     	oQuery := oQuery := oServer:Query( cQuery )
            if oQuery:NetErr()
           	   msginfo('Erro na Alteração : '+oQuery:Error())
              return(nil)
            endif
       	    oQuery:Destroy()
       	    form_encerra.release
            delete item all from grid_os of form_acompanhamento
            delete item all from grid_servicos of form_acompanhamento
            delete item all from grid_pecas of form_acompanhamento
            setproperty('form_acompanhamento','lbl_003','value','')
            setproperty('form_acompanhamento','lbl_data_prevista','value','')
            setproperty('form_acompanhamento','lbl_nome_cliente','value','')
            setproperty('form_acompanhamento','lbl_data_hora_previsao','value','')
            setproperty('form_acompanhamento','lbl_encerrada','value','')
            setproperty('form_acompanhamento','lbl_total','value','')
            setproperty('form_acompanhamento','lbl_total_os','value','')
			form_acompanhamento.txt_pesquisa.setfocus
         endif

         return(nil)