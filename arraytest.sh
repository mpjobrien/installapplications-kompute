#!/bin/zsh

sitecode="PKED"

exec < ./assets/sites.csv
read header
while IFS= read -r line || [ -n "$line" ]; do
   echo "Record is : $line"
done