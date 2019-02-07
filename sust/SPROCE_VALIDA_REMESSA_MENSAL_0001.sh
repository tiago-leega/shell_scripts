#!/bin/bash
set -x

####################################################################################################
#  Nome do Arquivo   : SPROCE_VALIDA_REMESSA_MENSAL_0001.sh                                        #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 10/08/2016                                                                  #
#  Descricao         : Realiza a validacao da remesa/header/trailer do arquivo                     #
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Codigo da Bandeira                                           #
#                      Parametro 2 -> Codigo da Credenciadora                                      #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
# EYVF06	  | 24/08/2016 | Criacao                                                           #
# CARLOS GABRIEL  | 16/09/2016 | ACRESCENTADO _YYYYmmDD-HHMMSS NA VARI�VEL f_NOM_ARQ_RET           #
# CARLOS GABRIEL  | 16/09/2016 | EXCLUIR LOG COM MAIS DE 7 DIAS                                    #
####################################################################################################

#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################

v_NOM_DIR_FILE_SRC=${3}
v_NOM_DIR_FILE_RET=${4}
v_NOM_DIR_FILE_PROC=${5}
v_NOM_DIR_RAIZ=${6}
v_NOM_DIR_FILE_TGT=${v_NOM_DIR_RAIZ}"/TgtFiles/"
v_DT_EXEC=`echo $( date +%Y%m%d-%H%M%S )`
v_DT=`echo $( date +%d%m%y )`
v_DIAS_RETENCAO='7'

#########################################
# Parametros Recebidos                  #
#########################################
p_CD_BANDEIRA=${1}
p_CD_CREDENCIADORA=${2}

##########################################################
# Declaracao de Arquivos (Source/Target/FileWatcher/Log) #
##########################################################
#Definicao do nome do arquivo Origem
f_NOM_ARQ_SRC=${v_NOM_DIR_FILE_SRC}"BAT_CAD_CNPJ_CPF_TX_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_*.[Tt][Xx][Tt]"

#Definicao do nome do arquivo Log
f_NOM_ARQ_LOG=${v_NOM_DIR_FILE_TGT}"AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_"${v_DT_EXEC}"_LOG.txt"

#Definicao do nome do arquivo de Retorno
f_NOM_ARQ_RET=${v_NOM_DIR_FILE_RET}"BAT_CAD_CNPJ_CPF_RX_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}_${v_DT}".txt"

#Definicao do nome do arquivo que contem somente o Header
f_NOM_ARQ_HEADER=${v_NOM_DIR_FILE_TGT}"AB_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E0.txt"

#Definicao do nome do arquivo que contem somente o Trailer
f_NOM_ARQ_TRAILER=${v_NOM_DIR_FILE_TGT}"AB_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E9.txt"

#Definicao do nome dos FileWatcher
v_NOM_ARQ_VALIDO=${v_NOM_DIR_FILE_TGT}"AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_VALIDO"
v_NOM_ARQ_INVALIDO=${v_NOM_DIR_FILE_TGT}"AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_INVALIDO"

#Arquivo de apoio com informacao da Data do Processamento atual
f_NOM_ARQ_EXT_0025=${v_NOM_DIR_FILE_TGT}"AOPROPRC002501_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"

#Arquivo de apoio com informacoes de Bandeira, Credenciadora e Remessa
f_NOM_ARQ_EXT_0026=${v_NOM_DIR_FILE_TGT}"AOPROPRC002601_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"


##############################################
# Remove arquivos gerados na ultima execucao #
##############################################
rm -f ${f_NOM_ARQ_RET}
rm -f ${f_NOM_ARQ_HEADER}
rm -f ${f_NOM_ARQ_TRAILER}
rm -f ${v_NOM_ARQ_VALIDO}
rm -f ${v_NOM_ARQ_INVALIDO}

##############################################
# Remove logs antigos                        #
##############################################
find ${v_NOM_DIR_FILE_TGT}AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}*LOG.txt -mtime +${v_DIAS_RETENCAO} -exec rm -f {} \;

#########################################
# Declaracao de Variaveis               #
#########################################
v_TP_STATUS_PROC_ARQ=0
v_NU_OCORRENCIA_HEADER=""
v_NU_OCORRENCIA_TRAILER=""

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

exit $v_ERR_CODE
}

