#!/bin/bash
# 3 different ways to get the user that executed via sudo
echo $(logname)
echo $(who -m | awk '{print $1;}')
