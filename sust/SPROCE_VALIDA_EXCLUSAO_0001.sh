#!/bin/bash

####################################################################################################
#  Nome do Arquivo   : SPROCE_VALIDA_DETALHE_0001.sh                                               #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 10/08/2016                                                                  #
#  Descricao         : Realiza a validacao do detalhe do arquivo                                   #
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Codigo da Bandeira                                           #
#                      Parametro 2 -> Codigo da Credenciadora                                      #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
# EYVF06	      | 10/08/2016 | Criacao                                                           #
####################################################################################################

#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################
v_NOM_DIR_RAIZ="/etlsys/pceproce/infa_shared"
v_NOM_DIR_FILE_TGT=${v_NOM_DIR_RAIZ}"/TgtFiles/"
v_DT_EXEC=`echo $( date +%Y%m%d-%H%M%S )`

#########################################
# Parametros Recebidos                  #
#########################################
p_CD_BANDEIRA=$1
p_CD_CREDENCIADORA=$2

##############################################
# Declaracao de Arquivos (Source/Target/Log) #
##############################################

#Definicao do nome do arquivo Origem gerado pelo processo 0014
f_NOM_ARQ_DEL=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL.txt"

#Definicao do nome do arquivo de apoio gerado pelo mapa 0050
f_NOM_ARQ_BSE=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"

f_NOM_ARQ_RET_E1=${v_NOM_DIR_FILE_TGT}"AB_0015_EPROPRCEXT_CLIENTE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E1.txt"
f_NOM_ARQ_RET_E2=${v_NOM_DIR_FILE_TGT}"AB_0016_EPROPRCEXT_PONTO_VENDA_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E2.txt"
f_NOM_ARQ_RET_E3=${v_NOM_DIR_FILE_TGT}"AB_0017_EPROPRCEXT_DOMICILIO_BANCARIO_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E3.txt"

#Arquivo Temporario
f_NOM_ARQ_DEL_E1_TMP=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_E1.tmp"
f_NOM_ARQ_DEL_E2_TMP=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_E2.tmp"
f_NOM_ARQ_DEL_E3_TMP=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_E3.tmp"

f_NOM_ARQ_DEL_E1_RET=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_E1.ret"
f_NOM_ARQ_DEL_E2_RET=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_E2.ret"
f_NOM_ARQ_DEL_E3_RET=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_E3.ret"

f_NOM_ARQ_TEMP_E2_TMP=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_TEMP_E2.tmp"
f_NOM_ARQ_TEMP_E3_TMP=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_TEMP_E3.tmp"

f_NOM_ARQ_TEMP_E2_RET=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_TEMP_E2.ret"
f_NOM_ARQ_TEMP_E3_RET=${v_NOM_DIR_FILE_TGT}"AB_PROPRC_005001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_TEMP_E3.ret"

#Definicao do nome do arquivo Log
f_NOM_ARQ_LOG=${v_NOM_DIR_FILE_TGT}"AO_0051_EPROPRCEXT_VALIDA_EXCLUSAO_01_01_"${v_DT_EXEC}"_LOG.txt"

#########################################
# Declaracao de Variaveis               #
#########################################
v_NU_OCORRENCIA=""
v_FG_OCORRENCIA="N"
v_NU_CLNT=""
v_FG_OCOR_1E1="N"
v_FG_OCOR_1E2="N"
v_FG_OCOR_1E3="N"		
v_FG_OCOR_2E2="N"
v_FG_OCOR_2E3="N"
v_FG_OCOR_3E3="N"	
v_TP_PESSOA_ANT=""
v_CNPJ_CPF_ANT=""

rm -f ${f_NOM_ARQ_DEL_E1_TMP}
rm -f ${f_NOM_ARQ_DEL_E2_TMP}
rm -f ${f_NOM_ARQ_DEL_E3_TMP}

rm -f ${f_NOM_ARQ_DEL_E1_RET}
rm -f ${f_NOM_ARQ_DEL_E2_RET}
rm -f ${f_NOM_ARQ_DEL_E3_RET}

rm -f ${f_NOM_ARQ_TEMP_E2_TMP}
rm -f ${f_NOM_ARQ_TEMP_E3_TMP}


#########################################
# Funcao de saida da rotina             #
#########################################
FNC_Exit()
{
v_ERR_CODE=${1}

exit ${v_ERR_CODE}
}

#########################################
# Funcao de geracao de arquivo de log   #
#########################################
FNC_Log()
{
        echo $( date +%d/%m/%Y-%H:%M:%S ) "${1}" >> ${f_NOM_ARQ_LOG}
}

