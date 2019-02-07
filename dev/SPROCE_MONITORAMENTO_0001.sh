#!/usr/bin/sh

##################################################################################
#
# Descricao: Shell criada para ler session log's e buscar quantidade
#            de linhas de entrada e de saida. A shell soma todas as SOURCE e TARGET
#            portanto quando um mapa existir varios pipe line's, a shell ira somar
#            suas entradas e saidas.
#
# Formato de arquivo de saida:
# 
# SESSION;QTD DE LINHAS DE ENTRADA;QTD DE LINHAS DE SAIDA
#
# Parametros:
#
# $1 - Diretório 
#    Ex: /etlsys/pceproce/infa_shared
# 
# Arquivo com as sessions:
#    O arquivo /etlsys/pceproce/infa_shared/BWParam/SPROCE_MONITORAMENTO_0001.par 
#    esta com o conteudo abaixo, e para adicionar uma nossa session, basta colocar
#    o prefixo da session separado por "|". Esta string nao deve comecar nem terminar com "|"
#    Nao requer conhecimento, tao pouca habilidade
#
#    Ex: s_0009|s_0012|s_0014|s_0015|s_0016|s_0017|s_0019|s_0020|s_0050|s_0051|s_0052|s_0053|s_0054|s_0093
#
##################################################################################

DIR_IN="${1}/SessLogs"
DIR_OUT="${1}/TgtFiles"
DIR_PAR="${1}/BWParam"
ARQ_OUT="AB_MONITORAMENTO_QTD_SESSION.txt"
ARQ_PAR="SPROCE_MONITORAMENTO_0001.par"
PRE_SESSION="$(cat ${DIR_PAR}/${ARQ_PAR})"

GERA_YYYYMMDD()
{

istat ${1} | grep "^Last modified" | awk 'BEGIN {

vt_MES["Jan"]="01";
vt_MES["Feb"]="02";
vt_MES["Mar"]="03";
vt_MES["Apr"]="04";
vt_MES["May"]="05";
vt_MES["Jun"]="06";
vt_MES["Jul"]="07";
vt_MES["Aug"]="08";
vt_MES["Sep"]="09";
vt_MES["Oct"]="10";
vt_MES["Nov"]="11";
vt_MES["Dec"]="12";

} { printf ("%04d%02d%02d\n", $8, vt_MES[$4], $5); }'

}

for SESSION_LOG in $(find ${DIR_IN} -type f -name "s_????_EPROPRCEXT_*" | grep -E ${PRE_SESSION} )

do

ENTRADA=$(strings ${SESSION_LOG} | sed -e '/Source Load Summary/,$!d' -e '/Target Load Summary/,$d' -e 's/.*Table/Table/g' | grep -E " Output"  | awk -F"," 'BEGIN{ soma=0; } { soma+=substr($1,index($1,"[")+1,(index($1,"]")-index($1,"["))-1) } END { print soma }')

SAIDA=$(strings ${SESSION_LOG} | sed -e '/Target Load Summary/,$!d' -e 's/.*Table/Table/g' | grep -E " Output" | awk -F"," 'BEGIN { soma=0; } {  soma+=substr($1,index($1,"[")+1,(index($1,"]")-index($1,"["))-1) } END { print soma; }')

ARQ_NAME=$( echo ${SESSION_LOG} | awk -F"/" '{ print $NF }' | cut -d'.' -f1)_$( GERA_YYYYMMDD ${SESSION_LOG} )

echo "${ARQ_NAME};${ENTRADA};${SAIDA}"

done > ${DIR_OUT}/${ARQ_OUT}

exit 0
