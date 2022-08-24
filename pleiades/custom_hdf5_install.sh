#Parallel hdf5: https://portal.hdfgroup.org/display/HDF5/Parallel+HDF5
#Parallel hdf5 install: https://github.com/UCSantaCruzComputationalGenomicsLab/hdf5/blob/master/release_docs/INSTALL_parallel
#Parallel h5py: https://docs.h5py.org/en/latest/mpi.html

#for module load szip/2.1.1
SZIP_PATH="/nasa/szip/2.1.1/"
HDF5_DIR="`pwd`/hdf5-hdf5-1_12_2"
pwd

DEST_SUFFIX="hdf5_install"
DEST_DIR="`pwd`/${DEST_SUFFIX/ /}"

if [ -e $HDF5_DIR ]
then
    echo "hdf5 already unpacked"
else
    wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_12_2.tar.gz
    tar xvf hdf5-1_12_2.tar.gz
fi
    
cd $HDF5_DIR
if [ -e done ] 
then
    echo "HDF5 already installed."
else
    echo "installing HDF5..."
    export MPICC_CC=icc
    export MPICXX_CXX=icpc
    export CC=mpicc

    MPICC="mpicc"
    MPICXX="mpicxx"
    MPIF90="mpif90"

    #ARCH_CONF may actually mess stuff up on rome nodes: https://www.nas.nasa.gov/hecc/support/kb/preparing-to-run-on-aitken-rome-nodes_657.html
    ARCH_CONF="-axCORE-AVX512,CORE-AVX2 -xAVX"
    HDF_FLAGS="-O3 "$ARCH_CONF" -fPIC -w -qopenmp -parallel"

    HDFCONF_ARGS="CC="$MPICC" \
                   CXX="$MPICXX" \
                   F77="$MPIF90" \
                   MPICC="$MPICC" MPICXX="$MPICXX" \
                   --enable-parallel --enable-shared \
                   --build=x86_64-redhat-linux --host=x86_64-redhat-linux \
                   --enable-ros3-vfd --enable-direct-vfd --enable-mirror-vfd \
                   --enable-preadwrite \
                   --enable-option-checking=yes"
    CPPFLAGS=$HDF_FLAGS
    FFLAGS=$HDF_FLAGS
    CFLAGS=$HDF_FLAGS
    echo $CFLAGS
#    LDFLAGS="-L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -L/usr/lib64 -Wl,-R/usr/lib64 -L/nasa/pkgsrc/toss3/2021Q2/lib -Wl,-R/nasa/pkgsrc/toss3/2021Q2/lib"
#                LDFLAGS="$LDFLAGS" \

    ./configure --prefix=${DEST_DIR}/ ${HDFCONF_ARGS} \
                CFLAGS="$CFLAGS" \
                CPPFLAGS="$CPPFLAGS" \
                FFLAGS="$FFLAGS" \
                F90

    make
    make check
    make install
#    make check-install
    touch done
fi