FNC_Busca_Reg_E1()
{
	vf_NIVEL=$1
	vf_CHAVE_E1=$2
	v_QT_REG_ENCT=`grep -c "${vf_CHAVE_E1}" ${f_NOM_ARQ_BSE}`
	echo "${v_QT_REG_ENCT}"
	if [ "${v_QT_REG_ENCT}" -eq 0 ]
	then
		v_FG_OCOR_E1="S"
		v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"9999"
		v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
		FNC_Log "FALHA : Exclusao do tipo E1 nao realizada, pois este nao esta cadastrado na base."
	fi
}

FNC_Busca_Reg_E2()
{
	vf_NIVEL=$1
	vf_CHAVE_E2=$2
	v_REG_ENCT=`grep "${vf_CHAVE_E2}" ${f_NOM_ARQ_BSE}`
	if [ "${v_REG_ENCT}" == "" ]
	then
		v_FG_OCOR_E2="S"			
		v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
		if [ "${vf_NIVEL}" == "1" ]
		then
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0292"
			FNC_Log "FALHA : Exclusao do tipo E1 nao realizada, pois nao foram informados todos os tipos E2 relacionados ao E1"
		elif [ "${vf_NIVEL}" == "2" ]
		then
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0295"
			FNC_Log "FALHA : Exclusao do tipo E2 nao realizada"
		fi
	else
		v_BASE_FG_CNTL=`echo "${v_REG_ENCT}" | cut -c 34-34`
		#Caso nivel exclusao igual a dois, deve verificar se nao e PV Centralizador	
		if [ "${vf_NIVEL}" == "2" -a "${v_BASE_FG_CNTL}" == "S" ]
		then
			v_FG_OCOR_E2="S"			
			v_QT_ERRO=`expr ${v_QT_ERRO} + 1`		
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0054"
			FNC_Log "FALHA : Exclusao do tipo E2 nao realizada, pois este é um PV Centralizador"			
		fi	
		
	    v_BASE_QT_REG_RELA=`echo "${v_REG_ENCT}" | cut -c 91-91`
		#Caso nivel exclusao igual a dois, deve verificar se nao e o unico registro relacionado ao E2
		if [ "${vf_NIVEL}" == "2" -a "${v_BASE_QT_REG_RELA}" == "1" ]
		then
			v_FG_OCOR_E2="S"			
			v_QT_ERRO=`expr ${v_QT_ERRO} + 1`		
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0296"
			FNC_Log "FALHA : Exclusao do tipo E2 nao realizada, pois este é o unico E2 relacionado ao E1"
		fi		
	fi	
}

FNC_Busca_Reg_E3()
{
	vf_NIVEL=$1
	vf_CHAVE_E3=$2
	v_BASE_QT_REG_RELA=`grep "${vf_CHAVE_E3}" ${f_NOM_ARQ_BSE} | cut -c 91-91`
	if [ "${v_BASE_QT_REG_RELA}" == "" ]
	then
		v_FG_OCOR_E3="S"	
		v_QT_ERRO=`expr ${v_QT_ERRO} + 1`		
		if [ "${vf_NIVEL}" == "1" ]
		then		
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0293"
			FNC_Log "FALHA : Exclusao do tipo E1 nao realizada, pois nao foram informados todos os tipos E3 relacionados ao E1"
		elif [ "${vf_NIVEL}" == "2" ]
		then	
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0294"
			FNC_Log "FALHA : Exclusao do tipo E2 nao realizada, pois nao foram informados todos os tipos E3 relacionados ao E2"
		elif [ "${vf_NIVEL}" == "3" ]
		then	
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0298"
			FNC_Log "FALHA : Exclusao do tipo E3 nao realizada"		
		fi
	else
		#Caso nivel exclusao igual a tres, deve verificar se nao e o unico registro relacionado ao E2
		if [ "${vf_NIVEL}" == "3" -a "${v_BASE_QT_REG_RELA}" == "1" ]
		then
			v_FG_OCOR_E3="S"	
			v_QT_ERRO=`expr ${v_QT_ERRO} + 1`		
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0297"
			FNC_Log "FALHA : Exclusao do tipo E3 nao realizada, pois este é o unico E3 relacionado ao E2"			
		fi
	fi	
}

