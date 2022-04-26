%%% FIT AND GET ALL THE MITOCHONDRIA LINE PROFILE WIDTHS.
%%% - Pick out all the small mitochondria, <100nm in size or some similar
%%% threshold, and save these numbers in a separate file. 
% This version: Check if mitochondria is in soma (column 109, 1=soma), and
% exclude those mitochondria that are.

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\NEW\Metabolism'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);   
try
    dataparam = dlmread(filepathparam,'',1,1);
    mitoLen = dataparam(1,3);
    actinLen = dataparam(1,1);
catch err
    mitoLen = 0;
    actinLen = 0;
end
onlyPlottingGUI(actinLen, mitoLen, 31, 0, 1000, 0.2, 2, 'Extra parameter')
uiwait
load('checkboxes.mat');
load('edittextvals.mat');

allCheckboxes = cell2mat(checks);
stripesPlots = allCheckboxes(1);
paramPlots = allCheckboxes(2);
saveFigs = allCheckboxes(3);
doubleVals = str2double(vals(1:2));
mitoLineProfLength = doubleVals(1);
actinLineProfLength = doubleVals(2);
intVals = str2double(vals(3:7));
lastFileNumber = round(intVals(1));
paramCol = round(intVals(2));
mitosPerFile = round(intVals(3));
mitoWidthRatioThresholdLow = intVals(4);
mitoWidthRatioThresholdHigh = intVals(5);
paramName = vals(8);

%mitosPerFile = 1000;

fileNumbers = 1:lastFileNumber;
fontSizeGlobal = 14;
%mitoWidthRatioThreshold = 0.2;
c = 0:0.001:1;

filenameAnalysis = '_MitoAnalysisFull.txt';

%%% TAKE CARE OF ALL MITOCHONDRIA DATA, DIVIDE FOR AIS AND STRIPES, AND
%%% THREE PEAKS

mitoWidthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoLengthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoAreaFiles = zeros(mitosPerFile,2,lastFileNumber);
borderParamFiles = zeros(mitosPerFile,2,lastFileNumber);
tmreParamFiles = zeros(mitosPerFile,2,lastFileNumber);
tmrevalFiles = zeros(mitosPerFile,2,lastFileNumber);

for fileNum = fileNumbers
    if fileNum < 10
        filename = strcat('Image_00',int2str(fileNum),filenameAnalysis);
    else
        filename = strcat('Image_0',int2str(fileNum),filenameAnalysis);
    end
    filepath = strcat(masterFolderPath,filename);
    
    try
        data = dlmread(filepath);
        %disp(filename);
        areaMito = data(1:end,4);
        lengthMito = data(1:end,5); %Ellipsoidal fit mitochondria length (major axis)
        lengthSkelMito = data(1:end,7); %Skeleton mitochondria length (skeleton part closest to the mitochondria centroid)
        widthMito = data(1:end,8);
        borderparam = data(1:end,110);
        tmreval = data(1:end,111);
        tmreparam = data(1:end,112);
        if paramPlots
            extraparam = data(1:end,paramCol);
        end
        for i=1:length(areaMito)
            mitoAreaFiles(i,1,fileNum) = i;
            mitoAreaFiles(i,2,fileNum) = areaMito(i);
            mitoWidthFiles(i,1,fileNum) = i;
            mitoWidthFiles(i,2,fileNum) = widthMito(i);
            % Take the maximum of the ellipsoidal and skeletal length.
            % For small ones, the elliposidal will be longer and is a
            % better match, but for long ones that curve a bit the
            % skeletal fit will hopefully always be better.
            mitoLengthFiles(i,1,fileNum) = i;
            mitoLengthFiles(i,2,fileNum) = max(lengthMito(i),lengthSkelMito(i));
            borderParamFiles(i,1,fileNum) = i;
            borderParamFiles(i,2,fileNum) = borderparam(i);
            tmreParamFiles(i,1,fileNum) = i;
            tmreParamFiles(i,2,fileNum) = tmreparam(i);
            tmrevalFiles(i,1,fileNum) = i;
            tmrevalFiles(i,2,fileNum) = tmreval(i);
            if paramPlots 
                extraParamFiles(i,1,fileNum) = i;
                extraParamFiles(i,2,fileNum) = extraparam(i);
            end
        end
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end  
end

