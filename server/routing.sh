#!/bin/bash

. /etc/balance/vars

echo "1" > /proc/sys/net/ipv4/ip_forward


ip route add $P1_NET dev $IF1 src $IP1 table $TBL1 > /dev/null 2>&1
ip route add default via $P1 table $TBL1 > /dev/null 2>&1
ip route add $P2_NET dev $IF2 src $IP2 table $TBL2 > /dev/null 2>&1
ip route add default via $P2 table $TBL2 > /dev/null 2>&1

ip route add $P1_NET dev $IF1 src $IP1 > /dev/null 2>&1
ip route add $P2_NET dev $IF2 src $IP2

ip route add default via $P1 > /dev/null 2>&1

ip rule add from $IP1 table $TBL1 > /dev/null 2>&1
ip rule add from $IP2 table $TBL2 > /dev/null 2>&1


ip route add $P0_NET dev $IF0 table $TBL1 > /dev/null 2>&1
ip route add $P2_NET dev $IF2 table $TBL1 > /dev/null 2>&1
ip route add 127.0.0.0/8 dev lo table $TBL1 > /dev/null 2>&1
ip route add $P0_NET dev $IF0 table $TBL2 > /dev/null 2>&1
ip route add $P1_NET dev $IF1 table $TBL2 > /dev/null 2>&1
ip route add 127.0.0.0/8 dev lo table $TBL2 > /dev/null 2>&1

iptables -t nat -F POSTROUTING
iptables -t nat -A POSTROUTING -s $P0_NET -o $IF1 -j MASQUERADE
iptables -t nat -A POSTROUTING -s $P0_NET -o $IF2 -j MASQUERADE