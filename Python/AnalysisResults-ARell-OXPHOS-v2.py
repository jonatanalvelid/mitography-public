# v2 of plotting the results of the number density analysis, with different input files
# no mitoofinterest.csv file, everything in mitoanalysisfull
# one file with all neurite lengths for all imgs
# 2021-03-01
#
# @jonatanalvelid

import os
import csv
import cv2 as cv
import glob
import tifffile
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tkinter.filedialog import askdirectory

dirpath = askdirectory(title='Choose your folder...',initialdir='E:/PhD/data_analysis/antimycin')  # directory path
files_mitoana = glob.glob(os.path.join(dirpath,'Image_0*MitoAnalysisFull.txt'))

cellnumber = np.loadtxt(os.path.join(dirpath,'cellnumber-all.txt'),delimiter=',').astype(int)
neurlens = np.loadtxt(os.path.join(dirpath,'neurite-lengths.txt'))

comptype_file = open(os.path.join(dirpath,'comptype.txt'),'r')
comptype = comptype_file.read().split(',')
comps = ['a','d','s','x']  # axons, dendrites, soma, unknown

areathreshtiny = 0.03
areathreshbig = 0.086

mitoinfos = []; nummito = [[] for i in range(2)]
nummito_all = [[[[[[] for i in range(2)] for i in range(4)] for i in range(np.max(cellnumber))] for i in range(2)] for i in range(2)] # tiny/big, ar, cell, comp, bool
neurlen_all = [[[] for i in range(4)] for i in range(np.max(cellnumber))] # cell, comp

for imgidx in range(0,len(files_mitoana)):
    # read tot neurite length and previously saved small mito info
    totneurlen = neurlens[imgidx]

    # read all mito info
    anafull = pd.read_csv(files_mitoana[imgidx], sep='\t', header=None)
    area = anafull[3]
    length = anafull[4]
    width = anafull[5]
    aspectratio = np.divide(width,length)
    oxphosbool = anafull[111]
    
    imgno = int(files_mitoana[imgidx].split('\\')[1].split('_')[1].split('-')[0])
    
    compidx = comps.index(comptype[imgno-1])
    cellidx = cellnumber[imgno-1]-1
        
    # add neurlen to respective cell-specific and compartment-specific lists
    neurlen_all[cellidx][compidx].append(totneurlen)
    
    # add number of mitos to cell-specific, and ar-specific sublists
    for n in [0,1]:  #0=tiny, 1=big
        for i in [0,1]:  # 0=stick, 1=mdv
            for b in [0,1]:  # 0=OXPHOS-, 1=OXPHOS+
                idx_bool = oxphosbool == b
                if i == 0:  # i=0 --> ar<=0.5 --> stick
                    idx_ar = aspectratio <= 0.5
                    if n == 0:  # n=0 --> area<areathresh --> tiny
                        idx_area = area <= areathreshtiny
                    if n == 1:  # n=1 --> area>areathresh --> big
                        idx_area1 = area > areathreshtiny
                        idx_area2 = area < areathreshbig
                        idx_area = (idx_area1 & idx_area2)
                if i == 1:  # i=1 --> ar>0.5 --> MDV
                    idx_ar = aspectratio > 0.5
                    if n == 0:
                        idx_area = area <= areathreshtiny
                    if n == 1:
                        idx_area1 = area > areathreshtiny
                        idx_area2 = area < areathreshbig
                        idx_area = (idx_area1 & idx_area2)
                nummitos = np.sum(idx_bool & idx_area & idx_ar)
                nummito_all[n][i][cellidx][compidx][b].append(nummitos)

totnummito = np.sum(np.sum(np.sum(np.sum(np.sum(nummito_all)))))
mitodensitytot = totnummito/np.sum(neurlens)

neurlen_all = np.array(neurlen_all)
nummito_all = np.array(nummito_all)

#print(neurlen_all)

## not per cell, big/small separation
#mitodensity_together = [[[[[] for i in range(2)] for i in range(4)] for i in range(2)] for i in range(2)]
#for n in [0,1]:
#    for i in [0,1]:
#        for b in [0,1]:
#            for comptype in comps:
#                compidx = comps.index(comptype)
#                mitodensity = np.sum(np.sum(nummito_all[n,i,:,compidx,b]))/np.sum(np.sum(neurlen_all[:,compidx]))
#                mitodensity_together[n][i][compidx][b] = mitodensity

# per cell, big/small separation, ax/de separation
mitodensity_percell = [[[[[[] for i in range(2)] for i in range(4)] for i in range(np.max(cellnumber))] for i in range(2)] for i in range(2)]
for n in [0,1]:
    for i in [0,1]:
        for b in [0,1]:
            for cellnum in set(cellnumber):
                for comptype in comps:
                    compidx = comps.index(comptype)
                    if not neurlen_all[cellnum-1,compidx]:
                        mitodensity_percell[n][i][cellnum-1][compidx][b] = np.nan
                    else:
                        mitodensity = np.sum(np.sum(nummito_all[n,i,cellnum-1,compidx,b]))/np.sum(neurlen_all[cellnum-1,compidx])
                        mitodensity_percell[n][i][cellnum-1][compidx][b] = mitodensity
                        #print(' '),print(n),print(i),print(cellnum-1),print(compidx),print(b), print(mitodensity)

