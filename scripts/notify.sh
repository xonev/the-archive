#!/bin/bash

afplay /System/Library/Sounds/Ping.aiff -v 2
osascript -e 'display notification "Shell job completed"'
