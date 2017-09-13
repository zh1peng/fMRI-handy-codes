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

