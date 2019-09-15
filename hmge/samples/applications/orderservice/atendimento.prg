/*
  sistema     : ordem de serviço
  programa    : atendimento
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'

function atendimento()

		 local cNumero := substr(alltrim(str(HB_RANDOM(123513,999999))),1,6)
		 nNumOS        := val(cNumero)
		 
		 public m_nome_servico := ''
		 public m_nome_peca    := ''
		 public m_nome_tecnico := ''
		 
		 public n_soma_total := 0

         define window form_atendimento;
                at 0,0;
                width 1000;
                height 700;
                title 'Atendimento';
                icon 'icone';
                modal;
                nosize

			  /*
			    número da OS
			  */
              @ 225,740 label lbl_numero_os;
                 		width 300;
                 		value 'OS Nº : '+alltrim(str(nNumOS));
                 		font 'verdana' size 18 bold;
                 		fontcolor {176,0,0}
			  /*
			    labels
			  */
              @ 005,010 label lbl_cliente;
                        value 'Cliente';
                        autosize;
                        font 'verdana' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 025,080 label lbl_nome_cliente;
                        value '';
                        autosize;
                        font 'verdana' size 014 bold;
                        fontcolor BLACK transparent
              @ 060,080 label lbl_endereco_cliente;
                        value '';
                        autosize;
                        font 'verdana' size 012;
                        fontcolor BLACK transparent
              @ 080,080 label lbl_baicid_cliente;
                        value '';
                        autosize;
                        font 'verdana' size 012;
                        fontcolor BLACK transparent
              @ 100,080 label lbl_complemento_cliente;
                        value '';
                        autosize;
                        font 'verdana' size 012;
                        fontcolor BLACK transparent
              @ 130,080 label lbl_fixo_cliente;
                        value '';
                        autosize;
                        font 'verdana' size 016 bold;
                        fontcolor BLACK transparent
              @ 170,080 label lbl_celular_cliente;
                        value '';
                        autosize;
                        font 'verdana' size 016 bold;
                        fontcolor BLACK transparent

              @ 005,560 label lbl_aparelho;
                        value 'Aparelho';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 040,560 label lbl_marca;
                        value 'Marca';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 075,560 label lbl_modelo;
                        value 'Modelo';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 110,560 label lbl_numserie;
                        value 'Nº Série';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 145,560 label lbl_defeito;
                        value 'Defeito';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 180,560 label lbl_estado;
                        value 'Estado';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 180,745 label lbl_condicao;
                        value 'Condição';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
			  /*
			    textbox
			  */
              @ 025,010 textbox tbox_cliente;
                        width 50;
                        value 0;
                        numeric;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        on enter pesq_cliente()
              @ 005,635 textbox tbox_aparelho;
                        height 027;
                        width 350;
                        value '';
                        maxlength 050;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 040,635 textbox tbox_marca;
                        height 027;
                        width 350;
                        value '';
                        maxlength 050;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 075,635 textbox tbox_modelo;
                        height 027;
                        width 350;
                        value '';
                        maxlength 050;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 110,635 textbox tbox_numserie;
                        height 027;
                        width 350;
                        value '';
                        maxlength 040;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 145,635 textbox tbox_defeito;
                        height 027;
                        width 350;
                        value '';
                        maxlength 060;
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                        uppercase
              @ 180,635 comboboxex cbo_estado;
                   		width 100;
                   		items aEstado;
                   		value 1
              @ 180,815 comboboxex cbo_condicao;
                   		width 100;
                   		items aCondicao;
                   		value 1
			  /*
              	linha separadora - meio da tela
              */
              define label linha_rodape_1
                     col 0
                     row 220
                     value ''
                     width form_atendimento.width
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
                     action servico_incluir(cNumero)
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
                     action servico_excluir()
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
                 		headers {'ID','Descrição','Qtd.','Unit.R$','Sub-Total R$','Técnico','ID Tec.'};
                 		widths {1,300,60,100,120,100,1};
                       	font 'courier new' size 10 bold;
                 		backcolor _AMARELO2;
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
                     action pecas_incluir(cNumero)
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
                     action pecas_excluir()
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
                 		headers {'ID','Descrição','Qtd.','Unit.R$','Sub-Total R$','Técnico','ID Tec.'};
                 		widths {1,300,60,100,120,100,1};
                       	font 'courier new' size 10 bold;
                 		backcolor _AMARELO2;
                 		fontcolor BLACK
			  /*
			    previsão entrega
			  */
              @ 300,750 label lbl_previsao;
                        value 'PREVISÃO DE ENTREGA';
                        autosize;
                        font 'tahoma' size 12 bold;
                        fontcolor BLUE transparent
              @ 330,770 label lbl_data_entrega;
                        value 'Data';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 350,770 datepicker dpi_data_entrega;
                 		width 100;
                 		value date()
              @ 330,880 label lbl_hora_entrega;
                        value 'Hora';
                        autosize;
                        font 'tahoma' size 010 bold;
                        fontcolor _preto_001 transparent
              @ 350,880 textbox tbox_hora_entrega;
                        height 027;
                        width 50;
                        value '';
                        font 'tahoma' size 010;
                        backcolor _fundo_get;
                        fontcolor _letra_get_1;
                 		inputmask '99:99'
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
                     row form_atendimento.height-090
                     value ''
                     width form_atendimento.width
                     height 001
                     backcolor _preto_001
                     transparent .F.
              end label
              /*
                botões
              */
              define buttonex button_recibo
                     picture 'imprimir'
                     col form_atendimento.width-515
                     row form_atendimento.height-085
                     width 140
                     height 050
                     caption 'Recibo OS'
                     action recibo_os(cNumero)
                     fontbold .T.
                     tooltip 'Imprimir o Recibo desta Ordem de Serviço para o Cliente'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_imprime
                     picture 'imprimir'
                     col form_atendimento.width-370
                     row form_atendimento.height-085
                     width 140
                     height 050
                     caption 'Imprime OS'
                     action imprime_os(cNumero)
                     fontbold .T.
                     tooltip 'Imprimir esta Ordem de Serviço'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_ok
                     picture 'img_gravar'
                     col form_atendimento.width-225
                     row form_atendimento.height-085
                     width 120
                     height 050
                     caption 'Gravar OS'
                     action gravar_os(cNumero)
                     fontbold .T.
                     tooltip 'Confirmar as informações digitadas'
                     flat .F.
                     noxpstyle .T.
              end buttonex
              define buttonex button_cancela
                     picture 'img_voltar'
                     col form_atendimento.width-100
                     row form_atendimento.height-085
                     width 090
                     height 050
                     caption 'Voltar'
                     action form_atendimento.release
                     fontbold .T.
                     tooltip 'Sair desta tela sem gravar informações'
                     flat .F.
                     noxpstyle .T.
              end buttonex

			  on key escape action thiswindow.release

         end window

         form_atendimento.center
         form_atendimento.activate

         return(nil)
