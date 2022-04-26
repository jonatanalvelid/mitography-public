%%% 
%
% Get all the results from the mitography, into variables for morphology
% and boolean variables.
% Version 20200515 - TMRE, OMP
%
%%%

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('E:\PhD\Data analysis\Mitography - temp copy'),'\');
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

%%% TAKE CARE OF ALL MITOCHONDRIA DATA, DIVIDE FOR AIS AND STRIPES, AND
%%% THREE PEAKS

mitoWidthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoWidthEllFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoLengthFiles = zeros(mitosPerFile,2,lastFileNumber);
mitoAreaFiles = zeros(mitosPerFile,2,lastFileNumber);
doublepeakfitFiles = zeros(mitosPerFile,2,lastFileNumber);
tmreParamFiles = zeros(mitosPerFile,2,lastFileNumber);
tmrevalFiles = zeros(mitosPerFile,2,lastFileNumber);
ompvalFiles = zeros(mitosPerFile,2,lastFileNumber);
somaParamFiles = zeros(mitosPerFile,2,lastFileNumber);
borderParamFiles = zeros(mitosPerFile,2,lastFileNumber);
bkgParamFiles = zeros(mitosPerFile,2,lastFileNumber);

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
        doublepeakfit = data(1:end,29);
        tmreval = data(1:end,111);
        tmreparam = data(1:end,112);
        ompval = data(1:end,115);
        
        somaparam = data(1:end,109);
        borderparam = data(1:end,110);
        bkgparam = data(1:end,116);
        
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
            % Take the maximum of the ellipsoidal and skeletal length.
            % For small ones, the elliposidal will be longer and is a
            % better match, but for long ones that curve a bit or branches
            % the skeletal fit will hopefully always be better. However,
            % sometimes for small ones, when no skeleton exists, it will
            % pick the close-by skeleton, which might be a big one, or
            % entirely the wrong length. Thus always pick the ellipsoidal
            % length for these. 
            mitoLengthFiles(i,1,fileNum) = i;
            if areaMito(i) < 0.2
                mitoLengthFiles(i,2,fileNum) = lengthMito(i);
            else
                mitoLengthFiles(i,2,fileNum) = max(lengthMito(i),lengthSkelMito(i));
            end
            doublepeakfitFiles(i,1,fileNum) = i;
            doublepeakfitFiles(i,2,fileNum) = doublepeakfit(i);
            
            tmreParamFiles(i,1,fileNum) = i;
            tmreParamFiles(i,2,fileNum) = tmreparam(i);
            tmrevalFiles(i,1,fileNum) = i;
            tmrevalFiles(i,2,fileNum) = tmreval(i);
            ompvalFiles(i,1,fileNum) = i;
            ompvalFiles(i,2,fileNum) = ompval(i);
            
            somaParamFiles(i,1,fileNum) = i;
            somaParamFiles(i,2,fileNum) = somaparam(i);
            borderParamFiles(i,1,fileNum) = i;
            borderParamFiles(i,2,fileNum) = borderparam(i);
            bkgParamFiles(i,1,fileNum) = i;
            bkgParamFiles(i,2,fileNum) = bkgparam(i);
            
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
mitoAR = [];
mitoArea = [];
mitoTMRE = [];
mitoOMP = [];
mitoTMREparam = [];
mitodoublepeakparam = [];

mitoWidthP = [];
mitoLengthP = [];
mitoARP = [];
mitoAreaP = [];
mitoTMREP = [];
mitoOMPP = [];
mitoTMREparamP = [];
mitodoublepeakparamP = [];

mitoWidthNP = [];
mitoLengthNP = [];
mitoARNP = [];
mitoAreaNP = [];
mitoTMRENP = [];
mitoOMPNP = [];
mitoTMREparamNP = [];
mitodoublepeakparamNP = [];


