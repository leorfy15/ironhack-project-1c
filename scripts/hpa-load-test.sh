#!/usr/bin/env bash
set -euo pipefail

URL="https://vote.tatiana.ironlabs.online"
TOTAL_REQUESTS="${1:-10000}"
CONCURRENCY="${2:-200}"
VOTE="${3:-a}"

echo "Starting HPA load test"
echo "URL: $URL"
echo "Requests: $TOTAL_REQUESTS"
echo "Concurrency: $CONCURRENCY"
echo "Vote: $VOTE"

seq 1 "$TOTAL_REQUESTS" | xargs -P "$CONCURRENCY" -I{} \
  curl -s \
  --connect-timeout 5 \
  --max-time 15 \
  -o /dev/null \
  -X POST \
  -d "vote=$VOTE" \
  "$URL"

echo "Load test completed"