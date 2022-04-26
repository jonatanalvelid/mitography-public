Instructions for plotting Mitography results:

1. Run analysis.
2. Run "ResultsHistogramPlotting..." for the variables you want to look at.
	a. Pick the folder in the first window that comes up.
	b. Do nothing in the second window that comes up.
	c. Press "Update Thresholds" on the GUI.
	d. Pick the folder again.
	e. Change the "Last image number" (31 by default) field to the last image number of your dataset.
	f. Press the button of the histrograms you are interested in: "Primary morphology" for width, length, area etc., "Actin" for actin-mito distance (D2 is the last version of this, furthest to the right of the histograms). 

If you want to plot histgrams comparing two datasets:
3. Close the ResultsHistogramPlotting GUI. In the Workspace of MATLAB, locate "mitoWidthNS", "mitoLengthNS", "mitoAreaNS", "mitoactindist" etc. Rename these to other names in order to prepare to save them. For example: "mitoWidthNS" renamed to "mitoWidthControl" if it was the control dataset.
4. Repeat step 4 for all the datasets of interest.
5. Save the workspace with all the named variables. (If you want: before saving, delete all other variables)
6. Open the "ResultsHistogramPlotting..." script, rename the variables h1var, h2var, h3var,... etc inside the script to the variable names you choose in the last few steps. This is explained also inside the MATLAB script.
7. If you want: change the plotting boundaries, like the y-axis top bound, the binning width etc. 
7. Run the script and it will plot histograms comparing your different datasets.