*-------------------------------------------------------------------------------
static function pesq_cliente()

	   local x_cliente  := form_atendimento.tbox_cliente.value
	   local x_nome     := ''
	   local x_endereco := ''
	   local x_baicid   := ''
	   local x_complem  := ''
	   local x_fixo     := ''
	   local x_celular  := ''
	   local oQuery
       local oRow := {}

	   if x_cliente <> 0
       	  oQuery := oServer:Query('select nome,endereco,numero,bairro,cidade,complemento,fixo,celular from clientes where id = '+alltrim(str(x_cliente)))
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow       := oQuery:GetRow(1)
	   	  x_nome     := alltrim(oRow:fieldGet(1))
	   	  x_endereco := alltrim(oRow:fieldGet(2))+', '+alltrim(oRow:fieldGet(3))
	   	  x_baicid   := alltrim(oRow:fieldGet(4))+', '+alltrim(oRow:fieldGet(5))
	   	  x_complem  := alltrim(oRow:fieldGet(6))
	   	  x_fixo     := alltrim(oRow:fieldGet(7))
	   	  x_celular  := alltrim(oRow:fieldGet(8))
	   	  setproperty('form_atendimento','lbl_nome_cliente','value',x_nome)
	   	  setproperty('form_atendimento','lbl_endereco_cliente','value',x_endereco)
	   	  setproperty('form_atendimento','lbl_baicid_cliente','value',x_baicid)
	   	  setproperty('form_atendimento','lbl_complemento_cliente','value',x_complem)
	   	  setproperty('form_atendimento','lbl_fixo_cliente','value',x_fixo)
	   	  setproperty('form_atendimento','lbl_celular_cliente','value',x_celular)
		  return(nil)
	   endif

       define window form_pesquisa;
              at 0,0;
		      width 500;
		      height 400;
              title 'Pesquisa Cliente';
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

  	   oQuery := oServer:Query('select id,nome from clientes order by nome')

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

	   local x_cliente  := val(v_id)
	   local x_nome     := ''
	   local x_endereco := ''
	   local x_baicid   := ''
	   local x_complem  := ''
	   local x_fixo     := ''
	   local x_celular  := ''
	   local oQuery
       local oRow := {}

       	  oQuery := oServer:Query('select nome,endereco,numero,bairro,cidade,complemento,fixo,celular from clientes where id = '+alltrim(str(x_cliente)))
  	 	  if oQuery:NetErr()
 	  	 	 msginfo('Erro de Pesquisa : '+oQuery:Error())
     	 	 return(nil)
          endif
          oRow       := oQuery:GetRow(1)
	   	  x_nome     := alltrim(oRow:fieldGet(1))
	   	  x_endereco := alltrim(oRow:fieldGet(2))+', '+alltrim(oRow:fieldGet(3))
	   	  x_baicid   := alltrim(oRow:fieldGet(4))+', '+alltrim(oRow:fieldGet(5))
	   	  x_complem  := alltrim(oRow:fieldGet(6))
	   	  x_fixo     := alltrim(oRow:fieldGet(7))
	   	  x_celular  := alltrim(oRow:fieldGet(8))
	   	  setproperty('form_atendimento','tbox_cliente','value',val(v_id))
	   	  setproperty('form_atendimento','lbl_nome_cliente','value',x_nome)
	   	  setproperty('form_atendimento','lbl_baicid_cliente','value',x_baicid)
	   	  setproperty('form_atendimento','lbl_complemento_cliente','value',x_complem)
	   	  setproperty('form_atendimento','lbl_fixo_cliente','value',x_fixo)
	   	  setproperty('form_atendimento','lbl_celular_cliente','value',x_celular)
	   	  
	   form_pesquisa.release

	   return(nil)
