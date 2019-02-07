#!/bin/bash

v_NOME_ARQUIVO=""
v_BANDEIRA=""
v_CREDENCIADORA=""
v_DIRETORIO="/etlsys/pceproce/processadora/credenciadora/cadastro/cnpj_mensal/recebidos"
v_DIRETORIO_PARAM="/etlsys/pceproce/infa_shared_2/BWParam"

if [ -f ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par ]
then
	rm ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
fi

touch ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

if [ -f ${v_DIRETORIO}/BAT_CAD_CNPJ_CPF_TX_* ]
then
     v_NOME_ARQUIVO=`ls -lt ${v_DIRETORIO}/BAT_CAD_CNPJ_CPF_TX_* | head -1 | awk '{ print $NF }'`
     v_BANDEIRA=`echo ${v_NOME_ARQUIVO} | cut -d'_' -f7 | cut -c1-3`
     v_CREDENCIADORA=`echo ${v_NOME_ARQUIVO} | cut -d'_' -f7 | cut -c4-7`
else
     echo "Nao existe arquivo"  >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
fi


echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 09 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[global]"																												>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 																						>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA} 																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_ARQV_PCSM=2" 																									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0009_EPROPRCEXT_ABRE_REMESSA_01]"										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2" 																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_CICL_PCSM_CDST=TBCCRR_CICL_PCSM_CDST" 																>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_CNTR_RMSA_CDST=TBCCRR_CNTR_RMSA_CDST" 																>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR" 																								>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0009_EPROPRCEXT_ABRE_REMESSA_01_002403.log" 														>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 12 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0012_EPROPRCEXT_PARAMETRO_01]"											>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_Bad_CicloProcessameto=AOPROPRC002501_"                                 									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_Bad_RemessaCredenciadora=AOPROPRC002601_"                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_Bad_TipoRegistro=AO_0012_EPROPRCEXT_PARAMETRO_01_01_TIPO_REGISTRO.bad" 									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_CicloProcessameto=AOPROPRC002501_"                                     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_RemessaCredenciadora=AOPROPRC002601_"                                  									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_TipoRegistro=AO_0012_EPROPRCEXT_PARAMETRO_01_01_TIPO_REGISTRO.txt"     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_CICL_PCSM_CDST=TBCCRR_CICL_PCSM_CDST"                           									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_CNTR_RMSA_CDST=TBCCRR_CNTR_RMSA_CDST"                           									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_CRDE_BNDR=TBCCRR_CRDE_BNDR"                                     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_TIPO_RGST=TBCCRR_TIPO_RGST"                                     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0012_EPROPRCEXT_PARAMETRO_01_002703.log"                      									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_ARQV_PCSM=2"                                                                 									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA} 			                                    									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}                                       									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Arq=.txt"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Bad=.bad"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO DE PARAMETRO TASK DO SESSION 28 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                            								>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                            									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$Param_Cmd_EXECUTA_SCRIPT=/etlsys/pceproce/infa_shared_2/Scripts/SPROCE_VALIDA_REMESSA_MENSAL_0001.sh" 		 	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 29 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01]"							>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2"                                                                                >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_ARQV_PCSM=2"                                                                                                   >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$Param_Cmd_EXECUTA_SCRIPT=/etlsys/pceproce/infa_shared_2/Scripts/SPROCE_VALIDA_DETALHE_MENSAL_0001.sh"				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamOwner_CCR=CCR"                                                                                               >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamArqName_Source_01=AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01_"                                         >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_01=AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01"                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_002903.log"                                         >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE2=_E2"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE3=_E3"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqR0=_R0"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE1=_E1"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Arq=.txt"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Bad=.bad"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_Valido=AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"                                               >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                            								>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                                                              >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}																			>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par		
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA}           		                                                                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 30 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01]"									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"																				>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"	                                                                            >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                            								>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                                                              >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_01=AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01"                                        >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_02=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01_01"                                               >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Target_01=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01_01"                                               >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamOwner_CCR=CCR"                                                                                               >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqCLNT=_CLNT"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE1=_E1"                                                                                                     >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqLOG=_LOG"                                                                                                   >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqRJTD=_RJTD"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2"                                                                                >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_01=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01"                                                           >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_02=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01"                                                           >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_03=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01"                                                           >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_04=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01"                                                           >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_003003.log"                                                   >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqCLNT=_CLNT"                                                                                             >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqLOG=_LOG"                                                                                               >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqRJTD=_RJTD"                                                                                             >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE1=_E1"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Arq=.txt"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Bad=.bad"  																								>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}																			>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par		
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA}                                                                                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 31 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_01]"								>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"	                                        									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"	                                        									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                        									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                        										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_01=AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01"  										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Target_01=AB_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_01_01"     										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamOwner_CCR=CCR"                                                         										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE2=_E2"                                                               										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqLOG=_LOG"                                                             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqPDV=_PDV"                                                             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqRJTD=_RJTD"                                                           										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2"                                         										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_01=AB_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_01_01"             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_02=AB_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_01_01"             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_03=AB_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_01_01"             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_04=AB_0031_EPROPRCEXT_PONTO_VENDA_01_BAT_MENSAL_01"             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR"                                                          										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CPR=CPR"                                                          										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_003103.log"        										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE2=_E2"                                                          										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqLOG=_LOG"                                                        										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqRJTD=_RJTD"                                                      										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Arq=.txt"                                                          										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Bad=.bad"                                                          										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqPDV=_PDV"                                                        										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}																			>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par		
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA}                                             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 32 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0032_EPROPRCEXT_DOMICILIO_BANCARIO_BAT_MENSAL_01]"						>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"	                                        									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"	                                        									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                        									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                        										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}																			>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par		
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA}                                             										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_01=AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01"										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Target_01=AB_0032_EPROPRCEXT_DOMICILIO_BANCARIO_BAT_MENSAL_01_01"  									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamOwner_CCR=CCR"                                                             									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE3=_E3"                                                                   									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqRJTD=_RJTD"                                                               									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2"                                             									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_01=AB_0032_EPROPRCEXT_DOMICILIO_BANCARIO_01_01"                     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_02=AB_0032_EPROPRCEXT_DOMICILIO_BANCARIO_01_01"                     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0032_EPROPRCEXT_DOMICILIO_BANCARIO_BAT_MENSAL_003203.log"     									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE3=_E3"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqRJTD=_RJTD"                                                          									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Arq=.txt"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Bad=.bad"                                                              									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 34 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0034_EPROPRCEXT_RETORNO_BAT_MENSAL_01]"									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"	                                        	 			                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"	                                        	 			                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                        	 			                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                        	 			                    	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}										 					            	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA}                                             	 			                    	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_01=AB_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01"                                      	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_02=AB_0030_EPROPRCEXT_CLIENTE_BAT_MENSAL_01_01"                                             	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_03=AB_0031_EPROPRCEXT_PONTO_VENDA_BAT_MENSAL_01_01"                                         	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_04=AB_0032_EPROPRCEXT_DOMICILIO_BANCARIO_BAT_MENSAL_01_01"                                  	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_05=AB_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01"                                      	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Source_06=AB_0029_EPROPRCEXT_VALIDA_DETALHE_BAT_MENSAL_01_01"                                      	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$ParamArqName_Target_01=BAT_CAD_CNPJ_CPF_RX"                                                                     	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE0=_E0"                                                                                                   	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE1=_E1"                                                                                                   	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE2=_E2"                                                                                                   	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE3=_E3"                                                                                                   	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqE9=_E9"                                                                                                   	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqR0=_R0"                                                                                                   	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$TP_ArqRET=.ret"                                                                                                 	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TargeProcessadoraDir=/etlsys/pceproce/processadora/credenciadora/cadastro/cnpj_mensal/retorno"             	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamBadFile_01=AO_0034_EPROPRCEXT_RETORNO_01_01"                                                                	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0034_EPROPRCEXT_RETORNO_BAT_MENSAL_003403.log"                                                	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE2=_E2"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE3=_E3"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqR0=_R0"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_TP_ArqRET=.ret"                                                                                            	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE0=_E0"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE1=_E1"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tp_ArqE9=_E9"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Arq=.txt"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ext_Bad=.bad"                                                                                              	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Arq_Valido=AO_0028_EPROPRCEXT_VALIDA_REMESSA_BAT_MENSAL_01_01_"                                            	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_ProcessadoraDirRecebido=/etlsys/pceproce/processadora/credenciadora/cadastro/cnpj_mensal/recebidos"			>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_ProcessadoraDirProcessado=/etlsys/pceproce/processadora/credenciadora/cadastro/cnpj_mensal/processados"		>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par

echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "########## BLOCO ARQUIVO DE PARAMETRO SESSION 20 ################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "#################################################################"													>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "[PROCESSADORA_R2.WF:wf_SIMULA_BATIMENTO.ST:s_0020_EPROPRCEXT_FECHA_REMESSA_01]"										>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Ini='2017-07-06 00:00:00'"	                                        	 			                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Ref_Fim='2017-07-07 00:00:00'"	                                        	 			                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_BANDEIRA="${v_BANDEIRA} 			                                        	 			                    >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$\$CD_CREDENCIADORA="${v_CREDENCIADORA}                                        	 			                    	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_CREDENCIADORA="${v_CREDENCIADORA}										 					            	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_CD_BANDEIRA="${v_BANDEIRA}                                             	 			                    	>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$DBConnection_PROCE=CN_ORCL_PROCE_R2"                                             									>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$Param_Tab_TBCCRR_CNTR_RMSA_CDST=TBCCRR_CNTR_RMSA_CDST"																>> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$ParamOwner_CCR=CCR"                                                                                                 >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par
echo "\$PMSessionLogFile=s_0020_EPROPRCEXT_FECHA_REMESSA_01_003503.log"                                                     >> ${v_DIRETORIO_PARAM}/wf_SIMULA_BATIMENTO.par