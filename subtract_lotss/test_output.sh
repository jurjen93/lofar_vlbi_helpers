#!/bin/bash
#SBATCH -N 1 -c 16 --job-name=test_subtract

export SIMG=/project/lofarvwf/Software/singularity/testpatch_lofar_sksp_v3.4_cascadelake_cascadelake_avx512_mkl_cuda_ddf.sif

MS_IN=$1

singularity exec -B ${SING_BIND} ${SING_IMAGE} DPPP msin=${MS_IN} msout=${MS_IN}_avg steps=[av] msout.storagemanager=dysco steps=[av] av.type=averager av.freqstep=16 av.timestep=16
singularity exec -B ${SING_BIND} ${SING_IMAGE} DPPP msin=sub6asec_${MS_IN}* msout=sub6asec_${MS_IN}_avg steps=[av] msout.storagemanager=dysco steps=[av] av.type=averager av.freqstep=16 av.timestep=16

singularity exec -B $PWD,/project,/home/lofarvwf-jdejong/scripts $SIMG wsclean \
-no-update-model-required \
-minuv-l 80 \
-size 8192 8192 \
-reorder \
-weight briggs \
-0.5 clean-border 1 \
-parallel-reordering 4 \
-mgain 0.75 \
-data-column DATA \
-auto-mask 2.5 \
-auto-threshold 0.5 \
-pol i -use-wgridder \
-name testimage \
-scale 3arcsec \
-nmiter 10 \
-niter 100000 \
-maxuv-l 20e3 \
-scale 3arcsec \
-taper-gaussian 20arcsec \
${MS_IN}_avg

singularity exec -B $PWD,/project,/home/lofarvwf-jdejong/scripts $SIMG wsclean \
-no-update-model-required \
-minuv-l 80 \
-size 8192 8192 \
-reorder \
-weight briggs \
-0.5 clean-border 1 \
-parallel-reordering 4 \
-mgain 0.75 \
-data-column DATA \
-auto-mask 2.5 \
-auto-threshold 0.5 \
-pol i -use-wgridder \
-name testimage \
-scale 3arcsec \
-nmiter 10 \
-niter 100000 \
-maxuv-l 20e3 \
-scale 3arcsec \
-taper-gaussian 20arcsec \
sub6asec_${MS_IN}_avg