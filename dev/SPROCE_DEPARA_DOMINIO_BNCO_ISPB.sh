#!/bin/bash

set -x

####################################################################################################
#  Nome do Arquivo   : SPROCE_DEPARA_DOMINIO_BNCO_ISPB.sh                                          #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 31/01/2019                                                                  #
#  Descricao         : Realiza o de-para de banco para ispb do arquivo                             # 
#					   recebido da credenciadora Rede(1606)                    #
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Flag indicadora do de-para				   #	
#                                     Se Flag igual a 1 => de-para será realizado no arquivo       #
# 							do diretório de recebidos    	           #
#                                                                                                  #
#                                     Se Flag igual a 2 =>  de-para será realizado nos arquivos    #
#                                                           intermediarios gerados pelo job wf_0014# 
#							    para consumo do retorno(job wf_0019)   #
#                      Parametro 2 -> Caminho do diretorio da source                               #
#                      Parametro 3 -> Codigo da bandeira                                           #
#                      Parametro 4 -> Codigo da credenciadora                                      #
#                      Parametro 5 -> Caminho e nome do arquivo a ser processado                   #
#                      Parametro 6 -> Caminho do diretorio de target                               #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+-----------------------------------------------------------------  #
# LE00534	      | 31/01/2019 | Criacao                                                       #
####################################################################################################

p_FLAG_ORDEM=${1}
p_NOM_DIR_FILE_SRC=${2}
p_CD_BANDEIRA=${3}
p_CD_CREDENCIADORA=${4}
p_DIR_TGT=${6}

v_ARQV_DOMINIO=${p_DIR_TGT}"AO_0331_EXT_DOMINIO_BNCO.txt"
v_ARQV_TEMP=${p_DIR_TGT}"TEMP_"
v_ARQV_RET_TEMP=${p_DIR_TGT}"RET_TEMP_"

f_NOM_ARQ_SRC=${v_NOM_DIR_FILE_SRC}"CAD_MANUT_CNPJ_CPF_TX_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_*.[Tt][Xx][Tt]"
f_NOM_ARQ_LOG=${p_DIR_TGT}"AO_DEPARA_ISPB_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_LOG.txt"



FNC_LOG(){
	
	printf "%-30s|%s\n" $1 $2  | sed -e 's/ /./g' | sed -e 's/|/: /' >> ${f_NOM_ARQ_LOG}
	chmod 777 ${f_NOM_ARQ_LOG}	
}

FNC_LOG_DETALHE(){

	printf "%-30s|%s\n" "$1" | sed -e 's/ /./g' | sed -e 's/|/:'"${2}"' /' >> ${f_NOM_ARQ_LOG}	
}

