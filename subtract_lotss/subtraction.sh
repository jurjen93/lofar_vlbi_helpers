#!/bin/bash
#SBATCH -N 1 -c 24 --job-name=subtract --exclusive

echo "Job landed on $(hostname)"

MS=$1

export SIMG=/project/lofarvwf/Software/singularity/testpatch_lofar_sksp_v3.4_cascadelake_cascadelake_avx512_mkl_cuda_ddf.sif

singularity exec -B $PWD,/project,/home/lofarvwf-jdejong/scripts $SIMG /home/lofarvwf-jdejong/scripts/lofar-highres-widefield/utils/sub-sources-outside-region.py \
--boxfile boxfile.reg \
--column DATA_DI_CORRECTED \
--freqavg 1 \
--timeavg 1 \
--ncpu 24 \
--prefixname sub6asec \
--noconcat \
--keeplongbaselines \
--nophaseshift \
--chunkhours 0.5 \
--mslist $MS

cp -r sub6asec* ../

echo "SUBTRACT END"