#!/bin/sh

temp=$(sensors | grep -m 1 Core | awk '{print substr($3, 2, length($3)-5)}' | tr "\\n" " " | sed 's/$//')

echo "$temp°C"
