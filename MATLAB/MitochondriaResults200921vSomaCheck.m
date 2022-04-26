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
areathresh_wEll = 0.1;

filenameAnalysis = '_MitoAnalysisFull.txt';
filenameThreePeaks = '_MitoThreePeaks.txt';

%%% DO ALL THE PLOTTING BELOW

mitoThreePeaksWidthOneFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoThreePeaksWidthTwoFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoThreePeaksCenterOneFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoThreePeaksCenterTwoFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoThreePeaksNonStripesDistFiles = zeros(mitosPerFile,2,lastFileNumber);

%%% TAKE CARE OF THE THREE PEAKS MITOCHONDRIA DATA

for fileNum = fileNumbers
    if fileNum < 10
        filename = strcat('Image_00',int2str(fileNum),filenameThreePeaks);
    else
        filename = strcat('Image_0',int2str(fileNum),filenameThreePeaks);
    end
    filepath = strcat(masterFolderPath,filename);
    
    try
        data = dlmread(filepath);
        widthMitoOne = data(1:end,2);
        widthMitoTwo = data(1:end,4);
        centerMitoOne = data(1:end,3);
        centerMitoTwo = data(1:end,5);
        nonstripesdistMito = data(1:end,7);
        for i=1:length(widthMitoOne)
            mitoThreePeaksWidthOneFiles(i,1,fileNum) = i;
            mitoThreePeaksWidthOneFiles(i,2,fileNum) = widthMitoOne(i);
            mitoThreePeaksWidthTwoFiles(i,1,fileNum) = i;
            mitoThreePeaksWidthTwoFiles(i,2,fileNum) = widthMitoTwo(i);
            mitoThreePeaksCenterOneFiles(i,1,fileNum) = i;
            mitoThreePeaksCenterOneFiles(i,2,fileNum) = centerMitoOne(i);
            mitoThreePeaksCenterTwoFiles(i,1,fileNum) = i;
            mitoThreePeaksCenterTwoFiles(i,2,fileNum) = centerMitoTwo(i);
            mitoThreePeaksNonStripesDistFiles(i,1,fileNum) = i;
            mitoThreePeaksNonStripesDistFiles(i,2,fileNum) = nonstripesdistMito(i);
        end
    catch err
    end  
end

%%% TAKE CARE OF ALL MITOCHONDRIA DATA, DIVIDE FOR AIS AND STRIPES, AND
%%% THREE PEAKS

mitoWidthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoWidthEllFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoLengthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoAreaFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoCenterFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoNonStripesDistFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoStripesParam = zeros(mitosPerFile,2,lastFileNumber);
mitoAISParam = zeros(mitosPerFile,2,lastFileNumber);
mitoSmallParam = zeros(mitosPerFile,2,lastFileNumber);
mitoBiggerParam = zeros(mitosPerFile,2,lastFileNumber);
mitoRatioParamUMFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoRatioParamBMFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoRatioParamUBFiles = zeros(mitosPerFile,2,lastFileNumber);
filamentWidthFiles = zeros(mitosPerFile,2,lastFileNumber);
filamentCenterFiles = zeros(mitosPerFile,2,lastFileNumber);
extraParamFiles = zeros(mitosPerFile,2,lastFileNumber);
filamentDoublePeakParamFiles = zeros(mitosPerFile,2,lastFileNumber);
filamentSinglePeakParamFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoSmallAreaParamFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoActinDistFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoActinDistNegParamFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoPatchOverlapFiles = zeros(mitosPerFile,2,lastFileNumber);
somaParamFiles = zeros(mitosPerFile,2,lastFileNumber);


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
        widthEllMito = data(1:end,6); %Ellipsoidal fit mitochondria width (minor axis)
        lengthSkelMito = data(1:end,7); %Skeleton mitochondria length (skeleton part closest to the mitochondria centroid)
        widthMito = data(1:end,8);
        centerMito = data(1:end,9);
        nonstripesdistMito = data(1:end,10);
        actinwidth = data(1:end,11);
        actincenter = data(1:end,12);
        stripesparam = data(1:end,13);
        aisparam = data(1:end,14);
        smallparam = data(1:end,15);
        mitobiggerparam = data(1:end,16);
        mitoratioparamum = data(1:end,17);
        mitoratioparambm = data(1:end,18);
        mitoratioparamub = data(1:end,19);
        smallareaparam = data(1:end,20);
        actindoublepeakparam = data(1:end,21);
        actinsinglepeakparam = data(1:end,22);
        mitoactindist = data(1:end,24);
        mitoactindistnegparam = data(1:end,25);
        mitopatchoverlap = data(1:end,27);
        mitopatchdist = data(1:end,39);
        somaparam = data(1:end,109);
        if paramPlots
            extraparam = data(1:end,paramCol);
        end
        for i=1:length(areaMito)
            mitoAreaFiles(i,1,fileNum) = i;
            mitoAreaFiles(i,2,fileNum) = areaMito(i);
            mitoWidthFiles(i,1,fileNum) = i;
            mitoWidthFiles(i,2,fileNum) = widthMito(i);
            mitoWidthEllFiles(i,1,fileNum) = i;
            mitoWidthEllFiles(i,2,fileNum) = widthEllMito(i);
            mitoCenterFiles(i,1,fileNum) = i;
            mitoCenterFiles(i,2,fileNum) = centerMito(i);
            % Take the maximum of the ellipsoidal and skeletal length.
            % For small ones, the elliposidal will be longer and is a
            % better match, but for long ones that curve a bit the
            % skeletal fit will hopefully always be better.
            mitoLengthFiles(i,1,fileNum) = i;
            mitoLengthFiles(i,2,fileNum) = max(lengthMito(i),lengthSkelMito(i));
            % Distance to nearest actin non-stripes binary patch
            mitoNonStripesDistFiles(i,1,fileNum) = i;
            mitoNonStripesDistFiles(i,2,fileNum) = mitopatchdist(i); % Distance to nearest actin patch
            mitoStripesParam(i,1,fileNum) = i;
            mitoStripesParam(i,2,fileNum) = stripesparam(i);
            mitoAISParam(i,1,fileNum) = i;
            mitoAISParam(i,2,fileNum) = aisparam(i);
            mitoSmallParam(i,1,fileNum) = i;
            mitoSmallParam(i,2,fileNum) = smallparam(i);
            mitoBiggerParam(i,1,fileNum) = i;
            mitoBiggerParam(i,2,fileNum) = mitobiggerparam(i);
            mitoRatioParamUMFiles(i,1,fileNum) = i;
            mitoRatioParamUMFiles(i,2,fileNum) = mitoratioparamum(i);
            mitoRatioParamBMFiles(i,1,fileNum) = i;
            mitoRatioParamBMFiles(i,2,fileNum) = mitoratioparambm(i);
            mitoRatioParamUBFiles(i,1,fileNum) = i;
            mitoRatioParamUBFiles(i,2,fileNum) = mitoratioparamub(i);
            filamentWidthFiles(i,1,fileNum) = i;
            filamentWidthFiles(i,2,fileNum) = actinwidth(i);
            filamentCenterFiles(i,1,fileNum) = i;
            filamentCenterFiles(i,2,fileNum) = actincenter(i);
            mitoSmallAreaParamFiles(i,1,fileNum) = i;
            mitoSmallAreaParamFiles(i,2,fileNum) = smallareaparam(i);
            filamentDoublePeakParamFiles(i,1,fileNum) = i;
            filamentDoublePeakParamFiles(i,2,fileNum) = actindoublepeakparam(i);
            filamentSinglePeakParamFiles(i,1,fileNum) = i;
            filamentSinglePeakParamFiles(i,2,fileNum) = actinsinglepeakparam(i);
            mitoActinDistFiles(i,1,fileNum) = i;
            mitoActinDistFiles(i,2,fileNum) = mitoactindist(i);
            mitoActinDistNegParamFiles(i,1,fileNum) = i;
            mitoActinDistNegParamFiles(i,2,fileNum) = mitoactindistnegparam(i);
            mitoPatchOverlapFiles(i,1,fileNum) = i;
            mitoPatchOverlapFiles(i,2,fileNum) = mitopatchoverlap(i);
            somaParamFiles(i,1,fileNum) = i;
            somaParamFiles(i,2,fileNum) = somaparam(i);
            if paramPlots 
                extraParamFiles(i,1,fileNum) = i;
                extraParamFiles(i,2,fileNum) = extraparam(i);
            end
        end
    catch err
        %disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end  
end

filamentStripes = zeros(mitosPerFile,4,lastFileNumber);
filamentNonStripes = zeros(mitosPerFile,4,lastFileNumber);

mitoWidthS = [];
mitoLengthS = [];
mitoAreaS = [];
mitoCenterS = [];
mitoNonStripesDistS = [];
filamentWidthS = [];
filamentCenterS = [];
mitoDisplacementEdgeS = [];
mitoWidthRatioUMS = [];
mitoWidthRatioBMS = [];
mitoWidthRatioUBS = [];
mitoActinDistS = [];
mitoActinDistD2S = [];
mitoPatchOverlapS = [];

