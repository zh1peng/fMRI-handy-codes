function []=dir_ROI_sum(input_path,ROI_format,output_dir,weight)
%input_paht: where are the ROI files
%weight [0--no weight, just sum ROI, 1--add weight (1,2,3)] default: 0
%ROI_format='.img' or '.nii'

%save name
name_tmp=regexp(input_path,filesep,'split');
if weight==0
save_name=['merged_',name_tmp{end}]; %save as folder name
elseif weight==1
 save_name=['Wmerged_',name_tmp{end}] ;   
end

%save dir
if ~exist(output_dir)
    mkdir(output_dir)
end

%input files
[path,name]=filesearch_substring(input_path,ROI_format,0);
VIs=fullfile(path,name);

%make expression
file_n=[1:length(VIs)];
if weight==0
expression=sprintf('i%d+',file_n);
elseif weight==1
    tmp=[file_n;file_n];
    new_n=tmp(:)';
    expression=sprintf('i%d*%d+',new_n);
end
expression=expression(1:end-1);
%name as folder name
matlabbatch{1}.spm.util.imcalc.input = VIs';                                      
matlabbatch{1}.spm.util.imcalc.output = save_name;
matlabbatch{1}.spm.util.imcalc.outdir = cellstr(output_dir);
matlabbatch{1}.spm.util.imcalc.expression = expression;
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
spm_jobman('run',matlabbatch)
matlabbatch=[];
end