#########################################
# Funcao de geracao de arquivo de log   #
#########################################
FNC_Log()
{
        echo $( date +%d/%m/%Y-%H:%M:%S ) "${1}" >> $f_NOM_ARQ_LOG
}

#############################################
# Funcao de geracao de arquivo de retorno   #
#############################################
FNC_Arq_Retorno()
{
v_TP_REGISTRO_RET="R0"
p_CD_BANDEIRA_RET=$p_CD_BANDEIRA
v_CD_CREDENCIADORA_RET=$vf_CD_CRDE
v_CD_IDENT_ENVIO_RET="2"
v_NU_REMESSA_RET=$3
v_DT_ARQUIVO_RET=$(date "+%Y%m%d")
v_STATUS_PROC_RET=$1
v_NUM_REG_INVALID_RET=$2
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

        echo "${v_TP_REGISTRO_RET}${p_CD_BANDEIRA_RET}${v_CD_CREDENCIADORA_RET}${v_CD_IDENT_ENVIO_RET}${v_NU_REMESSA_RET}${v_DT_ARQUIVO_RET}${v_STATUS_PROC_RET}${v_NUM_REG_INVALID_RET}${v_QT_REG_E1_OK_}${v_QT_REG_E1_DIF}${v_QT_REG_E1_CRD}${v_QT_REG_E1_BAN}${v_QT_REG_E2_OK_}${v_QT_REG_E2_DIF}${v_QT_REG_E2_CRD}${v_QT_REG_E2_BAN}${v_QT_REG_E3_OK_}${v_QT_REG_E3_DIF}${v_QT_REG_E3_CRD}${v_QT_REG_E3_BAN}" >> ${f_NOM_ARQ_RET}
}

#############################################
# Move o arquivo de origem para processado  #
#############################################
FNC_Move_ArqFinal_Processado()
{
	v_NOM_ARQ=`ls ${1} | xargs -n 1 basename`
	mv ${v_NOM_DIR_FILE_SRC}${v_NOM_ARQ} ${v_NOM_DIR_FILE_PROC}${v_NOM_ARQ}
	FNC_Log "Arquivo "${v_NOM_ARQ}" utilizado para processado movido para diretorio de processados."
}

###########################################################
# Funcao de geracao de header para o arquivo de retorno   #
###########################################################
FNC_Gera_Header()
{
v_HEADER="$1"
v_NU_OCORRENCIA_HEADER="$2"

        if [ "${v_NU_OCORRENCIA_HEADER}" == "" ]
        then
                echo "${v_HEADER}"  >> $f_NOM_ARQ_RET
        else
                v_NU_OCORRENCIA_HEADER=`printf "%024s" "${v_NU_OCORRENCIA_HEADER}"`
                v_HEADER_SEM_OCORRENCIAS=`echo "${v_HEADER}" | cut -c1-24`
                echo "${v_HEADER_SEM_OCORRENCIAS}${v_NU_OCORRENCIA_HEADER}" >> $f_NOM_ARQ_RET
        fi
}

###########################################################
# Funcao de geracao de trailer para o arquivo de retorno  #
###########################################################
FNC_Gera_Trailer()
{
v_TRAILER=$1
v_NU_OCORRENCIA_TRAILER=$2
        if [ "${v_NU_OCORRENCIA_TRAILER}" == "" ]
        then
                echo $v_TRAILER >> $f_NOM_ARQ_RET
        else
                v_NU_OCORRENCIA_TRAILER=`printf "%024s" ${v_NU_OCORRENCIA_TRAILER}`
                v_TRAILER_SEM_OCORRENCIAS=`echo $v_TRAILER | cut -c1-23`
                echo $v_TRAILER_SEM_OCORRENCIAS${v_NU_OCORRENCIA_TRAILER} >> $f_NOM_ARQ_RET
        fi
}

