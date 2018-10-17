###dir_ROI_sum

a function to sum ROI masks to one nii file (weighted or non-weighted)

how to use:

```matlab
%% run on SF
input_path='C:\Users\Zhipeng\Desktop\ROIs_separated_by_factors\SF\'
output_dir='C:\Users\Zhipeng\Desktop\ROIs_separated_by_factors\SF_OUTPUT';
ROI_format='.img';
weight=0;
tmp_dir=dir(input_path);
for n=3:length(tmp_dir)
new_path=fullfile(input_path,tmp_dir(n).name);
dir_ROI_sum(new_path,ROI_format,output_dir,weight);
clear new_path
end
% merge with weight
dir_ROI_sum(output_dir,'.nii','C:\Users\Zhipeng\Desktop\ROIs_separated_by_factors\SF_W',1);
input_path='C:\Users\Zhipeng\Desktop\ROIs_separated_by_factors\SS\'
output_dir='C:\Users\Zhipeng\Desktop\ROIs_separated_by_factors\SS_OUTPUT';
ROI_format='.img';
weight=0;
tmp_dir=dir(input_path);
for n=3:length(tmp_dir)
new_path=fullfile(input_path,tmp_dir(n).name);
dir_ROI_sum(new_path,ROI_format,output_dir,weight);
clear new_path
end
% merge with weight
dir_ROI_sum(output_dir,'.nii','C:\Users\Zhipeng\Desktop\ROIs_separated_by_factors\SS_W',1);
```



### split_mask

a function to seperate different ROIs weighted as 1,2,3... in a mask file

### beta2mask

codes to add beta values to masks ROIs.

### Reslice example codes

```matlab
%% Co reg
mask2use=cellstr(ls('C:\Users\Zhipeng\Desktop\AAL nii\*.nii'));
mask2use=fullfile('C:\Users\Zhipeng\Desktop\AAL nii\',mask2use);
volfiles='C:\Users\Zhipeng\Desktop\GLM 2nd level extraction\Anticipation-Big-No\spmT_0001.nii'

flags.prefix='extract_';flags.which=1;flags.mean=0;
    spm_reslice([volfiles mask2use'],flags);
```

### option

BrainNet viewer plotting option that I was using
