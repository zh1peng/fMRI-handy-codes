%% pre works before 1st level for IMAGEN

%% gunzip file to working folder
data_path='C:\Users\RobWhelan\Desktop\spmpreproc'
% all_ids=my_ls(data_path);
task_label='EPI_stop_signal';

[path,name]=filesearch_substring(data_path,'.gz');%find all gz files

task=cellfun(@(x) strfind(x,task_label),path,'Unif',0); %find all task_label gz files
new_path=path(~cellfun('isempty',task));
new_file=name(~cellfun('isempty',task));

subid=cellfun(@(x) x(39:end-25),new_path,'Unif',0); % !!!!!!change the num when you have different data_path!!!!!!!!!!!!!!!!!!
source=cellfun(@fullfile,new_path,new_file,'Unif',0);


output='C:\Users\RobWhelan\Desktop\Imagen SST raw S4';
save('C:\Users\RobWhelan\Desktop\Imagen SST raw S4/MRI_subid.mat','subid')


if ~exist(output)
    mkdir(output);
end

output_path=fullfile(output,subid);
cellfun(@mkdir,output_path,'Unif',0);

datapath='/Volumes/ShareDisk_2/Face_FU2_cons_raw'
[path,name]=filesearch_substring(data_path,'.gz');%find all gz files
source=fullfile(path,name)
cellfun(@gunzip,source,'Unif',0);
cellfun(@gunzip,source,output_path,'Unif',0);% gunzip to output_path
%cellfun(@copyfile,source,output_path,'Unif',0); copy gz files if needed


%% split to 4D
[path,name]=filesearch_substring(output,'.nii')% require only one nii file in each subject's folder!!!!!!!!!!
wea2split=cellfun(@fullfile,path',name','Unif',0)
save('C:\Users\RobWhelan\Desktop\Imagen SST raw S4/wea2split.mat','subid')

 spm_jobman('initcfg');
 spm('defaults','fmri');

parpool(2)
parfor indx=2:length(wea2split)
matlabbatch=[];
matlabbatch{1}.spm.util.split.vol = wea2split(indx);
spm_jobman('run',matlabbatch);

%% smooth
matlabbatch=[];
subpath=output_path{indx};
[path,name]=filesearch_substring(subpath,'_0');
wea2smooth=cellfun(@fullfile,path',name','Unif',0);

matlabbatch{1}.spm.spatial.smooth.data = wea2smooth
matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run',matlabbatch);

%% delete wea files and 4D file
delete(wea2split{indx});
cellfun(@delete,wea2smooth);
end




