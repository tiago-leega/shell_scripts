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
# EYVF06          | 10/08/2016 | Criacao                                                           #
# EYVF0C          | 09/12/2016 | Alterado matriz tecnologica para AWK                              #
####################################################################################################

#########################################
# Declaracao de Variaveis de Ambiente   #
#########################################
v_NOM_DIR_RAIZ="/etlsys/pceproce/infa_shared"
v_NOM_DIR_FILE_TGT=${v_NOM_DIR_RAIZ}"/TgtFiles/"
v_DT_EXEC=$(date +%Y%m%d-%H%M%S )
v_DIAS_RETENCAO=7

#########################################
# Parametros Recebidos                  #
#########################################
p_CD_BANDEIRA=$1
p_CD_CREDENCIADORA=$2

##############################################
# Declaracao de Arquivos (Source/Target/Log) #
##############################################
#Definicao do nome do arquivo Origem
f_NOM_ARQ_SRC=$(cat ${v_NOM_DIR_FILE_TGT}"AO_0013_EPROPRCEXT_VALIDA-REMESSA_01_01_${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}_VALIDO" 2>/dev/null)

#Definicao do nome do arquivo Log
f_NOM_ARQ_LOG=${v_NOM_DIR_FILE_TGT}"AO_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_"${v_DT_EXEC}"_LOG.txt"

#Definicao do nome do arquivo que contem somente os registros de nivel E1
f_NOM_ARQ_E1=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E1.txt"
f_NOM_ARQ_E1_TEMP=${f_NOM_ARQ_E1}_TEMP

#Definicao do nome do arquivo que contem somente os registros de nivel E2
f_NOM_ARQ_E2=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E2.txt"
f_NOM_ARQ_E2_TEMP=${f_NOM_ARQ_E2}_TEMP

#Definicao do nome do arquivo que contem somente os registros de nivel E3
f_NOM_ARQ_E3=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_E3.txt"
f_NOM_ARQ_E3_TEMP=${f_NOM_ARQ_E3}_TEMP

#Definicao do nome do arquivo que contem somente os registros de exclusao
f_NOM_ARQ_DEL_P1=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_P1.txt"
f_NOM_ARQ_DEL_P2=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL_P2.txt"
f_NOM_ARQ_DEL=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_DEL.txt"

f_ARQ_RETORNO=${v_NOM_DIR_FILE_TGT}"ARQ_RETORNO_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".tmp"

#Definicao do nome do arquivo que contem a linha de retorno
v_NOM_ARQ_RET=${v_NOM_DIR_FILE_TGT}"AB_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}"_R0.txt"

#Arquivo de apoio com informacao da Data do Processamento atual
#f_NOM_ARQ_EXT_0010=${v_NOM_DIR_FILE_TGT}"AO_0010_EPROPRCEXT_CICLO_PROCESSAMENTO_01_01.txt"
f_NOM_ARQ_EXT_0010=${v_NOM_DIR_FILE_TGT}"AOPROPRC001001_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"

#Arquivo de apoio com informacoes de Bandeira, Credenciadora e Remessa
#f_NOM_ARQ_EXT_0011=${v_NOM_DIR_FILE_TGT}"AO_0011_EPROPRCEXT_REMESSA_CREDENCIADORA_BANDEIRA_01_01.txt"
f_NOM_ARQ_EXT_0011=${v_NOM_DIR_FILE_TGT}"AOPROPRC001101_"${p_CD_BANDEIRA}${p_CD_CREDENCIADORA}".txt"

##############################################
# Remove arquivos gerados na ultima execucao #
##############################################
rm -f ${f_NOM_ARQ_E1}
rm -f ${f_NOM_ARQ_E2}
rm -f ${f_NOM_ARQ_E3}
rm -f ${v_NOM_ARQ_RET}
rm -f ${f_NOM_ARQ_DEL_P1}
rm -f ${f_NOM_ARQ_DEL_P2}
rm -f ${f_NOM_ARQ_DEL}

find ${v_NOM_DIR_FILE_TGT}AO_0014_EPROPRCEXT_VALIDA_DETALHE_01_01_*LOG.txt -mtime +${v_DIAS_RETENCAO} -exec rm -f {} \;

#########################################
# Declaracao de Variaveis               #
#########################################
v_TP_STATUS_PROC_ARQ=0
v_QT_ERRO=0
v_NU_OCORRENCIA=""
v_QT_REG_E1_ACP=0
v_QT_REG_E1_REJ=0
v_QT_REG_E2_ACP=0
v_QT_REG_E2_REJ=0
v_QT_REG_E3_ACP=0
v_QT_REG_E3_REJ=0
v_FG_PDV_CENTRAL=0
v_FG_NVL_EXCL=0
v_QT_REG_EXCL=0
v_FG_CPF_CNPJ_CENTRAL=0
v_NU_REG_FOUND_PDV=0

#Alimenta variaveis com dados dos arquivos de apoio
vf_CD_BNDR=`cat ${f_NOM_ARQ_EXT_0011} | cut -d '|' -f1`
vf_CD_CRDE=`cat ${f_NOM_ARQ_EXT_0011} | cut -d '|' -f2`
vf_NU_RMSA=`cat ${f_NOM_ARQ_EXT_0011} | cut -d '|' -f3`
vf_DT_CICLO=`cat ${f_NOM_ARQ_EXT_0010} | cut -d '|' -f1`

#########################################
# Funcao de saida da rotina             #
#########################################
FNC_Exit()
{
v_ERR_CODE=${1}

exit ${v_ERR_CODE}
}

