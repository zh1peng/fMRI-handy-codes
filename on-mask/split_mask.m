%% split script using original spm file
function []=split_mask(mask, output_path,mask_number)
for n=1:mask_number
Vi=mask
Vo=fullfile(output_path,['mask',num2str(n),'.nii'])
expression=sprintf('i1==%s',num2str(n))
spm_imcalc(Vi,Vo,expression)
clear Vi Vo expression
end
