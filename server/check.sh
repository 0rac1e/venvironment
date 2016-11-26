#!/bin/bash

. /etc/balance/vars

OLDIF1=0
OLDIF2=0

. /etc/balance/routing.sh
while true; do


ping -c 3 -s 100 $P1 -I $IF1 > /dev/null
if [ $? -ne 0 ]; then
echo "Failed IF1!"
NEWIF1=0
else
NEWIF1=1
fi

ping -c 3 -s 100 $P2 -I $IF2 > /dev/null
if [ $? -ne 0 ]; then
echo "Failed IF2!"
NEWIF2=0
else
NEWIF2=1
fi

if (( ($NEWIF1!=$OLDIF1) || ($NEWIF2!=$OLDIF2) )); then
echo "Changing routes"

if (( ($NEWIF1==1) && ($NEWIF2==1) )); then
echo "Both channels"
ip route delete default
ip route add default scope global nexthop via $P1 dev $IF1 weight $W1 \
nexthop via $P2 dev $IF2 weight $W2
elif (( ($NEWIF1==1) && ($NEWIF2==0) )); then
echo "First channel"
ip route delete default
ip route add default via $P1 dev $IF1
elif (( ($NEWIF1==0) && ($NEWIF2==1) )); then
echo "Second channel"
ip route delete default
ip route add default via $P2 dev $IF2
fi

else
echo "Not changed"
fi

OLDIF1=$NEWIF1
OLDIF2=$NEWIF2
sleep 3
done