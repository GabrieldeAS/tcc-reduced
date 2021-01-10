#!/bin/bash
echo "ok"
while true
do
tail -vf /dev/ttyACM0 >> output.txt | cat output.txt
done
