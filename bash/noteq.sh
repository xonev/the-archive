#!/bin/bash

if [[ $OSTYPE != "darwin18" ]]; then
    echo "Not darwin18"
elif [[ $OSTYPE == "darwin" ]]; then
    echo "darwin"
elif [[ $OSTYPE == "darwin18" ]]; then
    echo "darwin18"
fi
