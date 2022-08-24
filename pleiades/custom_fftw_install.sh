# Code from Ben Brown for installing FFTW on pleiades

FFTW_PATH="/swbuild/eanders/conda_install/fftw-3.3.9"
pwd

DEST_SUFFIX="fftw_install_new"
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

    ARCH_CONF="-axCORE-AVX512 -xSSE4.2"
    FFTW_FLAGS="-O2 "$ARCH_CONF" -fPIC"

    #Pleiades configure args
    #--enable-shared --enable-threads --prefix=/nasa/pkgsrc/toss3/2021Q2 
    #--build=x86_64-redhat-linux --host=x86_64-redhat-linux 
    #--infodir=/nasa/pkgsrc/toss3/2021Q2/info --mandir=/nasa/pkgsrc/toss3/2021Q2/man 
    #--enable-option-checking=yes

    #Pleiades flags
    #    CPPFLAGS=   -I/usr/include -I/nasa/pkgsrc/toss3/2021Q2/include
    #    FFLAGS=-O
    #    CFLAGS=-O2 -pipe -D_FORTIFY_SOURCE=2 -I/usr/include -I/nasa/pkgsrc/toss3/2021Q2/include
    #    LDFLAGS=   -L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -L/usr/lib64 -Wl,-R/usr/lib64 -L/nasa/pkgsrc/toss3/2021Q2/lib -Wl,-R/nasa/pkgsrc/toss3/2021Q2/lib


    FFTWCONF_ARGS="CC="$MPICC" \
                   CXX="$MPICXX" \
                   F77="$MPIF90" \
                   MPICC="$MPICC" MPICXX="$MPICXX" \
                   --enable-shared --enable-avx512 \
                   --enable-mpi --enable-openmp --enable-threads \
                   --build=x86_64-redhat-linux --host=x86_64-redhat-linux \
                   --enable-option-checking=yes"
    CPPFLAGS=$FFTW_FLAGS" -I/usr/include -I/nasa/pkgsrc/toss3/2021Q2/include"
    FFLAGS=$FFTW_FLAGS
    CFLAGS=$FFTW_FLAGS" -I/usr/include -I/nasa/pkgsrc/toss3/2021Q2/include"
    echo $CFLAGS
    LDFLAGS="-L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib/gcc/x86_64-redhat-linux/7.5.0 -L/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -Wl,-R/nasa/pkgsrc/toss3/2021Q2/gcc7/lib64 -L/usr/lib64 -Wl,-R/usr/lib64 -L/nasa/pkgsrc/toss3/2021Q2/lib -Wl,-R/nasa/pkgsrc/toss3/2021Q2/lib"

    ./configure --prefix=${DEST_DIR}/ ${FFTWCONF_ARGS} \
                CFLAGS="$CFLAGS" \
                CPPFLAGS="$CPPFLAGS" \
                LDFLAGS="$LDFLAGS" \
                FFLAGS="$FFLAGS" \
                F90

    make
    make install
    touch done
fi
cd ..
