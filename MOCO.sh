#!/bin/bash


cp Smagn.nii ./Basis_a.nii
#3dTcat程序用于将EPI数据复制到结果目录，删除前20个静息态的时间点
3dTcat -prefix Basis_a.nii Basis_a.nii'[20..$]' -overwrite
cp ./Basis_a.nii ./Basis_b.nii

# -nv:返回时间点的数量或子砖的数量
3dinfo -nt Basis_a.nii >> NT.txt
3dinfo -nt Basis_b.nii >> NT.txt


# NOTE: matlab might be at a different loation on your mashine. 
/home/fsyuee/software/MATLAB/bin/matlab -nodesktop -nosplash -r "mocobatch"

gnuplot "gnuplot_moco.txt"

#rm ./Basis_*.nii
