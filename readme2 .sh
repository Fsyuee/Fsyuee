
#-----step1-----
#dicom -> nii

#method 1: use fsleyes 
#method 2 :use dcm2niix(for example: dcm2niix -o /media/sub1/test.nii /media/fsyuee/raw_sub1)
#echo1 is converted to Nulled.nii
#echo2 is converted to BOLD.nii

#-----step2-----
#NODIC

#Remember to change the path in 'NODIC_VASO_wrapper.m'
#matlab runs 'NODIC_VASO_wrapper.m'


#-----step3----- 
#realign

#method 1: use AFNI
3dvolreg -overwrite -prefix  Nulled.nii -base NORDIC_run1_INV1.nii'[0]'  -dfile vaso_dfile.1D -1Dfile vaso_1Dfile.mot.1D NORDIC_run1_INV1.nii'[0..$]'
3dvolreg -overwrite -prefix  BOLD.nii -base NORDIC_run1_INV2.nii'[0]'  -dfile bold_dfile.1D -1Dfile bold_1Dfile.mot.1D NORDIC_run1_INV2.nii'[0..$]'

1dplot -png vaso.png -volreg vaso_1Dfile.mot.1D
1dplot -png bold.png -volreg bold_1Dfile.mot.1D


#-----step4----- 
#BOLD correction, calculation of signal to noise ratio, etc
#run 'BOCO.sh'


#-----step5-----
#Estimate activity based on difference or GLM, see 'ACTIVATION.sh' for details.


#-----step6-----
#Upsample, and manually draw 'rim.ni'i in 'scaled_T1.nii', layered, see 'LAYERNING.sh' for details.

