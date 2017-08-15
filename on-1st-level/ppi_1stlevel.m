% Before PPI:
% Run specify a standard GML with conditions and regressors.
% Estimate GML
% Store results in 'data_path'

PPI:
spm_jobman('initcfg')
spm('Defaults','fMRI')
spm_get_defaults('cmdline',true)

data_path='{dir for the 1st GLM results}'
load "subid"

%% Step1. F test for effect of interest========================================
% This is optional. For collection of VOIs it is better to adjust for effects
% of interest. This will create an F-contrast to identify the sources of
% signal that you are interested in and remove all the rest (movement effects etc.).
for indx=1:length(subid)
    matlabbatch{1}.spm.stats.con.spmmat = cellstr(fullfile(data_path,subid{indx},'SPM.mat'));
    matlabbatch{1}.spm.stats.con.consess{1}.fcon.name = 'Effects of interest';
    matlabbatch{1}.spm.stats.con.consess{1}.fcon.weights = [eye(8)];
    matlabbatch{1}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
    matlabbatch{1}.spm.stats.con.delete = 1; %Delete previous contrast!
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    strr=['F test for effect of interest for NO.' num2str(indx) ' is done'];
    disp(strr)
end

%% Step2. Extracting ROI and make PPI variable======================================
% Here it uses kind of customized extraction and PPI variable codes from another lab.
% Basically, they are modified spm codes.
% There is another way (spm batch) to do this. See VOI and PPI in spm batch

My_VOI = {'Thalamus_L';...
    'Pallidum_L';...
    'Pallidum_R';...
    'Thalamus_R';...
    'Ventral_Striatum_R';...
    'Ventral_Striatum_L';...
    'Putamen_Vs_L';...
    'Putamen_Vs_R';...
    'Caudate_Vs_R';...
    'Supp_Motor_Area_L'};
VOI_name=cellfun(@(x) strcat('Peak_', x), My_VOI,'Unif',0);
VOI_xyz  = {...
    [-9;-19;7];...
    [-12;8;-2];...
    [15;8;1];...
    [12;-13;7];...
    [12;14;-8];...
    [-15;14;-8];...
    [-15;14;-5];...
    [15;14;-8];...
    [9;11;1];...
    [0;2;55]};

% In the 1st GML, big-win is the 3rd condtion and no win is the 1st condition,
comp={'big-no'}
cond=[1 3]
weight=[-1,1]
ppiflag = 'psychophysiologic interaction';

for indx=1:length(subid);
    cd(fullfile(data_path,subid{indx})); load('SPM.mat');
    for Vi=1:length(VOI_name)
        %spm_regions(SPM, my_xyz, my_name, my_con_nr+1, my_radius)
        my_spm_regions(SPM, VOI_xyz {Vi}, VOI_name{Vi}, 2, 3); %F is 1+1=2
        voi = ['VOI_' VOI_name{Vi} '_1.mat'];

        name = [VOI_name{Vi} '_' comp{1}]; %Only one comp here, no loop
        PPI = my_spm_peb_ppi(SPM, ppiflag, voi, cond, weight, name);
        clear SPM, PPI
        close all
    end
    strr=['Extracting ROI and Creating PPI Variables for NO.' num2str(indx) ' is done'];
    disp(strr)
end


%% Step3. Specifiy a GML with PPI variables=================================================================
for indx=1:length(subid);
    for Vi=1:length(VOI_name)

    PPI_name = ['PPI_', VOI_name{Vi} '_' comp{1}];
    mkdir(fullfile(data_path,subid{indx},PPI_name));
    load(fullfile(data_path,subid{indx},strcat(PPI_name,'.mat')));

    motion_parameter=ls(['/Volumes/MRI data/Imagen_ts_1stlev/ppi analysis/movement_parameters/',subid{indx},'/SessionB/EPI_short_MID/' strcat('rp*',subid{indx},'*')]);

    matlabbatch{1}.spm.stats.fmri_spec.dir = cellstr(fullfile(data_path,subid{indx},PPI_name));
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.2;
    f = spm_select('FPList', fullfile(data_path,subid{indx}), '^swea.*\.nii$');
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = cellstr(f);
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = ['PPI_interation'];
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Pysiol_Y';
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Pschol_P';
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = PPI.P;
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motion_parameter};
    spm_jobman('run', matlabbatch);
    clear matlabbatch
    strr=[ VOI_name{Vi},' for NO.' num2str(indx) ' is done'];
    disp(strr)
    end
    strr=[  'PPI GLMs for NO.' num2str(indx) ' are done'];
    disp(strr)
end

%% Step4. Estimation and Contrast

for indx=1:length(subid)
    for Vi=1:length(VOI_name)
           PPI_name = ['PPI_', VOI_name{Vi} '_outcome'];
    matlabbatch{1}.spm.stats.fmri_est.spmmat{1} = fullfile(data_path,subid{indx},PPI_name,'SPM.mat');
    matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{2}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.con.consess{1}.tcon.name = 'PPI-Interaction';
    matlabbatch{2}.spm.stats.con.consess{1}.tcon.weights = [1];
    matlabbatch{2}.spm.stats.con.delete = 1
    spm_jobman('run', matlabbatch);
    clear matlabbatch
    strr=['Estimation for and Contrast of ', VOI_name{Vi}, ' for NO.', num2str(indx), ' is done'];
    disp(strr)
    end
    strr=['Estimation for and Contrast for NO.', num2str(indx), ' are done'];
    disp(strr)
end
