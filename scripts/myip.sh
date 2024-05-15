#!/bin/bash

# stolen from https://apple.stackexchange.com/questions/20547/how-do-i-find-my-ip-address-from-the-command-line
dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | jq -r .