FNC_DEPARA_BANCO(){

	p_ARQUIVO=${1}
	
	#imprime hashtag para formatar o layout do arquivo de saida
	printf "%-176s|%s\n" | sed -e 's/ /#/g' | sed -e 's/|/ /' >> ${f_NOM_ARQ_LOG}
	
	
	FNC_LOG "REALIZANDO_DE_PARA_NO_ARQUIVO" ${p_ARQUIVO}
	echo "\n" >> ${f_NOM_ARQ_LOG}	
			
	#nome do arquivo recebido		
	v_ARQUIVO_REC=`echo ${p_ARQUIVO} | awk -F"/" '{print $NF}'`			
			
	while read linha
	do 
		
		v_TP_REG=`echo ${linha} | cut -c 1-2`
		
		if [ "${v_TP_REG}" == "E3" ]
		then
			
			#pega o numero do banco do arquivo do diretorio de recebido e remove zeros a esquerda
			#v_BANCO_DEB=`echo ${linha} | cut -c 34-41 | sed 's/^0*//'`
			#v_BANCO_CRED=`echo ${linha} | cut -c 69-76 | sed 's/^0*//'`
			
			v_BANCO_DEB=`echo ${linha} | cut -c 34-41`
			v_BANCO_CRED=`echo ${linha} | cut -c 69-76`
						
			if [ ${p_FLAG_ORDEM} -eq 1 ]
			then			
				#recupera o ISPB do banco DEBITO e CREDITO contido no arquivo de dominio
				v_LINHA_DOMINIO=`cat ${v_ARQV_DOMINIO} | grep "^${v_BANCO_DEB};"`
				v_LINHA_DOMINIO_CRED=`cat ${v_ARQV_DOMINIO} | grep "^${v_BANCO_CRED};"`
				
				v_ARQV_DOMINIO_ISPB=`echo ${v_LINHA_DOMINIO} | cut -d';' -f6` 
				v_ARQV_DOMINIO_ISPB_CRED=`echo ${v_LINHA_DOMINIO_CRED} | cut -d';' -f6` 
				
				v_ISPB=""
				v_ISPB_CRED=""
				
			elif [ ${p_FLAG_ORDEM} -eq 2 ]
			then
				#recupera o banco DEBITO e CREDITO com base no ISPB contido no arquivo de dominio
				v_LINHA_DOMINIO=`cat ${v_ARQV_DOMINIO} | awk -F';' '{if ($6 =='${v_BANCO_DEB}') {print} }'`
				v_LINHA_DOMINIO_CRED=`cat ${v_ARQV_DOMINIO} | awk -F';' '{if ($6 =='${v_BANCO_CRED}') {print} }'`
				
				v_ARQV_DOMINIO_ISPB=`echo ${v_LINHA_DOMINIO} | cut -d';' -f1` 
				v_ARQV_DOMINIO_ISPB_CRED=`echo ${v_LINHA_DOMINIO_CRED} | cut -d';' -f1` 
				
				
			fi
			
			echo "BANCO_DEBITO:"${v_LINHA_DOMINIO}
			echo "BANCO_CREDITO:"${v_LINHA_DOMINIO_CRED}
			
			#caso nao encontre um banco de debito nem de credito no arquivo de dominio, 
			#preserva a linha gravando no arquivo temporario
						
			if [ "${v_LINHA_DOMINIO}" == "" -a "${v_LINHA_DOMINIO_CRED}" == "" ]
			then
				if [ ${p_FLAG_ORDEM} -eq 1 ]
				then					
					echo "${linha}" >> "${v_ARQV_TEMP}${v_ARQUIVO_REC}"
						
					#crio um arquivo com outra nomenclatura para ser utilizado no retorno			
				elif [ ${p_FLAG_ORDEM} -eq 2 ] 
				then
					echo "${linha}" >> "${v_ARQV_RET_TEMP}${v_ARQUIVO_REC}"
				fi
			else
			
				#caso nao exista banco debito, preservo o banco enviado. caso exista, populo a variavel com o ispb
				if [ "${v_LINHA_DOMINIO}" == "" ]
				then
					v_ISPB=`printf %08s "${v_BANCO_DEB}"`
				else
					v_ISPB=`printf %08s "${v_ARQV_DOMINIO_ISPB}"`	
				fi
				
				#caso nao exista banco credito, preservo o banco enviado. caso exista, populo a variavel com o ispb
				if [ "${v_LINHA_DOMINIO_CRED}" == "" ]
				then 
					v_ISPB_CRED=`printf %08s "${v_BANCO_CRED}"`
				else
					v_ISPB_CRED=`printf %08s "${v_ARQV_DOMINIO_ISPB_CRED}"`	
				fi
				
				#cria uma nova linha substituindo o banco pelo ISPB
				v_NOVA_LINHA=`echo "${linha}" | cut -c 1-33 `"${v_ISPB}"`echo "${linha}" | cut -c 42-68`"${v_ISPB_CRED}"`echo "${linha}" | cut -c 77-`
				
				FNC_LOG_DETALHE "DE" "${linha}"
				FNC_LOG_DETALHE "PARA" "${v_NOVA_LINHA}"
				
				#cria um arquivo temporario com a nova linha
				if [ ${p_FLAG_ORDEM} -eq 1 ]
				then
					echo "${v_NOVA_LINHA}" >> "${v_ARQV_TEMP}${v_ARQUIVO_REC}"
				elif [ ${p_FLAG_ORDEM} -eq 2 ] 
				then
					echo "${v_NOVA_LINHA}" >> "${v_ARQV_RET_TEMP}${v_ARQUIVO_REC}"
				fi
			
			fi
		#caso o tipo registro da linha nao seja E3, gravo a linha direto no arquivo temporario
		else
			echo "${linha}" >> "${v_ARQV_TEMP}${v_ARQUIVO_REC}"
			
		fi
		
	done < "${p_ARQUIVO}" 
	
	if [ ${p_FLAG_ORDEM} -eq 1 ]
	then
		#No final do processamento, subscreve o arquivo original pelo depara realizado
		mv "${v_ARQV_TEMP}${v_ARQUIVO_REC}" "${p_NOM_DIR_FILE_SRC}${v_ARQUIVO_REC}"
		chmod 666 "${p_NOM_DIR_FILE_SRC}${v_ARQUIVO_REC}"
	elif [ ${p_FLAG_ORDEM} -eq 2 ] 
	then
		#No final do processamento, subscreve o arquivo temporario utilizado 
		mv "${v_ARQV_RET_TEMP}${v_ARQUIVO_REC}" "${p_DIR_TGT}${v_ARQUIVO_REC}" 2>/dev/null
		chmod 666 "${p_DIR_TGT}${v_ARQUIVO_REC}"
	fi
	
	echo "\n" >> ${f_NOM_ARQ_LOG}
	printf "%-176s|%s\n" | sed -e 's/ /#/g' | sed -e 's/|/ /' >> ${f_NOM_ARQ_LOG}
	echo "+" >> ${f_NOM_ARQ_LOG}
	
	FNC_LOG "FIM_DO_PROCESSAMENTO" `echo $( date +%d/%m/%Y-%H:%M:%S )`
	
	echo "+" >> ${f_NOM_ARQ_LOG}
	printf "%-176s|%s\n" | sed -e 's/ /#/g' | sed -e 's/|/ /' >> ${f_NOM_ARQ_LOG}
}

