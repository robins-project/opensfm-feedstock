#!/bin/sh

mkdir build
cd build

cmake -G "Ninja"                                              \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}                          \
    -DCMAKE_BUILD_TYPE=Release                                \
    -DOPENSFM_BUILD_TESTS=OFF                                 \
    -DEIGEN_INCLUDE_DIR_HINTS=${CONDA_PREFIX}/include/eigen3  \
    -DLIBRT_LIBRARY=${CONDA_PREFIX}/lib/libmkl_rt.so          \
    -DBUILD_FOR_PYTHON3=ON                                    \
    -DBOOST_PYTHON3_COMPONENT=python37                        \
    -DBOOST_NUMPY_COMPONENT=numpy37                           \
    ../opensfm/src

ninja

cp ../bin/opensfm_run_all ${PREFIX}/bin
cp ../bin/opensfm ${PREFIX}/bin

mkdir -p $SP_DIR/opensfm
cp ../opensfm/*.py $SP_DIR/opensfm
cp ../opensfm/csfm.so $SP_DIR/opensfm
cp -r ../opensfm/commands $SP_DIR/opensfm
cp -r ../opensfm/large $SP_DIR/opensfm
mkdir -p $SP_DIR/opensfm/data
cp -r ../opensfm/data/sensor_data.json $SP_DIR/opensfm/data
