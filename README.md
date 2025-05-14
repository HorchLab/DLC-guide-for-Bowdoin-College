# Easy guide to use DeepLabCut on Bowdoin's HPC

> This page belongs to the lab of Professor Hadley W. Horch at Bowdoin College. ~~All of her behavioral data, along with ~~DeepLabCut information and user guide are centralized in this GitHub location.

For actual guide on how to use DeepLabCut on Bowdoin's HPC, please refer to `Getting-started-DLC.md`.
[Click here](guides/Getting-started-DLC.md) to go to the guide.

Want to use existing HPC scripts for your DLC project? Read [the section on HPC_Scripts](#hpc_scripts) for more information.

## References

1. Steps on how to get started using DLC on the HPC (`Getting-started-DLC.md`)
2. The R scripts and Python files necessary to do so (`HPC_scripts`)
3. DLC and HPC troubleshooting information (`Additional_DLC_Help/*`) *Some of the information is outdated, but still useful for reference.*

Reference to [DLC's official github](https://github.com/DeepLabCut/DeepLabCut/tree/master/deeplabcut).
Reference to the [original R script in 2019](https://github.com/mhukill/Crickets-Methods).

> (Deprecated) Link to [Tom's forked repository](https://github.com/tom21100227/DLC-guide-for-Bowdoin-College). Some leftover half-finished projects are still going and will be eventually merged back into this repository.

## `HPC_scripts/*`

Scripts that can be used on [Bowdoin's SLURM-based HPC Grid](https://www.bowdoin.edu/it/resources/high-performance-computing.html) for DeepLabCut tracking.

> The scripts are designed to work with DLC 2.3.9/2.3.10. As of Jun 2024, the corresponding DeepLabCut version is only installed in the new HPC. So instead of submitting a job on slurm (with `ssh slurm.bowdoin.edu`), submit those jobs on moosehead (with `ssh moosehead.bowdoin.edu`). Everything else (sbatch...) should be the same.

To use these scripts:

1. Clone this repository to your HPC folder. *Alternatively, download the folder and put it to your HPC/microwave folder.*
2. Change necessary parameters in the scripts. Most importantly, the path `config.yaml` file and paths to your videos.
3. When submitting a job with `sbatch`, you don't need to add `-p gpu ...` because the script would request the GPU for you.
4.

## `R files/*`

Post-DLC processing. Visualizing and analyzing movements of the crickets. (This part is Cricket/*G. bimaculatus* specific).
