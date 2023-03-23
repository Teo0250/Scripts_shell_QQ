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
    sh /root/Adinilson/webcam/ajutsta.sh &>-
    sleep 2
    MIC=${x}
    PIN="$(${SSH} root@${MIC} '
        if lsusb|grep -iq "C270"; then
                echo Webcam C270;
        elif lsusb|grep -iq "C505"; then
                echo Webcam C505;
        elif lsusb|grep -iq "C920"; then
                echo Webcam C920;
        elif lsusb|grep -iq "C920E"; then
                echo Webcam C902E;
        elif lsusb|grep -iq "C920S"; then
                echo Webcam C920S;
        elif lsusb|grep -iq "C925"; then
                echo Webcam C925;
        else echo Não comunicando ou sem webcam no micro;

        fi
    ')"

   [[ -n "${PIN}" ]] && echo -e  "\033[40;36;1m ${MIC} - ${PIN} \033[0m"

done

    echo -e "\033[0;32m ==== Fim ====  \033[0m"
exit
