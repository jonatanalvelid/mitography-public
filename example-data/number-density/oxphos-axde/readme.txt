.mat files: 1 file per experiment. The file contains a data structure with a number of variables. Each variable has a name on the form:
[vesicleType]_[OXPHOS+/-]_[aa/glucose]_[axon/dendrite]
and you can read it like the following:
vesicleType: t = tiny vesicles, b = big vesicles, s = sticks
OXPHOS+/-: p = positive, n = negative
aa/glucose: aa = AA, ct = glucose
axon/dendrite: ax = axon, de = dendrite
Each variable is a list where each number is the number density in one cell. 

.csv files: 1 file per experiment and conditions as above, on the form:
mdvdensity_exp[experimentNumber]_[aa/glucose]_[vesicleType][vesicleType][OXPHOS+/-]_[axon/dendrite].csv
and you can read it like the following:
experimentNumber: 1, 4 or 5
aa/glucose: aa = AA, gl = glucose
vesicleType: 10 = tiny vesicles, 11 = big vesicles, 01 = sticks
OXPHOS+/-: 1 = positive, 0 = negative
axon/dendrite: 0 = axon, 1 = dendrite
Each file contains a list where each number is the number density in one cell. 

NaN or nan means that that combination is not applicable for that specific cell and should be excluded.
0 means that there are no vesicles of that type, but it is still a valid measurement that should be included. 