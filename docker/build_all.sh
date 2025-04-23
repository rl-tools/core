set -e
#PLATFORM=linux/amd64
#OS=ubuntu
#OS_VERSION=20.04
#BACKEND=mkl
#TOOLCHAIN=gcc

build() {
  PLATFORM=$1
  OS=$2
  OS_VERSION=$3
  BACKEND=$4
  CMAKE_VERSION=$5
  TOOLCHAIN=$6
  FEATURE=$7

  tmp="$(mktemp -d)"
  git clone .. $tmp/rl-tools
  cp $OS/*.sh $tmp/

  BACKEND_IMAGE_NAME=rltools/rltools:${OS}${OS_VERSION}_${BACKEND}
  TOOLCHAIN_IMAGE_NAME=rltools/rltools:${OS}${OS_VERSION}_${BACKEND}_${CMAKE_VERSION}_${TOOLCHAIN}
  FEATURE_IMAGE_NAME_TMP=rltools/rltools:${OS}${OS_VERSION}_${BACKEND}_${TOOLCHAIN}_${FEATURE}_tmp
  FEATURE_IMAGE_NAME=rltools/rltools:${OS}${OS_VERSION}_${BACKEND}_${TOOLCHAIN}_${FEATURE}
  BUILD_IMAGE_NAME=rltools/rltools:${OS}${OS_VERSION}_${BACKEND}_${TOOLCHAIN}_${FEATURE}_build
  docker build -t ${BACKEND_IMAGE_NAME}     -f ${OS}/backend/Dockerfile.${BACKEND}     --build-arg OS=${OS} --build-arg OS_VERSION=${OS_VERSION} --platform ${PLATFORM} .
  docker build -t ${TOOLCHAIN_IMAGE_NAME}   -f ${OS}/toolchain/Dockerfile.${TOOLCHAIN} --build-arg CMAKE_VERSION=${CMAKE_VERSION} --build-arg BASE_IMAGE=${BACKEND_IMAGE_NAME} --platform ${PLATFORM} .
  docker build -t ${FEATURE_IMAGE_NAME_TMP} -f ${OS}/feature/Dockerfile.${FEATURE}     --build-arg BASE_IMAGE=${TOOLCHAIN_IMAGE_NAME} --platform ${PLATFORM} .
  docker build -t ${FEATURE_IMAGE_NAME}     -f ${OS}/Dockerfile.all                    --build-arg BASE_IMAGE=${FEATURE_IMAGE_NAME_TMP} --platform ${PLATFORM} $tmp
#  docker build -t ${BUILD_IMAGE_NAME}       -f ${OS}/Dockerfile.build                  --build-arg BASE_IMAGE=${FEATURE_IMAGE_NAME} --platform ${PLATFORM} $tmp
  rm -rf $tmp
  echo ${FEATURE_IMAGE_NAME}
}

#build linux/amd64 ubuntu 20.04 mkl      gcc base
#build linux/amd64 ubuntu 22.04 cuda     gcc base
#build linux/amd64 ubuntu 22.04 cuda_mkl gcc base
#build linux/amd64 ubuntu 22.04 cuda_mkl default gcc mujoco
#build linux/amd64 ubuntu 22.04 cuda_mkl 3.27.7-0kitware1ubuntu22.04.1 gcc mujoco

#wait $pid1 $pid2 $pid3

#docker tag ${BUILD_IMAGE_NAME} rltools/rltools:latest


#docker run -it --gpus all --runtime=nvidia  --rm -v $(cd .. && pwd):/rl_tools ${BUILD_IMAGE_NAME}
#docker run -it --gpus all --runtime=nvidia -v $(cd .. && pwd):/rl_tools ${BUILD_IMAGE_NAME} bash -c "./configure.sh && ./build.sh && ctest -j4 -V -S ../rl_tools/CTestScript.cmake -DCDASH_TOKEN=${CDASH_TOKEN}"

#TAG=$(build linux/amd64 ubuntu 24.04 openblas default gcc base)
#REGISTRY="10.8.0.1:5000"
#docker tag ${TAG} ${REGISTRY}/${TAG}
#docker push ${REGISTRY}/${TAG}
TAG=$(build linux/amd64 ubuntu 24.04 mkl default gcc base)
echo $TAG

#docker run -it --mount type=bind,source=$(cd .. && pwd),target=/rl-tools,readonly rltools/rltools:ubuntu24.04_openblas_gcc_base bash -c "./configure.sh && ./build.sh && ./test.sh"
