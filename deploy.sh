#!/bin/sh

set -e

############# LEER PARAMETROS ###############
BUILD_ONLY="0"
while [[ $# > 0 ]]
do
  key="$1"
  case $key in
    -b|--build-only)
      BUILD_ONLY="1"
    ;;
    -n|--no-cache)
      NO_CACHE=" --no-cache "
    ;;
    -h|--help)
      echo "TODO: Agregar una ayuda que sirva, por ahora -b es la unica opcion."
      exit 0
    ;;
    *)
    ;;
  esac
  shift
done

IMAGES=""
#############################################
OUT=$(mktemp -d) || exit 1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "DIR: ${DIR}"
VERSION=$(sh ${DIR}/scripts/version_info.sh | \
    sed s/@/_/ | \
    sed s/+/-/g)
TAG=$(echo $VERSION | sed s/-.*/-/g)

docker pull centos:7

docker build . -f ${DIR}/docker/Dockerfile -t docker-latest

IMAGES+="docker-latest"

### Crear imagenes con entorno de deployment ####
docker save ${IMAGES} > ${OUT}/hello-images.tar

#### Crear paquete final ###################
echo "* Empaquetando instalador..."

VERSION=$(sh ${DIR}/scripts/version_info.sh -d ${DIR})

mkdir -p ${OUT}/scripts
cp ${DIR}/scripts/docker-compose.yml ${OUT}/scripts
tar zcvf out.tar.gz -C ${OUT}/ $(ls ${OUT})
cat ${DIR}/scripts/installer.sh out.tar.gz > hello-${VERSION}.run
chmod +x hello-${VERSION}.run
rm -rf out.tar.gz
rm -rf ${OUT}
