#!/bin/bash
#SBATCH -N 1 -c 16 -t 120:00:00 --constraint=intel --job-name=pre-facet-target

CORES=16

echo "Job landed on $(hostname)"
echo "GENERIC PIPELINE STARTING"

export RUNDIR=$(mktemp -d -p "$TMPDIR")
export RESULTS_DIR=$1#/project/lofarvwf/Share/rtimmerman/CDGS54/part4/P150
export CAL_DIR=$2#/project/lofarvwf/Share/rtimmerman/CDGS54/part4/3C196
export SIMG=/project/lofarvwf/Software/singularity/test_lofar_sksp_v3.3.4_x86-64_generic_avx512_ddf.sif

echo "RUNDIR is $(readlink -f $RUNDIR)"
cd $RUNDIR

echo "RETRIEVING INPUT DATA ..."
# Run the pipeline
cp ~/scripts/prefactor_helpers/prefactor_pipeline/pipeline.cfg .
cp ~/scripts/prefactor_helpers/prefactor_pipeline/Delay-Calibration.parset .

sed -i "s?CORES?$CORES?g" Pre-Facet-Target.parset
sed -i "s?RESULTS_DIR?$RESULTS_DIR?g" Pre-Facet-Target.parset
sed -i "s?CAL_DIR?$CAL_DIR?g" Pre-Facet-Target.parset
sed -i "s?PREFACTOR_SCRATCH_DIR?$RUNDIR?g" pipeline.cfg

singularity exec -B $PWD,/project $SIMG genericpipeline.py -d -c pipeline.cfg Pre-Facet-Target.parset 

echo "Copying results to $RESULTS_DIR ..."
mkdir -p $RESULTS_DIR
cp -r Pre-Facet-Target $RESULTS_DIR/
echo "... done"

echo "Cleaning up RUNDIR ..."
rm -rf $RUNDIR
echo "... done"
echo "GENERIC PIPELINE FINISHED"