mitoWidthNS = [];
mitoLengthNS = [];
mitoAreaNS = [];
mitoCenterNS = [];
mitoNonStripesDistNS = [];
filamentWidthNS = [];
filamentCenterNS = [];
mitoDisplacementEdgeNS = [];
mitoWidthRatioUMNS = [];
mitoWidthRatioBMNS = [];
mitoWidthRatioUBNS = [];
mitoActinDistNS = [];
mitoActinDistD2NS = [];
mitoPatchOverlapNS = [];

mitoWidthP = [];
mitoLengthP = [];
mitoAreaP = [];
mitoCenterP = [];
mitoNonStripesDistP = [];
filamentWidthP = [];
filamentCenterP = [];
mitoDisplacementEdgeP = [];
mitoWidthRatioUMP = [];
mitoWidthRatioBMP = [];
mitoWidthRatioUBP = [];
mitoActinDistP = [];
mitoActinDistD2P = [];
mitoPatchOverlapP = [];

mitoWidthNP = [];
mitoLengthNP = [];
mitoAreaNP = [];
mitoCenterNP = [];
mitoNonStripesDistNP = [];
filamentWidthNP = [];
filamentCenterNP = [];
mitoDisplacementEdgeNP = [];
mitoWidthRatioUMNP = [];
mitoWidthRatioBMNP = [];
mitoWidthRatioUBNP = [];
mitoActinDistNP = [];
mitoActinDistD2NP = [];
mitoPatchOverlapNP = [];

filamentWidthAllS = [];
filamentWidthAllNS = [];
mitoThreePeaksNonStripesDist = [];
noOfThreePeaksInNonStripes = 0;
noOfThreePeaksInStripes = 0;
noOfMitoInNonStripes = 0;
noOfMitoInStripes = 0;

%%% DISPLAY THE MITOCHONDRIA NUMBER OF ALL THE MITOCHONDRIA WITH A WIDTH
%%% RATIO SMALLER THAN THE SPECIFIC NUMBER. 

disp(['All mitochondria with at least one width ratio below ' num2str(mitoWidthRatioThresholdLow)])
for fileNum=fileNumbers
    for i=1:mitosPerFile
        if mitoRatioParamUMFiles(i,2,fileNum) ~= 0 && mitoRatioParamUMFiles(i,2,fileNum) < mitoWidthRatioThresholdLow
            disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i), ', U/M'])
        end
        if mitoRatioParamBMFiles(i,2,fileNum) ~= 0 && mitoRatioParamBMFiles(i,2,fileNum) < mitoWidthRatioThresholdLow
            disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i), ', B/M'])
        end
        if mitoRatioParamUBFiles(i,2,fileNum) ~= 0 && mitoRatioParamUBFiles(i,2,fileNum) < mitoWidthRatioThresholdLow
            disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i), ', U/B'])
        end
    end
end

disp(['All mitochondria with at least one width ratio above ' num2str(mitoWidthRatioThresholdHigh)])
for fileNum=fileNumbers
    for i=1:mitosPerFile
        if mitoRatioParamUMFiles(i,2,fileNum) ~= 0 && mitoRatioParamUMFiles(i,2,fileNum) > mitoWidthRatioThresholdHigh
            disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i), ', U/M'])
        end
        if mitoRatioParamBMFiles(i,2,fileNum) ~= 0 && mitoRatioParamBMFiles(i,2,fileNum) > mitoWidthRatioThresholdHigh
            disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i), ', B/M'])
        end
    end
end

if paramPlots
    disp(['All mitochondria interesting for the given extra parameter: ' paramName])
end

