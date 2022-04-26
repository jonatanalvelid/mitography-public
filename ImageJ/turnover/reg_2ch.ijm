// Channel 1

dir1 = "C:/Users/Jonatan/Desktop/temp_analysis/NLGC_mice_Turnover OMP25_TMR-SiR/Cell4/stitching/tmr_raw";
outputfilename = "TileConfiguration_tmrreg_tmr.txt";
run("Grid/Collection stitching", "type=[Unknown position] order=[All files in directory] directory=["+dir1+"] output_textfile_name="+outputfilename+" fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 add_tiles_as_rois computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");

// Channel 2

dir2 = "C:/Users/Jonatan/Desktop/temp_analysis/NLGC_mice_Turnover OMP25_TMR-SiR/Cell4/stitching/sir_raw";
layoutfile = "TileConfiguration_tmrreg_sir.txt";
run("Grid/Collection stitching", "type=[Positions from file] order=[Defined by TileConfiguration] directory=["+dir2+"] layout_file="+layoutfile+" fusion_method=[Linear Blending] regression_threshold=0.30 max/avg_displacement_threshold=2.50 absolute_displacement_threshold=3.50 computation_parameters=[Save memory (but be slower)] image_output=[Fuse and display]");
