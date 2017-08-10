%% covert hdr/img to nii
data_path='F:\Google Drive\MID paper zhipeng\final final results\permutation prob map'
cd(data_path)
filename=cellstr(ls(strcat(data_path, '\*.img')))
outputname=cellfun(@(x) x(1:end-4),filename, 'Unif',0)
for n=1:length(filename)
output=strcat(outputname{n},'.nii')
V=spm_vol(filename{n});
ima=spm_read_vols(V);
V.fname=output;
spm_write_vol(V,ima);
end

%% Co reg
mask2use=cellstr(ls('C:\Users\Zhipeng\Desktop\AAL nii\*.nii'));
mask2use=fullfile('C:\Users\Zhipeng\Desktop\AAL nii\',mask2use);
volfiles='C:\Users\Zhipeng\Desktop\GLM 2nd level extraction\Anticipation-Big-No\spmT_0001.nii'

flags.prefix='extract_';flags.which=1;flags.mean=0;
    spm_reslice([volfiles mask2use'],flags);