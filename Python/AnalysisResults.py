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

mitoinfos = []; neurlens = []; nummito = [[] for i in range(2)]
nummito_all = [[[[] for i in range(4)] for i in range(np.max(cellnumber))] for i in range(2)] # bool, cell, comp
neurlen_all = [[[] for i in range(4)] for i in range(np.max(cellnumber))] # cell, comp

for imgidx in range(0,len(files_neurlen)):
    # read tot neurite length and previously saved small mito info
    [throw, throw, totneurlen] = np.loadtxt(files_neurlen[imgidx])
    neurlens.append(totneurlen)
    mitoinfo = pd.read_csv(files_mitointe[imgidx])
    # remove inneurite=0 mito, i.e. mito outside the measure neurites
    mitoinfo = mitoinfo.drop([i for i, x in enumerate(mitoinfo['inneurite']==0) if x])
    mitoinfos.append(mitoinfo)
    
    imgno = int(files_neurlen[imgidx].split('\\')[1].split('_')[1].split('-')[0])
    
    compidx = comps.index(comptype[imgno-1])
    cellidx = cellnumber[imgno-1]-1
        
    # add neurlen to respective cell-specific and compartment-specific lists
    neurlen_all[cellidx][compidx].append(totneurlen)
    
    # add number of mitos to cell-specific, compartment-specific and bool-specific sublists
    for i in [0,1]:
        nummitos = mitoinfo[mitoinfo['boolcheck'] == i].shape[0]
        nummito_all[i][cellidx][compidx].append(nummitos)

totnummito = np.sum(np.sum(np.sum(nummito_all)))
mitodensitytot = totnummito/np.sum(neurlens)

neurlen_all = np.array(neurlen_all)
nummito_all = np.array(nummito_all)
mitodensity_percell = [[[[] for i in range(4)] for i in range(np.max(cellnumber))] for i in range(2)]
for i in [0,1]:
    for cellnum in set(cellnumber):
        for comptype in comps:
            compidx = comps.index(comptype)
            mitodensity = np.sum(np.sum(nummito_all[i,cellnum-1,compidx]))/np.sum(neurlen_all[cellidx,compidx])
            mitodensity_percell[i][cellnum-1][compidx] = mitodensity
            
mitodensity_together = [[[] for i in range(4)] for i in range(2)]
for i in [0,1]:
    for comptype in comps:
        compidx = comps.index(comptype)
        mitodensity = np.sum(np.sum(nummito_all[i,:,compidx]))/np.sum(np.sum(neurlen_all[:,compidx]))
        mitodensity_together[i][compidx] = mitodensity

# -------- PER CELL - MEAN OF CELLS (NOT USEFUL) --------
print('PER CELL - MEAN OF CELLS')
mitodensity_percell = np.array(mitodensity_percell)
# print all results
print(f'MDVs/um in total: {mitodensitytot:.3}')
for comptype in comps:
    for i in [0,1]:
        compidx = comps.index(comptype)
        mitodensity = mitodensity_percell[i,:,compidx]
        print(f'MDVs/um, comp type {comptype}, bool {i}: {np.mean(mitodensity):.3}')
        print(mitodensity_percell[i,:,compidx])
for comptype in comps:
    for i in [0,1]:
        compidx = comps.index(comptype)
        mitoratio = np.sum(np.sum(nummito_all[i,:,compidx]))/np.sum(np.sum(nummito_all[:,:,compidx]))
        print(f'MDV rat, comp type {comptype}, bool {i}: {mitoratio:.2}')

# -------- ALL DATA TOGETHER - OXPHOS/PEX +/- --------
print('ALL DATA TOGETHER')
mitodensity_together = np.array(mitodensity_together)
# print all results
print(f'MDVs/um in total: {mitodensitytot:.3}')
for i in [0,1]:
    nummito = np.sum(np.sum(nummito_all[i,:,0:2]))
    mitodensity = nummito/np.sum(np.sum(neurlen_all[:,0:2]))
    print(f'MDVs/um, bool {i}: {mitodensity:.3}')
for i in [0,1]:
    mitoratio = np.sum(np.sum(nummito_all[i,:,0:3]))/np.sum(np.sum(nummito_all[:,:,0:3]))
    print(f'MDV rat, bool {i}: {mitoratio:.2}')

for comptype in comps:
    for i in [0,1]:
        compidx = comps.index(comptype)
        mitodensity = mitodensity_together[i,compidx]
        print(f'MDVs/um, comp type {comptype}, bool {i}: {mitodensity:.3}')
for comptype in comps:
    for i in [0,1]:
        compidx = comps.index(comptype)
        mitoratio = np.sum(np.sum(nummito_all[i,:,compidx]))/np.sum(np.sum(nummito_all[:,:,compidx]))
        print(f'MDV rat, comp type {comptype}, bool {i}: {mitoratio:.2}')
