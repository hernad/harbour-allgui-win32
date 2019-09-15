/*
  sistema     : ordem de serviço
  programa    : principal
  compilador  : harbour
  lib gráfica : minigui extended
*/

#include 'minigui.ch'
#include 'miniprint.ch'
/*
#define WM_USER              0x400
#define TTM_SETTIPBKCOLOR   (WM_USER + 19)
#define TTM_SETTIPTEXTCOLOR (WM_USER + 20)
#define TTM_SETTITLE        (WM_USER + 32)
#define TTI_NONE                0
#define TTI_INFO                1
#define TTI_WARNING             2
#define TTI_ERROR               3
*/
function main()

   	 local aColors

	 public nChave_ForPro := 0
	 public nCod_Usu_Log  := 0
	 public cNom_Usu_Log  := space(30)
	 public nTotServ      := 0
	 public nTotPeca      := 0
	 public lLog_IAE      := .F.
	 public nNumOS        := 0
	 public lEncerrada    := .F.
	 public _numero_os    := ''
	 /*
	   tabela de cores
	 */
	 public _AZUL         := {071,089,135}
	 public _AMARELO      := {255,255,225}
	 public _AMARELO2     := {255,255,255}
	 public _CIANO        := {000,255,255}
	 public _AZUL_CLARO   := {000,118,236}
	 public _AZUL_CLARO_2 := {113,184,255}
	 public _VERMELHO     := {242,079,000}
	 public _LARANJA      := {255,126,064}
	 public _VERDE        := {000,102,051}
	 public _AZUL_ESCURO  := {000,000,128}
	 public _CINZA        := {128,128,128}
         /*
           cores para labels, botões e janelas
         */
         public _branco_001     := {255,255,255}
         public _preto_001      := {000,000,000}
         public _azul_001       := {108,108,255}
         public _azul_002       := {000,000,255}
         public _azul_003       := {032,091,164}
         public _azul_004       := {023,063,115}
         public _azul_005       := {071,089,135}
         public _azul_006       := {000,073,148}
         public _laranja_001    := {255,163,070}
         public _verde_001      := {000,094,047}
         public _verde_002      := {000,089,045}
         public _cinza_001      := {128,128,128}
         public _cinza_002      := {192,192,192}
         public _cinza_003      := {229,229,229}
         public _cinza_004      := {226,226,226}
         public _cinza_005      := {245,245,245}
         public _vermelho_001   := {255,000,000}
         public _vermelho_002   := {160,000,000}
         public _vermelho_003   := {190,000,000}
         public _amarelo_001    := {255,255,225}
         public _amarelo_002    := {255,255,121}
         public _marrom_001     := {143,103,080}
         public _ciano_001      := {215,255,255}
         public _grid_001       := _branco_001
         public _grid_002       := {210,233,255}
         public _super          := {128,128,255}
         public _acompanhamento := {255,255,220}
         /*
           cores para get e botão
         */
         public _fundo_get   := {255,255,255}
         public _letra_get   := {000,000,255}
         public _letra_get_1 := {000,000,255}
	 public _letra_botao := WHITE
	 public _fundo_botao := BLACK
         /*
           setar cdx_fpt como padrão para tabelas dbf (indice_campo memo)
           setar para o idioma português-brasileiro
         //
       	 REQUEST DBFCDX, DBFFPT
       	 RDDSETDEFAULT('DBFCDX')

       	 DBSETDRIVER('DBFCDX')
       	 REQUEST HB_LANG_PT
       	 REQUEST HB_CODEPAGE_PT850
       	 HB_LANGSELECT('PT')
       	 HB_SETCODEPAGE('PT850')
         */
		 /*
		   setamentos de ambiente
		   alguns vindos do clipper outros da minigui
		 */
       	 set autoadjust on
       	 set deleted on
       	 set interactiveclose query
       	 set date british
       	 set century on
       	 set epoch to 1980
       	 set browsesync on
       	 set multiple off warning
       	 set tooltipballoon on
       	 set navigation extended
       	 set codepage to portuguese
       	 set language to portuguese
		 /*
		   definir fonte do menu
		 */
		 define font font_1 fontname 'verdana' size 10
		 fonte_menu := GetFontHandle('font_1')
		 /*
		   setar estilo do menu
		 */
         SET MENUSTYLE EXTENDED
      	 SET MENUCURSOR FULL
      	 SET MENUSEPARATOR SINGLE RIGHTALIGN
         SET MENUITEM BORDER FLAT
		 /*
		   reconfigurar cores do menu
		 */
         aColors := GetMenuColors()
      	 aColors[ MNUCLR_SEPARATOR1 ] := RGB( 128, 128, 128 ) //linha separadora
      	 aColors[ MNUCLR_IMAGEBACKGROUND1 ] := RGB( 236, 233, 216 ) //fundo bmp do ítem
      	 aColors[ MNUCLR_IMAGEBACKGROUND2 ] := RGB( 236, 233, 216 ) //fundo bmp do ítem
      	 aColors[ MNUCLR_MENUBARBACKGROUND1 ] := GetSysColor(15)
      	 aColors[ MNUCLR_MENUBARBACKGROUND2 ] := GetSysColor(15)
      	 aColors[ MNUCLR_MENUBARSELECTEDITEM1 ] := RGB( 198, 211, 239 )
      	 aColors[ MNUCLR_MENUBARSELECTEDITEM2 ] := RGB( 198, 211, 239 )
      	 aColors[ MNUCLR_MENUITEMSELECTEDTEXT ] := RGB( 000, 000, 000 )
      	 aColors[ MNUCLR_MENUITEMBACKGROUND1 ] := RGB( 255, 255, 255 ) //fundo geral menu
      	 aColors[ MNUCLR_MENUITEMBACKGROUND2 ] := RGB( 255, 255, 255 ) //fundo geral menu
      	 aColors[ MNUCLR_SELECTEDITEMBORDER1 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	 aColors[ MNUCLR_SELECTEDITEMBORDER2 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	 aColors[ MNUCLR_SELECTEDITEMBORDER3 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	 aColors[ MNUCLR_SELECTEDITEMBORDER4 ] := RGB( 049, 105, 198 ) //bordas do ítem
      	 aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND1 ] := RGB( 198, 211, 239 ) //fundo ítem menu
      	 aColors[ MNUCLR_MENUITEMSELECTEDBACKGROUND2 ] := RGB( 198, 211, 239 ) //fundo ítem menu
         SetMenuColors( aColors )
	   	 /*
	   	   montar janela principal
	   	 */
         define window form_main;
                at 000,000;
         	width 1300;
              	height 600;
                title 'Ordem de Serviço 8.0 :: versão MySQL';
                main;
                icon 'icone';
                noshow;
                on init entrada()
                /*
                  mostrar imagem de fundo : wallpaper
                */
                define image img_001
                       row 0
                       col 0
                       height getdesktopheight()
                       width getdesktopwidth()
                       picture 'wallpaper'
                       stretch .T.
                end image
                /*
                  montar o menu principal do programa
                */
                define main menu of form_main
                define popup 'Tabelas'
                       menuitem 'Grupos (produtos)' action grupos() image 'img_grupos' font fonte_menu
                       menuitem 'Formas de Pagamento' action fpagamentos() image 'img_fpagamento' font fonte_menu
                       menuitem 'Funcionários' action funcionarios() image 'img_grupos' font fonte_menu
                end popup
                define popup 'Financeiro'
                       menuitem 'Contas a Receber' action creceber() image 'img_crec' font fonte_menu
                       menuitem 'Contas a Pagar' action cpagar() image 'img_cpag' font fonte_menu
                end popup
                define popup '&Relatórios'
                       menuitem 'Ordem de Serviço em Aberto (por período)' action OS_af_periodo() image 'img_relatorios' font fonte_menu
                       menuitem 'Ordem de Serviço Encerrada (por período)' action OS_af2_periodo() image 'img_relatorios' font fonte_menu
                       separator
                       menuitem 'Ordem de Serviço em Aberto (por técnico e período)' action OS_tecnico_1() image 'img_relatorios' font fonte_menu
                       menuitem 'Ordem de Serviço Encerrada (por técnico e período)' action OS_tecnico_2() image 'img_relatorios' font fonte_menu
                       separator
                       menuitem 'Ordem de Serviço em Aberto (por cliente e período)' action OS_cliente_1() image 'img_relatorios' font fonte_menu
                       menuitem 'Ordem de Serviço Encerrada (por cliente e período)' action OS_cliente_2() image 'img_relatorios' font fonte_menu
                       separator
                       menuitem 'Posição do Estoque de Produtos' action Posicao_Estoque() image 'img_relatorios' font fonte_menu
                       menuitem 'Produtos em Falta no Estoque' action Produtos_em_Falta() image 'img_relatorios' font fonte_menu
                end popup
                end menu
		/*
		  botões menu principal : estilo metro
		*/
    			define buttonex button_menu_1
            		   row 30
            		   col 10
            		   width 300
            		   height 150
            		   picture 'atendimento'
            		   caption 'ATENDIMENTO'+CRLF+'Registro da OS'
            		   action atendimento()
            		   vertical .T.
            		   lefttext .F.
            		   flat .T.
            		   fontsize 12
            		   fontbold .T.
            		   fontcolor BLACK
            		   backcolor {244,244,244}
            		   uppertext .F.
            		   nohotlight .F.
            		   noxpstyle .T.
    			end buttonex
    			define buttonex button_menu_2
            		   row 30
            		   col 320
            		   width 300
            		   height 150
            		   picture 'andamento'
            		   caption 'ACOMPANHAR'+CRLF+'Andamento de uma OS'
            		   action acompanha()
            		   vertical .T.
            		   lefttext .F.
            		   flat .T.
            		   fontsize 12
            		   fontbold .T.
            		   fontcolor BLACK
            		   backcolor {244,244,244}
            		   uppertext .F.
            		   nohotlight .F.
            		   noxpstyle .T.
    			end buttonex
    			define buttonex button_menu_3
            		   row 190
            		   col 10
            		   width 300
            		   height 150
            		   picture 'produtos'
            		   caption 'Produtos'
            		   action produtos()
            		   vertical .T.
            		   lefttext .F.
            		   flat .T.
            		   fontsize 12
            		   fontbold .T.
            		   fontcolor BLACK
            		   backcolor {244,244,244}
            		   uppertext .F.
            		   nohotlight .F.
            		   noxpstyle .T.
    			end buttonex
    			define buttonex button_menu_4
            		   row 190
            		   col 320
            		   width 145
            		   height 150
            		   picture 'fornecedores'
            		   caption 'Fornecedores'
            		   action fornecedores()
            		   vertical .T.
            		   lefttext .F.
            		   flat .T.
            		   fontsize 12
            		   fontbold .T.
            		   fontcolor BLACK
            		   backcolor {244,244,244}
            		   uppertext .F.
            		   nohotlight .F.
            		   noxpstyle .T.
    			end buttonex
    			define buttonex button_menu_5
            		   row 190
            		   col 475
            		   width 145
            		   height 150
            		   picture 'clientes'
            		   caption 'Clientes'
            		   action clientes()
            		   vertical .T.
            		   lefttext .F.
            		   flat .T.
            		   fontsize 12
            		   fontbold .T.
            		   fontcolor BLACK
            		   backcolor {244,244,244}
            		   uppertext .F.
            		   nohotlight .F.
            		   noxpstyle .T.
    			end buttonex
    			define buttonex button_menu_6
    				   row 350
            		   col 320
            		   width 300
            		   height 075
            		   caption 'Sair do Programa'
            		   action form_main.release
            		   vertical .T.
            		   lefttext .F.
            		   flat .T.
            		   fontsize 12
            		   fontbold .T.
            		   fontcolor {255,255,255}
            		   backcolor {212,65,50}
            		   uppertext .F.
            		   nohotlight .F.
            		   noxpstyle .T.
    			end buttonex
     			*----------------------------*
     			*                            *
     			*   agenda de compromissos   *
     			*                            *
     			*----------------------------*
				   /*
				     cabeçalho
				   */
	   			   @ 000,getdesktopwidth()-400 label label_agenda_1 width 400 height 35 value '' backcolor {26,40,77}
	   			   @ 002,getdesktopwidth()-400 label label_agenda_2 width 400 height 30 value 'Agenda';
	   		 		  		 font 'verdana' size 14 fontcolor GRAY bold transparent centeralign
	   		 	   	   /*
	   		 	   	     calendário
	   		 	   	   */
      				   @ 036,getdesktopwidth()-400 monthcalendar calendario;
      				            value date();
             		   	 		font 'verdana' size 14;
             		   	 		BACKCOLOR BLACK;
				 		WEEKNUMBERS;
				 		notabstop;
         				 	BKGNDCOLOR WHITE;
				 		on change mostra_data()
				/*
    		   		  define largura e altura do calendário
                           	*/
      				 	form_main.calendario.width  := 400
      				 	form_main.calendario.height := 170
   		        	   /*
   		        	     grid compromissos
   		        	   */
	   				   define grid grid_compromissos
       				   		  col getdesktopwidth()-400
       				   		  row 207
       				   		  width 400
       				   		  height getdesktopheight()-427
       				   		  headers {'id','status','hora','descricao'}
       				   		  widths {1,30,50,530}
       				   		  fontname 'verdana'
       				   		  fontsize 10
       				   		  fontbold .F.
       				   		  backcolor {200,200,200}
       				   		  fontcolor BLACK
       				   		  nolines .T.
       				   		  showheaders .F.
      			  	   end grid
      			  	   /*
      			  	     frame
      			  	   */
    				   	define label label_frame
       				   		col getdesktopwidth()-400
       				   		row getdesktopheight()-220
			   		  	width 630
       				   		height 500
       				   		value ''
       				   		transparent .F.
       				   		backcolor WHITE
		   		       end label
     		  		   /*
         	  		   	 botões
       	  			   */
 			   		   define buttonex button_marcarok
	  			  	   		  col getdesktopwidth()-315
	   	  			   		  row getdesktopheight()-210
	   	  			   		  width 100
	   	  			   		  height 40
	   	  			   		  caption 'OK'
	   	  			   		  action marcar_ok()
	   	  			   		  fontname 'verdana'
	   	  			   		  fontsize 10
	   	  			   		  fontbold .T.
	   	  			   		  fontcolor BLACK
	   	  			   		  backcolor {200,200,200}
	   	  			   		  flat .T.
	   	  			   		  noxpstyle .T.
   		        	   end buttonex
 			   		   define buttonex button_imprimir
	  			  	   		  col getdesktopwidth()-210
	   	  			   		  row getdesktopheight()-210
	   	  			   		  width 100
	   	  			   		  height 40
	   	  			   		  caption 'Agenda'
	   	  			   		  action periodo_agenda()
	   	  			   		  fontname 'verdana'
	   	  			   		  fontsize 10
	   	  			   		  fontbold .T.
	   	  			   		  fontcolor BLACK
	   	  			   		  backcolor {200,200,200}
	   	  			   		  flat .T.
	   	  			   		  noxpstyle .T.
   		        	   end buttonex
	   		  		   define buttonex button_excluir
       		   	  	 		  col getdesktopwidth()-105
           		   	 		  row getdesktopheight()-210
          		   	 		  width 100
           		   	 		  height 40
           		   	 		  caption 'Excluir'
           		   	 		  action excluir_agenda()
           		   	 		  fontname 'verdana'
           		   	 		  fontsize 10
	             	   	 		  fontbold .T.
	 	  		 		  fontcolor BLACK
     		   	  	 		  backcolor {200,200,200}
      		   	  	 		  flat .T.
          		   	 		  noxpstyle .T.
	   		  		   end buttonex
	   		  		   define buttonex button_gravar
     		   	  	 		  col getdesktopwidth()-105
         		   	 		  row getdesktopheight()-130
          		   	 		  width 100
           		   	 		  height 40
       		   	  	 		  caption 'Gravar'
           		   	 		  action gravar_agenda()
           		   	 		  fontname 'verdana'
           		   	 		  fontsize 10
	             	   	 		  fontbold .T.
           		   	 		  fontcolor BLACK
           		   	 		  backcolor {200,200,200}
      		   	  	 		  flat .T.
          		   	 		  noxpstyle .T.
		   		           end buttonex
	    			   /*
	    			     campos : hora e compromisso
	    			   */
         			   @ getdesktopheight()-165,getdesktopwidth()-390 textbox gbox_hora height 28 width 60;
                   	   	         font 'verdana' size 10 backcolor WHITE fontcolor BLUE inputmask '99:99'
         			   @ getdesktopheight()-165,getdesktopwidth()-320 textbox tbox_descricao width 315 height 28 font 'verdana' size 10;
					   	 		 backcolor WHITE fontcolor BLUE uppercase maxlength 50
                /*
                  informações do programa, do cliente e do suporte
                */
                define label nome_programa_001
                       parent form_main
                       col 5
                       row getdesktopheight()-230
                       value 'OSFácil'
                       width 200
                       height 050
                       fontname 'tahoma'
                       fontsize 022
                       fontbold .T.
                       fontcolor _super
                       transparent .T.
                end label
                define label nome_programa_002
                       parent form_main
                       col 120
                       row getdesktopheight()-230
                       value '2017'
                       width 200
                       height 050
                       fontname 'tahoma'
                       fontsize 022
                       fontbold .T.
                       fontcolor _laranja_001
                       transparent .T.
                end label
                define label softhouse_001
                       parent form_main
                       col 5
                       row getdesktopheight()-190
                       value 'Este software foi desenvolvido por'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor _branco_001
                       transparent .T.
                end label
                define label softhouse_002
                       parent form_main
                       col 5
                       row getdesktopheight()-175
                       value 'NOME DA SUA EMPRESA'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 014
                       fontbold .T.
                       fontcolor _amarelo_001
                       transparent .T.
                end label
                define label suporte_001
                       parent form_main
                       col 5
                       row getdesktopheight()-135
                       value 'Para obter suporte técnico deste produto'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor {160,160,160}
                       transparent .T.
                end label
                define label suporte_002
                       parent form_main
                       col 5
                       row getdesktopheight()-120
                       value 'Telefone: (99) 9999-9999'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor {160,160,160}
                       transparent .T.
                end label
                define label suporte_003
                       parent form_main
                       col 5
                       row getdesktopheight()-105
                       value 'E-mail:suaempresa@seudominio.com.br'
                       autosize .T.
                       fontname 'verdana'
                       fontsize 010
                       fontbold .T.
                       fontcolor {160,160,160}
                       transparent .T.
                end label

         end window

	   	sendmessagestring(getformtooltiphandle('form_main'),TTM_SETTITLE,TTI_WARNING,'ajuda rápida')
	   	sendmessage(getformtooltiphandle('form_main'),TTM_SETTIPBKCOLOR,RGB(128,128,255),0)
	   	sendmessage(getformtooltiphandle('form_main'),TTM_SETTIPTEXTCOLOR,RGB(255,255,255),0)

         form_main.center
         form_main.activate

         return(nil)
*-------------------------------------------------------------------------------
static function entrada()

       local v_hostname := 'localhost'
       local v_usuario  := 'root'
       local v_senha    := ''
       local v_database := 'os'

       public oServer

       VariaveisPUB()

	   oServer := TMySQLServer():New(v_hostname,v_usuario,v_senha)

	   if oServer:NetErr()
  	   	  msginfo('Houve um erro de conexão com o servidor de banco de dados MySQL :: '+oServer:Error(),'Atenção')
       	  form_main.release
 	   else
		  criar_banco_de_dados(v_database)
		  criar_tabelas()
       endif

   return(nil)
*-------------------------------------------------------------------------------
static function criar_banco_de_dados(p_basededados)

	   local i := 0
       local aBaseDeDadosExistentes := {}

       p_basededados := lower(p_basededados)

	   * antes de criar verifica se a base de dados já existe
       aBaseDeDadosExistentes := oServer:ListDBs()

	   * verifica se ocorreu algum erro
       if oServer:NetErr()
       	  msginfo('Erro verificando lista de base de dados'+oServer:Error(),'Atenção')
          form_main.release
       endif

	   * verifica se na array aBaseDeDadosExistentes tem a base de dados
       if ascan(aBaseDeDadosExistentes,lower(p_basededados)) != 0
          * conecta na base de dados
          oServer:SelectDB(p_basededados)
          * verifica se ocorreu algum erro
          if oServer:NetErr()
         	 msginfo('Houve um erro tentando conectar à base de dados '+p_basededados+' , ERRO : '+oServer:Error(),'Atenção')
           	 form_main.release
          endif
	   else
          * cria a base de dados
          oServer:CreateDatabase(p_basededados)
          * verifica se ocorreu algum erro
          if oServer:NetErr()
          	 msginfo('Houve um erro na criação da base de dados '+p_basededados+' , ERRO : '+oServer:Error(),'Atenção')
             form_main.release
          else
             * conecta na base de dados
             oServer:SelectDB(p_basededados)
             * verifica se ocorreu algum erro
             if oServer:NetErr()
             	msginfo('Houve um erro tentando conectar à base de dados '+p_basededados+' , ERRO : '+oServer:Error(),'Atenção')
                form_main.release
             endif
          endif
	   endif

   return(nil)
*-------------------------------------------------------------------------------
static function criar_tabelas()

       local i := 0
       local aTabelasExistentes := {}
       local aStruc := {}
       local cQuery
       local oQuery

	   * carrega todas as tabelas no array
       aTabelasExistentes := oServer:ListTables()

	   * clientes
       if ascan(aTabelasExistentes,lower('clientes')) != 0
       else
          cQuery := 'CREATE TABLE clientes (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
          		  		 				   'cnpj char(18),'+;
		  		 				  		   'cpf char(15),'+;
		  		 				  		   'insc_est char(20),'+;
		  		 				  		   'nome char(40),'+;
		  		 				  		   'fixo char(10),'+;
		  		 				  		   'celular char(10),'+;
		  		 				  		   'endereco char(40),'+;
		  		 				  		   'numero char(10),'+;
		  		 				  		   'complemento char(20),'+;
		  		 				  		   'bairro char(20),'+;
		  		 				  		   'cidade char(30),'+;
		  		 				  		   'uf char(02),'+;
		  		 				  		   'cep char(08),'+;
		  		 				  		   'email char(50),'+;
		  		 				  		   'aniv_dia int,'+;
		  		 				  		   'aniv_mes int,'+;
		  		 				  		   'data_cad date,'+;
		  		 				  		   'hora_cad char(08),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : clientes : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * fornecedores
       if ascan(aTabelasExistentes,lower('fornecedores')) != 0
       else
          cQuery := 'CREATE TABLE fornecedores (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
          		  		 				   'cnpj char(18),'+;
		  		 				  		   'cpf char(15),'+;
		  		 				  		   'insc_est char(20),'+;
		  		 				  		   'nome char(40),'+;
		  		 				  		   'fixo char(10),'+;
		  		 				  		   'celular char(10),'+;
		  		 				  		   'endereco char(40),'+;
		  		 				  		   'numero char(10),'+;
		  		 				  		   'complemento char(20),'+;
		  		 				  		   'bairro char(20),'+;
		  		 				  		   'cidade char(30),'+;
		  		 				  		   'uf char(02),'+;
		  		 				  		   'cep char(08),'+;
		  		 				  		   'email char(50),'+;
		  		 				  		   'data_cad date,'+;
		  		 				  		   'hora_cad char(08),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : fornecedores : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * funcionários
       if ascan(aTabelasExistentes,lower('funcionarios')) != 0
       else
          cQuery := 'CREATE TABLE funcionarios (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'cpf char(15),'+;
		  		 				  		   'nome char(40),'+;
		  		 				  		   'fixo char(10),'+;
		  		 				  		   'celular char(10),'+;
		  		 				  		   'endereco char(40),'+;
		  		 				  		   'numero char(10),'+;
		  		 				  		   'complemento char(20),'+;
		  		 				  		   'bairro char(20),'+;
		  		 				  		   'cidade char(30),'+;
		  		 				  		   'uf char(02),'+;
		  		 				  		   'cep char(08),'+;
		  		 				  		   'email char(50),'+;
		  		 				  		   'data_cad date,'+;
		  		 				  		   'hora_cad char(08),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : funcionarios : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * ordem de serviço
       if ascan(aTabelasExistentes,lower('os')) != 0
       else
          cQuery := 'CREATE TABLE os (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'numero int,'+;
		  		 				  		   'data date,'+;
		  		 				  		   'hora char(08),'+;
		  		 				  		   'cliente int,'+;
		  		 				  		   'nome_cliente char(40),'+;
		  		 				  		   'atendente int,'+;
		  		 				  		   'nome_atendente char(40),'+;
		  		 				  		   'condicao int,'+;
		  		 				  		   'aprovado int,'+;
		  		 				  		   'data_prevista date,'+;
		  		 				  		   'hora_prevista char(08),'+;
		  		 				  		   'data_saida date,'+;
		  		 				  		   'hora_saida char(08),'+;
		  		 				  		   'data_garantia date,'+;
		  		 				  		   'aparelho char(40),'+;
		  		 				  		   'marca char(30),'+;
		  		 				  		   'modelo char(30),'+;
		  		 				  		   'numero_serie char(30),'+;
		  		 				  		   'estado_aparelho int,'+;
		  		 				  		   'condicao_aparelho int,'+;
		  		 				  		   'defeito char(70),'+;
		  		 				  		   'observacao blob,'+;
		  		 				  		   'encerrado int,'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : os : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * produtos
       if ascan(aTabelasExistentes,lower('produtos')) != 0
       else
          cQuery := 'CREATE TABLE produtos (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'nome char(40),'+;
		  		 				  		   'tipo int,'+;
		  		 				  		   'codigo_barras char(25),'+;
		  		 				  		   'unidade int,'+;
		  		 				  		   'id_grupo int,'+;
		  		 				  		   'custo float(12,2),'+;
		  		 				  		   'preco float(12,2),'+;
		  		 				  		   'custo_medio float(12,2),'+;
		  		 				  		   'comissao float(10,2),'+;
		  		 				  		   'estoque_atual int,'+;
		  		 				  		   'estoque_minimo int,'+;
		  		 				  		   'aplicacao char(50),'+;
		  		 				  		   'cla_fiscal char(10),'+;
		  		 				  		   'icms float(10,2),'+;
		  		 				  		   'ipi float(10,2),'+;
		  		 				  		   'iss float(10,2),'+;
		  		 				  		   'baixa_estoque int,'+;
		  		 				  		   'data_cad date,'+;
		  		 				  		   'hora_cad char(08),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : produtos : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * serviços da ordem de serviço
       if ascan(aTabelasExistentes,lower('os_servicos')) != 0
       else
          cQuery := 'CREATE TABLE os_servicos (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'id_os int,'+;
		  		 				  		   'numero_os int,'+;
		  		 				  		   'servico int,'+;
		  		 				  		   'nome_servico char(40),'+;
		  		 				  		   'quantidade int,'+;
		  		 				  		   'unitario float(12,2),'+;
		  		 				  		   'subtotal float(12,2),'+;
		  		 				  		   'tecnico int,'+;
		  		 				  		   'data date,'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : os_servicos : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * peças da ordem de serviço
       if ascan(aTabelasExistentes,lower('os_pecas')) != 0
       else
          cQuery := 'CREATE TABLE os_pecas (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'id_os int,'+;
		  		 				  		   'numero_os int,'+;
		  		 				  		   'peca int,'+;
		  		 				  		   'nome_peca char(40),'+;
		  		 				  		   'quantidade int,'+;
		  		 				  		   'unitario float(12,2),'+;
		  		 				  		   'subtotal float(12,2),'+;
		  		 				  		   'tecnico int,'+;
		  		 				  		   'data date,'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : os_pecas : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif
	
	   * grupos
       if ascan(aTabelasExistentes,lower('grupos')) != 0
       else
          cQuery := 'CREATE TABLE grupos (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'nome char(30),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : grupos : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * formas de pagamento
       if ascan(aTabelasExistentes,lower('fpagamentos')) != 0
       else
          cQuery := 'CREATE TABLE fpagamentos (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'nome char(30),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : forma de pagamentos : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif
	
	   * contas a pagar
       if ascan(aTabelasExistentes,lower('cpagar')) != 0
       else
          cQuery := 'CREATE TABLE cpagar (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'data_inclusao DATE,'+;
		  		 				  		   'hora_inclusao CHAR(10),'+;
		  		 				  		   'baixado CHAR(1),'+;
		  		 				  		   'id_fornecedor INT,'+;
		  		 				  		   'nome_fornecedor CHAR(40),'+;
		  		 				  		   'id_fpagamento INT,'+;
		  		 				  		   'nome_fpagamento CHAR(20),'+;
		  		 				  		   'vencimento DATE,'+;
		  		 				  		   'valor FLOAT(12,2),'+;
		  		 				  		   'numero_doc CHAR(20),'+;
		  		 				  		   'observacao CHAR(40),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : contas a pagar : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * contas a receber
       if ascan(aTabelasExistentes,lower('creceber')) != 0
       else
          cQuery := 'CREATE TABLE creceber (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'data_inclusao DATE,'+;
		  		 				  		   'hora_inclusao CHAR(10),'+;
		  		 				  		   'baixado CHAR(1),'+;
		  		 				  		   'id_cliente INT,'+;
		  		 				  		   'nome_cliente CHAR(40),'+;
		  		 				  		   'id_fpagamento INT,'+;
		  		 				  		   'nome_fpagamento CHAR(20),'+;
		  		 				  		   'vencimento DATE,'+;
		  		 				  		   'valor FLOAT(12,2),'+;
		  		 				  		   'numero_doc CHAR(20),'+;
		  		 				  		   'observacao CHAR(40),'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : contas a receber : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * usuários
       if ascan(aTabelasExistentes,lower('usuarios')) != 0
       else
          cQuery := 'CREATE TABLE usuarios (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'nome char(20),'+;
		  		 				  		   'login char(10),'+;
		  		 				  		   'senha char(10),'+;
		  		 				  		   'tipo int,'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : usuarios : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   * agenda
       if ascan(aTabelasExistentes,lower('agenda')) != 0
       else
          cQuery := 'CREATE TABLE agenda (id INT UNSIGNED NOT NULL AUTO_INCREMENT,'+;
		  		 				  		   'data DATE,'+;
		  		 				  		   'hora CHAR(10),'+;
		  		 				  		   'assunto CHAR(40),'+;
		  		 				  		   'status_1 INT,'+;
										   'PRIMARY KEY (id)) ENGINE=InnoDB DEFAULT CHARSET=utf8'
          oQuery := oServer:Query(cQuery)
          if oServer:NetErr()
          	 msginfo('Erro criando tabela : agenda : '+oServer:Error(),'Atenção')
             form_main.release
          endif
          oQuery:Destroy()
	   endif

	   tela_login()

       return(nil)
*-------------------------------------------------------------------------------
static function tela_login()

	   define window form_login;
  		at 0,0;
		width 700;
    		height 500;
     	 	title 'Tela de Login';
      		icon 'icone';
       		modal;
        	noautorelease;
        	nosize;
        	nosysmenu

			  define image img_loginlogo
			 	row 0
			 	col 0
      				height 347
        		 	width 700
         			picture 'tela_login'
          			stretch .F.
			  end image

			  define label label_versao
			 	col form_login.width - 210
   				row 315
			 	value 'versão 2017, revisão 016.008'
			 	autosize .T.
			 	fontname 'verdana'
			 	fontsize 10
			 	fontbold .F.
			 	fontcolor {0,0,0}
			 	transparent .T.
			  end label				  	
			  /*
			  	login e senha
			  */ 	
			  define label label_usuario
			 	col 305
   				row 360
			 	value 'Usuário'
			 	autosize .T.
			 	fontname 'verdana'
			 	fontsize 10
			 	fontbold .T.
			 	fontcolor {0,0,0}
			 	transparent .T.
			  end label				  	
              @ 360,375 textbox gbox_login;
                        of form_login;
                        height 27;
                        width 120;
                        value '';
                        maxlength 100;
                        font 'verdana' size 10;
                        backcolor {255,244,206};
                        fontcolor {0,0,0}
			  define label label_senha
			 	col 505
   				row 360
			 	value 'Senha'
			 	autosize .T.
			 	fontname 'verdana'
			 	fontsize 10
			 	fontbold .T.
			 	fontcolor {0,0,0}
			 	transparent .T.
			  end label				  	
              @ 360,565 textbox gbox_senha;
                        of form_login;
                        height 27;
                        width 120;
                        value '';
                        maxlength 100;
                        font 'verdana' size 10;
                        backcolor {255,244,206};
                        fontcolor {0,0,0};
                        password
            /*
              	botão : acessar
    	      */
			  define buttonex button_acessar
				row form_login.height - 100
				col 485
				width 200
  				height 60
				picture 'acessar'
 				caption 'Acessar o programa'
  				action acessar_programa()
   		   		vertical .F.
   		   		lefttext .F.
   		   		flat .F.
   		   		fontsize 10
   		   		fontbold .T.
   		   		fontcolor BLACK
			  end buttonex			  		
			  /*
			  	criar usuário
			  */
			  define buttonex button_criarusuario
				row form_login.height - 100
				col 250
				width 200
  				height 60
				picture 'login'  						
 				caption 'Criar usuário'
  				action criar_usuario()
   		   		vertical .F.
   		   		lefttext .F.
   		   		flat .F.
   		   		fontsize 10
   		   		fontbold .T.
   		   		fontcolor BLACK
			  end buttonex			  		
			  /*
			  	sair
			  */	
			  define buttonex button_sairlogin
				row form_login.height - 100
				col 5
				width 200
  				height 60
				picture 'exit'
 				caption 'Sair do programa'
  				action ( form_login.release, form_main.release )
   		   		vertical .F.
   		   		lefttext .F.
   		   		flat .F.
   		   		fontsize 10
   		   		fontbold .T.
   		   		fontcolor BLACK
			  end buttonex			  		

		end window
	
		form_login.center
		form_login.activate

		return(nil)
*-------------------------------------------------------------------------------
static function acessar_programa()

	   local oQuery
       local oRow := {}

	   local v_login := alltrim(form_login.gbox_login.value)
	   local v_senha := alltrim(form_login.gbox_senha.value)

	   oQuery := oServer:Query("select * from usuarios where login='"+v_login+"' and senha='"+v_senha+"' order by login")

	   if oQuery:Eof()
	   	  msginfo('Login ou Senha incorretos, tecle ENTER','Atenção')
	   	  form_login.gbox_login.setfocus
		  return(nil)
       else
          oRow := oQuery:GetRow(1)
       	  v_nome := alltrim(oRow:fieldGet(2))
       	  tipo_do_usuario := oRow:fieldGet(5)
          oQuery:Destroy()
          form_login.release
          form_main.show
          form_main.maximize
       endif

	   return(nil)
*-------------------------------------------------------------------------------
static function criar_usuario()

       local x_nome   := ''
       local x_login  := ''
       local x_senha  := ''

       define window form_dados;
              at 000,000;
              width 650;
              height 180;
              title 'Criar usuário';
              icon 'icone';
              modal;
              nosize

              * entrada de dados
              @ 010,010 label label_nome;
                        of form_dados;
                        value 'Nome Completo';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLACK;
                        transparent
              @ 030,010 textbox tbox_nome;
                        of form_dados;
                        height 027;
                        width 200;
                        value x_nome;
                        maxlength 030;
                        font 'tahoma' size 010;
                        backcolor WHITE;
                        fontcolor BLUE;
                        uppercase
              *----------
              @ 010,220 label label_login;
                        of form_dados;
                        value 'Login';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLACK;
                        transparent
              @ 030,220 textbox tbox_login;
                        of form_dados;
                        height 027;
                        width 200;
                        value x_login;
                        maxlength 010;
                        font 'tahoma' size 010;
                        backcolor WHITE;
                        fontcolor BLUE;
                        uppercase
              *----------
              @ 010,430 label label_senha;
                        of form_dados;
                        value 'Senha';
                        autosize;
                        font 'tahoma' size 010;
                        bold;
                        fontcolor BLACK;
                        transparent
              @ 030,430 textbox tbox_senha;
                        of form_dados;
                        height 027;
                        width 200;
                        value x_senha;
                        maxlength 010;
                        font 'tahoma' size 010;
                        password;
                        backcolor WHITE;
                        fontcolor BLUE;
                        uppercase

              * linha separadora
              define label linha_rodape
                     col 000
                     row form_dados.height-090
                     value ''
                     width form_dados.width
                     height 001
                     backcolor BLACK
                     transparent .F.
              end label

              * botões
              define buttonex button_ok
                     picture 'gravar'
                     col form_dados.width-225
                     row form_dados.height-085
                     width 120
                     height 050
                     caption 'Ok, gravar'
                     action gravar_novo_usuario()
                     fontbold .T.
                     tooltip 'Confirmar as informações digitadas'
                     flat .T.
                     noxpstyle .T.
              end buttonex
              define buttonex button_cancela
                     picture 'retornar'
                     col form_dados.width-100
                     row form_dados.height-085
                     width 090
                     height 050
                     caption 'Voltar'
                     action form_dados.release
                     fontbold .T.
                     tooltip 'Sair desta tela sem gravar informações'
                     flat .T.
                     noxpstyle .T.
              end buttonex

	   end window

	   form_dados.center
	   form_dados.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function gravar_novo_usuario()

	   local cQuery, oQuery

	   local v_tipo  := '1'
	   local v_nome  := alltrim(form_dados.tbox_nome.value)
	   local v_login := alltrim(form_dados.tbox_login.value)
	   local v_senha := alltrim(form_dados.tbox_senha.value)

	   if empty(v_nome) .or. empty(v_login) .or. empty(v_senha)
       	  msginfo('Obrigatório preencher os campos : Nome, Login e Senha','Atenção')
          return(nil)
       else
 		  cQuery := "insert into usuarios (nome,login,senha,tipo) values ('"
  		  cQuery += v_nome	+"','"
   		  cQuery += v_login	+"','"
   		  cQuery += v_senha	+"','"
   		  cQuery += v_tipo +"')"
 	      oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
         	 msginfo('Erro na Inclusão : '+oQuery:Error())
          	 return(nil)
          endif
  	      oQuery:Destroy()
   	      form_dados.release
       endif

	   return(nil)
*-------------------------------------------------------------------------------
function VariaveisPUB()

         public aEstado     := {}
         public aCondicao   := {}
         public aTipo       := {}
         public aClassifica := {}
         public aUnidade    := {}
         public aDiaSemana  := {}
         public aTipoFJ     := {}
         public aSexo       := {}
         public aLogradouro := {}
         public aUf         := {}
         public aSimNao     := {}

         aadd(aSimNao,'Sim')
         aadd(aSimNao,'Não')

         aadd(aCondicao,'Montado')
         aadd(aCondicao,'Desmontado')

         aadd(aEstado,'Novo')
         aadd(aEstado,'Bom')
         aadd(aEstado,'Ruim')

         aadd(aTipo,'Peça')
         aadd(aTipo,'Serviço')

         aadd(aClassifica,'Ótimo')
         aadd(aClassifica,'Bom')
         aadd(aClassifica,'Regular')

         aadd(aUnidade,'UN')
         aadd(aUnidade,'PC')
         aadd(aUnidade,'KG')
         aadd(aUnidade,'H.')

         aadd(aDiaSemana,'Domingo')
         aadd(aDiaSemana,'Segunda')
         aadd(aDiaSemana,'Terça')
         aadd(aDiaSemana,'Quarta')
         aadd(aDiaSemana,'Quinta')
         aadd(aDiaSemana,'Sexta')
         aadd(aDiaSemana,'Sábado')

         aadd(aTipoFJ,'Jurídica')
         aadd(aTipoFJ,'Física')

         aadd(aSexo,'Feminino ')
         aadd(aSexo,'Masculino')

         aadd(aLogradouro,'Rua')
         aadd(aLogradouro,'Avenida')
         aadd(aLogradouro,'Rodovia')
         aadd(aLogradouro,'Travessa')
         aadd(aLogradouro,'Alameda')
         aadd(aLogradouro,'BR')
         aadd(aLogradouro,'Km')
         aadd(aLogradouro,'Trevo')
         aadd(aLogradouro,'Via')

         aadd(aUf,'AC') //acre
         aadd(aUf,'AL') //alagoas
         aadd(aUf,'AM') //amazonas
         aadd(aUf,'AP') //amapá
         aadd(aUf,'BA') //bahia
         aadd(aUf,'CE') //ceará
         aadd(aUf,'DF') //distrito federal
         aadd(aUf,'ES') //espírito santo
         aadd(aUf,'GO') //goiás
         aadd(aUf,'MA') //maranhão
         aadd(aUf,'MG') //minas gerais
         aadd(aUf,'MS') //mato grosso do sul
         aadd(aUf,'MT') //mato grosso
         aadd(aUf,'PA') //pará
         aadd(aUf,'PB') //paraíba
         aadd(aUf,'PE') //pernambuco
         aadd(aUf,'PI') //piauí
         aadd(aUf,'PR') //paraná
         aadd(aUf,'RJ') //rio de janeiro
         aadd(aUf,'RN') //rio grande do norte
         aadd(aUf,'RO') //rondonia
         aadd(aUf,'RR') //roraima
         aadd(aUf,'RS') //rio grande do sul
         aadd(aUf,'SC') //santa catarina
         aadd(aUf,'SE') //sergipe
         aadd(aUf,'SP') //são paulo
         aadd(aUf,'TO') //tocantins

         return(Nil)
*-------------------------------------------------------------------------------
static function gravar_agenda()

	   local cQuery, oQuery

	   local v_data    := form_main.calendario.value
	   local v_hora    := alltrim(form_main.gbox_hora.value)
	   local v_assunto := alltrim(form_main.tbox_descricao.value)

	   if empty(v_hora)
		  msgalert('Hora não pode estar em branco, tecle ENTER','Atenção')
		  form_main.gbox_hora.setfocus
		  return(nil)
	   endif

	   if empty(v_assunto)
		  msgalert('Assunto não pode estar em branco, tecle ENTER','Atenção')
		  form_main.tbox_descricao.setfocus
		  return(nil)
	   endif

 		  cQuery := "insert into agenda (data,hora,assunto) values ('"
  		  cQuery += td(v_data)	+"','"
   		  cQuery += v_hora  	+"','"
   		  cQuery += v_assunto   +"')"
 	      oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
         	 msginfo('Erro na Inclusão : '+oQuery:Error())
          	 return(nil)
          endif
  	      oQuery:Destroy()

       setproperty('form_main','gbox_hora','value','')
       setproperty('form_main','tbox_descricao','value','')

       atualiza_agenda()

	   return(nil)
*-------------------------------------------------------------------------------
static function atualiza_agenda()

	   local oQuery
       local n_i  := 0
       local oRow := {}

	   local v_data := form_main.calendario.value
	   local x_data_inicio := td(form_main.calendario.value)

       delete item all from grid_compromissos of form_main

	   oQuery := oServer:Query("select * from agenda where data='"+x_data_inicio+"' order by data")
	
 	   for n_i := 1 to oQuery:LastRec()

	   	     oRow := oQuery:GetRow(n_i)

       		 add item {str(oRow:fieldGet(1)),iif(oRow:fieldGet(5)==2,'OK','-'),substr(oRow:fieldGet(3),1,2)+':'+substr(oRow:fieldGet(3),4,2),oRow:fieldGet(4)} to grid_compromissos of form_main

             oQuery:Skip(1)

	   next n_i

	   return(nil)
*-------------------------------------------------------------------------------
static function mostra_data()

	   local v_data_completa
	   local v_data := form_main.calendario.value

	   v_data_1 := alltrim(substr(dtoc(v_data),1,2))
	   v_data_2 := alltrim(dia_da_semana(v_data,1))
	   v_data_3 := alltrim(mes_do_ano(month(v_data),2))+' '+substr(dtoc(v_data),7,4)

	   v_data_completa := v_data_2 +', '+ v_data_1 +' de '+ v_data_3

	   setproperty('form_main','label_agenda_2','value',alltrim(v_data_completa))

	   atualiza_agenda()

	   return(nil)
*-------------------------------------------------------------------------------
static function excluir_agenda()

	   local cQuery
       local oQuery

       local v_id := valor_coluna('grid_compromissos','form_main',1)

	   if empty(v_id)
	      msginfo('Selecione primeiro uma informação na agenda, e depois clique no botão excluir','Atenção')
	      return(nil)
	   endif

	   if msgyesno('Confirma a exclusão ?')
       	  cQuery := 'delete from agenda where id = '+v_id
          oQuery := oQuery := oServer:Query( cQuery )
          if oQuery:NetErr()
          	 msginfo('Erro na Exclusão : '+oQuery:Error())
             return(nil)
          endif
          oQuery:Destroy()
          atualiza_agenda()
 	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function marcar_ok()

	   local cQuery
	   local oQuery
       local v_id := valor_coluna('grid_compromissos','form_main',1)

	   if empty(v_id)
	      msginfo('Selecione primeiro uma informação na agenda, e depois clique no botão marcar OK','Atenção')
	      return(nil)
	   endif

          if msgyesno('Marcar como OK esse compromisso ?','Marcar OK')
             cQuery := "update agenda set status_1 = 2 where id='"+v_id+"'"
       	     oQuery := oQuery := oServer:Query( cQuery )
             if oQuery:NetErr()
             	msginfo('Erro na Alteração : '+oQuery:Error())
              	return(nil)
             endif
       	     oQuery:Destroy()
             atualiza_agenda()
          else
             cQuery := "update agenda set status_1 = 1 where id='"+v_id+"'"
       	     oQuery := oQuery := oServer:Query( cQuery )
             if oQuery:NetErr()
             	msginfo('Erro na Alteração : '+oQuery:Error())
              	return(nil)
             endif
       	     oQuery:Destroy()
             atualiza_agenda()
          endif

	   return(nil)
*-------------------------------------------------------------------------------
static function periodo_agenda()

	   local width, height

	   define window form_imprime;
	  		  at 0,0;
      		  width 400;
         	  height 220;
           	  title 'Imprimir Agenda';
           	  icon 'icone';
           	  modal;
           	  nosize
			  /*
			    labels
			  */
         	  @ 010,010 label lbl_de;
                   		value 'Inicia em' font 'verdana' size 10 fontcolor BLACK bold transparent
              @ 010,200 label lbl_ate;
                   		value 'Termina em' font 'verdana' size 10 fontcolor BLACK bold transparent
              @ 010,080 datepicker dpi_de width 100 value date()
         	  @ 010,290 datepicker dpi_ate width 100 value date()
     		  /*
         	  	botões
        	  */
	   		  define buttonex button_cadastrar
     		   	  	 col form_imprime.width - 215
         		   	 row form_imprime.height - 85
          		   	 width 100
           		   	 height 40
       		   	  	 caption 'Imprime'
           		   	 action imprime_agenda()
           		   	 fontname 'verdana'
           		   	 fontsize 10
             	   	 fontbold .T.
      		   	  	 flat .T.
          		   	 noxpstyle .T.
	   		  end buttonex
	   		  define buttonex button_voltar
       		   	  	 col form_imprime.width - 110
           		   	 row form_imprime.height - 85
          		   	 width 100
           		   	 height 40
           		   	 caption 'Voltar'
           		   	 action form_imprime.release
           		   	 fontname 'verdana'
           		   	 fontsize 10
             	   	 fontbold .T.
      		   	  	 flat .T.
          		   	 noxpstyle .T.
	   		  end buttonex

 	  		  on key escape action form_imprime.release

       end window

	   form_imprime.center
	   form_imprime.activate

	   return(nil)
*-------------------------------------------------------------------------------
static function imprime_agenda()

	   local lSuccess
	   local v_cor_texto
       local v_linha    := 0
       local v_pagina   := 1
       local v_data_ini := form_imprime.dpi_de.value
       local v_data_fim := form_imprime.dpi_ate.value

       local x_data_inicio := td(v_data_ini)
       local x_data_final  := td(v_data_fim)

	   local oQuery
       local n_i  := 0
       local oRow := {}

       if v_data_fim < v_data_ini
          msgalert('Data FINAL maior que data INICIAL, tecle ENTER','Atenção')
		  return(nil)
	   endif

	   oQuery := oServer:Query("select * from agenda where data>='"+x_data_inicio+"' and data<='"+x_data_final+"' order by data")

	   SELECT PRINTER DIALOG TO lSuccess PREVIEW

	   if lSuccess == .T.

       	  START PRINTDOC NAME 'Agenda de Compromissos'
       	  START PRINTPAGE

		  cab_agenda(v_pagina,v_data_ini,v_data_fim)

		  v_linha := 45

		  for n_i := 1 to oQuery:LastRec()

	   	     oRow := oQuery:GetRow(n_i)
	   	
				if oRow:fieldGet(5) == 1 .or. empty(oRow:fieldGet(5))
	   			   @ v_linha-3,010 PRINT IMAGE 'nao_feito' WIDTH 7 HEIGHT 7 STRETCH
	   			   v_cor_texto := BLACK
				elseif oRow:fieldGet(5) == 2
	   			   @ v_linha-3,010 PRINT IMAGE 'feito' WIDTH 7 HEIGHT 7 STRETCH
	   			   v_cor_texto := BLUE
				endif

				@ v_linha,025 PRINT dtoc(oRow:fieldGet(2)) FONT 'courier new' SIZE 10 COLOR v_cor_texto
    			@ v_linha,050 PRINT oRow:fieldGet(3) FONT 'courier new' SIZE 10 COLOR v_cor_texto
       			@ v_linha,070 PRINT alltrim(oRow:fieldGet(4)) FONT 'courier new' SIZE 10 COLOR v_cor_texto

				v_linha += 6

				if v_linha >= 260
	   			   END PRINTPAGE
 		  		   START PRINTPAGE
          		   v_pagina ++
               	   cab_agenda(v_pagina,v_data_ini,v_data_fim)
                   v_linha := 45
                endif

				v_linha += 4
	   			@ v_linha,000 PRINT LINE TO v_linha,205 PENWIDTH 0.5 COLOR BLACK

				v_linha += 4

				if v_linha >= 260
	   			   END PRINTPAGE
 		  		   START PRINTPAGE
          		   v_pagina ++
               	   cab_agenda(v_pagina,v_data_ini,v_data_fim)
                   v_linha := 45
                endif

			 oQuery:Skip(1)

    	  next n_i

          END PRINTPAGE
		  END PRINTDOC

          form_imprime.release

	   endif

	   return(nil)
*-------------------------------------------------------------------------------
static function cab_agenda(p_pagina,p_data1,p_data2)

       @ 007,010 PRINT IMAGE 'logotipo' WIDTH 030 HEIGHT 025 STRETCH
       @ 015,035 PRINT 'Agenda de compromissos : de '+dtoc(p_data1)+' à '+dtoc(p_data2) FONT 'verdana' SIZE 12 BOLD

       @ 035,000 PRINT LINE TO 035,205 PENWIDTH 0.5 COLOR BLACK

       return(nil)