#########################################
# Funcao de geracao de arquivo de log   #
#########################################
FNC_Log()
{
        echo $( date +%d/%m/%Y-%H:%M:%S ) "${1}" >> ${f_NOM_ARQ_LOG}
}
#############################################
# Funcao de geracao de arquivo de retorno   #
#############################################
FNC_Arq_Retorno()
{
v_TP_REGISTRO_RET="R0"
v_CD_BANDEIRA_RET=${p_CD_BANDEIRA}
v_CD_CREDENCIADORA_RET=${p_CD_CREDENCIADORA}
v_CD_IDENT_ENVIO_RET="2"
v_NU_REMESSA_RET="${2}"
v_DT_ARQUIVO_RET="${3}"
v_STATUS_PROC_RET="${1}"
v_NUM_REG_INVALID_RET="00000"
v_QT_REG_E1_ACP="${4}"
v_QT_REG_E1_ACP=`printf '%07s' "${v_QT_REG_E1_ACP}"`			
v_QT_REG_E1_REJ="${5}"
v_QT_REG_E1_REJ=`printf '%07s' "${v_QT_REG_E1_REJ}"`
v_QT_REG_E2_ACP="${6}"
v_QT_REG_E2_ACP=`printf '%07s' "${v_QT_REG_E2_ACP}"`
v_QT_REG_E2_REJ="${7}"
v_QT_REG_E2_REJ=`printf '%07s' "${v_QT_REG_E2_REJ}"`
v_QT_REG_E3_ACP="${8}"
v_QT_REG_E3_ACP=`printf '%07s' "${v_QT_REG_E3_ACP}"`
v_QT_REG_E3_REJ="${9}"
v_QT_REG_E3_REJ=`printf '%07s' "${v_QT_REG_E3_REJ}"`

        echo "${v_TP_REGISTRO_RET}${v_CD_BANDEIRA_RET}${v_CD_CREDENCIADORA_RET}${v_CD_IDENT_ENVIO_RET}${v_NU_REMESSA_RET}${v_DT_ARQUIVO_RET}${v_STATUS_PROC_RET}${v_NUM_REG_INVALID_RET}${v_QT_REG_E1_ACP}${v_QT_REG_E1_REJ}${v_QT_REG_E2_ACP}${v_QT_REG_E2_REJ}${v_QT_REG_E3_ACP}${v_QT_REG_E3_REJ}" >> ${v_NOM_ARQ_RET}
}

FNC_Nivel_Exclusao()
{

while read v_REG_FILE_EXC
do

	v_TP_REGISTRO=`echo "${v_REG_FILE_EXC}" | cut -c 1-2`
	v_TP_PESSOA=`echo "${v_REG_FILE_EXC}" | cut -c 4-4`
	v_CNPJ_CPF=`echo "${v_REG_FILE_EXC}" | cut -c 5-18`
	
	if [ "${v_TP_REGISTRO}" == "E1" ]
	then
		v_REGISTRO_E1=`echo "${v_REG_FILE_EXC}" | cut -c 1-124`
		
		v_FG_NVL_EXCL="1"
		v_NU_REG_FOUND_E2=`grep -c "E2E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL_P2}`
		v_NU_REG_FOUND_E3=`grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL_P2}`		
		v_QT_REG_EXCL=`expr ${v_NU_REG_FOUND_E2} + ${v_NU_REG_FOUND_E3} + 1`
		
		v_QT_REG_EXCL=`printf '%03s' "${v_QT_REG_EXCL}"`
		v_NU_REG_FOUND_E2=`printf '%03s' "${v_NU_REG_FOUND_E2}"`
		v_NU_REG_FOUND_E3=`printf '%03s' "${v_NU_REG_FOUND_E3}"`
		
		echo "${v_REGISTRO_E1}${v_FG_NVL_EXCL}${v_QT_REG_EXCL}${v_NU_REG_FOUND_E2}${v_NU_REG_FOUND_E3}" >> $f_NOM_ARQ_DEL
 	elif [ "${v_TP_REGISTRO}" == "E2" ]
	then	
		v_REGISTRO_E2=`echo "${v_REG_FILE_EXC}" | cut -c 1-74`
		
		v_PONTO_VENDA=`echo "${v_REG_FILE_EXC}" | cut -c 19-33`
		v_NU_REG_FOUND_E2=`grep -c "E1E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL_P2}`
		if [ ${v_NU_REG_FOUND_E2} -eq 0 ]
		then 
			v_FG_NVL_EXCL="2"
			v_NU_REG_FOUND_E3=`grep -c "E3E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_DEL_P2}`	
			v_QT_REG_EXCL=`expr ${v_NU_REG_FOUND_E3}`
		else
			v_FG_NVL_EXCL="1"
			v_QT_REG_EXCL="0"
		fi
		
		v_QT_REG_EXCL=`printf '%03s' "${v_QT_REG_EXCL}"`
		v_NU_REG_FOUND_E3=`printf '%03s' "${v_NU_REG_FOUND_E3}"`		
		
		echo "${v_REGISTRO_E2}${v_FG_NVL_EXCL}${v_QT_REG_EXCL}${v_NU_REG_FOUND_E3}" >> $f_NOM_ARQ_DEL
 	elif [ "${v_TP_REGISTRO}" == "E3" ]
	then		
		v_REGISTRO_E3=`echo "${v_REG_FILE_EXC}" | cut -c 1-130`
	
		v_PONTO_VENDA=`echo "${v_REG_FILE_EXC}" | cut -c 19-33`
		
		v_NU_REG_FOUND_E1=`grep -c "E1E${v_TP_PESSOA}${v_CNPJ_CPF}" ${f_NOM_ARQ_DEL_P2}`
		if [ ${v_NU_REG_FOUND_E1} -ne 0 ]
		then
			v_FG_NVL_EXCL="1"
			v_QT_REG_EXCL="0"
		else
			v_NU_REG_FOUND_E2=`grep -c "E2E${v_TP_PESSOA}${v_CNPJ_CPF}${v_PONTO_VENDA}" ${f_NOM_ARQ_DEL_P2}`
			if [ ${v_NU_REG_FOUND_E2} -eq 0 ]
			then 
				v_FG_NVL_EXCL="3"
				v_QT_REG_EXCL="1"
			else
				v_FG_NVL_EXCL="2"
				v_QT_REG_EXCL="0"
			fi
		fi
		
		echo "${v_REGISTRO_E3}${v_FG_NVL_EXCL}${v_QT_REG_EXCL}" >> $f_NOM_ARQ_DEL
	fi
	
done < ${f_NOM_ARQ_DEL_P2}
}

###########################################################
# Inicio do processo                                      #
###########################################################
FNC_Log "### ALERTA: Inicio do Processo SPROCE_VALIDA_DETAHE_0001.sh - Parametros Recebidos -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

if [ "${p_CD_BANDEIRA}" == "" -o "${p_CD_CREDENCIADORA}" == "" -o "${p_CD_BANDEIRA}" == "   " -o "${p_CD_CREDENCIADORA}" == "    " ]
then
	FNC_Log "FALHA : Parametro Bandeira ou Credenciadora nao informados."
	FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_DETAHE_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"
	
	FNC_Exit 99
fi

#Verifica o nome do arquivo de origem utilizado pelo processo anterior.
if [ -z "${f_NOM_ARQ_SRC}" -o "${f_NOM_ARQ_SRC}" == "" ]
then
        FNC_Log "FALHA : Nao foi encontrado FileWatcher Valido do processo anterior!"
		FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_DETAHE_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

		FNC_Exit 99
