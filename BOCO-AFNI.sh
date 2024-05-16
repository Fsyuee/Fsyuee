#!/bin/bash


echo "The script starts now:  I expect two files Not_Nulled_Basis_a.nii and Nulled_Basis_b.nii that are motion corrected with SPM"


echo "temporal upsampling and shifting happens now"
3dUpsample -overwrite  -datum short -prefix Nulled_intemp.nii -n 2 -input Nulled.nii
3dUpsample -overwrite  -datum short -prefix BOLD_intemp.nii   -n 2 -input   BOLD.nii


NumVol=`3dinfo -nv BOLD_intemp.nii`


3dTcat -overwrite -prefix Nulled_intemp.nii Nulled_intemp.nii'[0]' Nulled_intemp.nii'[0..'`expr $NumVol - 2`']' 


echo "BOLD correction happens now"
LN_BOCO -Nulled Nulled_intemp.nii -BOLD BOLD_intemp.nii -trialBOCO 40


echo "I am correcting for the proper TR in the header"
3drefit -TR 2.35 BOLD_intemp.nii
3drefit -TR 2.35 VASO_LN.nii

echo "calculating T1 in EPI space"
3dUpsample -prefix testepi_r1_us -1 2 BOLD.nii
3dUpsample -prefix testepi_r2_us -1 2 Nulled.nii


3dcalc -a testepi_r1_us+orig. -b testepi_r2_us+orig. -c 'b-l' \
   -expr 'c*step(mod(l,2))+a*not(mod(l,2))' \
   -prefix combined.nii

3dTstat -cvarinv -prefix T1_weighted.nii -overwrite combined.nii 

rm testepi_r1_us+orig.BRIK
rm testepi_r1_us+orig.HEAD
rm testepi_r2_us+orig.BRIK
rm testepi_r2_us+orig.HEAD
rm combined.nii


echo "calculating Mean and tSNR maps"
3dTstat -mean -prefix mean_nulled.nii Nulled.nii -overwrite
3dTstat -mean -prefix mean_notnulled.nii BOLD.nii -overwrite
  3dTstat  -overwrite -mean  -prefix BOLD.Mean.nii \
     BOLD_intemp.nii'[1..$]'
  3dTstat  -overwrite -cvarinv  -prefix BOLD.tSNR.nii \
     BOLD_intemp.nii'[1..$]'
  3dTstat  -overwrite -mean  -prefix VASO.Mean.nii \
     VASO_LN.nii'[1..$]'
  3dTstat  -overwrite -cvarinv  -prefix VASO.tSNR.nii \
     VASO_LN.nii'[1..$]'

echo "curtosis and skew"
LN_SKEW -input BOLD.nii
LN_SKEW -input VASO_LN.nii




