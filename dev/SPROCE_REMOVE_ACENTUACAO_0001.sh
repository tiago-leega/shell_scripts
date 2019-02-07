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

DIR_ORI=${1}
ARQ_ORI=${2}
DIR_LOG=${3}
ARQ_LOG=AO_${4}_EPROPRCEXT_REMOVE_ACENTUACAO_$(date '+%Y%m%d-%H%M%S')_LOG.txt

#########################################
# INICIO                                #
#########################################

echo "[ ################################################################################ ]" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) - Diretorio Origem: ${DIR_ORI}" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) -   Arquivo Origem: ${ARQ_ORI}" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) - Diretorio de LOG: ${DIR_LOG}" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) -   Arquivo de LOG: ${ARQ_LOG}" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ ################################################################################ ]" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) - INICIO do processo de remocao de acentuacao" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ ################################################################################ ]"  >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) - Lista de arquivos tratados"  >> ${DIR_LOG}/${ARQ_LOG} 2>&1

cd ${DIR_ORI}

LISTA_ARQ=$(find . \( ! -name . -prune \) -type f -name "${ARQ_ORI}")

RC=$?

if [ ${RC} -eq 0 ]
   then

   for ARQ in ${LISTA_ARQ}
      do
   
      echo "[ $(date) - ${ARQ##*/} "  >> ${DIR_LOG}/${ARQ_LOG} 2>&1

      sed -e 's/ã/a/g' -e 's/á/a/g' -e 's/à/a/g' -e 's/â/a/g' -e 's/Ã/A/g' -e 's/Á/A/g' -e 's/À/A/g' -e 's/Â/A/g' -e 's/é/e/g' -e 's/è/e/g' -e 's/ê/e/g' -e 's/É/E/g' -e 's/È/E/g' -e 's/Ê/E/g' -e 's/í/i/g' -e 's/ì/i/g' -e 's/î/i/g' -e 's/Í/I/g' -e 's/Ì/I/g' -e 's/Î/I/g' -e 's/õ/o/g' -e 's/ó/o/g' -e 's/ò/o/g' -e 's/ô/o/g' -e 's/Õ/O/g' -e 's/Ó/O/g' -e 's/Ò/O/g' -e 's/Ô/O/g' -e 's/ú/u/g' -e 's/ù/u/g' -e 's/û/u/g' -e 's/Ú/U/g' -e 's/Ù/U/g' -e 's/Û/U/g' -e 's/ç/c/g' -e 's/Ç/C/g' -e 's/ä/a/g' -e 's/Ä/A/g' -e 's/ë/e/g' -e 's/Ë/E/g' -e 's/ï/i/g' -e 's/Ï/I/g' -e 's/ö/o/g' -e 's/Ö/O/g' -e 's/ü/u/g' -e 's/Ü/U/g' -e 's/ý/y/g' -e 's/Ý/Y/g' ${ARQ} > ${ARQ}_NEW
   
      RC=$?
   
      echo "[ $(date) - Novo arquivo criado sem acentuacao" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
      echo "[ $(date) - ${ARQ##*/}_NEW"  >> ${DIR_LOG}/${ARQ_LOG} 2>&1
      echo "[ $(ls -lrt ${ARQ}_NEW)"  >> ${DIR_LOG}/${ARQ_LOG} 2>&1

      if [ ${RC} -eq 0 ]
         then
	  
         echo "[ $(date) - Renomeando arquivo de ${ARQ##*/}_NEW para ${ARQ##*/}" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
   
         mv ${ARQ}_NEW ${ARQ} >> ${DIR_LOG}/${ARQ_LOG} 2>&1
	  
	 else
	  
	 echo "[ $(date) - ERRO na remocao da acentuacao do arquivo ${ARQ##*/}" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
	  
	 exit 1

      fi

   done

   else

   echo "[ ################################################################################ ]" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
   echo "[ $(date) - ERRO - FIM do processo de remocao de acentuacao" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
   echo "[ ################################################################################ ]"  >> ${DIR_LOG}/${ARQ_LOG} 2>&1

   exit 1

   fi

echo "[ ################################################################################ ]" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ $(date) - FIM do processo de remocao de acentuacao" >> ${DIR_LOG}/${ARQ_LOG} 2>&1
echo "[ ################################################################################ ]"  >> ${DIR_LOG}/${ARQ_LOG} 2>&1

exit 0