FNC_Gera_Ocor_Passada()
{

while read v_REG_FILE_TMP
do
	v_TP_REGISTRO=`echo "${v_REG_FILE_TMP}" | cut -c 1-2`
	if [ "${v_TP_REGISTRO}" == "E1" ]
	then
		v_REG=`echo "${v_REG_FILE_TMP}" | cut -c 1-90`
		v_NU_OCORRENCIA=`echo "${v_REG_FILE_TMP}" | cut -c 91-114`
		v_QT_ERRO=`echo "${v_REG_FILE_TMP}" | cut -c 115-115`
	elif [ "${v_TP_REGISTRO}" == "E2" ]
	then
		v_REG=`echo "${v_REG_FILE_TMP}" | cut -c 1-40`		
		v_NU_OCORRENCIA=`echo "${v_REG_FILE_TMP}" | cut -c 41-64`	
		v_QT_ERRO=`echo "${v_REG_FILE_TMP}" | cut -c 65-65`	
	elif [ "${v_TP_REGISTRO}" == "E3" ]
	then
		v_REG=`echo "${v_REG_FILE_TMP}" | cut -c 1-96`
		v_NU_OCORRENCIA=`echo "${v_REG_FILE_TMP}" | cut -c 97-120`	
		v_QT_ERRO=`echo "${v_REG_FILE_TMP}" | cut -c 121-121`	
	fi
	
	if [ "${v_FG_OCOR_E1}" == "S" ]
	then
		string="${v_NU_OCORRENCIA}"
		substring="0291"
		if test "${string#*$substring}" == "$string"
		then
			v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291"
			v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
		fi
	fi
		
	echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}" >> $f_NOM_ARQ_DEL_FINAL
	
done < ${f_NOM_ARQ_DEL_TMP}	
#rm -f ${f_NOM_ARQ_DEL_TMP}	

}

###########################################################
# Inicio do processo                                      #
###########################################################
FNC_Log "ALERTA: Inicio do Processo SPROCE_VALIDA_EXCLUSAO_0001.sh - Parametros Recebidos -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <-"

v_NU_LINHA_INI=1

