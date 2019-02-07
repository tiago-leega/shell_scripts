#!/bin/bash
set -x

####################################################################################################
#  Nome do Arquivo   : SPROCE_VALIDA_CONVIVENCIA_0001.sh                                           #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 07/02/2018                                                                  #
#  Descricao         : Verifica a existencia do arquivo de convivencia                             #
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Codigo da Bandeira                                           #
#                      Parametro 2 -> Codigo da Credenciadora                                      #
#                      Parametro 3 -> Diretorio de RECEBIDOS                                       #
#                      Parametro 4 -> Diretorio de RECEBIDOS R2                                    #
#                      Parametro 5 -> Diretorio de Target                                          #
#                      										                                       #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
#                                                                                                  #
####################################################################################################


#########################################
# Parametros Recebidos                  #
#########################################
p_CD_BANDEIRA=${1}
p_CD_CRDE=${2}
p_NOM_DIR_RECEBIDOS=${3}
p_NOM_DIR_RECEBIDOS_R2=${4}
p_NOM_DIR_TGT=${5}
#########################################
# Variaveis Gerados para Processamento #
#########################################
v_NOM_ARQ_SRC="CAD_MANUT_CNPJ_CPF_TX_"
v_NOM_DIR_TGT=${p_NOM_DIR_TGT}"/TgtFiles/"

#Monto o arquivo independente da forma do txt(Txt, txt,TXt,TXT)
NOM_ARQ_SRC_TMP=${p_NOM_DIR_RECEBIDOS}${v_NOM_ARQ_SRC}${p_CD_BANDEIRA}${p_CD_CRDE}"*.[Tt][Xx][Tt]"

#Resgata o arquivo mais recente no diretorio de recebidos
v_NOM_ARQ_REC=`ls -lt ${NOM_ARQ_SRC_TMP} | head -1 | awk '{print $9}'` 2> /dev/null

#Populo a variavel apenas com o nome do arquivo mais recente resgatado acima
v_NOME_ARQ_FINAL=`echo ${v_NOM_ARQ_REC} | cut -d"/" -f9`

#Nome do arquivo a ser gerado no target
v_NOM_ARQ="AO_0910_EPROPRCEXT_VALIDA_CONVIVENCIA_01_01_"${p_CD_BANDEIRA}${p_CD_CRDE}
	
#Verifica se o arquivo existe no diretório de RECEBIDOS
if [ -f "${v_NOM_ARQ_REC}" ]
then
	
	echo ${p_NOM_DIR_RECEBIDOS_R2}${v_NOME_ARQ_FINAL} > ${v_NOM_DIR_TGT}${v_NOM_ARQ}"_VALIDO"
	mv ${v_NOM_ARQ_REC} ${p_NOM_DIR_RECEBIDOS_R2}${v_NOME_ARQ_FINAL}
	if [ $? -ne 0 ]
	then
		exit 1
	else
		exit 0
	fi
else
	echo "### ALERTA: Nenhum arquivo encontrado no diretorio '${NOM_ARQ_SRC_TMP}'" >> ${v_NOM_DIR_TGT}${v_NOM_ARQ}"_INVALIDO"
	exit 99
fi

