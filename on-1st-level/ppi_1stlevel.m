%% Before PPI:
% Run specify a standard GML with conditions and regressors.
% Estimate GML
% Store results in 'data_path'

%% PPI:
spm_jobman('initcfg')
spm('Defaults','fMRI')
spm_get_defaults('cmdline',true)

data_path='[[dir for the 1st GLM results]]'
load ('subid.mat')

%% Step1. F test for effect of interest========================================
% This is optional. For collection of VOIs it is better to adjust for effects
% of interest. This will create an F-contrast to identify the sources of
% signal that you are interested in and remove all the rest (movement effects etc.).
for indx=1:length(subid)
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(fullfile(data_path,subid{indx},'SPM.mat'));
    matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = 'Effects of interest';
    matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [eye(8)]; %eight conditions in 1st level
    matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.delete = 1; %Delete previous contrast!
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    strr=['F test for effect of interest for NO.' num2str(indx) ' is done'];
    disp(strr)
end

%% Step2. Extracting ROI and make PPI variable======================================
% Here it uses kind of customized extraction and PPI variable codes from another lab.
% There is another way (spm batch) to do this. See VOI and PPI in spm batch

My_VOI = {'ACC_L';...
    'ACC_R'};

%If you want to add some prefix to the VOI, like Peak_ACC_L
%VOI_name=cellfun(@(x) strcat('Peak_', x), My_VOI,'Unif',0);

VOI_name=My_VOI;
VOI_xyz  = {[-3;41;7];...
    [3;41;7]};

%1.no,2.small,3.big,4.big_hit,5.big_mis,6.small_hit,7.small_mis,8.no_win
% In the 1st GML, big-win is the 3rd condtion and no win is the 1st condition

comp={'big-no'} %Just a name to save PPI.Loop through comp if there are multiple comparisions
cond=[1 3]
weight=[-1,1]
ppiflag = 'psychophysiologic interaction';

for indx=1:length(subid);
    cd(fullfile(data_path,subid{indx})); load('SPM.mat');
    for Vi=1:length(VOI_name)
        %spm_regions(SPM, my_xyz, my_name, my_con_nr+1, my_radius)
        % Extraction
        my_spm_regions(SPM, VOI_xyz {Vi}, VOI_name{Vi}, 2, 3); %F is 1+1=2
        % Make PPI
        voi = ['VOI_' ,VOI_name{Vi}, '_1.mat'];
        name = [VOI_name{Vi} ,'_' ,comp{1}]; %Loop through the comp if there are multiple comparisions
        PPI = my_spm_peb_ppi(SPM, ppiflag, voi, cond, weight, name);
        clear PPI
        close all
    end
    strr=['Extracting ROI and Creating PPI Variables for NO.' num2str(indx) ' is done'];
    disp(strr)
end


%% Step3. Run another GML with PPI variables=================================================================
for indx=1:length(subid);
    f = spm_select('FPList', fullfile('!!!!swea files path!!!!',subid{indx}), '^swea.*\.nii$');
    motion_parameter=ls(['!!!!movement file path!!!!',subid{indx},'/SessionB/EPI_short_MID/' strcat('rp*',subid{indx},'*')]);
    motion_parameter=fullfile('!!!!movement file path!!!!',subid{indx},'/SessionB/EPI_short_MID/',motion_parameter);

    for Vi=1:length(VOI_name)
        matlabbatch=[];
        PPI_name = ['PPI_', VOI_name{Vi},'_' comp{1}];
        sub_dir=fullfile('!!!!output dir!!!!!',PPI_name,subid{indx});
        mkdir(sub_dir);
        load(fullfile(data_path,subid{indx},strcat(PPI_name,'.mat')));

        matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(sub_dir);
        matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.2;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
        matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(f);
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = ['PPI_interation'];
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Pysiol_Y';
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Pschol_P';
        matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = PPI.P;
        matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motion_parameter};

        matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
        matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
        matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));

        matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'PPI_interaction';
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1];
        matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
        matlabbatch{3}.spm.stats.con.delete = 0;
        spm_jobman('run',matlabbatch);
        matlabbatch=[];
    end
    clc
    disp(num2str(indx));
end
