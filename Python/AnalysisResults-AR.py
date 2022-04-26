import os
import csv
import cv2 as cv
import glob
import tifffile
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from tkinter.filedialog import askdirectory

dirpath = askdirectory(title='Choose your folder...',initialdir='X:/Mitography/NEW/Antimycin Treatments_April2020/6h_5nM AA')  # directory path
files_neurlen = glob.glob(os.path.join(dirpath,'Image_*NeuritesLength.txt'))
files_mitointe = glob.glob(os.path.join(dirpath,'Image_*MitoOfInterest.csv'))
cellnumber = np.loadtxt(os.path.join(dirpath,'cellnumber.txt'),delimiter=',').astype(int)
comptype_file = open(os.path.join(dirpath,'comptype.txt'),'r')
comptype = comptype_file.read().split(',')
comps = ['a','d','s','x']
areathresh = 0.03

mitoinfos = []; neurlens = []; nummito = [[] for i in range(2)]
nummito_all = [[[[[] for i in range(4)] for i in range(np.max(cellnumber))] for i in range(2)] for i in range(2)] # tiny/big, ar, cell, comp
neurlen_all = [[[] for i in range(4)] for i in range(np.max(cellnumber))] # cell, comp

for imgidx in range(0,len(files_neurlen)):
    # read tot neurite length and previously saved small mito info
    [throw, throw, totneurlen] = np.loadtxt(files_neurlen[imgidx])
    neurlens.append(totneurlen)
    mitoinfo = pd.read_csv(files_mitointe[imgidx])
    # remove inneurite=0 mito, i.e. mito outside the measure neurites, and AR=0 mito, i.e. mito that didn't succesfully fit a width
    #print(mitoinfo)
    neuriteneg = enumerate(mitoinfo['inneurite']==0)
    arneg = enumerate(mitoinfo['ar']==0)
    allneg = list(set().union(neuriteneg,arneg))
    mitoinfo = mitoinfo.drop([i for i, x in allneg if x])
    #print(mitoinfo)
    mitoinfos.append(mitoinfo)
    
    imgno = int(files_neurlen[imgidx].split('\\')[1].split('_')[1].split('-')[0])
    
    compidx = comps.index(comptype[imgno-1])
    cellidx = cellnumber[imgno-1]-1
        
    # add neurlen to respective cell-specific and compartment-specific lists
    neurlen_all[cellidx][compidx].append(totneurlen)
    
    # add number of mitos to cell-specific, compartment-specific and ar-specific sublists
    for n in [0,1]:  #0=tiny, 1=big
        for i in [0,1]:  # 0=stick, 1=mdv
            if i == 0:  # i=0 --> ar<=0.5 --> stick
                idx_ar = mitoinfo['ar'] <= 0.5
                if n == 0:  # n=0 --> area<areathresh --> tiny
                    idx_area = mitoinfo['area'] <= areathresh
                if n == 1:  # n=1 --> area>areathresh --> big
                    idx_area = mitoinfo['area'] > areathresh
                nummitos = mitoinfo[idx_ar & idx_area].shape[0]
            if i == 1:  # i=1 --> ar>0.5 --> MDV
                idx_ar = mitoinfo['ar'] > 0.5
                if n == 0:
                    idx_area = mitoinfo['area'] <= areathresh
                if n == 1:
                    idx_area = mitoinfo['area'] > areathresh
                nummitos = mitoinfo[idx_ar & idx_area].shape[0]
            nummito_all[n][i][cellidx][compidx].append(nummitos)

totnummito = np.sum(np.sum(np.sum(nummito_all)))
mitodensitytot = totnummito/np.sum(neurlens)

neurlen_all = np.array(neurlen_all)
nummito_all = np.array(nummito_all)
            
mitodensity_together = [[[[] for i in range(4)] for i in range(2)] for i in range(2)]
for n in [0,1]:
    for i in [0,1]:
        for comptype in comps:
            compidx = comps.index(comptype)
            mitodensity = np.sum(np.sum(nummito_all[n,i,:,compidx]))/np.sum(np.sum(neurlen_all[:,compidx]))
            mitodensity_together[n][i][compidx] = mitodensity

# -------- ALL DATA TOGETHER - STICKS/MDVS/SMALL/TINY/BIG --------
print('ALL DATA TOGETHER')
mitodensity_together = np.array(mitodensity_together)
# print all results
print(f'MDVs/um in total: {mitodensitytot*100:.3}')
for n in [0,1]:
    for i in [0,1]:
        if i==0:
            nummito = np.sum(np.sum(np.sum(nummito_all[:,i,:,0:2])))
        else:
            nummito = np.sum(np.sum(nummito_all[n,i,:,0:2]))
        mitodensity = nummito/np.sum(np.sum(neurlen_all[:,0:2]))
        print(f'MDVs/um, type: {i}, size: {n}: {mitodensity*100:.3}')
    for i in [0,1]:
        if i==0:
            mitoratio = np.sum(np.sum(np.sum(nummito_all[:,i,:,0:3])))/np.sum(np.sum(nummito_all[:,:,:,0:3]))
        else:
            mitoratio = np.sum(np.sum(nummito_all[n,i,:,0:3]))/np.sum(np.sum(nummito_all[:,:,:,0:3]))
        print(f'MDVs rat, type: {i}, size: {n}: {mitoratio:.2}')

for comptype in comps:
    for n in [0,1]:
        for i in [0,1]:
            compidx = comps.index(comptype)
            if i==0:
                nummito = np.sum(np.sum(np.sum(nummito_all[:,i,:,compidx])))
            else:
                nummito = np.sum(np.sum(nummito_all[n,i,:,compidx]))
            mitodensity = nummito/np.sum(np.sum(neurlen_all[:,compidx]))
            print(f'MDVs/um, comp type: {comptype}, type: {i}, size: {n}: {mitodensity*100:.3}')
for comptype in comps:
    for n in [0,1]:
        for i in [0,1]:
            compidx = comps.index(comptype)
            if i==0:
                mitoratio = np.sum(np.sum(np.sum(nummito_all[:,i,:,compidx])))/np.sum(np.sum(np.sum(nummito_all[:,:,:,compidx])))
            else:
                mitoratio = np.sum(np.sum(nummito_all[n,i,:,compidx]))/np.sum(np.sum(np.sum(nummito_all[:,:,:,compidx])))
            print(f'MDVs rat, comp type {comptype}, type: {i}, size: {n}: {mitoratio:.2}')

print('type: 0 -> sticks, type: 1 -> MDVs')
print('size: 0 -> tiny, size: 1 -> big')
