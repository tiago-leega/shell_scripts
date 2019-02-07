#!/bin/sh

####################################################################################################
#  Nome do Arquivo   : SPROCE_CONVIVENCIA_REMOVE_BIN.sh                                            #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 01/03/2018                                                                  #
#  Descricao         : VALIDAR E RENOMEAR O ARQUIVO DAS CREDENCIADORAS QUE ESTAO EM RELEASE 2      #
#                       OU RELEASE 4															   #	
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

v_DIRETORIO=/etlsys/pceproce/processadora/credenciadora/cadastro/bins/retorno
v_DIR_TGT=/etlsys/pceproce/infa_shared_2/TgtFiles/AO_0056_CONVIVENCIA_REMOVE_BIN_LOG.txt
v_CRDE=""

#v_DIRETORIO=/pceproce/HM/credenciadora/cadastro/bins/retorno
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

#################################################
# INICIO DO PROCESSAMENTO DAS CREDENCIADORAS R2 #
#################################################

######################
# CREDENCIADORA 8364 #
######################

v_CRDE=8364

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R2 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_8364_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_8364_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"

if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_8364_R2}" ]
	then
	FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_8364_R2} "
	FNC_Log "ALERTA: ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} "	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}" ]
		then
			FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_8364_R4} "
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_8364_R4} "
			rm ${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_8364_R4} REMOVIDO COM SUCESSO"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA 8364"
		
		fi
	mv ${v_DIRETORIO}/${v_NOME_ARQ_8364_R2} ${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}
	FNC_Log "ALERTA: ARQUIVO R2: ${v_NOME_ARQ_8364_R2} RENOMEADO PARA R4: ${v_NOME_ARQ_8364_R4} "
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R2                           -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi

#################################################
# INICIO DO PROCESSAMENTO DAS CREDENCIADORAS R4 #
#################################################

######################
# CREDENCIADORA 5107 #
######################
v_CRDE=5107

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5107_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no0 formato R2
v_NOME_ARQ_5107_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5107_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5107_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5107_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5107_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5107_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5107_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5107_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi

######################
# CREDENCIADORA 5160 #
######################
v_CRDE=5160

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5160_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5160_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5160_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5160_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5160_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5160_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5160_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5160_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5160_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi

######################
# CREDENCIADORA 5120 #
######################
v_CRDE=5120

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5120_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5120_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5120_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5120_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5120_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5120_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5120_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5120_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5120_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi


######################
# CREDENCIADORA 5190 #
######################
v_CRDE=5190

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5190_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5190_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5190_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5190_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5190_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5190_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5190_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5190_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5190_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi

######################
# CREDENCIADORA 5140 #
######################
v_CRDE=5140

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5140_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5140_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5140_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5140_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5140_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5140_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5140_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5140_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5140_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi


######################
# CREDENCIADORA FAKE #
######################
v_CRDE=0082

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_0082_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_0082_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0082_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0082_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0082_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0082_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_0082_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_0082_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_0082_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi


######################
# CREDENCIADORA FAKE #
######################
v_CRDE=0025

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_0025_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_0025_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0025_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0025_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0025_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0025_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_0025_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_0025_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_0025_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi


######################
# CREDENCIADORA FAKE #
######################
v_CRDE=0099

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_0099_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_0099_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0099_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0099_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0099_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0099_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_0099_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_0099_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_0099_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi

######################
# CREDENCIADORA FAKE #
######################
v_CRDE=0098

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_0098_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_0098_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0098_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0098_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_0098_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_0098_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_0098_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_0098_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_0098_R2} REMOVIDO COM SUCESSO"
			FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
			FNC_Log "---------------------------------------------------------------"
		else
		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"
		FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
		FNC_Log "---------------------------------------------------------------"
		fi
else
	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}       -----"
	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R4 - CRDE ${v_CRDE}               -----"
	FNC_Log "---------------------------------------------------------------"
	FNC_Log "#"
fi
