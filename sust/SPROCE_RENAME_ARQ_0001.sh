#!/usr/bin/bash

####################################################################################################
#  Nome do Arquivo   : SPROCE_RENAME_ARQ_0001.sh                                                   #
#  Criado por        : Leega Consultoria                                                           #
#  Editado por       :                                                                             #
#  Versao            : 1.0                                                                         #
#  Data de Criacao   : 08/02/2017                                                                  #
#  Descricao         : Realiza o rename do arquivo de alertas funcionais para D-1 de acordo com    # 
#                       sua regra                                                                  #
#                                                                                                  #
#  dados de Entrada  : Parametro 1 -> Diretorio                                                    #
#                      Parametro 2 -> arquivo                                                      #
#                                                                                                  #
# Historico                                                                                        #
# Responsavel     | Data       | Comentario                                                        #
# ----------------+------------+----------------------------------------                           #
# EYVF0C          | 08/02/2017 | Criacao                                                           #
####################################################################################################


#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################

DIR=${1}
ARQ=${2}

#########################################
# Declaracao de Funcoes                 #
#########################################

fn_data_anterior()
{

DIA=${1}
MES=${2}
ANO=${3}

DIA=$(expr ${DIA} - 1)

if [ ${DIA} -eq 0 ]
   then

   MES=$(expr ${MES} - 1)

   if [ ${MES} -eq 0 ]
   then

       MES=12
       ANO=$(expr ${ANO} - 1)

   fi

   DIA=$(cal ${MES} ${ANO})
   DIA=$(echo ${DIA} | awk '{ print $NF }')

fi
	
DIA_ANT=$(printf "%04d%s%02d%s%02d\n" ${ANO} - ${MES} - ${DIA})  

}

#########################################
# MAIN                                  #
#########################################

# Obtendo dia anterior

fn_data_anterior $(date "+%d") $(date "+%m") $(date "+%Y")

# Verificando se o arquivo existe

if [ ! -f ${DIR}/${ARQ} ]
   then
   
   touch ${DIR}/${ARQ}
   
fi

# QTD_ARQ=1 - Arquivo com o timestamp do dia da execução
# QTD_ARQ=0 - Arquivo com o timestamp diferente do dia da execução

QTD_ARQ=$(find ${DIR} -type f -name "${ARQ}" -mtime 1 | wc -l)

if [ ${QTD_ARQ} -eq 0 ]
   then
   
   mv ${DIR}/${ARQ} ${DIR}/${ARQ%.*}-${DIA_ANT}.log
   touch ${DIR}/${ARQ}
   
fi
