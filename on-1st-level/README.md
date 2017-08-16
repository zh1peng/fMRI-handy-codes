# Task-related 1st Level GLM

1. Speficiy a 1st level through spm gui
2. Find the codes for that
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

2. There is an "official" way to extract VOI and make PPI variable [see `batch_ppi`].

   But need to some changes to make it work, as it is the codes for the example in the SPM manual. I tested it years ago, the extraction results looked same.

# Plot with BrainNet Viewer

1.    add brainnet view into matlabpath

2.    In command window, type in“BrainNet”

3.    File>Load File

4. Load Surface file, choose a surface provided by BrainNet

   ![Load surface](../master/img4readme/1.png)

5. Load a node file you made

    A node file includes MNI xyz, node type, node size, nodename;
    Node type allows you put different types in differentcolor; Use “_” to replace space in the node name.   (No space is allowed in nodename)
    After you made a file like this, save it as “.node” ratherthan ‘.txt’

   `Note: If pasting excel to txt file does not work, find an original node and edge file (you can find some in the BrainNet viewer folder) that can be loaded in BrainNet and paste the figures in them.`

         ![A node file](../master/img4readme/2.png)

  6. Load an edge file you made

  The edge file is a ROIs*ROIs matrix, and figures in it indicate the connection (0/1) or the strength of connection. In the following example the figures indicate whether there is a connection between two ROIs. After making this edge file, save it with ‘.edge’

   ![A edge file](../master/img4readme/3.png)

  7. Click OK entering Option panel. Set properties like layout, node color, node size, edge color, edge size etc. of the figure and click apply. The plot will appear in the main window.

  8. File>save image

Advanced tips:

Check toolbox manual for 

1. advanced plotting with different line colors.
2. batch plotting using codes.
3. save option would be a good idea.

