#!/bin/bash

echo "I estimate activity"

echo "based on difference" 
3dTstat -mean -prefix VASO_r.nii -overwrite  VASO_trialAV_LN.nii'[9-19]'
3dTstat -mean -prefix VASO_a.nii -overwrite  VASO_trialAV_LN.nii'[29-39]'
3dcalc -a  VASO_r.nii -b VASO_a.nii -overwrite -expr '(b-a)/b' -prefix delta_VASO.nii


echo "based on GLM" 
3dDeconvolve -overwrite -jobs 16 -polort a -input VASO_LN.nii\
             -num_stimts 1 \
             -TR_times 4.7 \
             -stim_times 1 '1D: 47 141 235 329 423 517 611 705 799 893' 'UBLOCK(47,1)' -stim_label 1 Task \
             -tout \
             -x1D MODEL_wm \
             -iresp 1 HRF_VASO.nii \
             -bucket STATS_VASO.nii

3dcalc -a HRF_VASO.nii'[1]'    -expr 'a'    -prefix 1_HRF_VASO.nii   -overwrite 
3dcalc -a STATS_VASO.nii'[0]'  -expr 'a'    -prefix 0_STATS_VASO.nii -overwrite 
3dcalc -a STATS_VASO.nii'[2]'  -expr 'a'    -prefix 2_STATS_VASO.nii -overwrite 


echo "The same for BOLD" 

3dTstat -mean -prefix BOLD_r.nii -overwrite  BOLD_trialAV_LN.nii'[9-19]'
3dTstat -mean -prefix BOLD_a.nii -overwrite  BOLD_trialAV_LN.nii'[29-39]'
3dcalc -a  BOLD_r.nii -b BOLD_a.nii -overwrite -expr '(a-b)/b' -prefix delta_BOLD.nii


#REST+TASK
3dDeconvolve -overwrite -jobs 16 -polort a -input BOLD_intemp.nii\
             -num_stimts 1 \
             -TR_times 2.35 \
             -stim_times 1 '1D: 47 141 235 329 423 517 611 705 799 893' 'UBLOCK(47,1)' -stim_label 1 Task \
             -tout \
             -x1D MODEL_wm \
             -iresp 1 HRF_BOLD.nii \
             -bucket STATS_BOLD.nii

3dcalc -a HRF_BOLD.nii'[1]'    -expr '-1*a' -prefix 1_HRF_BOLD.nii -overwrite
3dcalc -a STATS_BOLD.nii'[0]'  -expr 'a'   -prefix 0_STATS_BOLD.nii -overwrite 
3dcalc -a STATS_BOLD.nii'[2]'  -expr '-1*a' -prefix 2_STATS_BOLD.nii -overwrite 
