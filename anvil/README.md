# Installing Dedalus

To install Dedalus, simply load the appropriate modules (fftw, hdf5, and anaconda -- the rest should be loaded by default) and then run the install script provided in this repo (dedalus_hpc_install/anvil/conda_install_dedalus2.sh).

It is probably useful to add the following lines to your .bashrc to make loading and unloading modules easy:

    module load fftw/3.3.8
    module load hdf5/1.10.7
    
    dedalus2 () {
	    module load anaconda
            conda activate dedalus2
    }
    
    dedalus3 () {
	    module load anaconda
            conda activate dedalus3
    }
    
    deactivate () {
            conda deactivate
	    module unload anaconda
    }
  
Then in a terminal, to activate dedalus, you should be able to just type e.g.,

> dedalus2

and to deactivate it, just type

> deactivate

# Setting up your workflow

It's probably useful to create a scripts/ directory in your $HOME and to copy and modify the scripts in the local handy_scripts/ folder (which I haven't made yet oops) into $HOME/scripts.

You should also make it easy to get to your scratch and projects directories by linking them to something like 'scratchdir', etc., e.g.,:

> ln -s /anvil/scratch/$USER $HOME/scratchdir

To figure out what projects directories you have (should be one per allocation), just type

> myquota

and note the entries under the "projects" type. Then, to link to the appropriate projects directory, you could do, e.g.,

> ln -s /anvil/projects/x-phyXXXXXX $HOME/projectdir1

where x-phyXXXXXX is whatever the "Location" entry is when you run myquota.


For future reference, in case the default modules are updated and this script suddenly stops working and we need to troubleshoot, here are my currently loaded modules:

> Currently Loaded Modules:
>  1) gmp/6.2.1    3) mpc/1.1.0     5) gcc/11.2.0         7) numactl/2.0.14   9) xalt/2.10.45 (S)  11) fftw/3.3.8     13) hdf5/1.10.7
>  2) mpfr/4.0.2   4) zlib/1.2.11   6) libfabric/1.12.0   8) openmpi/4.0.6   10) modtree/cpu       12) libszip/2.1.1  14) anaconda/2021.05-py38

