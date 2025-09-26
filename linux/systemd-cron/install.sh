#!/bin/bash

chmod 700 script.sh

# Ensure config has been set up
ENV_FILE="$(dirname $0)/env"
if [ ! -f "${ENV_FILE}" ]; then
  echo "File ${ENV_FILE} does not exist - please create before installing by copying from env.template and filling out!"
  exit 1
else
  echo "File ${ENV_FILE} exists."
fi

source "${ENV_FILE}"

# Update unit path and name
cp "$(dirname $0)/script.service" "$(dirname $0)/${SERVICE_NAME}.service"
cp "$(dirname $0)/script.timer" "$(dirname $0)/${SERVICE_NAME}.timer"
sed -i "s|^ExecStart=.*|ExecStart=/bin/bash $(dirname $0)/script.sh|" "$(dirname $0)/${SERVICE_NAME}.service"
sed -i "s|SERVICE_NAME|${SERVICE_NAME}|g" "$(dirname $0)/${SERVICE_NAME}.service"
sed -i "s|SERVICE_NAME|${SERVICE_NAME}|g" "$(dirname $0)/${SERVICE_NAME}.timer"

# Apply units
sudo mv "$(dirname $0)/${SERVICE_NAME}.service" "/etc/systemd/system/${SERVICE_NAME}.service"
sudo chmod 644 "/etc/systemd/system/${SERVICE_NAME}.service"
sudo mv "$(dirname $0)/${SERVICE_NAME}.timer" "/etc/systemd/system/${SERVICE_NAME}.timer"
sudo chmod 644 "/etc/systemd/system/${SERVICE_NAME}.timer"
sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE_NAME}.timer"
