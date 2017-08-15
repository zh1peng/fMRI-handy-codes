# Task-related 1st Level GLM

1. Speficiy a 1st level through spm gui
2. Check the codes for that
3. Make it as a templete, specify the varibales that are different among subjects.
4. Loop through subject

:tada:Tips:

1. Use `f = spm_select('FPList', fullfile(data_path,subid{indx}), '^swea.*\.nii$');`  or `fullfile`to select the scan file.

2. If the code is not working, check if the 

    *scan files ➡️  [are pointing the correct files]

    *condition onsets ➡️  [are in correct formate. cColumn vector as I remember] 

    *head motion file ➡️[pointing the correct files]

    *output_dir ➡️[exists and is a cellstr `cellstr`]


3. Use dependency so that you don't need to run them sepreately.
4. Make templete through GUI.

# PPI (Psycho-Physiologic Interaction)

## Before PPI:

1. Run specify a standard GML with conditions and regressors.
2. Estimate GML
3. Store results in 'data_path'

## PPI

1. Extract VOIF contrast. For collection of VOIs it is better to adjust for effects of interest.

   ```
   %spm_regions(SPM, my_xyz, my_name, my_con_nr+1, my_radius)
   my_spm_regions(SPM, VOI_xyz {Vi}, VOI_name{Vi}, 2, 3); %2 = F_contrast+1
   ```

   ​

2. Make PPI varibles

   ```
   my_spm_peb_ppi(SPM, ppiflag, voi, cond, weight, name)
   ```

   It will save the PPI varibles as 'name' as a mat file.

   `comp={'big-no'}`You may need to loop through this, if you have muliple comparisions to do.

   `cond=[1 3]`In the 1st GML, big-win is the 3rd condtion and no win is the 1st condition

   `weight=[-1,1]`Weights to make the 3rd condition minus the 1st condition in the normal GML model.

   `ppiflag = 'psychophysiologic interaction';`

3. Specify a GML with PPI varibles and movement regressorsLoad PPI mat file generate in last step and put them as regressors:

   ```
       matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).name = ['PPI_interation'];
       matlabbatch{1}.spm.stats.fmri_spec.sess.regress(1).val = PPI.ppi;
       matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).name = 'Pysiol_Y';
       matlabbatch{1}.spm.stats.fmri_spec.sess.regress(2).val = PPI.Y;
       matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).name = 'Pschol_P';
       matlabbatch{1}.spm.stats.fmri_spec.sess.regress(3).val = PPI.P;
       matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motion_parameter};
   ```

   ​

4. Estimate GML and Contrast 

5. :checkered_flag:

## Note:

1. Make sure `my_spm_regions` and `my_spm_peb_ppi` are in the path. 
2. There is an "official" way to extract VOI and make PPI variable [see `batch_ppi`]. But need to some changes to make it work, as it is the codes for the example in the SPM manual. I tested it years ago, the extraction results looked same.

# Plot with BrainNet Viewer

:walking: coming soon [converting form word to markdown]