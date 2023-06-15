# Installing Dedalus

To install Dedalus, load the following modules:

- gcc/10.2.0
- openmpi/4.0.5-gcc10.2.0
- fftw/3.3.8
- anaconda3/2022.10

and then run the install script provided in this repo (dedalus_hpc_install/bridges-2/conda_install_dedalus2.sh)

It is probably useful to add the following lines to your .bashrc to make loading and unloading modules easy:

    module load gcc/10.2.0
    module load openmpi/4.0.5-gcc10.2.0
    module load fftw/3.3.8
    
    dedalus2 () {
	        module load anaconda3/2022.10
            conda activate dedalus2
    }
    
    dedalus3 () {
	        module load anaconda3/2022.10
            conda activate dedalus3
    }
    
    deactivate () {
            conda deactivate
	        module unload anaconda3/2022.10
    }
  
Then in a terminal, to activate dedalus, you should be able to just type e.g.,

> dedalus2

and to deactivate it, just type

> deactivate

# Setting up your workflow

It's probably useful to create a scripts/ directory in your $HOME and to copy and modify the scripts in the local handy_scripts/ folder (which I haven't made yet oops) into $HOME/scripts.

You should also make it easy to get to your projects directories (note individual nodes have their own local scratch directories, but you don't get a system-wide scratch directory like you do on many other machines) by linking them to something like 'projectdir'. 
To figure out what projects directories you have (should be one per allocation), just type

> projects

and note the last few lines where it'll say something like "STORAGE /ocean/projects/YOUR_PROJECT_DIR". You can also check

> echo $PROJECT

Then, to link to the appropriate projects directory, you could do, e.g.,

> ln -s /ocean/projects/YOUR_PROJECT_DIR $HOME/projectdir1

For future reference, in case the default modules are updated and this script suddenly stops working and we need to troubleshoot, here are my currently loaded modules:

> Currently Loaded Modules:
>  1) allocations/1.0   2) psc.allocations.user/1.0   3) gcc/10.2.0   4) openmpi/4.0.5-gcc10.2.0   5) fftw/3.3.8   6) anaconda3/2022.10

