First you probably want to load the following packages or something like them:

> module load git/2.31.1
> module load gcc/10.2.0
> module load openmpi/4.1.3
> module load fftw/3.3.10
> module load python/3.8.12
> module load py-pip/21.1.2
> module load py-numpy/1.20.3
> module load py-scipy/1.5.4
> module load py-mpi4py/3.1.2
> module load py-h5py/3.4.0

Note that Expanse has the same module (e.g., py-h5py/3.4.0) built using many different underlying packages (different MPIs, etc, etc).
When you do a `module list`, each module will have a garble of letters after it, and if you used differe MPI / compilers, you would expect to see different letters.

After loading these, if you type `module list`, it should print something like this:

>>> Currently Loaded Modules:
>>>   1) shared                      8) ucx/1.10.1/dnpjjuc            15) py-numpy/1.20.3/4o6jrav
>>>   2) cpu/0.17.3b           (c)   9) openmpi/4.1.3/oq3qvsv         16) py-scipy/1.5.4/u7skc52
>>>   3) slurm/expanse/21.08.8      10) fftw/3.3.10/bmvqsbr           17) py-mpi4py/3.1.2/kas2whp
>>>   4) sdsc/1.0                   11) python/3.8.12/7zdjza7         18) openjdk/11.0.12_7/27cv2ps
>>>   5) DefaultModules             12) py-setuptools/58.2.0/eefp7mw  19) hdf5/1.10.7/5o4oibc
>>>   6) git/2.31.1/ldetm5y         13) py-pip/21.1.2/mddhf7t         20) py-h5py/3.4.0/64x4q5l
>>>   7) gcc/10.2.0/npcyll4         14) openblas/0.3.18/fgk2tlu
>>> 
>>>   Where:
>>>    c:  built natively for AMD Rome

Per the dedalus user group (https://groups.google.com/g/dedalus-users/c/XhANyrEVkss/m/bYwSzVJgAQAJ) we need to set some environment variables:

> export FFTW_PATH=$FFTWHOME
> export MPI_PATH=$OPENMPIHOME
> export HDF5_DIR=$HDF5HOME
> export FFTW_STATIC=0
> export OMP_NUM_THREADS=1
> export CC=mpicc
> export LDSHARED="mpicc -shared"

Then upgrade pip

pip install --upgrade --user pip

Then clone dedalus

# Version 2 clone & build
> git clone -b v2_master https://github.com/DedalusProject/dedalus.git dedalus-d2

# Version 3 clone & build
> git clone -b master https://github.com/DedalusProject/dedalus.git dedalus-d3

and navigate into your dedalus directory (e.g., `cd dedalus-d3`).
We need to modify the install script a bit, so open it, and add:

>> import site
>> site.ENABLE_USER_SITE = "--user" in sys.argv[1:]

near the top of the file, after all of the other import statements.
Save, close the file, then install dedalus:

#
> python3 -m pip install --user -e .
