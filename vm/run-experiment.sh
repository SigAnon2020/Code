#!/bin/bash


ITERATIONS=${1:-256}
INVOCATIONS=${2:-256}

PSQL_EXEC="psql"

if [ "$ITERATIONS" -lt 1 ]; then
  echo "Iterations must be greater or equal to 1."
  exit 1
fi

if [ "$INVOCATIONS" -lt 1 ]; then
  echo "Invocations must be greater or equal to 1."
  exit 1
fi

echo "Running vm with $ITERATIONS iterations and $INVOCATIONS invocations"

echo "Setup database for experiment:"

$PSQL_EXEC --quiet -v iterations="$ITERATIONS" \
                   -v invocations="$INVOCATIONS" \
                   -f vm-preparation.sql >> /dev/null

echo -e "\n\n======================\n| Run PL/SQL version |\n======================\n"

$PSQL_EXEC -v iterations="$ITERATIONS" \
           -v invocations="$INVOCATIONS" \
           -f vm-pl.sql

echo -e "\n\n======================\n| Run translation    |\n======================\n"

$PSQL_EXEC -v iterations="$ITERATIONS" \
           -v invocations="$INVOCATIONS" \
           -v MODE=RECURSIVE \
           -f vm-tr.sql