###############################
# Funcao de Validacao de Data #
###############################
FNC_Valida_Data()
{
v_DT_ARQUIVO=$1
v_ANO=`echo ${v_DT_ARQUIVO} | cut -c 1-4`
v_MES=`echo ${v_DT_ARQUIVO} | cut -c 5-6`
v_DIA=`echo ${v_DT_ARQUIVO} | cut -c 7-8`
v_DIAS_MES=0

if [ ${v_MES} -le 0 -o ${v_MES} -gt 12 ];
then
    FNC_Log "FALHA : Mes '${v_MES}' invalido!"
	return 0
else
	case ${v_MES} in
		01) v_DIAS_MES=31;;
		02) v_DIAS_MES=28 ;;
		03) v_DIAS_MES=31 ;;
		04) v_DIAS_MES=30 ;;
		05) v_DIAS_MES=31 ;;
		06) v_DIAS_MES=30 ;;
		07) v_DIAS_MES=31 ;;
		08) v_DIAS_MES=31 ;;
		09) v_DIAS_MES=30 ;;
		10) v_DIAS_MES=31 ;;
		11) v_DIAS_MES=30 ;;
		12) v_DIAS_MES=31 ;;
		*) v_DIAS_MES=-1;;
	esac

	if [ ${v_MES} -eq 2 ]; # Se mes de Fevereiro, verifica se o ano e bissexto
	then
		if [ $((v_ANO % 4)) -ne 0 ] ; then
		   : 
		elif [ $((v_ANO % 400)) -eq 0 ] ; then
		   v_DIAS_MES=29
		elif [ $((v_ANO % 100)) -eq 0 ] ; then
		   : 
		else
		   v_DIAS_MES=29
		fi
	fi
	
	if [ ${v_DIA} -le 0 -o ${v_DIA} -gt ${v_DIAS_MES} ];
	then
		FNC_Log "FALHA : Dia '${v_DIA}' invalido!"
		return 0
	else
		return 1
	fi
fi
}

###########################################################
# Inicio do processo                                      #
###########################################################
FNC_Log "### ALERTA: Inicio do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

if [ "${p_CD_BANDEIRA}" == "" -o "${p_CD_CREDENCIADORA}" == "" ]
then
	FNC_Log "FALHA : Parametro Bandeira ou Credenciadora nao informados."
	FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
	
	#Gera o FileWatcher Invalido
	echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
	exit 99
fi

#Verifica quantos arquivos existem no diretorio de origem.
v_QTD_ARQ_DIR=`find ${f_NOM_ARQ_SRC} -type f | wc -l` 2>/dev/null

if [ ${v_QTD_ARQ_DIR} -gt 0 ]
then
        v_NOM_ARQ_FINAL=`ls -lt ${f_NOM_ARQ_SRC} | head -1 | awk '{print $9}'`
        FNC_Log "ALERTA: Foi(foram) encontrado(s) '${v_QTD_ARQ_DIR}' arquivo(s) no Diretorio: '${f_NOM_ARQ_SRC}'"
		FNC_Log "ALERTA: Arquivo origem utilizado '${v_NOM_ARQ_FINAL}'"
else
		#Gera o FileWatcher Invalido
		echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
		
		v_TP_STATUS_PROC_ARQ=3
		v_NU_REG_SRC=00000
		FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${v_NU_REG_SRC} ${vf_NU_RMSA}
		
		FNC_Log "FALHA : Nao foram encontrados arquivos no Diretorio: '${f_NOM_ARQ_SRC}'"
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
		
		exit 99
fi

#Verifica se primeira linha e do tipo E0
v_FIRST_LINE=`head -1 ${v_NOM_ARQ_FINAL}`
v_TP_REGISTRO=`echo $v_FIRST_LINE | cut -c1-2`
v_NU_REG_SRC=00001

if [ "$v_TP_REGISTRO" != "E0" ]
then
        v_TP_STATUS_PROC_ARQ=3
        FNC_Log "FALHA : Primeira linha do registro nao e do tipo E0!"
        FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${v_NU_REG_SRC} ${vf_NU_RMSA}
		FNC_Move_ArqFinal_Processado ${v_NOM_ARQ_FINAL}
		
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

		#Gera o FileWatcher Invalido
		echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
		exit 99
else
        FNC_Log "ALERTA: Validacao de primeira linha do registro com tipo igual E0 realizada com sucesso!"
fi

#Verifica se a ultima linha e do tipo E9
v_LAST_LINE=`tail -1 ${v_NOM_ARQ_FINAL}`
v_NU_REG_SRC_T=`wc -l ${v_NOM_ARQ_FINAL} | awk '{print $1}'`
v_TP_REGISTRO=`echo $v_LAST_LINE | cut -c1-2`

