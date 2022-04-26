%%%
% Mitography - antiDNA analysis - data plotting
% Plotting the data from the DNA analysis.
%----------------------------
% Version: 191217
% Last updated features: New script
%
% @jonatanalvelid
%%%

% clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('T:\Mitography'),'\');
fileList = dir(fullfile(masterFolderPath, 'Image_*.txt'));
filenumbers = [];
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(7:9));
end
lastFileNumber = max(filenumbers);

mitodatatemp = [];
mitodata = [];
map2bin = [];
numnucl = [];
area = [];

filenameallMito = '_MitoAnalysisFull.txt';
fileNumbers = 1:lastFileNumber;

%%% GATHER DATA

for fileNum = fileNumbers
    filepathmito = strFilepath(fileNum,filenameallMito,masterFolderPath);
    
    try
        % Read the mito and line profile data
        datamito = dlmread(filepathmito,'',0,0);
        [num,params] = size(datamito);
        
        % Get somadist and number of nucleotides for all mito in image
        map2bintemp = datamito(:,params);
        numnucltemp = datamito(:,params-1);
        areatemp = datamito(:,3);
        
        % Add to list of all mitochondria in all images
        map2bin = vertcat(map2bin,map2bintemp);
        numnucl = vertcat(numnucl,numnucltemp);
        area = vertcat(area,areatemp);
        
    catch err
        disp(strcat(num2str(fileNum),': General error.'));
    end 
end
mitodatatemp(:,1) = map2bin;
mitodatatemp(:,2) = numnucl;
mitodatatemp(:,3) = area;
mitodatatemp(any(isnan(mitodatatemp), 2), :) = [];
% mitodatatemp(mitodatatemp(:,1)==0, :) = [];

mitodata = vertcat(mitodata,mitodatatemp);

%%% PLOTTING CODE

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

xlimlow1 = 0;
xlimup1 = 150;
ylimup1 = 5;

fontsize = 14;
opacity = 0.5;

ylabeltext1 = '# of nucleotides/mito';
xlabeltext1 = 'Distance to soma [?m]';

TFAMfig = figure('rend','painters','pos',[100 100 800 400]);
h1 = scatter(mitodata(:,1),mitodata(:,2));
xlim([xlimlow1 xlimup1])
ylim([0 ylimup1])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0:ylimup1/12:ylimup1])
yticklabels({0,'','',ylimup1/4,'','',ylimup1/2,'','',3*ylimup1/4,'','',ylimup1})