SZIP_PATH="/nasa/szip/2.1.1/"
HDF5_DIR="/swbuild/eanders/conda_install/hdf5-hdf5-1_12_2"
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

    #I think these are broken
    ARCH_CONF="-axCORE-AVX512 -xSSE4.2"
    HDF_FLAGS="-O2 "$ARCH_CONF" -fPIC"

    HDFCONF_ARGS="CC="$MPICC" \
                   CXX="$MPICXX" \
                   F77="$MPIF90" \
                   MPICC="$MPICC" MPICXX="$MPICXX" \
                   --enable-parallel --enable-shared \
                   --enable-using-memchecker --enable-ros3-vfd \
                   --build=x86_64-redhat-linux --host=x86_64-redhat-linux \
                   --enable-using-memchecker --enable-ros3-vfd --enable-direct-vfd --enable-mirror-vfd \
                   --enable-preadwrite \
                   --enable-option-checking=yes"
    CPPFLAGS=$HDF_FLAGS" -I/usr/include -I/nasa/pkgsrc/toss3/2021Q2/include"
    FFLAGS=$HDF_FLAGS
    CFLAGS=$HDF_FLAGS" -I/usr/include -I/nasa/pkgsrc/toss3/2021Q2/include"
    echo $CFLAGS
    LDFLAGS="-L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -L/usr/lib64 -Wl,-R/usr/lib64 -L/nasa/pkgsrc/toss3/2021Q2/lib -Wl,-R/nasa/pkgsrc/toss3/2021Q2/lib"

    ./configure --prefix=${DEST_DIR}/ ${HDFCONF_ARGS} \
                CFLAGS="$CFLAGS" \
                CPPFLAGS="$CPPFLAGS" \
                LDFLAGS="$LDFLAGS" \
                FFLAGS="$FFLAGS" \
                F90

    make
    make check
    make install
    make check-install
    touch done
fi

