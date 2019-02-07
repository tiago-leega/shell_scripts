#!/bin/bash
set +x

####################################################################################################
#  Nome do Arquivo   : SPROCE_VALIDA_DETALHE_MENSAL_0001.sh                                        #
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
# EYVF06	  | 24/08/2016 | Criacao                                                           #
# CARLOS GABRIEL  | 16/09/2016 | EXCLUIR LOG COM MAIS DE 7 DIAS                                    #
####################################################################################################

#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################
v_NOM_DIR_RAIZ="/etlsys/pceproce/infa_shared"
v_NOM_DIR_FILE_TGT=${v_NOM_DIR_RAIZ}"/TgtFiles/"
v_DT_EXEC=`echo $( date +%Y%m%d-%H%M%S )`
v_DIAS_RETENCAO='7'

#########################################
# Parametros Recebidos                  #
#########################################
p_CD_BANDEIRA=$1
p_CD_CREDENCIADORA=$2

##############################################
# Declaracao de Arquivos (Source/Target/Log) #
##############################################
#Definicao do nome do arquivo Origem
f_NOM_ARQ_SRC=`cat ${v_NOM_DIR_FILE_TGT}"AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}_VALIDO" 2>/dev/null` 

#Definicao do nome do arquivo Log
f_NOM_ARQ_LOG=${v_NOM_DIR_FILE_TGT}"AO_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_"${v_DT_EXEC}"_LOG.txt"

#Definicao do nome do arquivo que contem somente os registros de nivel E1
f_NOM_ARQ_E1=${v_NOM_DIR_FILE_TGT}"AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E1.txt"

#Definicao do nome do arquivo que contem somente os registros de nivel E2
f_NOM_ARQ_E2=${v_NOM_DIR_FILE_TGT}"AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E2.txt"

#Definicao do nome do arquivo que contem somente os registros de nivel E3
f_NOM_ARQ_E3=${v_NOM_DIR_FILE_TGT}"AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E3.txt"

#Definicao do nome do arquivo que contem a linha de retorno
f_NOM_ARQ_RET=${v_NOM_DIR_FILE_TGT}"AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_R0.txt"

#Arquivo de apoio com informacao da Data do Processamento atual
f_NOM_ARQ_EXT_0025=${v_NOM_DIR_FILE_TGT}"AOPROPRC002501_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"

#Arquivo de apoio com informacoes de Bandeira, Credenciadora e Remessa
f_NOM_ARQ_EXT_0026=${v_NOM_DIR_FILE_TGT}"AOPROPRC002601_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"


##############################################
# Remove arquivos gerados na ultima execucao #
##############################################
rm -f ${f_NOM_ARQ_E1}
rm -f ${f_NOM_ARQ_E2}
rm -f ${f_NOM_ARQ_E3}
rm -f ${f_NOM_ARQ_RET}

##############################################
# Remove logs antigos                        #
##############################################
find ${v_NOM_DIR_FILE_TGT}AO_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}*LOG.txt -mtime +${v_DIAS_RETENCAO} -exec rm -f {} \;

#########################################
# Declaracao de Variaveis               #
#########################################
v_TP_STATUS_PROC_ARQ=0

#Alimenta variaveis com dados dos arquivos de apoio
vf_CD_BNDR=`cat ${f_NOM_ARQ_EXT_0026} | cut -d '|' -f1`
vf_CD_CRDE=`cat ${f_NOM_ARQ_EXT_0026} | cut -d '|' -f2`
vf_NU_RMSA=`cat ${f_NOM_ARQ_EXT_0026} | cut -d '|' -f3`
vf_DT_CICLO=`cat ${f_NOM_ARQ_EXT_0025} | cut -d '|' -f1`

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
#############################################
# Funcao de geracao de arquivo de retorno   #
#############################################
FNC_Arq_Retorno()
{
v_TP_REGISTRO_RET="R0"
v_CD_BANDEIRA_RET=${p_CD_BANDEIRA}
v_CD_CREDENCIADORA_RET=${p_CD_CREDENCIADORA}
v_CD_IDENT_ENVIO_RET="2"
v_NU_REMESSA_RET="${2}"
v_DT_ARQUIVO_RET="${3}"
v_STATUS_PROC_RET="${1}"
v_NUM_REG_INVALID_RET="00000"
v_QT_REG_E1_OK_="0000000"
v_QT_REG_E1_DIF="0000000"
v_QT_REG_E1_CRD="0000000"
v_QT_REG_E1_BAN="0000000"
v_QT_REG_E2_OK_="0000000"
v_QT_REG_E2_DIF="0000000"
v_QT_REG_E2_CRD="0000000"
v_QT_REG_E2_BAN="0000000"
v_QT_REG_E3_OK_="0000000"
v_QT_REG_E3_DIF="0000000"
v_QT_REG_E3_CRD="0000000"
v_QT_REG_E3_BAN="0000000"

        echo "${v_TP_REGISTRO_RET}${v_CD_BANDEIRA_RET}${v_CD_CREDENCIADORA_RET}${v_CD_IDENT_ENVIO_RET}${v_NU_REMESSA_RET}${v_DT_ARQUIVO_RET}${v_STATUS_PROC_RET}${v_NUM_REG_INVALID_RET}${v_QT_REG_E1_OK_}${v_QT_REG_E1_DIF}${v_QT_REG_E1_CRD}${v_QT_REG_E1_BAN}${v_QT_REG_E2_OK_}${v_QT_REG_E2_DIF}${v_QT_REG_E2_CRD}${v_QT_REG_E2_BAN}${v_QT_REG_E3_OK_}${v_QT_REG_E3_DIF}${v_QT_REG_E3_CRD}${v_QT_REG_E3_BAN}" >> ${f_NOM_ARQ_RET}
}