# per cell, big/small separation, ax+de together
mitodensity_percell_allneurites = [[[[[] for i in range(2)] for i in range(np.max(cellnumber))] for i in range(2)] for i in range(2)]
for n in [0,1]:
    for i in [0,1]:
        for b in [0,1]:
            for cellnum in set(cellnumber):
                if not neurlen_all[cellnum-1,0] and not neurlen_all[cellnum-1,1]:
                    mitodensity_percell_allneurites[n][i][cellnum-1][b] = np.nan
                else:
                    mitodensity = np.sum(np.sum(np.sum(nummito_all[n,i,cellnum-1,0:2,b])))/np.sum(np.sum(neurlen_all[cellnum-1,0:2]))
                    mitodensity_percell_allneurites[n][i][cellnum-1][b] = mitodensity
                    #print(' '),print(n),print(i),print(cellnum-1),print(b), print(mitodensity)

## -------- ALL DATA TOGETHER - STICKS/MDVS/SMALL/TINY/BIG --------
#print('ALL DATA TOGETHER')
#mitodensity_together = np.array(mitodensity_together)
## print all results
#print(f'MDVs/um in total: {mitodensitytot*100:.3}')
#for n in [0,1]:
#    for i in [0,1]:
#        for b in [0,1]:
#            if i==0:
#                nummito = np.sum(np.sum(np.sum(nummito_all[:,i,:,b])))
#            else:
#                nummito = np.sum(np.sum(nummito_all[n,i,:,b]))
#            mitodensity = nummito/np.sum(np.sum(neurlen_all[:]))
#            print(f'MDVs/um, type: {i}, size: {n}, OXPHOSbool: {b}: {mitodensity*100:.3}')
#    #for i in [0,1]:
#    #    for b in [0,1]:
#    #        if i==0:
#    #            mitoratio = np.sum(np.sum(np.sum(nummito_all[:,i,:,0:3,b])))/np.sum(np.sum(nummito_all[:,:,:,0:3,:]))
#    #        else:
#    #            mitoratio = np.sum(np.sum(nummito_all[n,i,:,0:3,b]))/np.sum(np.sum(nummito_all[:,:,:,0:3,:]))
#    #        print(f'MDVs rat, type: {i}, size: {n}, OXPHOSbool: {b}: {mitoratio:.2}')


# -------- PER CELL - MEAN OF CELLS - BIG/SMALL - NO COMP --------
print('')
print('PER CELL - MEAN OF CELLS - BIG/SMALL - NO COMP')
mitodensity_percell_allneurites = np.array(mitodensity_percell_allneurites)
# print all results
print(f'MDVs/um in total: {mitodensitytot:.3}')
for n in [0,1]:
    for i in [0,1]:
        for b in [0,1]:
            if not (n==0 and i==0):
                mitodensity = mitodensity_percell_allneurites[n,i,:,b]*100
                #mitodensity = mitodensity[~np.isnan(mitodensity)]
                print(mitodensity)
                print(f'MDVs/um, type: {i}, size: {n}, OXPHOSbool: {b}: {np.mean(mitodensity[~np.isnan(mitodensity)]):.3} +/- {np.std(mitodensity[~np.isnan(mitodensity)]):.3}')
                savename = f'mdvdensity_exp{5}_aa_{i}{n}{b}.csv'
                np.savetxt(savename, mitodensity, delimiter=',')


# -------- PER CELL - MEAN OF CELLS - BIG/SMALL - COMP --------
print('')
print('PER CELL - MEAN OF CELLS - BIG/SMALL - COMP')
mitodensity_percell = np.array(mitodensity_percell)
# print all results
print(f'MDVs/um in total: {mitodensitytot:.3}')
for comptype in comps[:2]:
    for n in [0,1]:
        for i in [0,1]:
            for b in [0,1]:
                if not (n==0 and i==0):
                    compidx = comps.index(comptype)
                    mitodensity = mitodensity_percell[n,i,:,compidx,b]*100
                    #mitodensity = mitodensity[~np.isnan(mitodensity)]
                    print(f'MDVs/um, comp type: {comptype}, type: {i}, size: {n}, OXPHOSbool: {b}: {np.mean(mitodensity[~np.isnan(mitodensity)]):.3} +/- {np.std(mitodensity[~np.isnan(mitodensity)]):.3}')
                    print(mitodensity)
                    savename = f'mdvdensity_exp{5}_aa_{i}{n}{b}_{compidx}.csv'
                    np.savetxt(savename, mitodensity, delimiter=',')


print('type: 0 -> sticks, type: 1 -> MDVs')
print('size: 0 -> tiny, size: 1 -> big')
print('OXPHOSbool: 0 --> -, OXPHOSbool: 1 --> +')
