import os
import cv2 as cv
import glob
import tifffile
import read_roi
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tkinter.filedialog import askdirectory
from skimage import measure

dirpath = askdirectory(title='Choose your folder...',initialdir='X:/Mitography/NEW/Antimycin Treatments_April2020/6h_5nM AA')  # directory path
files_neur = glob.glob(os.path.join(dirpath,'Image_0*NeuritesBinary.tif'))
files_neurlen = glob.glob(os.path.join(dirpath,'Image_0*NeuritesLength.txt'))
files_mitoana = glob.glob(os.path.join(dirpath,'Image_0*MitoAnalysisFull.txt'))
files_mitobin = glob.glob(os.path.join(dirpath,'*MitoBinary.tif'))
files_roi = glob.glob(os.path.join(dirpath,'*RoiSet.zip'))
files_oxphos = glob.glob(os.path.join(dirpath,'*OXPHOSbool.xlsx'))
files_pex = glob.glob(os.path.join(dirpath,'*PEXbool.xlsx'))

for filepath_neur in files_neur:
    # create empty dataframe for all the mito of interest to be saved in
    mitoofinterest = pd.DataFrame()
    mitoofinterest['mitonum'] = []
    mitoofinterest['boolcheck'] = []

    # print imgname, get index of img in all lists, and start loading data
    imgname_neur = filepath_neur.split('\\')[1].split('.')[0]
    print(imgname_neur.split('-')[0])
    imgno = int(imgname_neur.split('_')[1].split('-')[0])
    imgidx = files_neur.index(filepath_neur)

    # read tot neurite length and pixel size
    [throw, pxs_nm, totneurlen] = np.loadtxt(files_neurlen[imgidx])

    # read binary mitochondria image and get labelled binary mito image
    with tifffile.TiffFile(files_mitobin[imgidx]) as tif:
        mitobin = tif.pages[0].asarray().astype('uint8')  # image as numpy array
        labelmito = measure.label(mitobin, connectivity=2)
        print(np.max(labelmito))

    for filename_roi in files_roi:
        if f'{imgno:03d}' in filename_roi.split('\\')[1]:
            # read ROIs of mitochondria of interest
            rois = read_roi.read_roi_zip(filename_roi)
            # get the coordinates from ~the middle of the ROIs
            xcoor_rois = []; ycoor_rois = []; mitonums = []
            for roi in rois:
                roi_xs = rois[roi]['x']
                roi_ys = rois[roi]['y']
                xroi = (roi_xs[0]+roi_xs[len(roi_xs)//2])//2
                yroi = (roi_ys[0]+roi_ys[len(roi_ys)//2])//2
                xcoor_rois.append(xroi)
                ycoor_rois.append(yroi)
            # compare coords with labelled mito img (labelled in same order as MitoBinary), and save mito numbers to list
            for x,y in zip(xcoor_rois,ycoor_rois):
                mitonum = labelmito[y,x]
                if mitonum == 0:
                    rows,cols = np.nonzero(labelmito)
                    min_idx = ((rows - y)**2 + (cols - x)**2).argmin()
                    mitonum = labelmito[rows[min_idx],cols[min_idx]]
                mitonums.append(mitonum)
            # save mitonums of interest to all-data dataframe
            mitoofinterest['mitonum'] = mitonums
        
    # read OXPHOS/PEX boolean data
    for filename_oxphos in files_oxphos:
        if f'{imgno:03d}' in filename_oxphos.split('\\')[1]:
            oxphos = pd.read_excel(filename_oxphos, sheet_name='OXPHOS')
            oxphos = list(oxphos.iloc[:,-1][:len(rois)])
            # save OXPHOS data to all-data dataframe
            mitoofinterest['boolcheck'] = oxphos
            break
    for filename_pex in files_pex:
        if f'{imgno:03d}' in filename_pex.split('\\')[1]:
            pex = pd.read_excel(filename_pex, sheet_name='PEX14')
            pex = list(pex.iloc[:,-1][:len(rois)])
            # save PEX data to all-data dataframe
            mitoofinterest['boolcheck'] = pex
            break

    # read the mitoanalysis file and get coordinates and area for all mitos in img
    anafull = pd.read_csv(files_mitoana[imgidx], sep='\t', header=None)
    xcor_px = round(anafull[0]/pxs_nm*1000).astype(int)
    ycor_px = round(anafull[1]/pxs_nm*1000).astype(int)
    area = anafull[3]
    length = anafull[4]
    width = anafull[5]
    width_fit = anafull[7]
    aspectratio = np.divide(width,length)
    aspectratio_fit = np.divide(width_fit,length)
    print(np.shape(area))
    # gather the area and AR of the mito of interest in a list
    mitoareas = []
    mitoaspectratios = []
    mitoaspectratios_fit = []
    for mitono in mitoofinterest['mitonum']:
        #print(mitono)
        mitoareas.append(area[mitono-1])
        # ellipsoidal ar
        artemp = aspectratio[mitono-1]
        if artemp > 1:
            artemp = 1/artemp
        mitoaspectratios.append(artemp)
        # fitted width ar, that will be = 0 if the width fit has failed
        artemp_fit = aspectratio_fit[mitono-1]
        if artemp_fit > 1:
            artemp_fit = 1/artemp_fit
        mitoaspectratios_fit.append(artemp_fit)
    # add list of areas and ARs to all-data dataframe
    mitoofinterest['area'] = mitoareas
    mitoofinterest['ar'] = mitoaspectratios
    mitoofinterest['ar_fit'] = mitoaspectratios_fit

    # read binary neurites image
    with tifffile.TiffFile(files_neur[imgidx]) as tif:
        neurbin = tif.pages[0].asarray().astype('uint8')  # image as numpy array
    # mark in a list which mito are in mitoneur and which are not, of the mitos of interest
    mitoinneur = []
    for mitono in mitoofinterest['mitonum']:
        mitoneur = neurbin[ycor_px[mitono-1]][xcor_px[mitono-1]]
        mitoinneur.append(mitoneur)
    # add list of mitoneur to all-data dataframe
    mitoofinterest['inneurite'] = mitoinneur

    # save all-data dataframe to csv
    mitoofinterest.to_csv(os.path.join(dirpath,f'Image_{imgno:03d}-MitoOfInterest.csv'), header=True, index=False)

    """
    # visualize and mark in a list which small mito are in mitoneur and which are not
    marker = ['ro','go','bo']
    fig = plt.figure(figsize=(10,10))
    plt.imshow(neurbin)
    for mitono in range(0,len(xcor_px)):
        if mitoinneur[mitono]:
            if smallmito[mitono]:
                plt.plot(xcor_px[mitono], ycor_px[mitono], marker[1], markersize=10)
            else:
                plt.plot(xcor_px[mitono], ycor_px[mitono], marker[2], markersize=10)
        else:
            plt.plot(xcor_px[mitono], ycor_px[mitono], marker[0], markersize=10)
    """
#mitoperum, smallmitoperum

