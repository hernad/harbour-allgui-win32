/*
  sistema     : ordem de serviço
  programa    : funções genéricas
  compilador  : harbour
  lib gráfica : minigui extended
*/

function Chk_Mes(parametro,tipo)

	 if tipo == 1
	    return{'JAN','FEV','MAR','ABR','MAI','JUN',;
		   'JUL','AGO','SET','OUT','NOV','DEZ'} [Parametro]
	 elseif tipo == 2
	    return{'Janeiro  ','Fevereiro','Marco    ','Abril    ','Maio     ','Junho    ',;
		   'Julho    ','Agosto   ','Setembro ','Outubro  ','Novembro ',;
		   'Dezembro '} [Parametro]
	 endif
*-------------------------------------------------------------------------------
function Extenso(Amount)

	 local cents, final_amount, par[3], temp, base, x
	 final_amount := ''

	 if amount < 0
	    final_amount := 'INCAPAZ DE IMPRIMIR'
	 elseif amount == 0
	    final_amount := 'Zero'
	 else
	    cents  := val(subStr(str(amount, 12, 2), 11))
	    par[1] := val(subStr(str(amount, 12, 2), 1, 3))
	    par[2] := val(subStr(str(amount, 12, 2), 4, 3))
	    par[3] := val(subStr(str(amount, 12, 2), 7, 3))
	    for x := 1 to 3
		if par[x] <> 0
		   if x == 2 .and. par[x] == 1
		      final_amount += ' Mil'
		      if par[3] > 0
			 final_amount += ' e'
		      endif
		   else
		      final_amount += Checkextenso(par[x])
		      if x == 1
			 if par[1] == 1
			    final_amount += ' Milhao'
			 else
			    final_amount += ' Milhoes'
			 endif
			 if par[2] > 0 .or. par[3] > 0
			    final_amount += ' e'
			 endif
		      elseif x == 2
			 final_amount += ' Mil'
			 if par[3] > 0
			    final_amount += ' e'
			 endif
		      endif
		   endif
		endif
	    next

	    if int(amount) == 1
	       final_amount += ' Real'
	    elseif int(amount) > 1 .and. par[2] == 0 .and. par[3] == 0
	       final_amount += ' de Reais'
	    elseif int(amount) > 1
	       final_amount += ' Reais'
	    endif

	    if int(amount) > 0 .and. cents > 0
	       final_amount += ' e'
	    endif

	    if cents > 0
	       final_amount += Checkextenso(cents)
	       if cents == 1
		  final_amount += ' Centavo'
	       else
		  final_amount += ' Centavos'
	       endif
	    endif
	 endif

	 return(ltrim(final_amount))
*-------------------------------------------------------------------------------
function Checkextenso(value)

	 local temp
	 local string := ''

	 if value > 99
	    temp   := int(value/100)
	    string += Centena(temp,value)
	    value  -= (temp*100)
	    if value > 0
	       string += ' e'
	    endif
	 endif

	 if value > 19
	    temp   := int(value/10) - 1
	    string += Dezena(temp)
	    temp   := int(value/10) * 10
	    value  -= temp
	    if value > 0
	       string += ' e'
	    endif
	 endif

	 if value > 0
	    string += Unidade(value)
	 endif

	 return(string)
*-------------------------------------------------------------------------------
function Unidade(unid)

	 local vetor := {}

	 aadd(vetor,' Um')
	 aadd(vetor,' Dois')
	 aadd(vetor,' Tres')
	 aadd(vetor,' Quatro')
	 aadd(vetor,' Cinco')
	 aadd(vetor,' Seis')
	 aadd(vetor,' Sete')
	 aadd(vetor,' Oito')
	 aadd(vetor,' Nove')
	 aadd(vetor,' Dez')
	 aadd(vetor,' Onze')
	 aadd(vetor,' Doze')
	 aadd(vetor,' Treze')
	 aadd(vetor,' Quatorze')
	 aadd(vetor,' Quinze')
	 aadd(vetor,' Dezesseis')
	 aadd(vetor,' Dezessete')
	 aadd(vetor,' Dezoito')
	 aadd(vetor,' Dezenove')

	 return(vetor[unid])
