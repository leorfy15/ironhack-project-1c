#!/bin/bash

URL="https://vote.tatiana.ironlabs.online"

TOTAL_VOTES=10000
CONCURRENCY=100

echo "Sending $TOTAL_VOTES votes to $URL with concurrency $CONCURRENCY"

seq 1 $TOTAL_VOTES | xargs -n1 -P $CONCURRENCY -I{} sh -c '
  if [ $(({} % 2)) -eq 0 ]; then
    curl -s -o /dev/null -X POST -d "vote=a" '"$URL"'
  else
    curl -s -o /dev/null -X POST -d "vote=b" '"$URL"'
  fi
'

echo "Done"