if [ "$v_TP_REGISTRO" != "E9" ]
then
        v_TP_STATUS_PROC_ARQ=3
        FNC_Log "FALHA : Ultima linha do registro nao e do tipo E9!"
        v_NU_REG_SRC=`printf "%05s" ${v_NU_REG_SRC}`
        FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${v_NU_REG_SRC_T} ${vf_NU_RMSA}
		FNC_Move_ArqFinal_Processado ${v_NOM_ARQ_FINAL}
		
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

		#Gera o FileWatcher Invalido
		echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
		exit 99
else
        FNC_Log "ALERTA: Validacao da ultima linha do registro com tipo igual E9 realizada com sucesso!"
fi

#verifica se tipo de registro diferente de E0, E1, E2, E3, E9
v_QT_REGISTRO=`cat ${v_NOM_ARQ_FINAL} | cut -c1-2 | uniq | wc -l`
v_TP_REGISTRO_LIN=`cat ${v_NOM_ARQ_FINAL} | cut -c1-2 | uniq`
v_NU_CONTADOR=1
v_TP_REGISTRO_ANTER=-1

while [ $v_NU_CONTADOR -le $v_QT_REGISTRO ]
do
        v_TP_REGISTRO=`echo $v_TP_REGISTRO_LIN | cut -d' ' -f$v_NU_CONTADOR`
        v_TP_REGISTRO_ATUAL=`echo $v_TP_REGISTRO | cut -d'E' -f2`

        if [ "$v_TP_REGISTRO" != "E0" -a "$v_TP_REGISTRO" != "E1" -a "$v_TP_REGISTRO" != "E2" -a "$v_TP_REGISTRO" != "E3" -a "$v_TP_REGISTRO" != "E9" ]
        then
                v_TP_STATUS_PROC_ARQ=3
                FNC_Log "FALHA : Tipo de registro informado '$v_TP_REGISTRO' fora do domino esperado!"
                if [ "$v_TP_REGISTRO" == "" ]
                then
                        v_NU_REG_SRC=`cut -c1-2 ${v_NOM_ARQ_FINAL} | fgrep -nr '  ' | cut -d':' -f2`
                else
                        v_NU_REG_SRC=`cut -c1-2 ${v_NOM_ARQ_FINAL} | fgrep -nr ${v_TP_REGISTRO} | cut -d':' -f2`
                fi
                v_NU_REG_SRC=`printf "%05s" ${v_NU_REG_SRC}`
                FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${v_NU_REG_SRC} ${vf_NU_RMSA}
				FNC_Move_ArqFinal_Processado ${v_NOM_ARQ_FINAL}
				
				FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
				
				#Gera o FileWatcher Invalido
				echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
                exit 99
        else
                #verifica se os tipo de registros estão fora de ordem
                if [ ${v_TP_REGISTRO_ATUAL} -gt ${v_TP_REGISTRO_ANTER} ]
                then
                        v_TP_REGISTRO_ANTER=${v_TP_REGISTRO_ATUAL}
                        v_NU_CONTADOR=`expr ${v_NU_CONTADOR} + 1`
                else
                        v_TP_STATUS_PROC_ARQ=3
                        FNC_Log "FALHA : Encontrado tipo de registro fora de ordem!"
                        v_NU_REG_SRC=`cut -c1-2 ${v_NOM_ARQ_FINAL} | fgrep -nr ${v_TP_REGISTRO} | cut -d':' -f2 | awk '$1!=p+1{print $1}{p=$1}'`
						#Subtrai um para informar a linha que saiu da ordem (ja que a comparacao e entre atual e anterior)
                        v_NU_REG_SRC=`expr ${v_NU_REG_SRC} - 1`
                        v_NU_REG_SRC=`printf "%05s" ${v_NU_REG_SRC}`
                        FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${v_NU_REG_SRC} ${vf_NU_RMSA}
						FNC_Move_ArqFinal_Processado ${v_NOM_ARQ_FINAL}
						
						FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
						
						#Gera o FileWatcher Invalido
						echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
                        exit 99
                fi
        fi
done
FNC_Log "ALERTA: Validacao de tipo de registro em todos os registro realizado com sucesso!"
FNC_Log "ALERTA: Validacao de tipo de registro fora de ordem realizado com sucesso!"