*-------------------------------------------------------------------------------
static function servico_excluir()

	   local cQuery
       local oQuery

	   local v_id   := alltrim(valor_coluna('grid_servicos','form_atendimento',1))
	   local v_nome := alltrim(valor_coluna('grid_servicos','form_atendimento',2))

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
          msginfo('A informação : '+v_nome+' - foi excluída')
 	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function servico_incluir(p_numero_os)

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
  	      setproperty('form_inclui_servico','tbox_servico','value',0)
  	      setproperty('form_inclui_servico','txt_quantidade','value',0)
  	      setproperty('form_inclui_servico','txt_unitario','value',0)
  	      setproperty('form_inclui_servico','tbox_tecnico','value',0)
  	      setproperty('form_inclui_servico','lbl_nome_servico','value','')
  	      setproperty('form_inclui_servico','lbl_nome_tecnico','value','')
          add item {alltrim(x_1),m_nome_servico,x_2,x_3,str(n_subtotal,12,2),m_nome_tecnico,x_4} to grid_servicos of form_atendimento
          n_soma_total := n_soma_total + n_subtotal
          setproperty('form_atendimento','lbl_total_os','value',trans(n_soma_total,'@E 999,999.99'))
       endif

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
static function pecas_excluir()

	   local cQuery
       local oQuery

	   local v_id   := alltrim(valor_coluna('grid_pecas','form_atendimento',1))
	   local v_nome := alltrim(valor_coluna('grid_pecas','form_atendimento',2))

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
static function pecas_incluir(p_numero_os)

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
  	      setproperty('form_inclui_peca','tbox_peca','value',0)
  	      setproperty('form_inclui_peca','txt_quantidade','value',0)
  	      setproperty('form_inclui_peca','txt_unitario','value',0)
  	      setproperty('form_inclui_peca','tbox_tecnico','value',0)
  	      setproperty('form_inclui_peca','lbl_nome_peca','value','')
  	      setproperty('form_inclui_peca','lbl_nome_tecnico','value','')
          add item {alltrim(x_1),m_nome_peca,x_2,x_3,str(n_subtotal,12,2),m_nome_tecnico,x_4} to grid_pecas of form_atendimento
          n_soma_total := n_soma_total + n_subtotal
          setproperty('form_atendimento','lbl_total_os','value',trans(n_soma_total,'@E 999,999.99'))
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
static function gravar_os(p_numero_os)

	   local oRow_2
	   local oRow_3
	   local n_i := 0
	   local v_qtd := 0
	   local v_id_prod := 0
	   local v_soma := 0
	   local cQuery, cQuery_2, cQuery_3
       local oQuery, oQuery_2, oQuery_3, oQuery_4

	   local x_numero          := p_numero_os
	   local x_data            := date()
	   local x_hora            := time()
	   local x_cliente         := alltrim(str(form_atendimento.tbox_cliente.value))
	   local x_nome_cliente    := alltrim(form_atendimento.lbl_nome_cliente.value)
	   local x_condicao        := alltrim(str(form_atendimento.cbo_condicao.value))
	   local x_data_prevista   := form_atendimento.dpi_data_entrega.value
	   local x_hora_prevista   := alltrim(form_atendimento.tbox_hora_entrega.value)
	   local x_aparelho        := alltrim(form_atendimento.tbox_aparelho.value)
	   local x_marca           := alltrim(form_atendimento.tbox_marca.value)
	   local x_modelo          := alltrim(form_atendimento.tbox_modelo.value)
	   local x_numero_serie    := alltrim(form_atendimento.tbox_numserie.value)
	   local x_estado_aparelho := alltrim(str(form_atendimento.cbo_estado.value))
	   local x_defeito         := alltrim(form_atendimento.tbox_defeito.value)

	   if empty(m_nome_tecnico)
	      msgalert('Nenhum SERVIÇO ou PEÇA foi selecionado','Atenção')
	      return(nil)
	   endif
	   
	   if x_cliente == '0'
       	  msginfo('Obrigatório preencher os campos','Atenção')
          return(nil)
       else
          /*
            grava OS
          */
	   	  cQuery := "insert into os (numero,data,hora,cliente,nome_cliente,condicao_aparelho,data_prevista,hora_prevista,aparelho,marca,modelo,numero_serie,estado_aparelho,defeito,encerrado,nome_atendente) values ('"

		  cQuery += x_numero +"','"
 		  cQuery += td(x_data) +"','"
  		  cQuery += x_hora +"','"
   		  cQuery += x_cliente +"','"
	 	  cQuery += x_nome_cliente +"','"
	 	  cQuery += x_condicao +"','"
	 	  cQuery += td(x_data_prevista) +"','"
	 	  cQuery += x_hora_prevista +"','"
	 	  cQuery += x_aparelho +"','"
	 	  cQuery += x_marca +"','"
	 	  cQuery += x_modelo +"','"
	 	  cQuery += x_numero_serie +"','"
	 	  cQuery += x_estado_aparelho +"','"
	 	  cQuery += x_defeito +"','"
	 	  cQuery += '0' +"','"
  		  cQuery += m_nome_tecnico +"')"

     	  oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
         	 msginfo('Erro na Inclusão : '+oQuery:Error())
          	 return(nil)
          endif
  	      oQuery:Destroy()
  	      /*
  	        baixa estoque peças
  	      */
		  oQuery_2 := oServer:Query("select * from os_pecas where numero_os='"+alltrim(x_numero)+"' order by numero_os")
  		  for n_i := 1 to oQuery_2:LastRec()
              v_qtd := 0
              v_soma := 0
	      	  oRow_2 := oQuery_2:GetRow(n_i)
			  v_qtd := oRow_2:fieldGet(6)
			  v_id_prod := oRow_2:fieldGet(4)
		  	  oQuery_3 := oServer:Query("select * from produtos where id='"+alltrim(str(v_id_prod))+"' order by id")
	      	  oRow_3 := oQuery_3:GetRow(1)
			  v_soma := ( oRow_3:fieldGet(11) - v_qtd )
              cQuery_3 := "update produtos set estoque_atual='"+alltrim(str(v_soma))+"' where id='"+alltrim(str(v_id_prod))+"'"
       	      oQuery_4 := oQuery_4 := oServer:Query( cQuery_3 )
              if oQuery_4:NetErr()
             	 msginfo('Erro na operação : '+oQuery_4:Error())
              	 return(nil)
              endif
              oQuery_2:Skip(1)
              oQuery_3:Destroy()
  		  next n_i
  	      form_atendimento.release
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function recibo_os(p_numero_os)

       local n_linha := 60

       SELECT PRINTER DIALOG PREVIEW
       START PRINTDOC NAME 'Gerenciador de impressão'
       START PRINTPAGE

	   cabecalho_recibo_os(p_numero_os)

	   @ n_linha,020 PRINT 'Data/Hora Atendimento' FONT 'courier new' SIZE 12
       @ n_linha,100 PRINT 'Data/Hora Previsão Entrega' FONT 'courier new' SIZE 12
       n_linha += 5
	   @ n_linha,020 PRINT dtoc(date())+' / '+time() FONT 'courier new' SIZE 12 BOLD
       @ n_linha,100 PRINT dtoc(form_atendimento.dpi_data_entrega.value)+' / '+alltrim(form_atendimento.tbox_hora_entrega.value) FONT 'courier new' SIZE 12 BOLD

	   n_linha += 10

	   @ n_linha,020 PRINT 'DADOS DO CLIENTE' FONT 'courier new' SIZE 12 BOLD
	   n_linha += 10
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_nome_cliente.value) FONT 'courier new' SIZE 12 BOLD
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_endereco_cliente.value) FONT 'courier new' SIZE 12
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_baicid_cliente.value) FONT 'courier new' SIZE 12
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_complemento_cliente.value) FONT 'courier new' SIZE 12
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_fixo_cliente.value)+'   '+alltrim(form_atendimento.lbl_celular_cliente.value) FONT 'courier new' SIZE 12
	   
	   n_linha += 10
	   
       @ n_linha,010 PRINT LINE TO n_linha,205 PENWIDTH 0.5 COLOR _preto_001
       
       n_linha += 10

	   @ n_linha,040 PRINT 'Aparelho    : '+alltrim(form_atendimento.tbox_aparelho.value) FONT 'courier new' SIZE 12
	   n_linha += 5
       @ n_linha,040 PRINT 'Marca       : '+alltrim(form_atendimento.tbox_marca.value) FONT 'courier new' SIZE 12
	   n_linha += 5
       @ n_linha,040 PRINT 'Modelo      : '+alltrim(form_atendimento.tbox_modelo.value) FONT 'courier new' SIZE 12
	   n_linha += 5
       @ n_linha,040 PRINT 'Nº de Série : '+alltrim(form_atendimento.tbox_numserie.value) FONT 'courier new' SIZE 12

	   n_linha += 10
	   
	   @ n_linha,040 PRINT 'Defeito Apresentado  : '+alltrim(form_atendimento.tbox_defeito.value) FONT 'courier new' SIZE 12

	   n_linha += 10
	   
	   @ n_linha,040 PRINT 'Estado do Aparelho   : '+aEstado[form_atendimento.cbo_estado.value] FONT 'courier new' SIZE 12
	   n_linha += 5
       @ n_linha,040 PRINT 'Condição do Aparelho : '+aCondicao[form_atendimento.cbo_condicao.value] FONT 'courier new' SIZE 12

	   n_linha += 50

       @ n_linha,070 PRINT LINE TO n_linha,205 PENWIDTH 0.5 COLOR _preto_001
       n_linha += 3
	   @ n_linha,120 PRINT 'Assinatura do Cliente' FONT 'courier new' SIZE 12

       rodape()

       END PRINTPAGE
       END PRINTDOC

	   return(nil)