else
		v_NOM_ARQ_FINAL="${f_NOM_ARQ_SRC}"
		FNC_Log "ALERTA: Arquivo origem utilizado '"${v_NOM_ARQ_FINAL}"'"
fi

v_QT_REGISTRO=`cat $v_NOM_ARQ_FINAL | wc -l`
v_QT_REGISTRO=`expr $v_QT_REGISTRO - 1`

awk -v f_NOM_ARQ_E1_TEMP=${f_NOM_ARQ_E1_TEMP} -v f_NOM_ARQ_E2_TEMP=${f_NOM_ARQ_E2_TEMP} -v  f_NOM_ARQ_E3_TEMP=${f_NOM_ARQ_E3_TEMP} -v f_NOM_ARQ_DEL_P1=${f_NOM_ARQ_DEL_P1} -v f_ARQ_RETORNO=${f_ARQ_RETORNO} 'BEGIN {

v_CONCAT_E2="";

}

###############################
# Funcao de Validacao CPF     #
###############################

function codecpf ( cpf ) {
   
   gsub("\\.","",cpf);
   gsub("\\-","",cpf);
   gsub("\\/","",cpf);
   gsub(" ","",cpf);
   i=length(cpf);

   if ( i <= 3 ) { print "RES|ERR|CPF|"cpf"|Erro no tamanho do CPF" ; exit 1}

      if ( i > 0 ) d11= 1 * substr(cpf,i-0,1)
      if ( i > 1 ) d10= 1 * substr(cpf,i-1,1)
      if ( i > 2 ) d9 = 1 * substr(cpf,i-2,1)
      if ( i > 3 ) d8 = 1 * substr(cpf,i-3,1)
      if ( i > 4 ) d7 = 1 * substr(cpf,i-4,1)
      if ( i > 5 ) d6 = 1 * substr(cpf,i-5,1)
      if ( i > 6 ) d5 = 1 * substr(cpf,i-6,1)
      if ( i > 7 ) d4 = 1 * substr(cpf,i-7,1)
      if ( i > 8 ) d3 = 1 * substr(cpf,i-8,1)
      if ( i > 9 ) d2 = 1 * substr(cpf,i-9,1)
      if ( i > 10) d1 = 1 * substr(cpf,i-10,1)

      soma=10*d1 + 9*d2 + 8*d3 + 7*d4 + 6*d5 + 5*d6 + 4*d7 + 3*d8 + 2*d9;
      div = int(soma/11) ; # printf("%5.2f\n",div);
      resto = soma/11 - int(soma/11) ; # printf("resto=%5.2f\n",resto);
      tot=div * 11;
      dif=soma - tot;
      if ( ( dif == 0 ) || ( dif == 1 ) ) { dv1=0 } 
      else { dv1 = 11 - dif } 

     soma=11*d1+10*d2 + 9*d3 + 8*d4 + 7*d5 + 6*d6 + 5*d7 + 4*d8 + 3*d9 + 2*dv1;
     div = int(soma/11) ;
     resto = soma/11 - int(soma/11) ; # printf("resto=%5.2f\n",resto);
     tot=div * 11;
     dif=soma - tot;
     if ( ( dif == 0 ) || ( dif == 1 ) ) { dv2=0 } 
     else { dv2 = 11 - dif } 

     if ( d9 == 1 ) { ufs="DF;GO;MS;MT;TO" }
     if ( d9 == 2 ) { ufs="AC;AM;AP;PA;RO;RR" }
     if ( d9 == 3 ) { ufs="CE;MA;PI" }
     if ( d9 == 4 ) { ufs="AL;PB;PE;RN" }
     if ( d9 == 5 ) { ufs="BA;SE" }
     if ( d9 == 6 ) { ufs="MG" }
     if ( d9 == 7 ) { ufs="ES;RJ" }
     if ( d9 == 8 ) { ufs="SP" }
     if ( d9 == 9 ) { ufs="PR;SC" }
     if ( d9 == 0 ) { ufs="RS" }

     if ( ( dv1 == d10 ) && ( dv2 == d11 ) ) { return 0; }
     else {                                    
              return 1 ;
          }

}

###############################
# Funcao de Validacao CNPJ    #
###############################

function codecnpj ( cnpj ) {

   gsub("\\.","",cnpj);
   gsub("\\-","",cnpj);
   gsub("\\/","",cnpj);
   gsub(" ","",cnpj);
   i=length(cnpj);

      if ( i >  0 ) d14= 1 * substr(cnpj,i-0,1);
      if ( i >  1 ) d13= 1 * substr(cnpj,i-1,1);
      if ( i >  2 ) d12= 1 * substr(cnpj,i-2,1);
      if ( i >  3 ) d11= 1 * substr(cnpj,i-3,1);
      if ( i >  4 ) d10= 1 * substr(cnpj,i-4,1);
      if ( i >  5 ) d9 = 1 * substr(cnpj,i-5,1);
      if ( i >  6 ) d8 = 1 * substr(cnpj,i-6,1);
      if ( i >  7 ) d7 = 1 * substr(cnpj,i-7,1);
      if ( i >  8 ) d6 = 1 * substr(cnpj,i-8,1);
      if ( i >  9 ) d5 = 1 * substr(cnpj,i-9,1);
      if ( i > 10 ) d4 = 1 * substr(cnpj,i-10,1);
      if ( i > 11 ) d3 = 1 * substr(cnpj,i-11,1);
      if ( i > 12 ) d2 = 1 * substr(cnpj,i-12,1);
      if ( i > 13 ) d1 = 1 * substr(cnpj,i-13,1);

      soma=5*d1 + 4*d2 + 3*d3 + 2*d4 + 9*d5 + 8*d6 + 7*d7 + 6*d8 + 5*d9 + 4 * d10 + 3*d11 + 2*d12 ;
      div = int(soma/11) ;
      resto = soma/11 - int(soma/11) ;
      tot=div * 11;
      dif=soma - tot;
      if ( ( dif == 0 ) || ( dif == 1 ) ) { dv1=0 } 
      else { dv1 = 11 - dif } 

     soma=6*d1+5*d2 + 4*d3 + 3*d4 + 2*d5 + 9*d6 + 8*d7 + 7*d8 + 6*d9 + 5*d10 +4*d11 +3*d12 + 2*dv1;
     div = int(soma/11) ;
     resto = soma/11 - int(soma/11) ;
     tot=div * 11;
     dif=soma - tot;
     if ( ( dif == 0 ) || ( dif == 1 ) ) { dv2=0 } 
     else { dv2 = 11 - dif } 

     if ( ( dv1 == d13 ) && ( dv2 == d14 ) ) { return 0 }
     else {                                    

              return 1 
          }
}

