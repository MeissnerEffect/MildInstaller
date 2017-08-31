#!/bin/bash
OUTFILE=create_user.sh
CUSERNAME=$(id -un)
CUID=$(id -u)
CPGID=$(id -g)
CPGIDNAME=$(cat /etc/group | grep "${CPGID}:")
#cat /etc/group | grep $CUSERNAME | tr ':' ' '| awk '{ printf("groupadd -g %d %s &> /dev/null\n", $3,$1) }' > $OUTFILE
cat /etc/group |grep $CUSERNAME|tr ':' ' '|awk '{printf("groupadd -og %d g%d\n",$3,$3)}' > $OUTFILE
#CUSERGROUP=$(cat /etc/group | grep $CUSERNAME  | tr ":" " " | awk '{ print $1}' | tr '\n' ',' | sed s/.$//)
CUSERGROUP=$(cat /etc/group | grep $CUSERNAME  | tr ":" " " | awk '{ print $3}' | tr '\n' ',' | sed s/.$//)
echo "mkdir -p $(dirname $HOME)" >> $OUTFILE 
echo "useradd -o -b / -d $HOME -m -G ${CUSERGROUP} -U -u $CUID $CUSERNAME" >> $OUTFILE