*-------------------------------------------------------------------------------
function Dezena(deze)

	 local vetor := {}

	 aadd(vetor,' Vinte')
	 aadd(vetor,' Trinta')
	 aadd(vetor,' Quarenta')
	 aadd(vetor,' Cinquenta')
	 aadd(vetor,' Sessenta')
	 aadd(vetor,' Setenta')
	 aadd(vetor,' Oitenta')
	 aadd(vetor,' Noventa')

	 return(vetor[deze])
*-------------------------------------------------------------------------------
function Centena(cent,deta)

	 local vetor := {}

	 if cent == 1 .and. deta == 100
	    aadd(vetor,' Cem')
	 else
	    aadd(vetor, ' Cento')
	 endif

	 aadd(vetor,' Duzentos')
	 aadd(vetor,' Trezentos')
	 aadd(vetor,' Quatrocentos')
	 aadd(vetor,' Quinhentos')
	 aadd(vetor,' Seiscentos')
	 aadd(vetor,' Setecentos')
	 aadd(vetor,' Oitocentos')
	 aadd(vetor,' Novecentos')

	 return(vetor[cent])
*-------------------------------------------------------------------------------
function Chk_DiaSem(dData,nTipo)

	 local cSem_ext,cSem_abv,cData

	 if nTipo == 1
	    cSem_ext := {'Domingo','Segunda-Feira','Terça-Feira' ,;
			 'Quarta-Feira','Quinta-Feira','Sexta-Feira' ,;
			 'Sábado'}
	    cData := cSem_ext[dow(dData)]
	    return(cData)
	 elseif nTipo == 2
	    cSem_abv := {'DOM','SEG','TER','QUA','QUI','SEX','SAB'}
	    cData    := cSem_abv[dow(dData)]
	    return(cData)
	 endif

	 return(nil)
*-------------------------------------------------------------------------------
function Chk_Cpf(parametro)

         local nConta
         local nResto
         local nDigito
	 local nDigito1 := 0
         local nDigito2 := 0
	 local nVez     := 1

	 if empty(parametro)
	    MsgExclamation('O Nº do CPF não pode ser em branco','Atenção')
	    return(.t.)
	 endif

	 if parametro == '00000000000' ;
	    .or. parametro == '11111111111' ;
	    .or. parametro == '22222222222' ;
	    .or. parametro == '33333333333' ;
	    .or. parametro == '44444444444' ;
	    .or. parametro == '55555555555' ;
	    .or. parametro == '66666666666' ;
	    .or. parametro == '77777777777' ;
	    .or. parametro == '88888888888' ;
	    .or. parametro == '99999999999' ;
	    .or. parametro == '12345678909'
	    MsgExclamation('Este Nº não é válido','Atenção')
	    return(.f.)
	 endif

	 for nConta := 1 to len(parametro)-2
	     if at(subs(parametro,nConta,1),'/-.') == 0
		nDigito1 := nDigito1+(11-nVez)*val(subs(parametro,nConta,1))
		nDigito2 := nDigito2+(12-nVez)*val(subs(parametro,nConta,1))
		nVez ++
	     endif
	 next

	 nResto   := nDigito1-(int(nDigito1/11)*11)
	 nDigito  := if(nResto < 2,0,11-nResto)
	 nDigito2 := nDigito2 + 2 * nDigito
	 nResto   := nDigito2 - (int(nDigito2/11)*11)
	 nDigito  := val(str(nDigito,1)+str(if(nResto<2,0,11-nResto),1))

	 if nDigito <> val(subs(parametro,len(parametro)-1,2))
	    MsgExclamation('Este Nº não é válido','Atenção')
	    return(.f.)
	 else
	    return(.t.)
	 endif

	 return(nil)