*-------------------------------------------------------------------------------
static function cabecalho_recibo_os(p_numero_os)

       @ 007,010 PRINT IMAGE 'logotipo' WIDTH 030 HEIGHT 025 STRETCH
       @ 010,050 PRINT 'Empresa Teste & Teste Ltda' FONT 'verdana' SIZE 012 BOLD
       @ 015,050 PRINT 'CNPJ : 99.999.999/9999-99 - Insc.Estadual : 154954554620-XX' FONT 'verdana' SIZE 010
       @ 018,050 PRINT 'Rua Mal Floriano Peixoto, 8437 - Centro - São Paulo/SP' FONT 'verdana' SIZE 010
	   @ 021,050 PRINT 'Telefone : (11) 9999-9999 - empresateste@empresa.com.br' FONT 'verdana' SIZE 010
	   @ 028,050 PRINT 'Nº da OS : '+p_numero_os FONT 'verdana' SIZE 014 BOLD

       @ 035,000 PRINT LINE TO 035,205 PENWIDTH 0.5 COLOR _preto_001

       @ 040,065 PRINT 'RECIBO DE ENTREGA' FONT 'verdana' SIZE 018 BOLD

	   return(nil)
*-------------------------------------------------------------------------------
static function imprime_os(p_numero_os)

	   local oQuery_1, oQuery_2
       local n_i := 0
       local oRow_1 := {}
       local oRow_2 := {}
       
       local n_linha := 50

	   local nCod_Cliente := 0
       local nSub_Servico := 0
	   local nTot_Servico := 0
       local nSub_Peca    := 0
       local nTot_Peca    := 0
       local nTotal_OS    := 0

       SELECT PRINTER DIALOG PREVIEW
       START PRINTDOC NAME 'Gerenciador de impressão'
       START PRINTPAGE

	   cabecalho_os(p_numero_os)

	   @ n_linha,020 PRINT 'Data/Hora Atendimento' FONT 'courier new' SIZE 10
       @ n_linha,100 PRINT 'Data/Hora Previsão Entrega' FONT 'courier new' SIZE 10
       n_linha += 5
	   @ n_linha,020 PRINT dtoc(date())+' / '+time() FONT 'courier new' SIZE 10 BOLD
       @ n_linha,100 PRINT dtoc(form_atendimento.dpi_data_entrega.value)+' / '+alltrim(form_atendimento.tbox_hora_entrega.value) FONT 'courier new' SIZE 10 BOLD

	   n_linha += 8

	   @ n_linha,020 PRINT 'DADOS DO CLIENTE' FONT 'courier new' SIZE 10 BOLD
	   n_linha += 6
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_nome_cliente.value) FONT 'courier new' SIZE 10 BOLD
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_endereco_cliente.value) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_baicid_cliente.value) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_complemento_cliente.value) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT alltrim(form_atendimento.lbl_fixo_cliente.value)+'   '+alltrim(form_atendimento.lbl_celular_cliente.value) FONT 'courier new' SIZE 10

	   n_linha += 5
       @ n_linha,010 PRINT LINE TO n_linha,205 PENWIDTH 0.5 COLOR _preto_001
       n_linha += 5

	   @ n_linha,040 PRINT 'Aparelho             : '+alltrim(form_atendimento.tbox_aparelho.value) FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Marca                : '+alltrim(form_atendimento.tbox_marca.value) FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Modelo               : '+alltrim(form_atendimento.tbox_modelo.value) FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Nº de Série          : '+alltrim(form_atendimento.tbox_numserie.value) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT 'Defeito Apresentado  : '+alltrim(form_atendimento.tbox_defeito.value) FONT 'courier new' SIZE 10
	   n_linha += 5
	   @ n_linha,040 PRINT 'Estado do Aparelho   : '+aEstado[form_atendimento.cbo_estado.value] FONT 'courier new' SIZE 10
	   n_linha += 5
       @ n_linha,040 PRINT 'Condição do Aparelho : '+aCondicao[form_atendimento.cbo_condicao.value] FONT 'courier new' SIZE 10

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