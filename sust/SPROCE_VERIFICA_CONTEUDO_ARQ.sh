#!/bin/bash

NM_ARQ=$1
TIPO_PLTF=$2

data=`date +%Y-%m-%d %H:%M:%S`
data2=`date +%Y-%m-%d`

if
	[ `$Param_Arq_Entrada | wc -c` -eq 0 ] 
		then
			touch /etlsys/pceproce/processadora/logs/GRADE_ERR.log
			echo "[$data] [$data] [007] [GRADE] [7253] [Cielo Transitório] [${TIPO_PLTF}] [Acionar o time de sustentação responsável] [100] [Arquivo ${NM_ARQ} vazio]" >> /etlsys/pceproce/processadora/logs/GRADE_ERR-$data2.log
			exit 2
fi