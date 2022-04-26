import os
import glob
import tifffile
import cv2 as cv
import numpy as np
import matplotlib.pyplot as plt
import skimage.filters as skfilt
from skimage import morphology, measure
from tkinter.filedialog import askdirectory
from scipy import ndimage as ndi


bkgthresh = 10  # put all over this thresh to = thresh, for the neurites background
bindil = 20  # number of dilations
binero = 15  # number of erosions
#neursizethresh = np.max([prop.area for prop in regprops])-1
neursizethresh = 3000  # threshold size for the binary neurites detected

allimgs = True  # parameter to check if you want to loop through all imgs or just analyse one
dirpath = askdirectory(title='Choose your folder...',initialdir='X:/Mitography/NEW/Antimycin Treatments_April2020/6h_5nM AA')  # directory path

if allimgs:   
    files_mito = glob.glob(os.path.join(dirpath,'Image_0*Mitochondria.tif'))
    files_soma = glob.glob(os.path.join(dirpath,'Image_0*SomaBinary.tif'))
else:
    files_mito = [os.path.join(dirpath,'Image_003-Mitochondria.tif')]
    files_soma = [os.path.join(dirpath,'Image_003-SomaBinary.tif')]

for filepath_mito in files_mito:
    imgname_mito = filepath_mito.split('\\')[1].split('.')[0]
    print(imgname_mito.split('-')[0])
    imgno = int(imgname_mito.split('_')[1].split('-')[0])
    # load mito img
    with tifffile.TiffFile(filepath_mito) as tif:
        imgraw = tif.pages[0].asarray()  # image as numpy array
        pxs_nm = 1e9/tif.pages[0].tags['XResolution'].value[0]  # pixel size in nm
    # load soma img (if exist)
    imgsoma = np.invert(np.zeros(np.shape(imgraw)).astype('uint8'))/255
    for filename in files_soma:
        if f'{imgno:03d}' in filename:
            with tifffile.TiffFile(files_soma[files_soma.index(filename)]) as tif:
                imgsoma = np.invert(tif.pages[0].asarray())/255  # image as numpy array
                
    # Process image
    img = imgraw*imgsoma
    img[img > bkgthresh] = bkgthresh

    # Binarize image
    binary = img > skfilt.threshold_triangle(img)
    binary = morphology.remove_small_objects(binary, 20)
    # dilate and erode to smooth out edges
    for i in range(0,bindil):
        binary = ndi.binary_dilation(binary)
    for i in range(0,binero):
        binary = ndi.binary_erosion(binary)

    # remove everything except largest connected segment
    binarybig = morphology.remove_small_objects(binary, neursizethresh)

    # skeletonize binary image
    skelbin = morphology.skeletonize(binarybig)
    skelbin = (skelbin*imgsoma).astype('uint8')

    # get skeleton (neurites) total length
    ret, thresh = cv.threshold(np.array(skelbin).astype('uint8'), 0.5, 255, 0)
    cnt, hie = cv.findContours(thresh, 1, 2)
    totskellen = 0
    for contour in cnt:
        totskellen = totskellen + cv.arcLength(contour, closed=True)/2
    totneurlen = totskellen
    totneurlen_um = totneurlen*pxs_nm/1E3

    #print('Skeleton length (pixels):')
    #print(totneurlen)
    print(f'Total neurite length (um): {totneurlen_um:.3f}')
    #print('Number of pixels in skeleton:')
    #print(np.sum(skelbin))

    if allimgs==False:
        f, axs = plt.subplots(1,4)
        axs[0].imshow(imgraw)
        axs[1].imshow(img)
        axs[2].imshow(binarybig)
        axs[3].imshow(skelbin)
        plt.show()

    tifffile.imsave(os.path.join(dirpath,f'Image_{imgno:03d}-NeuritesBinary.tif'), binarybig)
    
    np.savetxt(os.path.join(dirpath,f'Image_{imgno:03d}-NeuritesLength.txt'), [totneurlen, pxs_nm, totneurlen_um], fmt='%.3f')
