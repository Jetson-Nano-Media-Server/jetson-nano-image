#!/bin/bash

declare -a FILES=("/home/servarr" "/home/prodarr" "/home/langarr")

for file in "${FILES[@]}"
do
   docker compose -f $file pull --ignore-pull-failures && sudo docker compose -f $file up -d
done

yes | docker image prune -a
yes | docker system prune -a