###############################
# Funcao de Validacao de Data #
###############################
function FNC_Valida_Data ( v_DT_ARQUIVO ) {

   v_ANO=substr(v_DT_ARQUIVO,1,4);
   v_MES=substr(v_DT_ARQUIVO,5,2);
   v_DIA=substr(v_DT_ARQUIVO,7,2);
   
   if (( v_MES < 0 ) || ( v_MES > 12 )) {
   
       #print "FALHA : Mes "v_MES" invalido!";
       
   } else {
   
      v_DIAS_MES["01"]=31;
      v_DIAS_MES["02"]=28;
      v_DIAS_MES["03"]=31;
      v_DIAS_MES["04"]=30;
      v_DIAS_MES["05"]=31;
      v_DIAS_MES["06"]=30;
      v_DIAS_MES["07"]=31;
      v_DIAS_MES["08"]=31;
      v_DIAS_MES["09"]=30;
      v_DIAS_MES["10"]=31;
      v_DIAS_MES["11"]=30;
      v_DIAS_MES["12"]=31;

   }
   
    if ( v_MES == "02" ) { # Se mes de Fevereiro, verifica se o ano e bissexto
       
      if ( (v_ANO % 4) != 0 ) {
       
         } else if ( (v_ANO % 400) != 0 ) {
              
              v_DIAS_MES["02"]=29;
           
           } else if ( (v_ANO % 100) != 0 ) {
              
           } else {
           
              v_DIAS_MES["02"]=29;
              
           }
    }
    
   if (( v_DIA < 0 ) || ( v_DIA > v_DIAS_MES[v_MES] )) {
    
      #print "FALHA : Dia "v_DIA" invalido!";
      return 0;
        
   } else {

      return 1;
        
   }

}

