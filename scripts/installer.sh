#!/bin/bash
set -e

echo "|======================== SEBA ==========================|"
echo "|==================== Hello-World =======================|"
echo "|=========================================================|"
echo " "

TMP1=$(mktemp -d) || exit 1
# Extraer info
SKIP=$(awk '/^__TARFILE_FOLLOWS__/ { print NR + 1; exit 0; }' $0)
THIS=$(pwd)/$0
tail -n +${SKIP} ${THIS} | tar -xz -C ${TMP1}
HELLO=/root/hello
mkdir -p ${HELLO}

cp ${TMP1}/scripts/docker-compose.yml ${HELLO}/

echo "Cargando imagen de docker..."
docker load < ${TMP1}/hello-images.tar

echo "Deteniendo servicio de docker-compose..."
docker-compose -f ${HELLO}/docker-compose.yml stop

echo "Reiniciando docker..."
systemctl restart docker

echo "Levantando servicio de docker-compose..."
docker-compose -f ${HELLO}/docker-compose.yml up -d

echo "Borrando archivos generados por el instalador..."
rm -rf ${TMP1}
echo "Ok."

exit 0
__TARFILE_FOLLOWS__
