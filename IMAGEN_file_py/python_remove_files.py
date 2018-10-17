# example 1 fMRI data , remove unused files
# keep files that have 'swau'/'wau'/'rp_au'
import glob
import shutil
import os
search_task = r'Z:\IMAGEN data downloaded\TEST_IMAGEN_ZP\BL\processed\spm_preprocessing\*\EPI_stop_signal\*'
tmp = list(glob.iglob(search_task, recursive=True))

file2remove = [n for n in tmp if 'swau' not in n and 'wau' not in n and 'rp_au' not in n]
for n in file2remove:
    os.remove(n)

# example 2 EEG data remove useless files: intermediate folder
search_task = r'W:\eMID project\**\Inter*'
tmp = list(glob.iglob(search_task, recursive=True))
for n in tmp:
    shutil.rmtree(n)
shutil.rmtree(r'W:\eMID project\test move')
# example3 EEG data remove useless
search_task = r'W:\eMID project\**\*'
tmp = list(glob.iglob(search_task, recursive=True))
# file2remove = [n for n in tmp if 'bdf' in n or 'eegjob' in n or 'ced' in n or 'log' in n or 'txt' in n and  if 'mat' in n]
file2remove
for n in file2remove:
    os.remove(n)

# def get_dir_size(path=os.getcwd()):
#
#     total_size = 0
#     for dirpath, dirnames, filenames in os.walk(path):
#
#         dirsize = 0
#         for f in filenames:
#             fp = os.path.join(dirpath, f)
#             size = os.path.getsize(fp)
#             #print('\t',size, f)
#             #print(dirpath, dirnames, filenames,size)
#             dirsize += size
#             total_size += size
#         print('\t',dirsize, dirpath)
#     print(" {0:.2f} Kb".format(total_size/1024))

    # get_dir_size(r'Z:\IMAGEN data downloaded\TEST_IMAGEN_ZP\BL')