{

v_TP_REGISTRO=substr($0,1,2);
v_CD_OPERACAO=substr($0,3,1);
v_TP_PESSOA=substr($0,4,1);
v_CNPJ_CPF=substr($0,5,14);
v_TP_PESSOA_CENTRAL=substr($0,59,1);
v_CNPJ_CPF_CENTRAL=substr($0,60,14);
v_PV_CENTRAL=substr($0,74,15);
v_QT_ERRO=0;
v_NU_OCORRENCIA="";

if (( v_TP_REGISTRO == "E1" ) || ( v_TP_REGISTRO == "E2" ) || ( v_TP_REGISTRO == "E3" )){

   if ( v_TP_REGISTRO == "E1" ) {
   
      vt_E1[substr($0,3,16)]=substr($0,1,90)"|"NR;
	  
   } else if ( v_TP_REGISTRO == "E2" ) {
   
      vt_E2[substr($0,3,31)]=substr($0,1,40)"|"NR;
	  vt_E2_E1[substr($0,1,18)]="0";

   } else if ( v_TP_REGISTRO == "E3" ) {
   
      vt_E3[substr($0,3,31)]=substr($0,1,96)"|"NR;
   
   } 
   
}

} END {

for ( v_E1 in vt_E1 ) {
   
   v_CD_OPERACAO=substr(vt_E1[v_E1],3,1);
   v_RAZAO_NOME=substr(vt_E1[v_E1],19,40);
   v_TP_PESSOA_CENTRAL=substr(vt_E1[v_E1],59,1);
   v_CNPJ_CPF_CENTRAL=substr(vt_E1[v_E1],60,14);
   v_PV_CENTRAL=substr(vt_E1[v_E1],74,15);
   v_NU_CATEG_PROD_FINANCEIRO=substr(vt_E1[v_E1],89,2);
   v_BLOCO_CENTRAL=substr(vt_E1[v_E1],60,29);
   v_REGISTRO_E1=substr(vt_E1[v_E1],1,90);
   v_SORT_E1=substr(vt_E1[v_E1],match(vt_E1[v_E1],"|")+1);
   v_TP_PESSOA=substr(vt_E1[v_E1],4,1);
   v_CNPJ_CPF=substr(vt_E1[v_E1],5,14);
   v_QT_ERRO=0;
   v_NU_OCORRENCIA=""
   
   if (( v_CD_OPERACAO == "I" ) || ( v_CD_OPERACAO == "E" ) || ( v_CD_OPERACAO == "A" )) {
   
   } else {   
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0009";
      #print "FALHA : Codigo da Operacao " v_CD_OPERACAO " invalido! Registro rejeitado!"
    
   }
      
   if (( v_TP_PESSOA != "F" ) && ( v_TP_PESSOA != "J" )) {
   
   v_QT_ERRO=v_QT_ERRO + 1;
   v_NU_OCORRENCIA=v_NU_OCORRENCIA"0010";
   #print "FALHA: Tipo de Pessoa " v_TP_PESSOA " invalido! Registro rejeitado!";
   
   }

   if (( v_CNPJ_CPF ~ "^[0-9]*$" ) && ( v_CNPJ_CPF != "" )) {
   
      if ( v_TP_PESSOA == "F" ) {
	  
	     v_CNPJ_CPF=substr(vt_E1[v_E1],8,11);
		 rc_CPF=codecpf(v_CNPJ_CPF);
         
         if ( rc_CPF != 0 ) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0011";
            #print "FALHA : CPF " v_CNPJ_CPF " invalido! Registro rejeitado!"
         
         }
      
      } else { 
      
         if ( v_TP_PESSOA == "J" ) {
         
		    rc_CNPJ=codecnpj(v_CNPJ_CPF);
         
            if ( rc_CNPJ != 0 ) {
               
               v_QT_ERRO=v_QT_ERRO + 1;
               v_NU_OCORRENCIA=v_NU_OCORRENCIA"0012";         
               #print "FALHA : CNPJ " v_CNPJ_CPF " invalido! Registro rejeitado!"
            
            }
         
         }
      
      }
   
   } else {
   
   v_QT_ERRO=v_QT_ERRO + 1;
   v_NU_OCORRENCIA=v_NU_OCORRENCIA"0044";
   #print "FALHA : CNPJ/CPF " v_CNPJ_CPF " nao numerico! Registro rejeitado!"
   
   }
   
   if ( v_CD_OPERACAO == "I" ) {
   
      if (( v_RAZAO_NOME == "" ) || ( v_RAZAO_NOME == "                                        " )) {
         
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0013";
         #print "FALHA : Nome ou Razao Social nao informado. Registro rejeitado!";
         
      }

      if ( v_CNPJ_CPF_CENTRAL ~ "^[0-9]*$" ) {

         v_NU_REG_FOUND_CPF_CNPJ=v_NU_REG_FOUND_CPF_CNPJ+1;

      }

      if ( ! ("E2"v_E1 in vt_E2_E1) ) {
      
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0040";
      #print "FALHA : CNPJ/CPF sem Ponto de Venda correspondente no Tipo de Registro E2. Registro rejeitado!";
      
      }
   
   }
   
   if ( v_CD_OPERACAO == "E" ) {
   
      if ( ! ("E2"v_E1 in vt_E2_E1)) {
      
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0299";
      #print "FALHA : CNPJ/CPF sem Ponto de Venda correspondente no Tipo de Registro E2. Registro rejeitado!";
      
      }
   
   }
   
   if (( v_CD_OPERACAO == "I" ) || ( v_CD_OPERACAO == "A" )) {
   
      v_INDICADOR=substr(vt_E2[substr(v_E1,3,16)],39,1);
   
      if (( ( v_INDICADOR == "S" ) || ( v_TP_PESSOA_CENTRAL != " " ) ) || (( v_BLOCO_CENTRAL ~ "^[0-9]*$" ) && ( v_BLOCO_CENTRAL != "" ) && ( v_BLOCO_CENTRAL != "00000000000000000000000000000" ))) {
      
         if ( v_PV_CENTRAL == "               " ) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0014"
            #print "FALHA : Ponto de Venda Centralizador nao informado. Registro rejeitado!";
         
         }
      
         if (( v_TP_PESSOA_CENTRAL == " " ) && ( v_CNPJ_CPF_CENTRAL != "              " )) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0033";
            #print "FALHA : Tipo Pessoa Centralizador nao informado. Registro rejeitado!";
         
         } else if (( v_TP_PESSOA_CENTRAL != "F" ) && ( v_TP_PESSOA_CENTRAL != "J" )) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0337";
            #print "FALHA : Tipo Pessoa Centralizador "v_TP_PESSOA_CENTRAL" invalido! Registro rejeitado!";
         
         } else if ( v_TP_PESSOA_CENTRAL != v_TP_PESSOA ) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0031";
            #print "FALHA : Tipo Pessoa Centralizador diferente de Tipo Pessoa da Credenciadora. Registro rejeitado!";
         
         }
         
         if (( v_CNPJ_CPF_CENTRAL == "              " ) && ( v_TP_PESSOA_CENTRAL != " " )) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0032";
            #print "FALHA : CNPJ/CPF Centralizador nao informado. Registro rejeitado!";
         
         } else if ( v_CNPJ_CPF_CENTRAL ~ "^[0-9]*$" ) {
         
            if ( v_TP_PESSOA_CENTRAL == "F" ) {
            
	           v_CNPJ_CPF_CENTRAL=substr(vt_E1[v_E1],63,11);
		       rc_CPF=codecpf(v_CNPJ_CPF_CENTRAL);
               
               if ( rc_CPF != 0 ) {
                  
				  v_FG_CPF_CNPJ_CENTRAL=1;
                  v_QT_ERRO=v_QT_ERRO + 1;
                  v_NU_OCORRENCIA=v_NU_OCORRENCIA"0338";         
                  #print "FALHA : CPF informado "v_CNPJ_CPF_CENTRAL" invalido! Registro rejeitado!";
               
               } else {
			   
			      v_FG_CPF_CNPJ_CENTRAL=0;
			   
			   }
            
            
            } else if ( v_TP_PESSOA_CENTRAL == "J" ) {
            
               rc_CNPJ=codecnpj(v_CNPJ_CPF_CENTRAL);
               
               if ( rc_CNPJ != 0 ) {
                  
				  v_FG_CPF_CNPJ_CENTRAL=1;
                  v_QT_ERRO=v_QT_ERRO + 1;
                  v_NU_OCORRENCIA=v_NU_OCORRENCIA"0339";         
                  #print "FALHA : CNPJ informado "v_CNPJ_CPF_CENTRAL" invalido! Registro rejeitado!";
               
               } else {
			   
			      v_FG_CPF_CNPJ_CENTRAL=0;
			   
			   }
            
            }
         
         } else {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0044";         
            #print "FALHA : CNPJ/CPF CENTRAL "v_CNPJ_CPF_CENTRAL" invalido! Registro rejeitado!";
         
         }
         
      } else {
      
         #print "ALERTA: Indicador Financeiro (Nivel E2) igual a N, atributos de centralizador nao serao validados!"
      
      }
	  
   } else {
      
      #print "ALERTA: Codigo Operacao diferente de I e A, Tipo Pessoa Central nao sera validado!";    
      #print "ALERTA: Codigo Operacao diferente de I e A, CNPJ/CPF Central nao sera validado!";                
      #print "ALERTA: Codigo Operacao diferente de I, Ponto de Venda Centralizador nao sera validado";
      
   }
   
   if (( v_NU_CATEG_PROD_FINANCEIRO !~ "^[0-9]*$" ) || ( v_NU_CATEG_PROD_FINANCEIRO != "00" )) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0077";         
      #print "FALHA : Categoria de Produto Financeiro "v_NU_CATEG_PROD_FINANCEIRO" invalido! Registro rejeitado!";
   
   }

   if ( v_CD_OPERACAO == "E" ) {
   
   printf ("%s", v_REGISTRO_E1) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%024d", v_NU_OCORRENCIA) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%d", v_QT_ERRO) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%09d", v_SORT_E1) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%d", v_FG_CPF_CNPJ_CENTRAL) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%d\n", v_FG_PDV_CENTRAL) >> f_NOM_ARQ_DEL_P1 ;

   } else {
   
   printf ("%s", v_SORT_E1"|") > f_NOM_ARQ_E1_TEMP
   printf ("%s", v_REGISTRO_E1) >> f_NOM_ARQ_E1_TEMP ;
   printf ("%024d", v_NU_OCORRENCIA) >> f_NOM_ARQ_E1_TEMP ;
   printf ("%d", v_QT_ERRO) >> f_NOM_ARQ_E1_TEMP ;
   printf ("%09d", v_SORT_E1) >> f_NOM_ARQ_E1_TEMP ;
   printf ("%d", v_FG_CPF_CNPJ_CENTRAL) >> f_NOM_ARQ_E1_TEMP ;
   printf ("%d\n", v_FG_PDV_CENTRAL) >> f_NOM_ARQ_E1_TEMP ;
   
   }
   
   if ( v_QT_ERRO != 0 ) {

      v_QT_REG_E1_REJ=v_QT_REG_E1_REJ+1;
   
   } else {
   	   
	   v_QT_REG_E1_ACP=v_QT_REG_E1_ACP+1;
   
   }

}

