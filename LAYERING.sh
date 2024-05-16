#!/bin/bash


# Upsample
#pixdim1
delta_x=$(3dinfo -di T1_weighted.nii)
#pixdim2
delta_y=$(3dinfo -dj T1_weighted.nii)
#pixdim3
delta_z=$(3dinfo -dk T1_weighted.nii)

sdelta_x=$(echo "((sqrt($delta_x * $delta_x) / 5))"|bc -l)
sdelta_y=$(echo "((sqrt($delta_y * $delta_y) / 5))"|bc -l)
sdelta_z=$(echo "((sqrt($delta_z * $delta_z) / 5))"|bc -l) 

# here I only upscale in 2 dimensions. 
#3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode NN -overwrite -prefix scaled_$1 -input $1 
3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode Cu -overwrite -prefix scaled_T1.nii -input T1_weighted.nii 
3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode Cu -overwrite -prefix scaled_VASO.nii -input 0_STATS_VASO.nii 
3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode Cu -overwrite -prefix scaled_BOLD.nii -input 0_STATS_BOLD.nii 


#estimating layers based on rim
LN_GROW_LAYERS -rim rim.nii -N 11 -vinc 40

mv rim_layers.nii layers.nii


#extractiong profiles for VASO
#get mean value, STDEV, and number of voxels
3dROIstats -mask layers.nii -1DRformat -quiet -nzmean scaled_VASO.nii > layer_t.dat
3dROIstats -mask layers.nii -1DRformat -quiet -sigma scaled_VASO.nii >> layer_t.dat
3dROIstats -mask layers.nii -1DRformat -quiet -nzvoxels scaled_VASO.nii >> layer_t.dat
#format file to be in columns, so gnuplot can read it.
WRD=$(head -n 1 layer_t.dat|wc -w); for((i=2;i<=$WRD;i=i+2)); do awk '{print $'$i'}' layer_t.dat| tr '\n' ' ';echo; done > layer.dat

1dplot -sepscl layer.dat 
mv layer.dat layer_VASO.dat

#extractiong profiles for BOLD
#get mean value, STDEV, and number of voxels
3dROIstats -mask layers.nii -1DRformat -quiet -nzmean scaled_BOLD.nii > layer_t.dat
3dROIstats -mask layers.nii -1DRformat -quiet -sigma scaled_BOLD.nii >> layer_t.dat
3dROIstats -mask layers.nii -1DRformat -quiet -nzvoxels scaled_BOLD.nii >> layer_t.dat
#format file to be in columns, so gnuplot can read it.
WRD=$(head -n 1 layer_t.dat|wc -w); for((i=2;i<=$WRD;i=i+2)); do awk '{print $'$i'}' layer_t.dat| tr '\n' ' ';echo; done > layer.dat

1dplot -sepscl layer.dat 
mv layer.dat layer_BOLD.dat

gnuplot "gnuplot_layers.txt"

