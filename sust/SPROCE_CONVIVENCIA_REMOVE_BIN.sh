
me do Arquivo   : SPROCE_CONVIVENCIA_REMOVE_BIN.sh                                            #
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
v_DIR_TGT=/etlsys/pceproce/infa_shared/TgtFiles/AO_0056_CONVIVENCIA_REMOVE_BIN_LOG.txt
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

#v_CRDE=8364

#FNC_Log "---------------------------------------------------------------"
#FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R2 - CRDE ${v_CRDE} --------"
#FNC_Log "---------------------------------------------------------------"
#
##Define nome do arquivo da credenciadora no formato R2
#v_NOME_ARQ_8364_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt
#
##Define nome do arquivo da credenciadora no formato R4
#v_NOME_ARQ_8364_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt
#
#FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
#
#if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_8364_R2}" ]
#	then
#	FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_8364_R2} "
#	FNC_Log "ALERTA: ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} "	
#		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}" ]
#		then
#			FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_8364_R4} "
#			FNC_Log "ALERTA: REMOVENDO ARQUIVO R4 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_8364_R4} "
#			rm ${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}
#			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_8364_R4} REMOVIDO COM SUCESSO"
#		else
#		FNC_Log "ALERTA: NAO EXISTE ARQUIVO R4 DA CREDENCIADORA 8364"
#		
#		fi
#	mv ${v_DIRETORIO}/${v_NOME_ARQ_8364_R2} ${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}
#	FNC_Log "ALERTA: ARQUIVO R2: ${v_NOME_ARQ_8364_R2} RENOMEADO PARA R4: ${v_NOME_ARQ_8364_R4} "
#else
#	FNC_Log "ALERTA: NAO EXISTE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}       -----"
#	FNC_Log "ALERTA: FIM DO PROCESSAMENTO R2                           -----"
#	FNC_Log "---------------------------------------------------------------"
#	FNC_Log "#"
#fi






#################################################
# INICIO DO PROCESSAMENTO DAS CREDENCIADORAS R4 #
#################################################

######################
# CREDENCIADORA 8364 #
######################

v_CRDE=8364

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_8364_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no0 formato R2
v_NOME_ARQ_8364_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_8364_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_8364_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_8364_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_8364_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_8364_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_8364_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_8364_R2} REMOVIDO COM SUCESSO"
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
	FNC_Log "---------------------R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5150_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5150_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5150_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5150_R2} REMOVIDO COM SUCESSO"
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
# CREDENCIADORA 5170 #
######################
v_CRDE=5170

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5170_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5170_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5170_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5170_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5170_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5170_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5170_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5170_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5170_R2} REMOVIDO COM SUCESSO"
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
# CREDENCIADORA 5180 #
######################
v_CRDE=5180

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5180_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5180_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5180_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5180_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5180_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5180_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5180_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5180_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5180_R2} REMOVIDO COM SUCESSO"
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
# CREDENCIADORA 5390 #
######################
v_CRDE=5390

FNC_Log "---------------------------------------------------------------"
FNC_Log "------- ALERTA: INICIO DO PROCESSAMENTO R4 - CRDE ${v_CRDE} --------"
FNC_Log "---------------------------------------------------------------"

#Define nome do arquivo da credenciadora no formato R4
v_NOME_ARQ_5390_R4=BIN_TX_007${v_CRDE}_${DATADIA}.txt

#Define nome do arquivo da credenciadora no formato R2
v_NOME_ARQ_5390_R2=BIN_TX_007${v_CRDE}_${DATADIA}_R2.txt

FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO DA CREDENCIADORA ${v_CRDE}"
if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5390_R4}" ]
	then
		FNC_Log "ALERTA: ARQUIVO R4 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5390_R4}"
		FNC_Log "ALERTA: VERIFICANDO EXISTENCIA DE ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}"	
		if [ -f "${v_DIRETORIO}/${v_NOME_ARQ_5390_R2}" ]
			then
			FNC_Log "ALERTA: ARQUIVO R2 DA CREDENCIADORA ${v_CRDE} ENCONTRADO: ${v_NOME_ARQ_5390_R2}"
			FNC_Log "ALERTA: REMOVENDO ARQUIVO R2 DA CREDENCIADORA ${v_CRDE}: ${v_NOME_ARQ_5390_R2}"
			rm ${v_DIRETORIO}/${v_NOME_ARQ_5390_R2}
			FNC_Log "ALERTA: ARQUIVO ${v_NOME_ARQ_5390_R2} REMOVIDO COM SUCESSO"
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

