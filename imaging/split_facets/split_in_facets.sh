#!/bin/bash
#SBATCH -c 2

#SINGULARITY SETTINGS
SING_BIND=$( python3 $HOME/parse_settings.py --BIND )
SIMG=$( python3 $HOME/parse_settings.py --SIMG )

LISTMS=(*.ms)
H5S=(*.h5)
HH=${H5S[@]}

#make facets based on merged h5
singularity exec -B ${SING_BIND} ${SIMG} python \
/home/lofarvwf-jdejong/scripts/lofar_vlbi_helpers/extra_scripts/ds9facetgenerator.py \
--h5 ${H5S[0]} \
--DS9regionout facets.reg \
--imsize 22500 \
--ms ${LISTMS[0]} \
--pixelscale 0.4

#loop over facets from merged h5
singularity exec -B ${SING_BIND} ${SIMG} python \
/home/lofarvwf-jdejong/scripts/lofar_vlbi_helpers/extra_scripts/split_facets.py \
--h5 ${H5S[0]} \
--reg facets.reg

sbatch /home/lofarvwf-jdejong/scripts/lofar_vlbi_helpers/imaging/split_facets/subtract_per_facet.sh