clear all

dir = strcat('E:\PhD\data_analysis\mice_NLGF_oxphos\raw_results','\');
file = 'oxphos_mice_c5.mat';
load(strcat(dir,file))

mitoinfo = struct;
mitoinfo.exp = 1;
mitoinfo.ctaa = ' ';
mitoinfo.cell = 5;
mitoinfo.ar = mitoAR;
mitoinfo.area = mitoArea;
mitoinfo.length = mitoLength;
mitoinfo.omp = mitoOMP;
mitoinfo.oxphos = mitoOXPHOS;
mitoinfo.oxphosparam = mitoOXPHOSparam;
mitoinfo.width = mitoWidth;

save(file, 'mitoinfo')