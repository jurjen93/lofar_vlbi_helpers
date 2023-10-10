#!/bin/bash
#SBATCH -c 10

#SINGULARITY SETTINGS
SING_BIND=$( python3 $HOME/parse_settings.py --BIND )
SIMG=$( python3 $HOME/parse_settings.py --SIMG )
SCRIPT_DIR=/home/lofarvwf-jdejong/scripts/lofar_vlbi_helpers/imaging/split_facets

echo "COPY SOLUTION FILES"
cp /project/lofarvwf/Share/jdejong/output/ELAIS/ALL_L/dd_solutions/mergedsolutions/merged_L??????.h5 .
cp /project/lofarvwf/Share/jdejong/output/ELAIS/ALL_L/dd_solutions/facets_1.2.reg .

LISTMS=(/project/lofarvwf/Share/jdejong/output/ELAIS/ALL_L/apply_delaycal/*.ms)
H5S=(*.h5)

#make facets based on merged h5
singularity exec -B ${SING_BIND} ${SIMG} python \
/home/lofarvwf-jdejong/scripts/lofar_vlbi_helpers/extra_scripts/ds9facetgenerator.py \
--h5 ${H5S[0]} \
--DS9regionout facets_1.2.reg \
--imsize 22500 \
--ms ${LISTMS[0]} \
--pixelscale 0.4

#loop over facets from merged h5
singularity exec -B ${SING_BIND} ${SIMG} python \
${SCRIPT_DIR}/split_facets.py \
--h5 ${H5S[0]} \
--reg facets_1.2.reg \
--extra_boundary 0.1

# give night names
#COUNT=$( ls -1d poly_*.reg | wc -l )
#for ((i=1;i<=COUNT;i++)); do
#  sbatch ${SCRIPT_DIR}/subtract_perfacet_pernight_persb_1.2.sh $i L686962
#  sbatch ${SCRIPT_DIR}/subtract_perfacet_pernight_persb_1.2.sh $i L769393
#  sbatch ${SCRIPT_DIR}/subtract_perfacet_pernight_persb_1.2.sh $i L798074
#  sbatch ${SCRIPT_DIR}/subtract_perfacet_pernight_persb_1.2.sh $i L816272
#done