for fileNum=fileNumbers
    for i=1:mitosPerFile
        allcheck = somaParamFiles(i,2,fileNum) | borderParamFiles(i,2,fileNum) | bkgParamFiles(i,2,fileNum);
        if mitoWidthFiles(i,2,fileNum) ~= 0 && ~allcheck
            % Calculate AR as w_ell/l_ell if the area is small enough
            % (A<0.2 µm^2), while instead use w_fit/l_ell if the
            % mitochondria is bigger. The fitted width will always be the
            % more accurate width, but since we don't have a completely 
            % accurate (fitted) length for the small mitos, the AR will be 
            % more accurate by using the ellipsoidal width and length for 
            % the smaller mitos. 
            if mitoAreaFiles(i,2,fileNum) < areathresh_wEll
                ARtemp = mitoWidthEllFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            else
                ARtemp = mitoWidthFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
            end
            if ARtemp > 1
                ARtemp = 1/ARtemp;
            end
            mitoWidth = [mitoWidth; mitoWidthFiles(i,2,fileNum)];
            mitoArea = [mitoArea; mitoAreaFiles(i,2,fileNum)];
            mitoLength = [mitoLength; mitoLengthFiles(i,2,fileNum)];
            mitoAR = [mitoAR; ARtemp];
            mitoTMRE = [mitoTMRE; tmrevalFiles(i,2,fileNum)];
            mitoOMP = [mitoOMP; ompvalFiles(i,2,fileNum)];
            mitoTMREparam = [mitoTMREparam; tmreParamFiles(i,2,fileNum)];
            mitodoublepeakparam = [mitodoublepeakparam; doublepeakfitFiles(i,2,fileNum)];
            if paramPlots
                if extraParamFiles(i,2,fileNum) == 1
                    disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
                    mitoWidthP = [mitoWidthP; mitoWidthFiles(i,2,fileNum)];
                    mitoAreaP = [mitoAreaP; mitoAreaFiles(i,2,fileNum)];
                    mitoLengthP = [mitoLengthP; mitoLengthFiles(i,2,fileNum)];
                    mitoARP = [mitoARP; ARtemp];
                    mitoTMREP = [mitoTMREP; tmrevalFiles(i,2,fileNum)];
                    mitoOMPP = [mitoOMPP; ompvalFiles(i,2,fileNum)];
                    mitoTMREparamP = [mitoTMREparamP; tmreParamFiles(i,2,fileNum)];
                    mitodoublepeakparamP = [mitodoublepeakparamP; doublepeakfitFiles(i,2,fileNum)];
                elseif extraParamFiles(i,2,fileNum) == 0
                    mitoWidthNP = [mitoWidthNP; mitoWidthFiles(i,2,fileNum)];
                    mitoAreaNP = [mitoAreaNP; mitoAreaFiles(i,2,fileNum)];
                    mitoLengthNP = [mitoLengthNP; mitoLengthFiles(i,2,fileNum)];
                    mitoARNP = [mitoARNP; ARtemp];
                    mitoTMRENP = [mitoTMRENP; tmrevalFiles(i,2,fileNum)];
                    mitoOMPNP = [mitoOMPNP; ompvalFiles(i,2,fileNum)];
                    mitoTMREparamNP = [mitoTMREparamNP; tmreParamFiles(i,2,fileNum)];
                    mitodoublepeakparamNP = [mitodoublepeakparamNP; doublepeakfitFiles(i,2,fileNum)];
                end
            end
        end
    end 
end

%{
%%% DISPLAY THE MITOCHONDRIA NUMBER OF SPECIFIC MITOCHONDRIA WITH A CERTAIN
%%% PARAMETER ABOVE/BELOW A CERTAIN THRESHOLD
mitoAreaThresh = 0.086;
mitoARThresh = 0.5;

disp(['All stick-like small mitos with TMRE+: '])
for fileNum=fileNumbers
    for i=1:mitosPerFile
        ARtemp = mitoWidthFiles(i,2,fileNum)/mitoLengthFiles(i,2,fileNum);
        if ARtemp > 1
            ARtemp = 1/ARtemp;
        end
        if tmreParamFiles(i,2,fileNum) == 0 && mitoAreaFiles(i,2,fileNum) < mitoAreaThresh && ARtemp < mitoARThresh
            disp(['Image: ' int2str(fileNum) ', mito: ' int2str(i)])
        end
    end
end
%}

clearvars -except mitoWidth mitoArea mitoLength mitoAR mitoTMRE mitoOMP mitoTMREparam mitodoublepeakparam

%{
% %%% PLOTTING BELOW
% 
% interactivePlottingGUIThresholds191113(fontSizeGlobal, filamentWidthSNZ, mitoDisplacementEdgeS, mitoActinDistS, filamentWidthNSNZ, mitoDisplacementEdgeNS,...
%     mitoActinDistNS, mitoWidth, mitoArea, mitoLength, nonzeroS, mitoWidthNS, mitoAreaNS, mitoLengthNS, nonzeroNS, mitoNonStripesDistS,...
%     mitoNonStripesDistNS, mitoThreePeaksNonStripesDist, mitoWidthRatioUMS, mitoWidthRatioBMS, mitoWidthRatioUBS, mitoWidthRatioUMNS,...
%     mitoWidthRatioBMNS, mitoWidthRatioUBNS, mitoPatchOverlapS, mitoPatchOverlapNS, filamentWidthPNZ, mitoDisplacementEdgeP, mitoActinDistP,...
%     filamentWidthNPNZ, mitoDisplacementEdgeNP, mitoActinDistNP, mitoWidthP, mitoAreaP, mitoLengthP, nonzeroP, mitoWidthNP, mitoAreaNP,...
%     mitoLengthNP, nonzeroNP, mitoPatchOverlapP, mitoPatchOverlapNP, mitoNonStripesDistP, mitoNonStripesDistNP, paramName)
%}