*-------------------------------------------------------------------------------
function Chk_Cnpj( parametro )

         local nConta
         local nResto
         local nDigito
	 local nDigito1 := 0
         local nDigito4 := 0
         local nVez     := 1

	 if empty(parametro)
	    MsgExclamation('O Nº do CNPJ não pode ser em branco','Atenção')
	    return(.t.)
	 endif

	 for nConta := 1 to len(parametro)-2
	     if at(subs(parametro,nConta,1),'/-.') == 0
		nDigito1 := nDigito1+val(subs(parametro,nConta,1))*(if(nVez<5,6,14)-nVez)
		nDigito4 := nDigito4+val(subs(parametro,nConta,1))*(if(nVez<6,7,15)-nVez)
		nVez ++
	     endif
	 next

	 nResto   := nDigito1 - (int(nDigito1/11)*11)
	 nDigito  := if(nResto < 2,0,11-nResto)
	 nDigito4 := nDigito4 + 2 * nDigito
	 nResto   := nDigito4 - (int(nDigito4/11)*11)
	 nDigito  := val(str(nDigito,1)+str(if(nResto < 2,0,11-nResto),1))

	 if nDigito <> val(subs(parametro,len(parametro)-1,2))
	    MsgExclamation('Este Nº não é válido','Atenção')
	    return(.f.)
	 else
	    return(.t.)
	 endif

	 return(nil)
*-------------------------------------------------------------------------------
function Calculadora()
         ShellExecute('','open','calc.exe','',,'')
         return(nil)
*-------------------------------------------------------------------------------
function Valor_Coluna(xObj,xForm,nCol)
	 local nPos := GetProperty(xForm,xObj,'Value')
	 local aRet := GetProperty(xForm,xObj,'Item',nPos)
	 return aRet[nCol]
*-------------------------------------------------------------------------------
function suportetecnico()
		 return(nil)
*-------------------------------------------------------------------------------
function td(parametro)

		 local v_data := ''
		 local v_retorno := ''

		 local v_dia := ''
		 local v_mes := ''
		 local v_ano := ''

		 if empty(parametro)
		    return('2000-01-01')
		 else
		    v_data := dtoc(parametro)
		 	v_dia := substr(v_data,1,2)
		 	v_mes := substr(v_data,4,2)
		 	v_ano := substr(v_data,7,4)
		 	v_retorno := v_ano+'-'+v_mes+'-'+v_dia
		 	return(v_retorno)
		 endif
*-------------------------------------------------------------------------------
function dia_da_semana(p_data,p_tipo)

	 	 local cSem_ext,cSem_abv,cData

	 	 if p_tipo == 1
	     	cSem_ext := {'Domingo','Segunda','Terça' ,;
		 	 		 	 'Quarta','Quinta','Sexta' ,;
		 	 			 'Sábado'}
	     				 cData := cSem_ext[dow(p_data)]
	     				 return(cData)
	     elseif p_tipo == 2
	        cSem_abv := {'Dom','Seg','Ter','Qua','Qui','Sex','Sáb'}
	    	cData    := cSem_abv[dow(p_data)]
	    	return(cData)
	     endif

	 	 return(nil)
*-------------------------------------------------------------------------------
function mes_do_ano(parametro,tipo)

	 	 if tipo == 1
	     	return{'Jan','Fev','Mar','Abr','Mai','Jun',;
		           'Jul','Ago','Set','Out','Nov','Dez'} [Parametro]
	     elseif tipo == 2
	        return{'Janeiro  ','Fevereiro','Março    ','Abril    ','Maio     ','Junho    ',;
		           'Julho    ','Agosto   ','Setembro ','Outubro  ','Novembro ',;
		           'Dezembro '} [Parametro]
	     endif