for ( v_E2 in vt_E2 ) {

   if ( vt_E2[v_E2] != "" ){

   v_CD_OPERACAO=substr(vt_E2[v_E2],3,1);
   v_PONTO_VENDA=substr(vt_E2[v_E2],19,15);
   v_MCC=substr(vt_E2[v_E2],34,5);
   v_INDICADOR=substr(vt_E2[v_E2],39,1);
   v_SIT_PAG_CLIENTE=substr(vt_E2[v_E2],40,1);
   v_REG_FOUND=substr(vt_E2[v_E2],3);
   v_CNPJ_CPF=substr(vt_E2[v_E2],5,14);
   v_TP_PESSOA=substr(vt_E2[v_E2],4,1);
   v_QT_ERRO=0;
   v_SORT_E2=substr(vt_E2[v_E2],match(vt_E2[v_E2],"|")+1);
   v_CNPJ_CPF_CENTRAL=substr(vt_E2[v_E2],60,14);
   v_CONCATECACAO=v_CD_OPERACAO v_TP_PESSOA v_CNPJ_CPF v_PONTO_VENDA;
   v_REGISTRO_E2=substr(vt_E2[v_E2],1,40);
   v_QT_ERRO=0;
   v_NU_OCORRENCIA=""
   
   if (( v_CD_OPERACAO == "I" ) || ( v_CD_OPERACAO == "E" ) || ( v_CD_OPERACAO == "A" )) {
   
   } else {   
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0009";
      #print "FALHA : Codigo da Operacao " v_CD_OPERACAO " invalido! Registro rejeitado!"
    
   }
      
   if (( v_TP_PESSOA != "F" ) && ( v_TP_PESSOA != "J" )) {
   
   v_QT_ERRO=v_QT_ERRO + 1;
   v_NU_OCORRENCIA=v_NU_OCORRENCIA"0010";
   #print "FALHA : Tipo de Pessoa " v_TP_PESSOA " invalido! Registro rejeitado!";
   
   }

   if (( v_CNPJ_CPF ~ "^[0-9]*$" ) && ( v_CNPJ_CPF != "" )) {
   
      if ( v_TP_PESSOA == "F" ) {
      
	     v_CNPJ_CPF=substr(vt_E2[v_E2],8,11);
		 rc_CPF=codecpf(v_CNPJ_CPF);

         if ( rc_CPF != 0 ) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0011";
            #print "FALHA : CPF " v_CNPJ_CPF " invalido! Registro rejeitado!"
         
         }
      
      } else { 
      
         if ( v_TP_PESSOA == "J" ) {
         
            rc_CNPJ=codecnpj(v_CNPJ_CPF);
            
            if ( rc_CNPJ != 0 ) {
               
               v_QT_ERRO=v_QT_ERRO + 1;
               v_NU_OCORRENCIA=v_NU_OCORRENCIA"0012";         
               #print "FALHA : CNPJ " v_CNPJ_CPF " invalido! Registro rejeitado!"
            
            }
         
         }
      
      }
   
   } else {
   
   v_QT_ERRO=v_QT_ERRO + 1;
   v_NU_OCORRENCIA=v_NU_OCORRENCIA"0044";
   #print "FALHA : CNPJ/CPF " v_CNPJ_CPF " nao numerico! Registro rejeitado!"
   
   }
   
   if (( v_CNPJ_CPF_CENTRAL ~ v_REGISTRO_E2 ) && ( v_PV_CENTRAL ~ v_REGISTRO_E2 )) {

      v_NU_REG_FOUND_PDV=v_NU_REG_FOUND_PDV+1;

   }
   
   if (( v_PONTO_VENDA == "" ) || ( v_PONTO_VENDA == "               " )) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0014";         
      #print "FALHA : Ponto de Venda nao informado. Registro rejeitado!";
   
   }
   
   if ( v_CD_OPERACAO == "I" ) {
   
      if ( ! ( v_E2 in vt_E3 ) ) {
      
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0041";         
         #print "FALHA : Ponto de Venda sem Domicilio Bancario correspondente no Tipo de Registro E3. Registro rejeitado!";   
      
      }   
               
   }
   
   if ( v_CD_OPERACAO == "E" ) {
   
      if ( ! ( v_E2 in vt_E3 ) ) {
   
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0300";         
         #print "FALHA : Ponto de Venda sem Domicilio Bancario correspondente no Tipo de Registro E3. Registro rejeitado!";   
      
      }
      
   }
   
   if (( v_CD_OPERACAO == "I" ) || ( v_CD_OPERACAO == "A" )) {
   
      if ( v_MCC !~ "^[0-9]*$" ) {
         
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0017";         
         #print "FALHA : MCC nao informado ou nao numerico . Registro rejeitado!"; 
         
      }
      
      if (( v_INDICADOR != "S" ) && ( v_INDICADOR != "N" )) {
          
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0019";         
         #print "FALHA : Indicador(Transacoes financeiras) "v_INDICADOR" invalido! Registro rejeitado!"; 
         
      }
      
      if (( v_SIT_PAG_CLIENTE != "A" ) && ( v_SIT_PAG_CLIENTE != "B" )) {
          
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0020";         
         #print "FALHA : Situacao de Pagamento Cliente "v_SIT_PAG_CLIENTE" invalido! Registro rejeitado!"; 
         
      }
   
   } else {
   
      #print "ALERTA: Codigo Operacao diferente de I, Ponto de Venda nao sera validado!"
      #print "ALERTA: Codigo Operacao diferente de I e A, MCC nao sera validado!"
      #print "ALERTA: Codigo Operacao diferente de I e A, Indicador (Transacoes financeiras) nao sera validado!"
      #print "ALERTA: Codigo Operacao diferente de I e A, Situacao de Pagamento Cliente nao sera validado!"        
   
   }
   
   if ( v_CD_OPERACAO == "E" ) {
   
   printf ("%s", v_REGISTRO_E2) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%024d", v_NU_OCORRENCIA) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%d", v_QT_ERRO) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%09d\n", v_SORT_E2) >> f_NOM_ARQ_DEL_P1 ;

   } else {
   
   printf ("%s", v_SORT_E2"|") > f_NOM_ARQ_E2_TEMP ;
   printf ("%s",v_REGISTRO_E2) >> f_NOM_ARQ_E2_TEMP ;
   printf ("%024d",v_NU_OCORRENCIA) >> f_NOM_ARQ_E2_TEMP ;
   printf ("%d",v_QT_ERRO) >> f_NOM_ARQ_E2_TEMP ;
   printf ("%09d\n",v_SORT_E2) >> f_NOM_ARQ_E2_TEMP ;
   
   }	
   
   }
   
   if ( v_QT_ERRO != 0 ) {

      v_QT_REG_E2_REJ=v_QT_REG_E2_REJ+1;
   
   } else {
   	   
	   v_QT_REG_E2_ACP=v_QT_REG_E2_ACP+1;
   
   }

}