for fileNum=fileNumbers
%     noProfiles = size(mitoThreePeaksNonStripesDistFiles);
%     for i=1:noProfiles(1)
%         if mitoThreePeaksWidthOneFiles(i,2,fileNum) ~= 0
%             mitoThreePeaksNonStripesDist = [mitoThreePeaksNonStripesDist; mitoThreePeaksNonStripesDistFiles(i,2,fileNum)];
%             if mitoThreePeaksNonStripesDistFiles(i,2,fileNum) == 0
%                 noOfThreePeaksInNonStripes = noOfThreePeaksInNonStripes+1;
%             else
%                 noOfThreePeaksInStripes = noOfThreePeaksInStripes+1;
%             end
%         end
%     end

    for i=1:mitosPerFile
        if mitoWidthFiles(i,2,fileNum) ~= 0 && somaParamFiles(i,2,fileNum)
            if mitoStripesParam(i,2,fileNum) == 1
                mitoWidthS = [mitoWidthS; mitoWidthFiles(i,2,fileNum)];
                mitoCenterS = [mitoCenterS; mitoCenterFiles(i,2,fileNum)];
                mitoAreaS = [mitoAreaS; mitoAreaFiles(i,2,fileNum)];
                mitoLengthS = [mitoLengthS; mitoLengthFiles(i,2,fileNum)];
                mitoNonStripesDistS = [mitoNonStripesDistS; mitoNonStripesDistFiles(i,2,fileNum)];
                filamentWidthS = [filamentWidthS; filamentWidthFiles(i,2,fileNum)];
                filamentCenterS = [filamentCenterS; filamentCenterFiles(i,2,fileNum)];
                mitoPatchOverlapS = [mitoPatchOverlapS; mitoPatchOverlapFiles(i,2,fileNum)];
                if mitoRatioParamUMFiles(i,2,fileNum) ~= 0
                    mitoWidthRatioUMS = [mitoWidthRatioUMS; mitoRatioParamUMFiles(i,2,fileNum)];
                end
                if mitoRatioParamBMFiles(i,2,fileNum) ~= 0
                    mitoWidthRatioBMS = [mitoWidthRatioBMS; mitoRatioParamBMFiles(i,2,fileNum)];
                end
                if mitoRatioParamUBFiles(i,2,fileNum) ~= 0
                    mitoWidthRatioUBS = [mitoWidthRatioUBS; mitoRatioParamUBFiles(i,2,fileNum)];
                end
                if filamentWidthFiles(i,2,fileNum) ~= 0
                    mitoActinDistS = [mitoActinDistS; mitoActinDistFiles(i,2,fileNum)];
                    mitoDisplacementEdgeS = [mitoDisplacementEdgeS; filamentWidthFiles(i,2,fileNum)/2-abs((filamentCenterFiles(i,2,fileNum)-actinLineProfLength/2)-(mitoCenterFiles(i,2,fileNum)-mitoLineProfLength/2))+mitoWidthFiles(i,2,fileNum)/2];
                end
            elseif mitoStripesParam(i,2,fileNum) == 0
                mitoWidthNS = [mitoWidthNS; mitoWidthFiles(i,2,fileNum)];
                mitoCenterNS = [mitoCenterNS; mitoCenterFiles(i,2,fileNum)];
                mitoAreaNS = [mitoAreaNS; mitoAreaFiles(i,2,fileNum)];
                mitoLengthNS = [mitoLengthNS; mitoLengthFiles(i,2,fileNum)];
                mitoNonStripesDistNS = [mitoNonStripesDistNS; mitoNonStripesDistFiles(i,2,fileNum)];
                filamentWidthNS = [filamentWidthNS; filamentWidthFiles(i,2,fileNum)];
                filamentCenterNS = [filamentCenterNS; filamentCenterFiles(i,2,fileNum)];
                mitoPatchOverlapNS = [mitoPatchOverlapNS; mitoPatchOverlapFiles(i,2,fileNum)];
                if mitoRatioParamUMFiles(i,2,fileNum) ~= 0
                    mitoWidthRatioUMNS = [mitoWidthRatioUMNS; mitoRatioParamUMFiles(i,2,fileNum)];
                end
                if mitoRatioParamBMFiles(i,2,fileNum) ~= 0
                    mitoWidthRatioBMNS = [mitoWidthRatioBMNS; mitoRatioParamBMFiles(i,2,fileNum)];
                end
                if mitoRatioParamUBFiles(i,2,fileNum) ~= 0
                    mitoWidthRatioUBNS = [mitoWidthRatioUBNS; mitoRatioParamUBFiles(i,2,fileNum)];
                end
                if filamentWidthFiles(i,2,fileNum) ~= 0
                    mitoActinDistNS = [mitoActinDistNS; mitoActinDistFiles(i,2,fileNum)];
                    mitoDisplacementEdgeNS = [mitoDisplacementEdgeNS; filamentWidthFiles(i,2,fileNum)/2-abs((filamentCenterFiles(i,2,fileNum)-actinLineProfLength/2)-(mitoCenterFiles(i,2,fileNum)-mitoLineProfLength/2))+mitoWidthFiles(i,2,fileNum)/2];
                end
            end
            if extraParamFiles(i,2,fileNum) == 1
                disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                mitoWidthP = [mitoWidthP; mitoWidthFiles(i,2,fileNum)];
                mitoCenterP = [mitoCenterP; mitoCenterFiles(i,2,fileNum)];
                mitoAreaP = [mitoAreaP; mitoAreaFiles(i,2,fileNum)];
                mitoLengthP = [mitoLengthP; mitoLengthFiles(i,2,fileNum)];
                mitoNonStripesDistP = [mitoNonStripesDistP; mitoNonStripesDistFiles(i,2,fileNum)];
                filamentWidthP = [filamentWidthP; filamentWidthFiles(i,2,fileNum)];
                filamentCenterP = [filamentCenterP; filamentCenterFiles(i,2,fileNum)];
                mitoPatchOverlapP = [mitoPatchOverlapP; mitoPatchOverlapFiles(i,2,fileNum)];
                if filamentWidthFiles(i,2,fileNum) ~= 0
                    mitoActinDistP = [mitoActinDistP; mitoActinDistFiles(i,2,fileNum)];
                    mitoDisplacementEdgeP = [mitoDisplacementEdgeP; filamentWidthFiles(i,2,fileNum)/2-abs((filamentCenterFiles(i,2,fileNum)-actinLineProfLength/2)-(mitoCenterFiles(i,2,fileNum)-mitoLineProfLength/2))+mitoWidthFiles(i,2,fileNum)/2];
                end
            elseif extraParamFiles(i,2,fileNum) == 0
                mitoWidthNP = [mitoWidthNP; mitoWidthFiles(i,2,fileNum)];
                mitoCenterNP = [mitoCenterNP; mitoCenterFiles(i,2,fileNum)];
                mitoAreaNP = [mitoAreaNP; mitoAreaFiles(i,2,fileNum)];
                mitoLengthNP = [mitoLengthNP; mitoLengthFiles(i,2,fileNum)];
                mitoNonStripesDistNP = [mitoNonStripesDistNP; mitoNonStripesDistFiles(i,2,fileNum)];
                filamentWidthNP = [filamentWidthNP; filamentWidthFiles(i,2,fileNum)];
                filamentCenterNP = [filamentCenterNP; filamentCenterFiles(i,2,fileNum)];
                mitoPatchOverlapNP = [mitoPatchOverlapNP; mitoPatchOverlapFiles(i,2,fileNum)];
                if filamentWidthFiles(i,2,fileNum) ~= 0
                    mitoActinDistNP = [mitoActinDistNP; mitoActinDistFiles(i,2,fileNum)];
                    mitoDisplacementEdgeNP = [mitoDisplacementEdgeNP; filamentWidthFiles(i,2,fileNum)/2-abs((filamentCenterFiles(i,2,fileNum)-actinLineProfLength/2)-(mitoCenterFiles(i,2,fileNum)-mitoLineProfLength/2))+mitoWidthFiles(i,2,fileNum)/2];
                end
            end
        end
    end 
