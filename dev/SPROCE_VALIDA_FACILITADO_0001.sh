#!/bin/bash
set -x

####################################################################################################
#  Nome do Arquivo   : SPROCE_VALIDA_FACILITADO_0001.sh                                            #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 28/12/2016                                                                  #
#  Descricao         : Realiza a validacao do arquivo de Facilitados enviado pela Bandeira         #
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Codigo da Bandeira                                           #
#                      Parametro 2 -> Diretorio de RECEBIDOS                                       #
#                      Parametro 3 -> Diretorio de RETORNO                                         #
#                      Parametro 4 -> Diretorio de PROCESSADOS                                     #
#                      Parametro 5 -> Diretorio TGTFILES                                           #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
#                                                                                                  #
####################################################################################################


#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################

v_DT_EXEC=`echo $( date +%Y%m%d-%H%M%S )`
v_DT=`echo $( date +%d%m%y )`
v_DIAS_RETENCAO='7'

#########################################
# Parametros Recebidos                  #
#########################################
p_CD_BANDEIRA=${1}
v_NOM_DIR_FILE_SRC=${2}
v_NOM_DIR_FILE_RET=${3}
v_NOM_DIR_FILE_PROC=${4}
v_NOM_DIR_RAIZ=${5}
v_NOM_DIR_FILE_TGT=${v_NOM_DIR_RAIZ}"/TgtFiles/"

##########################################################
# Declaracao de Arquivos (Source/Target/FileWatcher/Log) #
##########################################################
#Definicao do nome do arquivo Origem
f_NOM_ARQ_SRC=${v_NOM_DIR_FILE_SRC}"CAD_MANUT_FCDR_FCLT_TX_"${p_CD_BANDEIRA}"_*.[Tt][Xx][Tt]"

#Definicao do nome do arquivo Log
f_NOM_ARQ_LOG=${v_NOM_DIR_FILE_TGT}"AO_0228_EPROPRCEXT_VALIDA_FACILITADO_01_"${p_CD_BANDEIRA}"_"${v_DT_EXEC}"_LOG.txt"

#Definicao do nome do arquivo Intermediario
f_NOM_ARQ_DETALHE=${v_NOM_DIR_FILE_TGT}"AB_0228_EPROPRCEXT_DETALHE_FACILITADO_01_"${p_CD_BANDEIRA}".txt"

##############################################
# Remove logs antigos                        #
##############################################
find ${v_NOM_DIR_FILE_TGT}AO_0228_EPROPRCEXT_VALIDA_FACILITADO_01_01_${p_CD_BANDEIRA}*LOG.txt -mtime +${v_DIAS_RETENCAO} -exec rm -f {} \;

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
# Move o arquivo de origem para processado  #
#############################################
FNC_Move_ArqFinal_Processado()
{
	v_NOM_ARQ=`ls ${1} | xargs -n 1 basename`
	
	if [ -e ${v_NOM_DIR_FILE_SRC}${v_NOM_ARQ} ]
	   then
	
	   mv ${v_NOM_DIR_FILE_SRC}${v_NOM_ARQ} ${v_NOM_DIR_FILE_PROC}${v_NOM_ARQ}
	   FNC_Log "Arquivo "${v_NOM_ARQ}" utilizado para processado movido para diretorio de processados."
	   
	   else
	   
	   FNC_Log "Arquivo nao disponivel para processamento."
	   
	fi
}
#Funcao criada para verificar se existe o arquivo no diretorio de Targets para entao remove-lo
FNC_Verifica_Target(){
	if [ -e ${f_NOM_ARQ_DETALHE} ]
		then 
		rm -f ${f_NOM_ARQ_DETALHE}
		FNC_Log "### ALERTA: Arquivo removido -> ${f_NOM_ARQ_DETALHE}"
	fi
}		

###########################################################
# Inicio do processo                                      #
###########################################################

FNC_Log "### ALERTA: Inicio do Processo: SPROCE_VALIDA_FACILITADO_0001.sh -> Bandeira: ${p_CD_BANDEIRA} ###"
FNC_Log "### ALERTA: Separando Tipo de registro                                                         ###"