for ( v_E3 in vt_E3 ) {
   
   v_CD_OPERACAO=substr(vt_E3[v_E3],3,1);
   v_PONTO_VENDA=substr(vt_E3[v_E3],19,15);
   v_BANCO_DOMICILIO_DEBITO=substr(vt_E3[v_E3],34,4);
   v_AGENCIA_BANCO_DOCIMICILIO_DEBITO=substr(vt_E3[v_E3],38,5);
   v_CONTA_DOMICILIO_DEBITO=substr(vt_E3[v_E3],43,14);
   v_BANCO_DOMICILIO_CREDITO=substr(vt_E3[v_E3],57,4);
   v_AGENCIA_BANCO_DOCIMICILIO_CREDITO=substr(vt_E3[v_E3],61,5);
   v_CONTA_DOMICILIO_CREDITO=substr(vt_E3[v_E3],66,14);
   v_TRAVA_DOMICILIO=substr(vt_E3[v_E3],80,1);
   V_DT_INICIO_TRAVA=substr(vt_E3[v_E3],81,8);
   v_SORT_E3=substr(vt_E3[v_E3],match(vt_E3[v_E3],"|")+1);
   V_DT_FIM_TRAVA=substr(vt_E3[v_E3],89,8);
   v_REGISTRO_E3=substr(vt_E3[v_E3],1,96);
   v_TP_PESSOA=substr(vt_E3[v_E3],4,1);
   v_CNPJ_CPF=substr(vt_E3[v_E3],5,14);
   v_QT_ERRO=0;
   v_NU_OCORRENCIA=""
   
   if (( v_CD_OPERACAO == "I" ) || ( v_CD_OPERACAO == "E" ) || ( v_CD_OPERACAO == "A" )) {
   
   } else {   
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0009";
      #print "FALHA : Codigo da Operacao " v_CD_OPERACAO " invalido! Registro rejeitado!"
    
   }
      
   if (( v_TP_PESSOA != "F" ) && ( v_TP_PESSOA != "J" )) {
   
   v_QT_ERRO=v_QT_ERRO + 1;
   v_NU_OCORRENCIA=v_NU_OCORRENCIA"0010";
   #print "FALHA : Tipo de Pessoa " v_TP_PESSOA " invalido! Registro rejeitado!";
   
   }

   if (( v_CNPJ_CPF ~ "^[0-9]*$" ) && ( v_CNPJ_CPF != "" )) {
   
      if ( v_TP_PESSOA == "F" ) {
      
	     v_CNPJ_CPF=substr(vt_E3[v_E3],8,11);
		 rc_CPF=codecpf(v_CNPJ_CPF);
         
         if ( rc_CPF != 0 ) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0011";
            #print "FALHA : CPF " v_CNPJ_CPF " invalido! Registro rejeitado!"
         
         }
      
      } else { 
      
         if ( v_TP_PESSOA == "J" ) {
         
            rc_CNPJ=codecnpj(v_CNPJ_CPF);
            
            if ( rc_CNPJ != 0 ) {
               
               v_QT_ERRO=v_QT_ERRO + 1;
               v_NU_OCORRENCIA=v_NU_OCORRENCIA"0012";         
               #print "FALHA : CNPJ " v_CNPJ_CPF " invalido! Registro rejeitado!"
            
            }
         
         }
      
      }
   
   } else {
   
   v_QT_ERRO=v_QT_ERRO + 1;
   v_NU_OCORRENCIA=v_NU_OCORRENCIA"0044";
   #print "FALHA : CNPJ/CPF " v_CNPJ_CPF " nao numerico! Registro rejeitado!"
   
   }
   
   if (( v_PONTO_VENDA == "" ) || ( v_PONTO_VENDA == "               " )) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0014";         
      #print "FALHA : Ponto de Venda nao informado. Registro rejeitado!"; 
      
   }
   
   if ( v_BANCO_DOMICILIO_DEBITO !~ "^[0-9]*$" ) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0024";         
      #print "FALHA : Banco Domicilio Plataforma Debito nao informado ou nao numerico. Registro rejeitado!"; 
   
   }
   
   if ( v_AGENCIA_BANCO_DOCIMICILIO_DEBITO !~ "^[0-9]*$" ) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0025";         
      #print "FALHA : Agencia do Banco Domicilio Plataforma Debito nao informado ou nao numerico. Registro rejeitado!"; 
   
   }
   
   if (( v_CONTA_DOMICILIO_DEBITO == "" ) || ( v_CONTA_DOMICILIO_DEBITO == "              " )) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0026";         
      #print "FALHA : Conta do Domicilio Bancario Plataforma Debito nao informado. Registro rejeitado!"; 
   
   }

   if ( v_BANCO_DOMICILIO_CREDITO !~ "^[0-9]*$" ) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0024";         
      #print "FALHA : Banco Domicilio Plataforma Credito nao informado ou nao numerico. Registro rejeitado!"; 
   
   }
   
   if ( v_AGENCIA_BANCO_DOCIMICILIO_CREDITO !~ "^[0-9]*$" ) {
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0025";         
      #print "FALHA : Agencia do Banco Domicilio Plataforma Credito nao informado ou nao numerico. Registro rejeitado!"; 
   
   }
   
   if (( v_CONTA_DOMICILIO_CREDITO == "" ) || ( v_CONTA_DOMICILIO_CREDITO == "              " )){
   
      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0026";         
      #print "FALHA : Conta do Domicilio Bancario Plataforma Credito nao informado. Registro rejeitado!"; 
   
   }
   
   if ( v_CD_OPERACAO == "I" ){
   
      if (( v_TRAVA_DOMICILIO != "N" ) && ( v_TRAVA_DOMICILIO != "S" )) {
      
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0023";         
         #print "FALHA : Trava no Domicilio Bancario "v_TRAVA_DOMICILIO" invalido. Registro rejeitado!"; 
      
      }
   
   }
   
   if (( v_CD_OPERACAO == "I" ) || ( v_CD_OPERACAO == "A" )) {
   
      if (( V_DT_INICIO_TRAVA == "        " ) && ( v_TRAVA_DOMICILIO == "S" )) {
      
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0062";         
         #print "FALHA : Data de Inicio da Trava no Domicilio Bancario nao informada. Registro rejeitado!"; 
      
      } else if (( V_DT_INICIO_TRAVA != "        " ) && ( v_TRAVA_DOMICILIO == "S" )) {
      
         if ( V_DT_INICIO_TRAVA !~ "^[0-9]*$" ) {
         
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0062";         
            #print "FALHA : Data de Inicio da Trava nao numerica. Registro rejeitado!"; 
         
         } else {
            
            if ( (FNC_Valida_Data(V_DT_INICIO_TRAVA)) == 0 ) {
            
               v_QT_ERRO=v_QT_ERRO + 1;
               v_NU_OCORRENCIA=v_NU_OCORRENCIA"0062";         
               #print "FALHA : Data de Inicio da Trava invalida. Registro rejeitado!";
            
            }
         
         }
      
      }
	  
	  if (( V_DT_FIM_TRAVA == "        " ) && ( v_TRAVA_DOMICILIO == "S" )) {

      v_QT_ERRO=v_QT_ERRO + 1;
      v_NU_OCORRENCIA=v_NU_OCORRENCIA"0063";         
      #print "FALHA: Data de Fim da Trava no Domicilio Bancario nao informada. Registro rejeitado!";
   
      } else if (( V_DT_FIM_TRAVA != "        " ) && ( v_TRAVA_DOMICILIO == "S" )) {
      
         if ( V_DT_FIM_TRAVA !~ "^[0-9]*$" ) {
      
         v_QT_ERRO=v_QT_ERRO + 1;
         v_NU_OCORRENCIA=v_NU_OCORRENCIA"0063";         
         #print "FALHA : Data de Fim da Trava nao numerica. Registro rejeitado!";
      
      } else {
      
         if ( (FNC_Valida_Data (V_DT_FIM_TRAVA)) == 0 ) {
	     
            v_QT_ERRO=v_QT_ERRO + 1;
            v_NU_OCORRENCIA=v_NU_OCORRENCIA"0063";         
            #print "FALHA : Data de Fim da Trava invalida. Registro rejeitado!"
	     
	        }
      
         }
      
      }
  
   } else {
   
      #print "ALERTA: Codigo Operacao diferente de I, Trava no Domicilio Bancario nao sera validado!";
      #print "ALERTA: Codigo Operacao diferente de I e A, Data de Inicio da Trava no Domicilio Bancario nao sera validado!";
      #print "ALERTA: Codigo Operacao diferente de I e A, Data de Inicio da Trava no Domicilio Bancario nao sera validado!";
	  
   }
   
   if ( v_CD_OPERACAO == "E" ) {
   
   printf ("%s", v_REGISTRO_E3) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%024d", v_NU_OCORRENCIA) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%d", v_QT_ERRO) >> f_NOM_ARQ_DEL_P1 ;
   printf ("%09d\n", v_SORT_E3) >> f_NOM_ARQ_DEL_P1 ;

   } else {
   
   printf ("%s", v_SORT_E3"|") > f_NOM_ARQ_E3_TEMP ;
   printf ("%s", v_REGISTRO_E3) >> f_NOM_ARQ_E3_TEMP ;
   printf ("%024d", v_NU_OCORRENCIA) >> f_NOM_ARQ_E3_TEMP ;
   printf ("%d", v_QT_ERRO) >> f_NOM_ARQ_E3_TEMP ;
   printf ("%09d\n", v_SORT_E3) >> f_NOM_ARQ_E3_TEMP ;
   
   }

   if ( v_NU_OCORRENCIA != "" ) {
      
	  v_TP_STATUS_PROC_ARQ=1;
   
   }
   
   if ( v_QT_ERRO != 0 ) {

      v_QT_REG_E3_REJ=v_QT_REG_E3_REJ+1;
   
   } else {
   	   
	   v_QT_REG_E3_ACP=v_QT_REG_E3_ACP+1;
   
   }

   
}

