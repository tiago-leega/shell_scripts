#!/bin/sh

####################################################################################################
#  Nome do Arquivo   : SPROCE_CONVIVENCIA_REMOVE_REMUNERACAO.sh                                    #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 01/03/2018                                                                  #
#  Descricao         : Realiza a remoção de arquivos R4 para a credenciadora 1606 e dos            #
#					   arquivos R2 da credenciadora 5390 quando existirem                          #
#                                                                                                  #
#  dados de Entrada  : N/A                                                                         #
#                                        														   #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
#                                                                                                  #
####################################################################################################

set -x

###################################
# DECLARACAO DE VARIAVEIS GLOBAIS #
###################################

DATADIA=`date +%y%m%d`

#PARAM DE DEV
v_DIRETORIO=/etlsys/pceproce/processadora/credenciadora/cadastro/grp_remuneracao/retorno
v_DIR_TGT=/etlsys/pceproce/infa_shared_2/TgtFiles/AO_0056_CONVIVENCIA_REMOVE_REMUNERACAO_LOG.txt

#PARAM DE HOMOL
#v_DIRETORIO=/pceproce/HM/credenciadora/cadastro/grp_remuneracao/retorno
#v_DIR_TGT=/pceproce/HM/infa_shared/TgtFiles

FNC_Log(){

	v_MSG_LOG=${1}	
	echo "${v_MSG_LOG}" >> ${v_DIR_TGT}
}

##############################
# LIMPA ARQUIVO DE LOG       #
##############################

if [ -f "${v_DIR_TGT}" ]
	then
	rm "${v_DIR_TGT}"
fi

##############################
# INICIO DO PROCESSAMENTO R2 #
##############################

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R2 - CRDE 1606 --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora 1606 formato R2
v_NOME_ARQ_1606_R2=FEE_GRP_ESPECIAL_TX_0071606_${DATADIA}_R2.txt

#Define nome do arquivo da credenciadora 1606 formato R4
v_NOME_ARQ_1606_R4=FEE_GRP_ESPECIAL_TX_0071606_${DATADIA}.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA 1606"

if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_1606_R2}" ]
	then
	FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA 1606 ENCONTRADO: ${v_NOME_ARQ_1606_R2} "
	FNC_Log "ALERTA: ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R4 DA CREDENCIADORA 1606 "	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_1606_R4}" ]
		then
			FNC_Log "ALERTA: ARQUIVO R4 da CREDENCIADORA 1606 ENCONTRADO: ${v_NOME_ARQ_1606_R4} "
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R4 DA CREDENCIADORA 1606: ${v_NOME_ARQ_1606_R4} "
			rm ${v_DIRETORIO}/${v_NOME_ARQ_1606_R4}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_1606_R4} REMOVIDO COM SUCESSO###"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA 1606 ###"
		
		fi
	mv ${v_DIRETORIO}/${v_NOME_ARQ_1606_R2} ${v_DIRETORIO}/${v_NOME_ARQ_1606_R4}
	FNC_Log "ALERTA: ARQUIVO R2: ${v_NOME_ARQ_1606_R2} RENOMEADO PARA R4: ${v_NOME_ARQ_1606_R4} "
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA 1606       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R2                           -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi

##############################
# INICIO DO PROCESSAMENTO R4 #
##############################

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE 5390 --------"
FNC_Log "---------------------------------------------------------------"


#Define nome do arquivo da credenciadora 5390 formato R4
v_NOME_ARQ_5390_R4=FEE_GRP_ESPECIAL_TX_0071606_${DATADIA}.txt

#Define nome do arquivo da credenciadora 5390 formato R2
v_NOME_ARQ_5390_R2=FEE_GRP_ESPECIAL_TX_0071606__${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA 5390"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5390_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA 5390 ENCONTRADO: ${v_NOME_ARQ_5390_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA 5390"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5390_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA 5390 ENCONTRADO: ${v_NOME_ARQ_5390_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA 5390: ${v_NOME_ARQ_5390_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5390_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5390_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE 5390               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA 5390"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE 5390               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA 5390       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE 5390               -----"
	FNC_Log "---------------------------------------------------------------"
fi
