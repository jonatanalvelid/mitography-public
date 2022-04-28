Dataset: X:\Mitography\NEW\Antimycin Treatments_April2020\Experiment 5_6h-5h_5nM AA

Mitochondria: Raw

MitoBinary: Automatic binarization with the script:
C:\Users\Jonatan\Documents\GitHub\Mitography\ImageJ\MitochondriaBinarization-PexAA.ijm
with the following parameters:
thresh1scale = 0.63
thresh2scale = 0.5
gaussiansmsize = 0.65
2xdilation
thresh1min = 3.5 (1.3 * gaussiansmsize for low signal)
thresh2min = 2.5 (1.3 * gaussiansmsize for low signal)
and a bit of manual tweaking to remove detected background etc.

NeuritesBinary: Automatic binarization with the script:
neuritesBinarization-map2.ipynb
with the parameters:
percent = 0.96
sizethresh = 20
threshscale = 0.6
gaussiansmsize = 3
bordersize = 15
imgnum = 8
pxs_nm = 30
but doing it completely manually in a few images as the automatic does not work when the signal is way too low and you get a lot of disconnected fragments.

ImageJ analysis (only mito morph):