#Validacao dos atributos do Header
v_FIRST_LINE=`head -1 "${v_NOM_ARQ_FINAL}"`
v_CD_BANDEIRA=`echo $v_FIRST_LINE | cut -c 3-5`
v_CD_CREDENCIADORA_ARQ=`echo $v_FIRST_LINE | cut -c 6-9`
v_CD_ENVIO_ARQ=`echo $v_FIRST_LINE | cut -c 10-10`
v_NU_REMESSA_ARQ=`echo $v_FIRST_LINE | cut -c 11-15`
v_DT_ARQUIVO=`printf "${v_FIRST_LINE}" | cut -c 16-23`
v_TP_STATUS=`echo $v_FIRST_LINE | cut -c 24-24`
v_NU_REG_SRC=00000
v_TP_STATUS_PROC_ARQ=2

if [ "$v_TP_STATUS" != "0" ]
then
        v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0045"
        FNC_Log "FALHA : Status de Geracao de Arquivo '$v_TP_STATUS' invalido!"
else
        FNC_Log "ALERTA: Validacao de Status de Geracao de Arquivo realizado com sucesso!"
fi

#Valida Codigo da Bandeira
if [ "$v_CD_BANDEIRA" != "$vf_CD_BNDR" ]
then
        v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0051"
        FNC_Log "FALHA : Codigo da bandeira '$v_CD_BANDEIRA' invalido!"
else
        FNC_Log "ALERTA: Validacao de Codigo da Bandeira realizado com sucesso!"
fi

#Valida Codigo da Credenciadora
if [ "$v_CD_CREDENCIADORA_ARQ" != "$vf_CD_CRDE" ]
then
        v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0005"
        FNC_Log "FALHA : Codigo da Credenciadora '$v_CD_CREDENCIADORA_ARQ' nao cadastrado na base!"
else
        FNC_Log "ALERTA: Validacao do Codigo da Credenciadora realizado com sucesso!"
fi

#Valida Codigo de Identificacao do Envio do Arquivo (Origem/Destino)
if [ "$v_CD_ENVIO_ARQ" != "1" -a "$v_CD_ENVIO_ARQ" != "2" ]
then
       v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0039"
       FNC_Log "FALHA : Codigo da Identificacao do Envio do Arquivo= '$v_CD_ENVIO_ARQ' invalido!"
else
       FNC_Log "ALERTA: Validacao do Codigo da Identificadao do Envio do Arquivo realizado com sucesso!"
fi

#Valida Numero da Remessa do Arquivo Enviado
if [ "${v_NU_REMESSA_ARQ}" != "${vf_NU_RMSA}" ]
then
       v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0006"
       FNC_Log "FALHA : Numero da Remessa do Arquivo Enviado '${v_NU_REMESSA_ARQ}' nao cadastrado na base!"
else
       FNC_Log "ALERTA: Validacao do Numero da Remessa do Arquivo Enviado realizado com sucesso!"
fi

#Valida Data de Geracao do Arquivo
v_NUM=`printf ${v_DT_ARQUIVO} | grep "^[1234567890]*$"`
if [ "${v_NUM}" == "" ]
then
	v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0007"
	FNC_Log "FALHA : Data do arquivo nao numerica. Registro rejeitado!"	
else
	FNC_Valida_Data ${v_DT_ARQUIVO}
	v_Retorno_Valida_Data=$?
	if [ ${v_Retorno_Valida_Data} -eq 0 ]
	then
		v_NU_OCORRENCIA_HEADER=${v_NU_OCORRENCIA_HEADER}"0007"
		FNC_Log "FALHA : Data do arquivo invalida. Registro rejeitado!"	
	else
		FNC_Log "ALERTA: Validacao da Data de Geracao do Arquivo realizada com sucesso!"
	fi
fi

#Valida Trailer
v_LAST_LINE=`tail -1 ${v_NOM_ARQ_FINAL}`
v_TP_REGISTRO=`echo $v_LAST_LINE | cut -c1-2`
v_QT_REGISTRO_E1_TRAILER=`echo $v_LAST_LINE | cut -c 3-9`
v_QT_REGISTRO_E2_TRAILER=`echo $v_LAST_LINE | cut -c 10-16`
v_QT_REGISTRO_E3_TRAILER=`echo $v_LAST_LINE | cut -c 17-23`
v_TP_STATUS_PROC_ARQ=2

