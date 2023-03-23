#/usr/bin/env bash

#--------------------------------------------------------------------
# Verifica se o Pinpad da Verde está comunicando, ajusta e informa o modelo.
# By Matheus
# Data: 23/01/2023
# v1.0
# By Matheus
# Data: 23/01/2023
# v2.0

##------------------------ Variaveis -----------------------

source /root/Adinilson/tools/functions.sh

SSH='sshpass -p root123 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

MICRO="$(__valida_micro $1)"

##------------------------ Funcoes ------------------------


for x in ${MICRO}; do
    #${SSH} root@${MICRO} 'dmesg -c &>-'
    atu_usb ${MICRO} &>-
    sleep 2
    atu_prefsjs ${x} &>-
    sleep 2
    MIC=${x}
    PIN="$(${SSH} root@${MIC} '
        if lsusb|grep -iq "DATECS"; then
                 echo DATECS;
        elif lsusb|grep -iq "Mobile PO"; then
                 echo GERTEC;
        else echo Não comunicando;

        fi
    ')"

   [[ -n "${PIN}" ]] && echo -e  "\033[40;36;1m ${MIC} - ${PIN} \033[0m"

done

    echo -e "\033[0;32m ==== Fim ====  \033[0m"
exit