mitoWidth = [];
mitoLength = [];
mitoArea = [];
mitoTMRE = [];
mitoTMREparam = [];

mitoWidthP = [];
mitoLengthP = [];
mitoAreaP = [];
mitoTMREP = [];
mitoTMREparamP = [];

mitoWidthNP = [];
mitoLengthNP = [];
mitoAreaNP = [];
mitoTMRENP = [];
mitoTMREparamNP = [];


for fileNum=fileNumbers
    for i=1:mitosPerFile
        if mitoWidthFiles(i,2,fileNum) ~= 0
            mitoWidth = [mitoWidth; mitoWidthFiles(i,2,fileNum)];
            mitoArea = [mitoArea; mitoAreaFiles(i,2,fileNum)];
            mitoLength = [mitoLength; mitoLengthFiles(i,2,fileNum)];
            mitoTMRE = [mitoTMRE; tmrevalFiles(i,2,fileNum)];
            mitoTMREparam = [mitoTMREparam; tmreParamFiles(i,2,fileNum)];
            if paramPlots
                if extraParamFiles(i,2,fileNum) == 1
                    disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                    mitoWidthP = [mitoWidthP; mitoWidthFiles(i,2,fileNum)];
                    mitoAreaP = [mitoAreaP; mitoAreaFiles(i,2,fileNum)];
                    mitoLengthP = [mitoLengthP; mitoLengthFiles(i,2,fileNum)];
                    mitoTMREP = [mitoTMREP; tmrevalFiles(i,2,fileNum)];
                    mitoTMREparamP = [mitoTMREparamP; tmreParamFiles(i,2,fileNum)];
                elseif extraParamFiles(i,2,fileNum) == 0
                    mitoWidthNP = [mitoWidthNP; mitoWidthFiles(i,2,fileNum)];
                    mitoAreaNP = [mitoAreaNP; mitoAreaFiles(i,2,fileNum)];
                    mitoLengthNP = [mitoLengthNP; mitoLengthFiles(i,2,fileNum)];
                    mitoTMRENP = [mitoTMRENP; tmrevalFiles(i,2,fileNum)];
                    mitoTMREparamNP = [mitoTMREparamNP; tmreParamFiles(i,2,fileNum)];
                end
            end
        end
    end 
end

% %%% PLOTTING BELOW
% 
% interactivePlottingGUIThresholds191113(fontSizeGlobal, filamentWidthSNZ, mitoDisplacementEdgeS, mitoActinDistS, filamentWidthNSNZ, mitoDisplacementEdgeNS,...
%     mitoActinDistNS, mitoWidth, mitoArea, mitoLength, nonzeroS, mitoWidthNS, mitoAreaNS, mitoLengthNS, nonzeroNS, mitoNonStripesDistS,...
%     mitoNonStripesDistNS, mitoThreePeaksNonStripesDist, mitoWidthRatioUMS, mitoWidthRatioBMS, mitoWidthRatioUBS, mitoWidthRatioUMNS,...
%     mitoWidthRatioBMNS, mitoWidthRatioUBNS, mitoPatchOverlapS, mitoPatchOverlapNS, filamentWidthPNZ, mitoDisplacementEdgeP, mitoActinDistP,...
%     filamentWidthNPNZ, mitoDisplacementEdgeNP, mitoActinDistNP, mitoWidthP, mitoAreaP, mitoLengthP, nonzeroP, mitoWidthNP, mitoAreaNP,...
%     mitoLengthNP, nonzeroNP, mitoPatchOverlapP, mitoPatchOverlapNP, mitoNonStripesDistP, mitoNonStripesDistNP, paramName)
