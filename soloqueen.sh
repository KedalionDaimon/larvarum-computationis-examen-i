#!/bin/bash

# The purpose of this program is to initialise a new swarm.
# It also determines the size of the swarm.

rm insects.txt 2>/dev/null
rm -r pupa* 2>/dev/null
# redirect errors to /dev/null

for i in {1..30} # say how many prototype insects you will want
do
  echo $i >> insects.txt
  mkdir ./pupa$i # "insect$i.txt"
  cp ./swarmdata.txt ./swarmhistory.txt ./swarminsistence.txt ./swarminput.txt ./swarmoutput.txt ./pupa$i

  # cp ./swarm ./pupa$i/swarm
  # ln ./swarm ./pupa$i/swarm
  cd ./pupa$i
  ln ../swarm ./swarm
  cd ..

  chmod +x ./pupa$i/swarm
done

