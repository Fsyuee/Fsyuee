#!/bin/bash


cp Smagn.nii ./Basis_a.nii
#3dTcat�������ڽ�EPI���ݸ��Ƶ����Ŀ¼��ɾ��ǰ20����Ϣ̬��ʱ���
3dTcat -prefix Basis_a.nii Basis_a.nii'[20..$]' -overwrite
cp ./Basis_a.nii ./Basis_b.nii

# -nv:����ʱ������������ש������
3dinfo -nt Basis_a.nii >> NT.txt
3dinfo -nt Basis_b.nii >> NT.txt


# NOTE: matlab might be at a different loation on your mashine. 
/home/fsyuee/software/MATLAB/bin/matlab -nodesktop -nosplash -r "mocobatch"

gnuplot "gnuplot_moco.txt"

#rm ./Basis_*.nii
