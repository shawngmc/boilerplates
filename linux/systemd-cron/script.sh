#!/bin/bash

source "$(dirname $0)/env"

notify() {
  # Send notification
  aws sns publish --topic-arn "${SNS_TOPIC}" --message "$1"
}

handle_error() {
  notify "ERROR: ${SERVICE_NAME} failed on line ${LINENO}!"
  exit 1
}

trap handle_error ERR

# Example: 50/50 Success/Failure
random_byte=$(od -An -N1 -t u1 /dev/urandom)
if (( random_byte % 2 == 0 )); then
  result="True - Worked"
else
  result="ERROR - False - Failed"
  exit 1
fi

notify "OK: ${SERVICE_NAME} completed OK!"
