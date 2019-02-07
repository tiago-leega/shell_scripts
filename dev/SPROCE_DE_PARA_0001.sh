#!/bin/bash
set -x

####################################################################################################
#  Nome do Arquivo   : SPROCE_VALIDA_REMESSA_0001.sh                                               #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 25/10/2017                                                                  #
#  Descricao         : Realiza Movimentação do arquivo de CAdastro Diário para configurar o De/Para#
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Codigo da Bandeira                                           #
#                      Parametro 2 -> Codigo da Credenciadora                                      #
#                      Parametro 3 -> Tipo de Arquivo                                              #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
# ADRIANA DE ASSIS	  | 25/10/2017 | Criacao                                                   #
                                                                                                   #
####################################################################################################


#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################

v_NOM_DIR_FILE_SRC_R1=${4}
v_NOM_DIR_FILE_SRC=${5}
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
p_TP_ARQUIVO=${3}

##########################################################
# Declaracao de Arquivos (Source/Target/FileWatcher/Log) #
##########################################################

#Definicao do nome do arquivo Origem
f_NOM_ARQ_SRC=${v_NOM_DIR_FILE_SRC}"CAD_MANUT_CNPJ_CPF_TX_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_*.[Tt][Xx][Tt]"

#Definicao do nome do arquivo Log
f_NOM_ARQ_LOG=${v_NOM_DIR_FILE_TGT}"DEPARA"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_"${v_DT_EXEC}"_LOG.txt"

#Definicao do nome dos FileWatcher
v_NOM_ARQ_VALIDO=${v_NOM_DIR_FILE_TGT}"TESTE_ADRI"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_VALIDO"
v_NOM_ARQ_INVALIDO=${v_NOM_DIR_FILE_TGT}"TESTE_ADRI"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_INVALIDO"



##############################################
# Remove logs antigos                        #
##############################################
find ${v_NOM_DIR_FILE_TGT}TESTE_ADRI${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}*LOG.txt -mtime +${v_DIAS_RETENCAO} -exec rm -f {} \;

#########################################
# Declaracao de Variaveis               #
#########################################
v_TP_STATUS_PROC_ARQ=0


#########################################
# Funcao de saida da rotina             #
#########################################
#FNC_Exit()
#{
#v_ERR_CODE=${1}

#exit $v_ERR_CODE
#}

#########################################
# Funcao de geracao de arquivo de log   #
#########################################
FNC_Log()
{
        echo $( date +%d/%m/%Y-%H:%M:%S ) "${1}" >> $f_NOM_ARQ_LOG
}




###########################################################
# Inicio do processo                                      #
###########################################################
FNC_Log 

#Verifica quantos arquivos existem no diretorio de origem.
v_QTD_ARQ_DIR=`find ${f_NOM_ARQ_SRC} -type f | wc -l` 2>/dev/null





if [ ${v_QTD_ARQ_DIR} -gt 0 ]
then

if [ "${p_TP_ARQUIVO}" == "R1" ]
		then
			mv ${v_NOM_DIR_FILE_SRC}$(ls -lrt ${v_NOM_DIR_FILE_SRC}| grep CAD_MANUT_CNPJ_CPF_TX_${p_CD_BANDEIRA}${p_CD_CREDENCIADORA} | tail -1 | awk '{ print $NF }') ${v_NOM_DIR_FILE_SRC_R1};
                      v_NOM_ARQ_FINAL=`ls -lt ${f_NOM_ARQ_SRC} | head -1 | awk '{print $9}'`
        FNC_Log "ALERTA: Foi(foram) encontrado(s) '${v_QTD_ARQ_DIR}' arquivo(s) no Diretorio: '${f_NOM_ARQ_SRC}'"
		FNC_Log "ALERTA: Arquivo origem utilizado '${v_NOM_ARQ_FINAL}'"
   
			
		else

			1>${v_NOM_DIR_FILE_SRC_R1}$(ls -lrt ${v_NOM_DIR_FILE_SRC}| grep CAD_MANUT_CNPJ_CPF_TX_${p_CD_BANDEIRA}${p_CD_CREDENCIADORA} | tail -1 | awk '{ print $NF }') 
			
fi
else
v_TP_STATUS_PROC_ARQ=3
		v_NU_REG_SRC=00000
FNC_Log "FALHA : Nao foram encontrados arquivos no Diretorio: '${f_NOM_ARQ_SRC}'"
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_DE_PARA0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"


fi


exit 0
