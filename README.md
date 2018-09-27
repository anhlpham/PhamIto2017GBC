# Pham_Ito_17_GBC_Fe_model
Ouput data for GBC 2018 paper "Formation and maintenance of the GEOTRACES subsurface dissolved iron maxima in an ocean biogeochemistry model".
Files include:
1. Fe_Full_run.mat; Fesinks_Full_run.mat, and Fesources_Full_run.mat are the model iron ouput from the Full run
2. Fe_ConstL_run.mat; Fesinks_ConstL_run.mat, and Fesources_ConstL_run.mat are the model iron ouput from the ConstL run
3. Fe_Nodiss_run.mat; Fesinks_Nodiss_run.mat, and Fesources_Nodiss_run.mat are the model iron ouput from the No Fe redissolution run
4. Fe_Weaksed_run.mat; Fesinks_Weaksed_run.mat, and Fesources_Weaksed_run.mat are the model iron ouput from the Weak sed run
5. Fe_Weakhydro_run.mat; Fesinks_Weakhydro_run.mat, and Fesources_Weakhydro_run.mat are the model iron ouput from the Weak hydro run
6. Fe_ConstKL_run.mat, Fesinks_ConstKL_run.mat, and Fesources_ConstKL_run.mat are the model iron output from the ConstKL run
7. Fe_LargeK_run.mat, Fesinks_LargeK_run.mat, and Fesources_LargeK_run.mat are the model iron output from the Large delta K run
8. GA02.mat, GI04.mat,CoFeMUG.mat,GP02.mat, and GP13.mat, and GP16.mat are Fe data from GEOTRACES transects
9. The observational and model data are then interpolated into the same grid point using the objective mapping method. 
10. GA02_obs.mat, GI04_obs.mat,CoFeMUG_obs.mat,GP02_obs.mat, and GP13_obs.mat, and GP16_obs.mat are Fe data along GEOTRACES transects after interpolation
11. GA02_model.mat, GI04_model.mat,CoFeMUG_model.mat,GP02_model.mat, and GP13_model.mat, and GP16_model.mat are Fe model results (Full run) along GEOTRACES transects after interpolation
12. A sample MATLAB script to plot the Fe transect figure in the paper: Pham_Ito_GBC_2018.m
13. A sample MATLAB code to objective map model and observed dFe data into the same grid point following the GA02 GEOTRACES cruise:Objective_mapping_GA02_data.m (Note that this script using m_map package for MATLAB to plot figures)
