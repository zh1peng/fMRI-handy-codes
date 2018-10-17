# example 1 fMRI data , remove unused files
# keep files that have 'swau'/'wau'/'rp_au'
import glob
import shutil
import os
search_task = r'C:\Users\RobWhelan\Desktop\PPI_ACC_L_outcome\*\*'
tmp = list(glob.iglob(search_task, recursive=True))

file2remove = [n for n in tmp if 'con_0001.nii' not in n]
for n in file2remove:
    os.remove(n)


