# Installing Dedalus

To install Dedalus, simply load the appropriate packages (git, gcc, openmpi, fftw, hdf5, and anaconda3) and then run the custom install script of your choice.

It is probably useful to add the following lines to your .bashrc to make loading and unloading modules easy:

    module load git/2.31.1
    module load gcc/10.2.0
    module load openmpi/4.1.3
    module load fftw/3.3.10
    module load hdf5/1.10.7
    
    dedalus2 () {
            module load anaconda3/2021.05
            conda activate dedalus2
    }
    
    dedalus3 () {
            module load anaconda3/2021.05
            conda activate dedalus3
    }
    
    deactivate () {
            conda deactivate
            module unload anaconda3/2021.05
    }
  
Then in a terminal, to activate dedalus, you should be able to just type e.g.,

> dedalus2

and to deactivate it, just type

> deactivate

Note that the anaconda module messes up the pathing for the git module, so it's useful to load and unload it when you're running (or done running) a dedalus simulation.

# Setting up your workflow

It's probably useful to create a scripts/ directory in your $HOME and to copy and modify the scripts in the local handy_scripts/ folder into $HOME/scripts.

You should also make it easy to get to your scratch directory by linking it to something like 'workdir', e.g.,:

> ln -s /expanse/lustre/scratch/$USER/temp_project $HOME/workdir