end

[nonzeroS,~,filamentWidthSNZ]=find(filamentWidthS);
[nonzeroNS,~,filamentWidthNSNZ]=find(filamentWidthNS);
[nonzeroP,~,filamentWidthPNZ]=find(filamentWidthP);
[nonzeroNP,~,filamentWidthNPNZ]=find(filamentWidthNP);

%%% PLOTTING BELOW

interactivePlottingGUIThresholds191113(fontSizeGlobal, filamentWidthSNZ, mitoDisplacementEdgeS, mitoActinDistS, filamentWidthNSNZ, mitoDisplacementEdgeNS,...
    mitoActinDistNS, mitoWidthS, mitoAreaS, mitoLengthS, nonzeroS, mitoWidthNS, mitoAreaNS, mitoLengthNS, nonzeroNS, mitoNonStripesDistS,...
    mitoNonStripesDistNS, mitoThreePeaksNonStripesDist, mitoWidthRatioUMS, mitoWidthRatioBMS, mitoWidthRatioUBS, mitoWidthRatioUMNS,...
    mitoWidthRatioBMNS, mitoWidthRatioUBNS, mitoPatchOverlapS, mitoPatchOverlapNS, filamentWidthPNZ, mitoDisplacementEdgeP, mitoActinDistP,...
    filamentWidthNPNZ, mitoDisplacementEdgeNP, mitoActinDistNP, mitoWidthP, mitoAreaP, mitoLengthP, nonzeroP, mitoWidthNP, mitoAreaNP,...
    mitoLengthNP, nonzeroNP, mitoPatchOverlapP, mitoPatchOverlapNP, mitoNonStripesDistP, mitoNonStripesDistNP, paramName)
