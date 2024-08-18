#!/bin/bash

set -a
. ./homekube.env.sh
set +a

INSTALL_DIR=$(pwd)
cd ${INSTALL_DIR}/whoami
. ./install-with-sso.sh
cd ${INSTALL_DIR}/ingress
. ./install.sh
cd ${INSTALL_DIR}/dashboard
. ./install-with-sso.sh
cd ${INSTALL_DIR}/prometheus
. ./install.sh
cd ${INSTALL_DIR}/grafana
. ./install-with-sso.sh
cd ${INSTALL_DIR}

. ./whoami/install.sh
. ./ingress/install.sh
. ./dashboard/install.sh
. ./storage/nfs/install.sh
. ./prometheus/install.sh
. ./grafana/install.sh

echo "Next steps: Installation of cert-manager"
echo "Cert manager automates creation and renewal of LetsEncrypt certificates"
echo "Follow ${INSTALL_DIR}/../docs/cert-manager.md"