###########################################################
# Inicio do processo                                      #
###########################################################
FNC_Log "### ALERTA: Inicio do Processo SPROCE_VALIDA_DETAHE_MENSAL_0001.sh - Parametros Recebidos -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

if [ "${p_CD_BANDEIRA}" == "" -o "${p_CD_CREDENCIADORA}" == "" ]
then
	FNC_Log "FALHA : Parametro Bandeira ou Credenciadora nao informados."
	FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_DETAHE_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
	
	FNC_Exit 99
fi

#Verifica o nome do arquivo de origem utilizado pelo processo anterior.
if [ -z "${f_NOM_ARQ_SRC}" -o "${f_NOM_ARQ_SRC}" == "" ]
then
        FNC_Log "FALHA : Nao foi encontrado FileWatcher Valido do processo anterior!"
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_DETAHE_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

		FNC_Exit 99
else
		v_NOM_ARQ_FINAL="${f_NOM_ARQ_SRC}"
		FNC_Log "ALERTA: Arquivo origem utilizado '"${v_NOM_ARQ_FINAL}"'"
fi

v_QT_REGISTRO=`cat $v_NOM_ARQ_FINAL | wc -l`
v_QT_REGISTRO=`expr $v_QT_REGISTRO - 1`

v_NU_LINHA=1
while read v_REG_FILE
do
	v_TP_REGISTRO=`echo "${v_REG_FILE}" | cut -c 1-2`
	
	if [ "${v_TP_REGISTRO}" == "E1" ]
	then		
		v_REGISTRO_E1=`echo "${v_REG_FILE}" | cut -c 1-113`
		v_NU_LINHA=`printf '%09s' "${v_NU_LINHA}"`
		
		echo "${v_REGISTRO_E1}${v_NU_LINHA}" >> $f_NOM_ARQ_E1
		
	elif [ "${v_TP_REGISTRO}" == "E2" ]
	then		
		v_REGISTRO_E2=`echo "${v_REG_FILE}" | cut -c 1-63`
		v_NU_LINHA=`printf '%09s' "${v_NU_LINHA}"`
		
		echo "${v_REGISTRO_E2}${v_NU_LINHA}" >> $f_NOM_ARQ_E2

	elif [ "$v_TP_REGISTRO" == "E3" ]
	then
		v_REGISTRO_E3=`echo "${v_REG_FILE}" | cut -c 1-119`
		v_NU_LINHA=`printf '%09s' "${v_NU_LINHA}"`		
		
		echo "${v_REGISTRO_E3}${v_NU_LINHA}" >> $f_NOM_ARQ_E3		
	fi
		
	v_NU_LINHA=`expr ${v_NU_LINHA} + 1`

done < ${v_NOM_ARQ_FINAL}

FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${vf_NU_RMSA} ${vf_DT_CICLO}

#Verifica se o arquivo foi criado e em caso negativo gera arquivo vazio.
if [ ! -f "${f_NOM_ARQ_E1}" ]
then
	touch ${f_NOM_ARQ_E1}
fi

#Verifica se o arquivo foi criado e em caso negativo gera arquivo vazio.
if [ ! -f "${f_NOM_ARQ_E2}" ]
then
	touch ${f_NOM_ARQ_E2}
fi

#Verifica se o arquivo foi criado e em caso negativo gera arquivo vazio.
if [ ! -f "${f_NOM_ARQ_E3}" ]
then
	touch ${f_NOM_ARQ_E3}
fi

FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_DETAHE_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

FNC_Exit 0
