# import glob
# import shutil
# import os
# output = r'W:\IMAGEN_MID_data\FU2_info'
# search_task = r'W:\IMAGEN_MID_data\FU2\processed\spm_preprocessing\*\EPI_mid\rp_au*.txt'
# count = 0
# for filen in glob.iglob(search_task, recursive=True):
#     count += 1
#     subid = os.path.basename(os.path.dirname(os.path.dirname(filen)))
#     subpath = os.path.join(output, subid)
#     if not os.path.exists(subpath):
#         os.makedirs(subpath)
#     print('copying file: ' + str(count))
#     shutil.copy(filen, subpath)

# copy EPI_onset csv file
# import glob
# import shutil
# import os
# output = r'Z:\IMAGEN_MID_data\BL_info'
# search_task = r'H:\EPI_onsets\BL\processed\nifti\*\BehaviouralData\mid_*.csv'
# count = 0
# for filen in glob.iglob(search_task, recursive=True):
#     count += 1
#     subid = os.path.basename(os.path.dirname(os.path.dirname(filen)))
#     subpath = os.path.join(output, subid)
#     if not os.path.exists(subpath):
#         os.makedirs(subpath)
#     print('copying file: ' + str(count))
#     shutil.copy(filen, subpath)


# import glob
# import shutil
# import os
# output = r'W:\IMAGEN_MID_data\FU2_info'
# search_task = r'W:\IMAGEN_MID_data\MID_onsets\FU2\processed\spm_first_level\*\EPI_mid\onset.txt'
# count = 0
# for filen in glob.iglob(search_task, recursive=True):
#     count += 1
#     subid = os.path.basename(os.path.dirname(os.path.dirname(filen)))
#     subpath = os.path.join(output, subid)
#     if not os.path.exists(subpath):
#         os.makedirs(subpath)
#     print('copying file: ' + str(count))
#     shutil.copy(filen, subpath)

import glob
import shutil
import os
output = r'W:\IMAGEN_MID_data\BL_info'
search_task = r'W:\IMAGEN_MID_data\MID_onsets\BL\processed\spm_first_level\*\EPI_short_MID\onset.txt'
count = 0
for filen in glob.iglob(search_task, recursive=True):
    count += 1
    subid = os.path.basename(os.path.dirname(os.path.dirname(filen)))
    subpath = os.path.join(output, subid)
    if not os.path.exists(subpath):
        os.makedirs(subpath)
    print('copying file: ' + str(count))
    shutil.copy(filen, subpath)
