#/usr/bin/env bash

#--------------------------------------------------------------------
# Lista o estado das ECF da loja.
# By Matheus
# Data: 12/01/2023
# v1.0
# By Matheus e Lima e Gabriel
# Data: 13/01/2023
# v2.0

##------------------------ Variaveis -----------------------
source /root/Adinilson/tools/functions.sh

SSH='sshpass -p root123 ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

LOJA="$(__valida_loja $1)"
IPFL="$(lsecf ${LOJA}|grep '172.'|awk -F \| '{print $4}')"


##------------------------ Funcoes ------------------------


MICR="$(for i in ${IPFL}; do ping -i 0.0001 -c2 -q $i &>- && echo $(__ip_micro $i) ; done)"

for x in ${MICR}; do
    ${SSH} root@${x} 'dmesg -c &>-'
    atu_usb ${x} &>-
    sleep 2
    sh /root/Adinilson/pdv/atu_pinpad.sh ${x} &>-
    sleep 2
    MIC=${x}
    ##MIC=$(${SSH} root@${x} 'dmesg|egrep -qi "(PPC930)"|cut -d\ -f5  >/dev/null 2>/dev/null; echo '${x}'')
    ##PIN="$(${SSH} root@${MIC} 'dmesg|egrep -i "(PPC930)"|cut -d\  -f5 >/dev/null 2>/dev/null; [ ! -z $? ] && echo 0 || echo 1;')"
    ##PIN="$(${SSH} root@${MIC} 'dmesg|egrep -i "(PPC930)" &>- ; [ $? -eq 0 ] && echo 0 || echo 1;')"
    PIN="$(${SSH} root@${MIC} 'dmesg|egrep -i "(PPC930)" &>- ; echo $?;')"
    [ $PIN -eq 0  ] && {
        echo -e  "\033[40;36;1m ${MIC} - Modelo:PPC930  \033[0m"
    } || echo -e "\033[40;36;1m ${MIC} - Pinpad não comunicando ou modelo antigo. Favor validar e caso seja modelo antigo passar para o SOS!!!\033[0m"
done




   # echo "$MIC - ${PIN}"

echo -e "\033[0;32m ==== Fim ====  \033[0m"
exit