#Valida se a quantidade de registros do tipo E1 no arquivo é igual ao informado no trailer
v_QT_REGISTRO_E1_ARQ=`cat ${v_NOM_ARQ_FINAL} | cut -c 1-2 | egrep 'E1' | wc -l`
v_QT_REGISTRO_E1_ARQ=`printf "%07s" $v_QT_REGISTRO_E1_ARQ`
if [ "$v_QT_REGISTRO_E1_TRAILER" != "$v_QT_REGISTRO_E1_ARQ" ]
then
        v_NU_OCORRENCIA_TRAILER=${v_NU_OCORRENCIA_TRAILER}"0034"
        FNC_Log "FALHA : Quantidade de registros informado para o tipo E1 diferente!"
else
        FNC_Log "ALERTA: Validacao do Numero do Registro informado no Trailer para o tipo E1 realizado com sucesso!"
fi

#Valida se a quantidade de registros do tipo E2 no arquivo é igual ao informado no trailer
v_QT_REGISTRO_E2_ARQ=`cat ${v_NOM_ARQ_FINAL} | cut -c 1-2 | egrep 'E2' | wc -l`
v_QT_REGISTRO_E2_ARQ=`printf "%07s" $v_QT_REGISTRO_E2_ARQ`
if [ "$v_QT_REGISTRO_E2_TRAILER" != "$v_QT_REGISTRO_E2_ARQ" ]
then
        v_NU_OCORRENCIA_TRAILER=${v_NU_OCORRENCIA_TRAILER}"0035"
        FNC_Log "FALHA : Quantidade de registros informado para o tipo E2 diferente!"
else
        FNC_Log "ALERTA: Validacao do Numero do Registro informado no Trailer para o tipo E2 realizado com sucesso!"
fi

#Valida se a quantidade de registros do tipo E3 no arquivo é igual ao informado no trailer
v_QT_REGISTRO_E3_ARQ=`cat ${v_NOM_ARQ_FINAL} | cut -c 1-2 | egrep 'E3' | wc -l`
v_QT_REGISTRO_E3_ARQ=`printf "%07s" $v_QT_REGISTRO_E3_ARQ`
if [ "$v_QT_REGISTRO_E3_TRAILER" != "$v_QT_REGISTRO_E3_ARQ" ]
then
        v_NU_OCORRENCIA_TRAILER=${v_NU_OCORRENCIA_TRAILER}"0036"
        FNC_Log "FALHA : Quantidade de registros informado para o tipo E3 diferente!"
else
        FNC_Log "ALERTA: Validacao do Numero do Registro informado no Trailer para o tipo E3 realizado com sucesso!"
fi

v_FIRST_LINE=`echo "${v_FIRST_LINE}" | cut -c 1-9`"2"`echo "${v_FIRST_LINE}" | cut -c 11-48`

if [ "${v_NU_OCORRENCIA_HEADER}" != "" -o "${v_NU_OCORRENCIA_TRAILER}" != "" ]
then
        v_TP_STATUS_PROC_ARQ=2
        FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${v_NU_REG_SRC} ${vf_NU_RMSA}
        FNC_Gera_Header "${v_FIRST_LINE}" "${v_NU_OCORRENCIA_HEADER}"
        FNC_Gera_Trailer $v_LAST_LINE ${v_NU_OCORRENCIA_TRAILER}
		FNC_Move_ArqFinal_Processado ${v_NOM_ARQ_FINAL}
		
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
		
		#Gera o FileWatcher Invalido
		echo "REMESSA INVALIDA" >> ${v_NOM_ARQ_INVALIDO}
        exit 99
else
		#Caso nao seja encontrado problemas de Status de processamento 2 e 3, sera gerado separadamente arquivo de header e trailer para ser consumido
		#no job wf_0019_EPROPRCEXT_RETORNO_01
			
		#Gera o arquivo com Header
		echo ${v_FIRST_LINE}"000000001" >> ${f_NOM_ARQ_HEADER}
		
		#Gera o arquivo com Trailer
		v_NU_REG_SRC_T=`printf "%09s" ${v_NU_REG_SRC_T}`
		echo `echo ${v_LAST_LINE} | cut -c 1-47`"${v_NU_REG_SRC_T}" >> ${f_NOM_ARQ_TRAILER}
		
		#Gera o FileWatcher Valido
		echo "${v_NOM_ARQ_FINAL}" >> ${v_NOM_ARQ_VALIDO}
		
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_REMESSA_MENSAL_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
fi

exit 0
