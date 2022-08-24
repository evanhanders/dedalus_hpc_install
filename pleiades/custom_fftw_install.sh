# Code from Ben Brown modified by Evan Anders for installing FFTW on pleiades
# Info on NASA intel compilers: https://www.nas.nasa.gov/hecc/support/kb/intel-compiler_86.html
# Info on NASA mpt: https://www.nas.nasa.gov/hecc/support/kb/porting-with-hpe-mpt_100.html
# Info on an mpt alternative: https://www.nas.nasa.gov/hecc/support/kb/hpc-x-mpi-an-alternative-to-mpt_619.html
# Recommended compilation flags: https://www.nas.nasa.gov/hecc/support/kb/recommended-compiler-options_99.html

FFTW_PATH="`pwd`/fftw-3.3.9"
pwd

DEST_SUFFIX="fftw_install"
DEST_DIR="`pwd`/${DEST_SUFFIX/ /}"

if [ -e $FFTW_PATH ]
then
    echo "FFTW already unpacked"
else
    wget http://www.fftw.org/fftw-3.3.9.tar.gz
    tar xvf fftw-3.3.9.tar.gz
fi

cd $FFTW_PATH
if [ -e done ]
then
    echo "FFTW already installed."
else
    echo "installing FFTW..."
    export MPICC_CC=icc
    export MPICXX_CXX=icpc
    export CC=mpicc

    MPICC="mpicc"
    MPICXX="mpicxx"
    MPIF90="mpif90"

    #ARCH_CONF may actually mess stuff up on rome nodes: https://www.nas.nasa.gov/hecc/support/kb/preparing-to-run-on-aitken-rome-nodes_657.html
    ARCH_CONF="-axCORE-AVX512,CORE-AVX2 -xAVX"
    FFTW_FLAGS="-O3 "$ARCH_CONF" -fPIC -w -qopenmp -parallel"

    #possibly useful: --enable-avx512 --enable-avx2 --enable-avx 

    FFTWCONF_ARGS="CC="$MPICC" \
                   CXX="$MPICXX" \
                   F77="$MPIF90" \
                   MPICC="$MPICC" MPICXX="$MPICXX" \
                   --enable-shared\
                   --enable-mpi --enable-openmp --enable-threads \
                   --build=x86_64-redhat-linux --host=x86_64-redhat-linux \
                   --enable-option-checking=yes"
    CPPFLAGS=$FFTW_FLAGS
    FFLAGS=$FFTW_FLAGS
    CFLAGS=$FFTW_FLAGS
    echo $CFLAGS
#    LDFLAGS="-L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -L/usr/lib64 -Wl,-R/usr/lib64 -L/nasa/pkgsrc/toss3/2021Q2/lib -Wl,-R/nasa/pkgsrc/toss3/2021Q2/lib"
#                LDFLAGS="$LDFLAGS" \

    ./configure --prefix=${DEST_DIR}/ ${FFTWCONF_ARGS} \
                CFLAGS="$CFLAGS" \
                CPPFLAGS="$CPPFLAGS" \
                FFLAGS="$FFLAGS" \
                F90

    make
    make install
    touch done
fi
cd ..
