

%% import data
[num,txt,raw]=xlsread('C:\Users\Zhipeng\Desktop\ppi plot\results_WISCdsbacklongest.csv','results_WISCdsbacklongest');
%% Find values
ROI_name=raw(2:end-9,1);
beta_wz=raw(2:end-9,3);
% beta_nz=raw(2:end-9,4);
ROI_mask=ROI_name(cellfun(@any,beta_wz));
ROI_beta_wz=beta_wz(cellfun(@any,beta_wz));
% ROI_mask=cellfun(@(x) x(7:end), ROI_name_beta, 'Unif', 0)
% ROI_beta_nz=beta_nz(cellfun(@any,beta_wz));
original_mask_path='C:\Users\Zhipeng\Google ‘∆∂À”≤≈Ã\matlab files on Drive\AAL_masks\exval_masks'
for indx=1:length(ROI_mask)
beta=ROI_beta_wz{indx};
mask_name=ROI_mask{indx};
matlabbatch{1}.spm.util.imcalc.input = cellstr(strcat(fullfile(original_mask_path,['exval_',mask_name]),'.nii,1'))
matlabbatch{1}.spm.util.imcalc.output = ['beta_',mask_name];
matlabbatch{1}.spm.util.imcalc.outdir = {'C:\Users\Zhipeng\Desktop\test plot\'};
matlabbatch{1}.spm.util.imcalc.expression = 'i1*beta';
matlabbatch{1}.spm.util.imcalc.var.name = 'beta';
matlabbatch{1}.spm.util.imcalc.var.value =beta;
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0; %don't read images into data matrix
matlabbatch{1}.spm.util.imcalc.options.mask = 0; %No implicit zero mask
matlabbatch{1}.spm.util.imcalc.options.interp = 1;%Trilinear
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;%INT16--signed short
spm_jobman('run',matlabbatch);
clear matlabbatch
end
    

%This part can be used for write txt file for
%nodes*********************************************************************************************************
%  Find coordinates for ROI_name_beta
% ROI_label=cellfun(@(x) x(7:end), ROI_name_beta, 'Unif', 0)
% ROI_xyz=cellfun(@(x) xyz4AAL(find(strcmpi(x, xyz4AAL(:,1))==1),7:9), ROI_label, 'Unif', 0)
% erro=ROI_name_beta(cellfun('isempty',ROI_xyz));
% if ~isempty(erro)
% disp(['Can not find coordinates for: ///',strjoin(erro','///')]);
% pause
% end
% 
% colour_module=repmat({1},size(ROI_beta_wz));
% xyz=ROI_xyz(~cellfun('isempty',ROI_xyz))
% % cellfun(@cell2mat, xyz,'Unif',0)
% label=ROI_label(~cellfun('isempty',ROI_xyz))
% output=[xyz, ROI_beta_wz, colour_module,label]
%  tmpfile2=cell2table(output);
% writetable(tmpfile2, ['C:\Users\Zhipeng\Desktop\test.txt'], 'WriteVariableNames',false, 'Delimiter', 'tab')
%*******************************************************************************************************************


%% covert hdr/img to nii
data_path='C:\Users\Zhipeng\Google ‘∆∂À”≤≈Ã\matlab files on Drive\AAL_masks\all_masks'
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