v_QTD_ARQ_DIR=`find ${f_NOM_ARQ_SRC} -type f | wc -l` 2>/dev/null

if [ ${v_QTD_ARQ_DIR} -gt 0 ]
then
        v_NOM_ARQ_FINAL=`ls -lt ${f_NOM_ARQ_SRC} | head -1 | awk '{print $9}'`
        FNC_Log "ALERTA: Foi(foram) encontrado(s) '${v_QTD_ARQ_DIR}' arquivo(s) no Diretorio: '${f_NOM_ARQ_SRC}'"
		FNC_Log "ALERTA: Arquivo origem utilizado '${v_NOM_ARQ_FINAL}'"
else

        FNC_Log "FALHA : Nao foram encontrados arquivos no Diretorio: '${f_NOM_ARQ_SRC}'"
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_FACILITADO_0001.sh -> Bandeira: ${p_CD_BANDEIRA} <- ###"
		FNC_Verifica_Target
		exit 99
fi

v_REG_HEADER=$( head -1 ${v_NOM_ARQ_FINAL} )
v_REG_TRAILER=$( tail -1 ${v_NOM_ARQ_FINAL} )

v_TP_REG_HEADER=$( echo ${v_REG_HEADER} | cut -c1-2 )
v_TP_REG_TRAILER=$( echo ${v_REG_TRAILER} | cut -c1-2 )
v_TP_REG_DETAIL=$( grep -Ev "^${v_TP_REG_HEADER}|^${v_TP_REG_TRAILER}" ${v_NOM_ARQ_FINAL} | cut -c1-2 | sort -u )

v_QTD_REG_DETAIL=$( grep -c "^01" ${v_NOM_ARQ_FINAL} )
v_QTD_REG_TOTAL=$( wc -l ${v_NOM_ARQ_FINAL} | awk '{ print $1 }' )
v_QTD_REG_TRAILER=$(echo ${v_REG_TRAILER} | cut -c3-12 | sed 's/^0*//' ) 
#v_QTD_REG_TRAILER=$(( $(echo ${v_REG_TRAILER} | cut -c3-12 ) * 1 ))


FNC_Log "### ALERTA: Verificando se existe conteudo de detalhe para seguir com o processamento          ###"

if [ ${v_QTD_REG_DETAIL} -eq 0 ]
   then
   
   FNC_Log "### ERRO: sem volume a ser processado na execuçao de hoje                                      ###"
   FNC_Log "### ALERTA: Arquivo rejeitado para processamento                                               ###"
   
   FNC_Move_ArqFinal_Processado
   FNC_Verifica_Target
   FNC_Exit 99
      
fi

FNC_Log "### ALERTA: Verificando se Tipo de registro é diferente de 00, 01, 09                          ###"

if [ "${v_TP_REG_HEADER}" != '00' -o "${v_TP_REG_DETAIL}" != '01' -o "${v_TP_REG_TRAILER}" != '09' ]
   then
   
   FNC_Log "### ERRO: Tipo registro nao está de acordo com o layout definido pela Bandeira                 ###"
   FNC_Log "### ALERTA: Arquivo rejeitado para processamento                                               ###"
   
   FNC_Move_ArqFinal_Processado
   FNC_Verifica_Target
   FNC_Exit 99
   
fi

FNC_Log "### ALERTA: Verificando quantidade de registros de detalhe com o trailer                       ###"

if [ ${v_QTD_REG_TOTAL} != ${v_QTD_REG_TRAILER} ]
   then
   
   FNC_Log "### ERRO: Quantidade de registros de detalhe diferente do descriminado no trailer              ###"
   FNC_Log "### ALERTA: Arquivo rejeitado para processamento                                               ###"
   
   FNC_Move_ArqFinal_Processado
   FNC_Verifica_Target
   FNC_Exit 99
      
fi

grep ^"${v_TP_REG_DETAIL}" ${v_NOM_ARQ_FINAL} > ${f_NOM_ARQ_DETALHE}

exit 0
