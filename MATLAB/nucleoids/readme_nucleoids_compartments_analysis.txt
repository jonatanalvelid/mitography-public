Analysis of nucleoids per mitochondria for different compartments of the neuron
-------------------------------------------------------------------------------
For all steps, using the provided scripts, make sure the images have names matching those in the scripts, alternatively change the scripts. 

1. Gather the following images as .tifs (Use msr2tif-singlechannel or multicolor if wanted)
a) nucleoids image 
b) mito image
c) AIS/other axon/dendrite labelled image
d) neurites image
2. If more than one image per cell: tile/merge into one image, for a), b), d) (Use Pairwise stiching, Grid/collection stiching, or MosaicJ in ImageJ, depending on how the image has been acquired)
3. Manually generate binary map of axon/dendrite, if wanted.
4. Manually generate binary soma image, to be used as seed for the distance transform of the neurites binary image. 
5. Binarize mito image and neurites image (neurites binary should contain the soma as well) (Use ImageJ scripts: NeuritesBinarization (two alternatives), and MitoBinarization (two alternatives), 
adapt thresholds and parameters in the scripts to the images)
6. Make a geodesic distance transform of the binary neurites image (Use MATLAB script: distancetrasnform_folder)
7. If too large images to work with: split binary mito image, binary neurites image, distance transformed image to smaller tiles again (now without overlap) (Cannot remember what I used to do this, but should be ImageJ plugins available, 
alternatively write your own MATLAB/ImageJ/Python script to do it)
8. Detect nucleoids in nucleoids image, generating a list of nuceloid center coordinates (Use ImageJ script: TFAMmaximaFinder, adjust peakprom (prominence) parameter to the images)
9. Get general mito morphological parameters from binary mito map (Use ImageJ script: Mitography200512-OnlyMitoPreBinary, should not have to adjust any parameters)
10. Combine all per-mitochondria info and count nucleoids per mito (Use MATLAB script: TFAManalysis). All the results will now be per image and per mitochondria in '*_MitoAnalysisFull.txt' files.
Data columns in *_MitoAnalysisFull.txt: A-X, B-Y, C-Angle, D-Area, E-Length, ellipse fit, F-Width, ellipse fit, G-Skeletal length, H-Skeletal number, I-Soma(bool), J-Distance from soma, K-Number of nucleoids, L-AISBinary(bool)
11. Use MATLAB scripts to plot the results (TFAManalysisPlotting can be used as a first test)