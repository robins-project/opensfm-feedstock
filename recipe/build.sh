#!/bin/sh

mkdir build
cd build

P=$(echo $PY_VER | tr "." "\n")
PYVER=($P)

PY_MAJOR=${PYVER[0]}
PY_MINOR=${PYVER[1]}
if [ $PY3K -eq 1 ]; then
    BUILD_FOR_PYTHON3=ON
    BOOST_PYTHON_COMPONENT="-DBOOST_PYTHON3_COMPONENT=python${PY_MAJOR}${PY_MINOR}"
    BOOST_NUMPY_COMPONENT="-DBOOST_NUMPY_COMPONENT=numpy${PY_MAJOR}${PY_MINOR}"
else
    BUILD_FOR_PYTHON3=OFF
    BOOST_PYTHON_COMPONENT="-DBOOST_PYTHON_COMPONENT=python${PY_MAJOR}${PY_MINOR}"
    BOOST_NUMPY_COMPONENT="-DBOOST_NUMPY_COMPONENT=numpy${PY_MAJOR}${PY_MINOR}"
fi

cmake -G "Ninja"                                              \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}                          \
    -DCMAKE_BUILD_TYPE=Release                                \
    -DOPENSFM_BUILD_TESTS=OFF                                 \
    -DEIGEN_INCLUDE_DIR_HINTS=${CONDA_PREFIX}/include/eigen3  \
    -DLIBRT_LIBRARY=${CONDA_PREFIX}/lib/libmkl_rt.so          \
    -DBUILD_FOR_PYTHON3=${BUILD_FOR_PYTHON3}                  \
    ${BOOST_PYTHON_COMPONENT}                                 \
    ${BOOST_NUMPY_COMPONENT}                                  \
    ../opensfm/src

ninja

cp ../bin/opensfm_run_all ${PREFIX}/bin
cp ../bin/opensfm ${PREFIX}/bin
cp ../bin/export_bundler ${PREFIX}/bin

mkdir -p $SP_DIR/opensfm
cp ../opensfm/*.py $SP_DIR/opensfm
cp ../opensfm/csfm.so $SP_DIR/opensfm
cp -r ../opensfm/commands $SP_DIR/opensfm
cp -r ../opensfm/large $SP_DIR/opensfm
mkdir -p $SP_DIR/opensfm/data
cp -r ../opensfm/data/sensor_data.json $SP_DIR/opensfm/data