v_TP_PESSOA_ANT=""
v_CNPJ_CPF_ANT=""
while read v_REG_FILE
do

	v_TP_REGISTRO=`echo "${v_REG_FILE}" | cut -c 1-2`
	v_CD_OPERACAO=`echo "${v_REG_FILE}" | cut -c 3-3`
	v_TP_PESSOA=`echo "${v_REG_FILE}" | cut -c 4-4`
	v_CNPJ_CPF=`echo "${v_REG_FILE}" | cut -c 5-18`
	
	v_E1_MANDATORIO=$(grep E1E${v_TP_PESSOA}${v_CNPJ_CPF} ${f_NOM_ARQ_DEL} | cut -c 115-115)

	if [ "${v_TP_PESSOA}" == "${v_TP_PESSOA_ANT}" -a "${v_CNPJ_CPF}" == "${v_CNPJ_CPF_ANT}" ] || [ "${v_TP_PESSOA_ANT}" == "" -a "${v_CNPJ_CPF_ANT}" == "" ]
	then
		if [ "${v_TP_REGISTRO}" == "E1" ]
		then
			v_REG=`echo "${v_REG_FILE}" | cut -c 1-90`		
			v_QT_ERRO=`echo "${v_REG_FILE}" | cut -c 115-115`
			if [ ${v_QT_ERRO} -eq 0 ]
			then
				v_NU_OCORRENCIA=""
			else		
				v_POS_INI=`expr '(' '(' 6 - ${v_QT_ERRO} ')' \* 4 ')' + 91`
				v_NU_OCORRENCIA=`echo "${v_REG_FILE}" | cut -c "${v_POS_INI}"-114`
			fi
			v_NU_LINHA=`echo "${v_REG_FILE}" | cut -c 116-124`
			v_FG_NVL_EXC=`echo "${v_REG_FILE}" | cut -c 125-125`
			v_QT_REG_EXC=`echo "${v_REG_FILE}" | cut -c 126-128`
			v_QT_REG_ATR_E2=`echo "${v_REG_FILE}" | cut -c 129-131`
			v_QT_REG_ATR_E3=`echo "${v_REG_FILE}" | cut -c 132-134`
			
			v_RET_BUSC=`grep "E1E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_BSE}`
			#Adriana
			#v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 86-95` 
			v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 105-114`
			#v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 96-98`
			v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 115-117`
			#v_QT_REG_BASE_ATR_E2=`echo "${v_RET_BUSC}" | cut -c 103-105`
			v_QT_REG_BASE_ATR_E2=`echo "${v_RET_BUSC}" | cut -c 122-124`
			#v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 106-109`
			v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 125-128`
			####
			if [ "${v_NU_CLNT}" == "" ]
			then
				#v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0016"
				#v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				v_FG_OCOR_E1="S"
		    elif [ "${v_QT_REG_EXC}" != "${v_QT_REG_BASE_ATR}" ]
		   then
		   	#v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291" #0291
		   	#v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
		   	#v_FG_OCOR_1E1="S"
		   	
		   	if [ "${v_QT_REG_ATR_E2}" != "${v_QT_REG_BASE_ATR_E2}" ]
		   	then
		   		v_FG_OCOR_1E2="S"
		   	fi
           
		   	if [ "${v_QT_REG_ATR_E3}" != "${v_QT_REG_BASE_ATR_E3}" ]
		   	then
		   		v_FG_OCOR_1E3="S"
		   	fi				
		    fi
			v_NU_OCORRENCIA=`printf '%024s' "${v_NU_OCORRENCIA}"`
			
			if [ ${v_QT_ERRO} -eq 0 ]
			   then
			   
			   grep "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_BSE} | cut -c1-42 > ${f_NOM_ARQ_TEMP_E2_TMP}
		   
			   while read v_REG_E2
			      do

				  echo "${v_REG_E2}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E2_TMP}
				  
               done < ${f_NOM_ARQ_TEMP_E2_TMP}
			   
			   grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_BSE} | sed 's/ //g' | cut -c1-96 > ${f_NOM_ARQ_TEMP_E3_TMP}
			   
			   while read v_REG_E3
			      do

			   echo "${v_REG_E3}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E3_TMP}
			   
               done < ${f_NOM_ARQ_TEMP_E3_TMP}
			   
			   			   
			   grep "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL} | awk '{ print substr($0,1,40)"0000000000000000000000000"substr($0,66) }' >> ${f_NOM_ARQ_DEL_E2_RET}
               grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL} | awk '{ print substr($0,1,96)"0000000000000000000000000"substr($0,122) }' >> ${f_NOM_ARQ_DEL_E3_RET}

            fi

            echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}00${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E1_TMP}

            echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}00${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E1_RET}

            #Adriana

			
		elif [ "${v_TP_REGISTRO}" == "E2" ]
		then
		
		if [ "${v_E1_MANDATORIO}" != "0" -o "${v_E1_MANDATORIO}" == "" ]
		then
		
			v_REG=`echo "${v_REG_FILE}" | cut -c 1-40`		
			v_PONTO_VENDA=`echo "${v_REG_FILE}" | cut -c 19-33`
			v_QT_ERRO=`echo "${v_REG_FILE}" | cut -c 65-65`
            if [ ${v_QT_ERRO} -eq 0 ]
			then
				v_NU_OCORRENCIA=""	
			else
				v_POS_INI=`expr '(' '(' 6 - ${v_QT_ERRO} ')' \* 4 ')' + 41`
				v_NU_OCORRENCIA=`echo "${v_REG_FILE}" | cut -c "${v_POS_INI}"-64`	
			fi
			
			v_NU_LINHA=`echo "${v_REG_FILE}" | cut -c 66-74`
			#Adriana
			v_FG_NVL_EXC=`echo "${v_REG_FILE}" | cut -c 75-75`	
			V_QT_REG_ARQ=`echo "${v_REG_FILE}" | cut -c 76-78`
		
			v_RET_BUSC=`grep "E2E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_BSE}`
			v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 105-114`
           #v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 91-100`			
			##
			if [ ${v_FG_NVL_EXC} -eq 1 ]
			then
			
				if [ "${v_FG_OCOR_1E1}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291" #0291
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi
			
				if [ "${v_FG_OCOR_1E2}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0292" #0292
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi			
			else	
			   #v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 91-93`
				v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 115-117`
			   #v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 94-96`
                v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 118-120`				
			   #v_FG_PDV_CENZ=`echo "${v_RET_BUSC}" | cut -c 97-97`
                v_FG_PDV_CENZ=`echo "${v_RET_BUSC}" | cut -c 121-121`						
				
				if [ "${v_NU_CLNT}" == "" ]
				then
					v_FG_OCOR_2E2="S"
				   #v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0022"
				   #v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				else	
					if [ "${v_FG_PDV_CENZ}" == "S" ]
					then
						v_FG_OCOR_2E2="S"
						v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0054"
						v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
					fi	
				
					v_QT_PDV_CPF_CNPJ=`grep -c "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL}`
					v_ERROR_E3=`grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL} | cut -c121-121`
					if [ ${v_QT_PDV_CPF_CNPJ} -eq ${v_QT_REG_BASE_ATR} -a ${v_QT_PDV_CPF_CNPJ} -gt 0 ]
					then
						v_FG_OCOR_2E2="S"
						v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0296" #0296
						v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
					fi				
				
					if [ ${v_QT_REG_BASE_ATR_E3} -ne ${V_QT_REG_ARQ} -o ${v_ERROR_E3} -gt 0 ]
					then
						v_FG_OCOR_2E2="S"
						v_FG_OCOR_2E3="S"
					fi
				fi
				
			   v_E2_UNICO=$(grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_DEL})
			
			     if [ ${v_E2_UNICO} -eq 0 ]
			        then
			        
					v_FG_OCOR_2E2="S"
			        v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0294" #0294
			        v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
			        
			     fi
				
				if [ "${v_FG_OCOR_2E2}" == "S" ]
				then
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0295" #0295
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`	
				 fi
				
	
			fi
			
			v_NU_OCORRENCIA=`printf '%024s' "${v_NU_OCORRENCIA}"`

			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E2_TMP}
			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E2_RET}
        
		fi
		
		elif [ "${v_TP_REGISTRO}" == "E3" ]
		then
		
		if [ "${v_E1_MANDATORIO}" != "0" -o "${v_E1_MANDATORIO}" == "" ]
		then
		
			v_REG=`echo "${v_REG_FILE}" | cut -c 1-96`	
			v_PONTO_VENDA=`echo "${v_REG_FILE}" | cut -c 19-33`
			v_BANCO_DOMICILIO_DEBITO=`echo "${v_REG_FILE}" | cut -c 34-37`
			v_AGENCIA_BANCO_DOCIMICILIO_DEBITO=`echo "${v_REG_FILE}" | cut -c 38-42`
			v_CONTA_DOMICILIO_DEBITO=`echo "${v_REG_FILE}" | cut -c 43-56`
			v_BANCO_DOMICILIO_CREDITO=`echo "${v_REG_FILE}" | cut -c 57-60`
			v_AGENCIA_BANCO_DOCIMICILIO_CREDITO=`echo "${v_REG_FILE}" | cut -c 61-65`
			v_CONTA_DOMICILIO_CREDITO=`echo "${v_REG_FILE}" | cut -c 66-79`
			v_QT_ERRO=`echo "${v_REG_FILE}" | cut -c 121-121`	
			if [ ${v_QT_ERRO} -eq 0 ]
			then
				v_NU_OCORRENCIA=""	
			else
				v_POS_INI=`expr '(' '(' 6 - ${v_QT_ERRO} ')' \* 4 ')' + 97`		
				v_NU_OCORRENCIA=`echo "${v_REG_FILE}" | cut -c "${v_POS_INI}"-120`	
			fi
			v_NU_LINHA=`echo "${v_REG_FILE}" | cut -c 122-130`		
			v_FG_NVL_EXC=`echo "${v_REG_FILE}" | cut -c 131-131`
			v_QT_REG_RELA=`echo "${v_REG_FILE}" | cut -c 132-132`
			
			if [ "${v_FG_NVL_EXC}" == "1" ]
			then
			
				if [ "${v_FG_OCOR_1E1}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291" #0291
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi

				if [ "${v_FG_OCOR_1E3}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0293" #0293
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi		
				
			elif [ "${v_FG_NVL_EXC}" == "2" ]
			then	

				if [ "${v_FG_OCOR_2E2}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0295" #0295
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi		

				#if [ "${v_FG_OCOR_2E3}" == "S" ]
				#then 
				#	v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0294" #0294
				#	v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				#fi		
							
			else
				v_RET_BUSC=`grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_BSE}`
			   #v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 81-90`
				v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 105-114`
			   #v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 94-96`
				v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 118-120`				
				v_QT_DMCN_PDV=`grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_DEL}`
				
				if [ "${v_NU_CLNT}" == "" ]
				then
					v_FG_OCOR_3E3="S"
				   #v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0030"
				   #v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				elif [ ${v_QT_DMCN_PDV} -le ${v_QT_REG_BASE_ATR} ]
				then
					v_FG_OCOR_3E3="S"
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0297" #0297
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`	
				fi			
				
				if [ "${v_QT_REG_BASE_ATR}" == "" ]
				then
					v_QT_REG_BASE_ATR=0
				fi
				
				if [ "${v_FG_OCOR_3E3}" == "S" ]
				then
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0298" #0298
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`	
				fi
			fi
		
		    #v_NU_CLNT=`grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}${v_BANCO_DOMICILIO_DEBITO}${v_AGENCIA_BANCO_DOCIMICILIO_DEBITO}${v_CONTA_DOMICILIO_DEBITO}${v_BANCO_DOMICILIO_CREDITO}${v_AGENCIA_BANCO_DOCIMICILIO_CREDITO}${v_CONTA_DOMICILIO_CREDITO}" ${f_NOM_ARQ_BSE} | cut -c 81-90`
            v_NU_CLNT=`grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}       ${v_BANCO_DOMICILIO_DEBITO}${v_AGENCIA_BANCO_DOCIMICILIO_DEBITO}${v_CONTA_DOMICILIO_DEBITO}${v_BANCO_DOMICILIO_CREDITO}${v_AGENCIA_BANCO_DOCIMICILIO_CREDITO}${v_CONTA_DOMICILIO_CREDITO}" ${f_NOM_ARQ_BSE} | cut -c 105-114`

			v_NU_OCORRENCIA=`printf '%024s' "${v_NU_OCORRENCIA}"`
			
			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E3_TMP}
			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E3_RET}
			
		fi
		
		else
			FNC_Log "FALHA : Tipo de Registro '"${v_TP_REGISTRO}"' invalido!"
			exit 10
		fi
		

		
	else
		v_FG_OCOR_1E1="N"
		v_FG_OCOR_1E2="N"
		v_FG_OCOR_1E3="N"		
		v_FG_OCOR_2E2="N"
		v_FG_OCOR_2E3="N"
		v_FG_OCOR_3E3="N"		
		
		#repetido
		if [ "${v_TP_REGISTRO}" == "E1" ]
		then
			v_REG=`echo "${v_REG_FILE}" | cut -c 1-90`		
			v_QT_ERRO=`echo "${v_REG_FILE}" | cut -c 115-115`
			if [ ${v_QT_ERRO} -eq 0 ]
			then
				v_NU_OCORRENCIA=""
			else		
				v_POS_INI=`expr '(' '(' 6 - ${v_QT_ERRO} ')' \* 4 ')' + 91`
				v_NU_OCORRENCIA=`echo "${v_REG_FILE}" | cut -c "${v_POS_INI}"-114`
			fi
			v_NU_LINHA=`echo "${v_REG_FILE}" | cut -c 116-124`
			v_FG_NVL_EXC=`echo "${v_REG_FILE}" | cut -c 125-125`
			v_QT_REG_EXC=`echo "${v_REG_FILE}" | cut -c 126-128`
			v_QT_REG_ATR_E2=`echo "${v_REG_FILE}" | cut -c 129-131`
			v_QT_REG_ATR_E3=`echo "${v_REG_FILE}" | cut -c 132-134`
			
			v_RET_BUSC=`grep "E1E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_BSE}`
			#Adriana
			#v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 86-95` 
			v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 105-114`
			#v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 96-98`
			v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 115-117`
			#v_QT_REG_BASE_ATR_E2=`echo "${v_RET_BUSC}" | cut -c 103-105`
			v_QT_REG_BASE_ATR_E2=`echo "${v_RET_BUSC}" | cut -c 122-124`
			#v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 106-109`
			v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 125-128`
			####
			
			if [ "${v_NU_CLNT}" == "" ]
			then
				#v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0016"
				#v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				v_FG_OCOR_E1="S"
		   elif [ "${v_QT_REG_EXC}" != "${v_QT_REG_BASE_ATR}" ]
		   then
		   	#v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291" #0291
		   	#v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
		   	#v_FG_OCOR_1E1="S"
		   	
		   	if [ "${v_QT_REG_ATR_E2}" != "${v_QT_REG_BASE_ATR_E2}" ]
		   	then
		   		v_FG_OCOR_1E2="S"
		   	fi
             #
		   	if [ "${v_QT_REG_ATR_E3}" != "${v_QT_REG_BASE_ATR_E3}" ]
		   	then
		   		v_FG_OCOR_1E3="S"
		   	fi				
			fi
			v_NU_OCORRENCIA=`printf '%024s' "${v_NU_OCORRENCIA}"`
			
			if [ ${v_QT_ERRO} -eq 0 ]
			   then
			   
			   grep "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_BSE} | cut -c1-42 > ${f_NOM_ARQ_TEMP_E2_TMP}
		   
			   while read v_REG_E2
			      do

				  echo "${v_REG_E2}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E2_TMP}
				  
               done < ${f_NOM_ARQ_TEMP_E2_TMP}
			   
			   grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_BSE} | sed 's/ //g' | cut -c1-96 > ${f_NOM_ARQ_TEMP_E3_TMP}
			   
			   while read v_REG_E3
			      do

			   echo "${v_REG_E3}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E3_TMP}
			   
               done < ${f_NOM_ARQ_TEMP_E3_TMP}
			   
			   			   
			   grep "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL} | awk '{ print substr($0,1,40)"0000000000000000000000000"substr($0,66) }' >> ${f_NOM_ARQ_DEL_E2_RET}
               grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL} | awk '{ print substr($0,1,96)"0000000000000000000000000"substr($0,122) }' >> ${f_NOM_ARQ_DEL_E3_RET}

            fi

            echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}00${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E1_TMP}

            echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}00${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E1_RET}
			
		elif [ "${v_TP_REGISTRO}" == "E2" ]
		then
		
		if [ "${v_E1_MANDATORIO}" != "0" -o "${v_E1_MANDATORIO}" == "" ]
		then
		
			v_REG=`echo "${v_REG_FILE}" | cut -c 1-40`		
			v_PONTO_VENDA=`echo "${v_REG_FILE}" | cut -c 19-33`
			v_QT_ERRO=`echo "${v_REG_FILE}" | cut -c 65-65`		
			if [ ${v_QT_ERRO} -eq 0 ]
			then
				v_NU_OCORRENCIA=""	
			else
				v_POS_INI=`expr '(' '(' 6 - ${v_QT_ERRO} ')' \* 4 ')' + 41`
				v_NU_OCORRENCIA=`echo "${v_REG_FILE}" | cut -c "${v_POS_INI}"-64`	
			fi
			
			v_NU_LINHA=`echo "${v_REG_FILE}" | cut -c 66-74`
			v_FG_NVL_EXC=`echo "${v_REG_FILE}" | cut -c 75-75`	
			V_QT_REG_ARQ=`echo "${v_REG_FILE}" | cut -c 76-78`
		
			v_RET_BUSC=`grep "E2E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_BSE}`
			v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 105-114`
           #v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 91-100`			
			
			if [ ${v_FG_NVL_EXC} -eq 1 ]
			then
			
				if [ "${v_FG_OCOR_1E1}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291" #0291
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi
			
				if [ "${v_FG_OCOR_1E2}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0292" #0292
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi			
			else	
			   #v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 91-93`
				v_QT_REG_BASE_ATR_E3=`echo "${v_RET_BUSC}" | cut -c 115-117`
			   #v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 94-96`
                v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 118-120`				
			   #v_FG_PDV_CENZ=`echo "${v_RET_BUSC}" | cut -c 97-97`
                v_FG_PDV_CENZ=`echo "${v_RET_BUSC}" | cut -c 121-121`	
				
				if [ "${v_NU_CLNT}" == "" ]
				then
					v_FG_OCOR_2E2="S"
				   #v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0022"
				   #v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				else	
					if [ "${v_FG_PDV_CENZ}" == "S" ]
					then
						v_FG_OCOR_2E2="S"
						v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0054"
						v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
					fi	
				
					v_QT_PDV_CPF_CNPJ=`grep -c "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL}`
					v_ERROR_E3=`grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL} | cut -c121-121`
					if [ ${v_QT_PDV_CPF_CNPJ} -eq ${v_QT_REG_BASE_ATR} -a ${v_QT_PDV_CPF_CNPJ} -gt 0 ]
					then
						v_FG_OCOR_2E2="S"
						v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0296" #0296
						v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
					fi				
				
					if [ ${v_QT_REG_BASE_ATR_E3} -ne ${V_QT_REG_ARQ} -o ${v_ERROR_E3} -gt 0 ]
					then
						v_FG_OCOR_2E2="S"
						v_FG_OCOR_2E3="S"
					fi
				fi
				
				v_E2_UNICO=$(grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_DEL})
			
			     if [ ${v_E2_UNICO} -eq 0 ]
			        then
			        
					v_FG_OCOR_2E2="S"
			        v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0294" #0294
			        v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
			        
			     fi
				
				if [ "${v_FG_OCOR_2E2}" == "S" ]
				then
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0295" #0295
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`	

				fi
				
			fi

			v_NU_OCORRENCIA=`printf '%024s' "${v_NU_OCORRENCIA}"`

			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E2_TMP}
			
			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E2_RET}
        
		fi
		
		elif [ "${v_TP_REGISTRO}" == "E3" ]
		then
		
		if [ "${v_E1_MANDATORIO}" != "0" -o "${v_E1_MANDATORIO}" == "" ]
		then
		
			v_REG=`echo "${v_REG_FILE}" | cut -c 1-96`	
			v_PONTO_VENDA=`echo "${v_REG_FILE}" | cut -c 19-33`
			v_BANCO_DOMICILIO_DEBITO=`echo "${v_REG_FILE}" | cut -c 34-37`
			v_AGENCIA_BANCO_DOCIMICILIO_DEBITO=`echo "${v_REG_FILE}" | cut -c 38-42`
			v_CONTA_DOMICILIO_DEBITO=`echo "${v_REG_FILE}" | cut -c 43-56`
			v_BANCO_DOMICILIO_CREDITO=`echo "${v_REG_FILE}" | cut -c 57-60`
			v_AGENCIA_BANCO_DOCIMICILIO_CREDITO=`echo "${v_REG_FILE}" | cut -c 61-65`
			v_CONTA_DOMICILIO_CREDITO=`echo "${v_REG_FILE}" | cut -c 66-79`
			v_QT_ERRO=`echo "${v_REG_FILE}" | cut -c 121-121`	
			if [ ${v_QT_ERRO} -eq 0 ]
			then
				v_NU_OCORRENCIA=""	
			else
				v_POS_INI=`expr '(' '(' 6 - ${v_QT_ERRO} ')' \* 4 ')' + 97`		
				v_NU_OCORRENCIA=`echo "${v_REG_FILE}" | cut -c "${v_POS_INI}"-120`	
			fi
			v_NU_LINHA=`echo "${v_REG_FILE}" | cut -c 122-130`		
			v_FG_NVL_EXC=`echo "${v_REG_FILE}" | cut -c 131-131`
			v_QT_REG_RELA=`echo "${v_REG_FILE}" | cut -c 132-132`
			
			if [ "${v_FG_NVL_EXC}" == "1" ]
			then
			
				if [ "${v_FG_OCOR_1E1}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0291" #0291
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi

				if [ "${v_FG_OCOR_1E3}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0293" #0293
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi		
				
			elif [ "${v_FG_NVL_EXC}" == "2" ]
			then	

				if [ "${v_FG_OCOR_2E2}" == "S" ]
				then 
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0295" #0295
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				fi		

				#if [ "${v_FG_OCOR_2E3}" == "S" ]
				#then 
				#	v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0294" #0294
				#	v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				#fi		
							
			else
				v_RET_BUSC=`grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_BSE}`
			   #v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 81-90`
				v_NU_CLNT=`echo "${v_RET_BUSC}" | cut -c 105-114`
			   #v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 94-96`
				v_QT_REG_BASE_ATR=`echo "${v_RET_BUSC}" | cut -c 118-120`
				v_QT_DMCN_PDV=`grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_DEL}`
				
				if [ "${v_NU_CLNT}" == "" ]
				then
					v_FG_OCOR_3E3="S"
				   #v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0030"
				   #v_QT_ERRO=`expr ${v_QT_ERRO} + 1`
				elif [ ${v_QT_DMCN_PDV} -le ${v_QT_REG_BASE_ATR} ]
				then
					v_FG_OCOR_3E3="S"
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0297" #0297
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`	
				fi			
				
				if [ "${v_QT_REG_BASE_ATR}" == "" ]
				then
					v_QT_REG_BASE_ATR=0
				fi
				
				if [ "${v_FG_OCOR_3E3}" == "S" ]
				then
					v_NU_OCORRENCIA=${v_NU_OCORRENCIA}"0298" #0298
					v_QT_ERRO=`expr ${v_QT_ERRO} + 1`	
				fi
			fi
		
		    #v_NU_CLNT=`grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}${v_BANCO_DOMICILIO_DEBITO}${v_AGENCIA_BANCO_DOCIMICILIO_DEBITO}${v_CONTA_DOMICILIO_DEBITO}${v_BANCO_DOMICILIO_CREDITO}${v_AGENCIA_BANCO_DOCIMICILIO_CREDITO}${v_CONTA_DOMICILIO_CREDITO}" ${f_NOM_ARQ_BSE} | cut -c 81-90`
            v_NU_CLNT=`grep "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}       ${v_BANCO_DOMICILIO_DEBITO}${v_AGENCIA_BANCO_DOCIMICILIO_DEBITO}${v_CONTA_DOMICILIO_DEBITO}${v_BANCO_DOMICILIO_CREDITO}${v_AGENCIA_BANCO_DOCIMICILIO_CREDITO}${v_CONTA_DOMICILIO_CREDITO}" ${f_NOM_ARQ_BSE} | cut -c 105-114`

			v_NU_OCORRENCIA=`printf '%024s' "${v_NU_OCORRENCIA}"`
			
			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E3_TMP}
			
			echo "${v_REG}${v_NU_OCORRENCIA}${v_QT_ERRO}${v_NU_LINHA}${v_NU_CLNT}" >> ${f_NOM_ARQ_DEL_E3_RET}
			
		fi
			
		else
			FNC_Log "FALHA : Tipo de Registro '"${v_TP_REGISTRO}"' invalido!"
			exit 10
		fi
		#repetido
	
	fi
	
	v_TP_PESSOA_ANT="${v_TP_PESSOA}" 
	v_CNPJ_CPF_ANT="${v_CNPJ_CPF}" 
	
	v_NU_LINHA_INI=`expr ${v_NU_LINHA_INI} + 1`
	v_NU_CLNT=""
	
done < ${f_NOM_ARQ_DEL}	

if [ ! -f "${f_NOM_ARQ_DEL_E1_TMP}" ]
then
	touch ${f_NOM_ARQ_DEL_E1_TMP}
	touch ${f_NOM_ARQ_DEL_E1_RET}
else
	cat "${f_NOM_ARQ_DEL_E1_RET}" >> "${f_NOM_ARQ_RET_E1}" 
fi

if [ ! -f "${f_NOM_ARQ_DEL_E2_TMP}" ]
then
	touch ${f_NOM_ARQ_DEL_E2_TMP}
	touch ${f_NOM_ARQ_DEL_E2_RET}
else
	cat "${f_NOM_ARQ_DEL_E2_RET}" >> "${f_NOM_ARQ_RET_E2}" 	
fi

if [ ! -f "${f_NOM_ARQ_DEL_E3_TMP}" ]
then
	touch ${f_NOM_ARQ_DEL_E3_TMP}
	touch ${f_NOM_ARQ_DEL_E3_RET}
else
	cat "${f_NOM_ARQ_DEL_E3_RET}" >> "${f_NOM_ARQ_RET_E3}" 		
fi

exit 0
