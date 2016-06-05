#!/bin/bash

# The purpose of this program is to re-link the swarm to a new version.

for i in {1..30} # say how many prototype insects you will want
do
  rm ./pupa$i/swarm 2>/dev/null
  # ln ./swarm ./pupa$i/swarm
  # chmod +x ./pupa$i/swarm

  cd ./pupa$i
  ln ../swarm ./swarm
  cd ..

done

