MitoBinary: Automatic binarization with the script:
MitochondriaBinarization.ijm
with the following parameters:
thresh1scale = 0.63
thresh2scale = 0.5
gaussiansmsize = 0.65
2x dilation
thresh1min = 3.5 (1.3 * gaussiansmsize for low signal)
thresh2min = 2.5 (1.3 * gaussiansmsize for low signal)
and manual tweaking to remove detected background etc.

NeuritesBinary: Automatic binarization with the script:
NeuritesBinarization.ijm
with the parameters:
percent = 0.96
sizethresh = 20
threshscale = 0.6
gaussiansmsize = 3
bordersize = 15
imgnum = 8
pxs_nm = 30
or doing it manually in a few images where the automatic does not work as the signal is too low and you get a lot of disconnected fragments.