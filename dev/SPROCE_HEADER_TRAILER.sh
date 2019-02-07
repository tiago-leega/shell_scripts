###############################################################################################################
#  Nome do Arquivo   : SPROCE_HEADER_TRAILER.sh                                                               #
#  Criado por        : Eduardo Maia - Leega 	                                                             #
#  Editado por       : Victor Huang - Leega                                                                   #
#  Versao            : 1.0                                                                                    #
#  Data de Criacao   : 18/07/2016                                                                             #
#  Descricao         : Concatena header e trailer aos seus respectivos arquivos de detalhe                    #
#                                                                                                             #
#  Historico                                                                                                  #
#  Responsavel          | Data       | Comentario                                                             #
#  ---------------------+------------+----------------------------------------------------------------------- #
#  Victor Huang - Leega | 22/07/2016 | Alteração parametro de entrada e limpeza header e trailer              #
#  ---------------------+------------+----------------------------------------------------------------------- #
#  Victor Huang - Leega | 25/10/2016 | Inclusao parametro de entrada para movimentar o arquivo em outro diret #
#  ---------------------+------------+----------------------------------------------------------------------- #
#                                                                                                             #
#                                                                                                             #
#  Parametros        : Parametro 1 -> <Diretorio de geracao dos arquivos>                                     #
#  de Entrada          Parametro 2 -> AO_<Sufixo do nome do mapa>                                             #
#                      Parametro 3 -> <Diretorio de movimentacao do arquivo>                                  #
#  Exemplo:                                                                                                   #
#  	     SPROCE_HEADER_TRAILER.sh  /etlsys/pceproce/infa_shared/Temp AO_0001_EPROPRCEXT_AUTORIZACOES_01 /home #
#                                                                                                             #
###############################################################################################################

if [ $# -ne 3 ]; then
   echo "ERRO: Favor, informar os 3 parametros!"
   exit 99
else
   DIR="$1"
   DIR_PROCE="$3"
   DETAIL="${DIR}/${2}_DETAIL_*.txt"
   HEADER="${DIR}/${2}_HEADER.txt"
   TRAILER="${DIR}/${2}_TRAILER.txt"
   TMP_DETAIL_FILES="${DIR}/TMP_DETAILS.tmp"
   
   if [ -d "${DIR}" ]; then
      if [ -e "${HEADER}" ]; then
         if [ -e "${TRAILER}" ]; then
            if [[ -n `ls -ltr ${DETAIL}` ]]; then
               ls -ltr ${DETAIL} | awk '{print $9}' | awk -F"/" '{print $(NF)}' > ${TMP_DETAIL_FILES}
               while read LISTA
               do
                  cat ${HEADER} | grep "${LISTA}" | sed "s/${LISTA};//g" > ${HEADER}.new
                  cat ${TRAILER} | grep "${LISTA}" | sed "s/${LISTA};//g" > ${TRAILER}.new

                  if [ -n "`head -1 ${DIR}/${LISTA} | cut -c 13-100 | sed 's/;//g' | sed 's/ //g'`" ]; then
                     cat ${HEADER}.new ${DIR}/${LISTA} ${TRAILER}.new > ${DIR}/${LISTA}.new
                  else
                     cat ${HEADER}.new ${TRAILER}.new > ${DIR}/${LISTA}.new
                  fi

                  FINAL=$( echo "${LISTA}" | sed "s/_DETAIL//g" )

                  mv ${DIR}/${LISTA}.new ${DIR}/${FINAL}
                  mv ${DIR}/${FINAL} ${DIR_PROCE}/${FINAL}

                  rm -f ${HEADER}.new ${TRAILER}.new ${DIR}/${LISTA} 2> /dev/null
               done < ${TMP_DETAIL_FILES}
            else
               echo "ERRO: Arquivo de DETALHE ${DETAIL} nao existe!"
               exit 99
            fi
         else
            echo "ERRO: Arquivo de TRAILER ${TRAILER} nao existe!"
            exit 99
         fi
      else
         echo "ERRO: Arquivo de HEADER ${HEADER} nao existe!"
         exit 99
      fi
   else
      echo "ERRO: Diretorio ${DIR} nao existe!"
      exit 99
   fi
   rm -f ${TMP_DETAIL_FILES} 2> /dev/null

   if [ $? -eq 0 ]; then
      rm -f ${HEADER} ${TRAILER} 2> /dev/null
   fi

fi

exit $?