printf v_QT_REG_E1_ACP" "v_QT_REG_E1_REJ" "v_QT_REG_E2_ACP" "v_QT_REG_E2_REJ" "v_QT_REG_E3_ACP" "v_QT_REG_E3_REJ"\n" > f_ARQ_RETORNO;

}' ${f_NOM_ARQ_SRC}

RC_AWK=$?

FNC_Arq_Retorno ${v_TP_STATUS_PROC_ARQ} ${vf_NU_RMSA} ${vf_DT_CICLO} $(cat ${f_ARQ_RETORNO})

RC_RETORNO=$?

#Verifica se o arquivo foi criado e em caso negativo gera arquivo vazio.
if [ ! -f "${f_NOM_ARQ_E1_TEMP}" ]
then
	touch ${f_NOM_ARQ_E1}
	
else

   sort -t"|" -k1n ${f_NOM_ARQ_E1_TEMP} | cut -d'|' -f2 > ${f_NOM_ARQ_E1}
   
fi

#Verifica se o arquivo foi criado e em caso negativo gera arquivo vazio.
if [ ! -f "${f_NOM_ARQ_E2_TEMP}" ]
then

	touch ${f_NOM_ARQ_E2}
	
else

   sort -t"|" -k1n ${f_NOM_ARQ_E2_TEMP} | cut -d'|' -f2 > ${f_NOM_ARQ_E2}
   
fi

#Verifica se o arquivo foi criado e em caso negativo gera arquivo vazio.
if [ ! -f "${f_NOM_ARQ_E3_TEMP}" ]
then

	touch ${f_NOM_ARQ_E3}

else

   sort -t"|" -k1n ${f_NOM_ARQ_E3_TEMP} | cut -d'|' -f2 > ${f_NOM_ARQ_E3}
   
fi

#Orderna pelas colunas TIPO_PESOA/CPF_CNPJ(4-18) e TIPO_REGISTRO(1-2)
if [ -f "${f_NOM_ARQ_DEL_P1}" ] 
then
	sort -k 1.4,1.18 -k 1.1,1.2 ${f_NOM_ARQ_DEL_P1} >> ${f_NOM_ARQ_DEL_P2} 
	FNC_Nivel_Exclusao 
else
	touch ${f_NOM_ARQ_DEL}
fi

rm -f ${f_NOM_ARQ_E1_TEMP}
rm -f ${f_NOM_ARQ_E2_TEMP}
rm -f ${f_NOM_ARQ_E3_TEMP}
	
FNC_Log "### ALERTA: Termino do Processo: SPROCE_VALIDA_DETAHE_0001.sh -> Bandeira: ${p_CD_BANDEIRA} - Credenciadora: ${p_CD_CREDENCIADORA} <- ###"

if [ ${RC_AWK} -eq 0 -a ${RC_RETORNO} -eq 0 ]
   then

   FNC_Exit 0

   else
   
   FNC_Exit 1
   
fi