#########################################
#     BLOCO INICIO DO PROCESSAMENTO     #
#########################################

#remove os arquivos temporarios antigos
if [ "${p_FLAG_ORDEM}" -eq 1 ]
then 
	rm -f "${v_ARQV_TEMP}"*""
	rm -f "${f_NOM_ARQ_LOG}"
fi

#imprime hashtag para formatar o layout do arquivo de saida
printf "%-176s|%s\n" | sed -e 's/ /#/g' | sed -e 's/|/ /' >> ${f_NOM_ARQ_LOG}

FNC_LOG "INICIO_DO_PROCESSAMENTO" `echo $( date +%d/%m/%Y-%H:%M:%S )`
FNC_LOG "BANDEIRA" ${p_CD_BANDEIRA}
FNC_LOG "CREDENCIADORA" ${p_CD_CREDENCIADORA}


if [ "${p_FLAG_ORDEM}" -eq 1 ]
	then
	
	#v_NOM_ARQ_FINAL=`ls -lt ${p_NOM_DIR_FILE_SRC}${f_NOM_ARQ_SRC} | head -1 | awk '{print $9}'`
	v_NOM_ARQ_FINAL=`echo ${5} | awk -F"/" '{print $NF}'`
	FNC_LOG "VALOR_DA_FLAG" ${p_FLAG_ORDEM}
		
	#cria backup do arquivo
	cp "${p_NOM_DIR_FILE_SRC}${v_NOM_ARQ_FINAL}" "${p_NOM_DIR_FILE_SRC}bkp/"
	
	FNC_LOG "BACKUP_CRIADO_NO_DIRETORIO" "${p_NOM_DIR_FILE_SRC}bkp"
	
	FNC_DEPARA_BANCO "${p_NOM_DIR_FILE_SRC}${v_NOM_ARQ_FINAL}"
	
elif [ "${p_FLAG_ORDEM}" -eq 2 ]
	then
	FNC_LOG "VALOR_DA_FLAG" ${p_FLAG_ORDEM}
	
	#lista os arquivos temporarios para fazer o de-para de BANCO para ISPB
	for i in `ls ${p_DIR_TGT}AB_0014_*"${p_CD_CREDENCIADORA}"_*E3*`
	do
		#passo apenas o nome do arquivo como parametro para a funcao
		FNC_DEPARA_BANCO "${i}"
	done
	
fi
