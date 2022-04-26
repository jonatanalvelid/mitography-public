%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 191112
% Added a binary soma variable in the FullAnalysisResults .txt file that
% tells you if the mitochondria is in the soma or not, based on a binary
% soma map. Instead of doing this step in ImageJ and just deleting those
% mitochondria, it can be done here instead, just tagging those
% mitochondria that has the centroid inside the soma binary, and
% disregarding them in the ResultsPlotting. 
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\NEW\Metabolism\Control\OMP25'),'\');
filenameparam = 'ImageJAnalysisParameters.txt';
filepathparam = strcat(masterFolderPath,filenameparam);
try
    dataparam = readtable(filepathparam);
    mitoLineProfLength = dataparam.MitoLineProfLen;
    actinLineProfLength = dataparam.ActLineProfLen;
catch err
    mitoLineProfLength = input('What is the mitochondria line profile length (um)? ');
    actinLineProfLength = input('What is the actin line profile length (um)? ');
end

lastFileNumber = input('What is the number of the last image? ');
dendFiles = input('Are there AIS-files? (1=yes) ');
mitosPerFile = 1000;
mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
actinSingleGaussTol = 0.96;
actinDoubleGaussTol = 0.96;
actinGaussMinDistance = 0.100;
gaussianFitting = 1;

filenameall = '_MitoLineProfiles.txt';
filenameupper = '_MitoUpperLineProfiles.txt';
filenamebottom = '_MitoBottomLineProfiles.txt';
filenameallNo = '_StripesNonStripesMitoNo.txt';
filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
filenameallMask = '_NonStripesMask.tif'; 
filenamePatchesBinary = '_PatchesBinaryAlternative.tif';
% filenameallDend = '_DendritesBinary.tif';
filenameallDend = '-AISBinary.tif';  % Use this if you named the files differently
fileNumbers = 1:lastFileNumber;
% fileNumbers = 1;

%% 
%%% COMBINE THE MITO AND ACTIN FILES, TO SAVE THE LOCAL ACTIN WIDTH WITH
%%% EVERY MITOCHONDRIA DIRECTLY, IN THE SAME FILE, INSTEAD OF READING FROM
%%% ALL THREE FILES AT THE SAME TIME LATER AT THE TIME OF PLOTTING.

filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoStripes = '_MitoStripes.txt';
% filenameMitoNonStripes = '_MitoNonStr.txt';
filenameStripes = '_ActinStripes.txt';
filenameNonStripes = '_ActinNonStripes.txt';
filenameStripesUpper = '_ActinStripesUpper.txt';
filenameNonStripesUpper = '_ActinNonStripesUpper.txt';
filenameStripesBottom = '_ActinStripesBottom.txt';
filenameNonStripesBottom = '_ActinNonStripesBottom.txt';
filenameMitoNumStr = '_StripesNonStripesMitoNo.txt';
filenameMitoNumDend = '_MitoInDend.txt';
filenameWidths = '_MitoWidths.txt';
filenameUpperWidths = '_MitoUpperWidths.txt';
filenameBottomWidths = '_MitoBottomWidths.txt';
filenameAllFitsWidths = '_MitoAllFitsWidths.txt';
filenameAllFitsUpperWidths = '_MitoAllFitsUpperWidths.txt';
filenameAllFitsBottomWidths = '_MitoAllFitsBottomWidths.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenamePatchesBinary = '_PatchesBinaryAlternative.tif';
filenameNeuronBinary = '_NeuronBinary.tif';
filenameSomaBinary = '_SomaBinary.tif';
filenameAISBinary = '-AISBinary.tif';

for fileNum = fileNumbers
    
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(fileNum,filenameAnalysis,masterFolderPath);
    filepathWid = strFilepath(fileNum,filenameWidths,masterFolderPath);
    filepathUpperWid = strFilepath(fileNum,filenameUpperWidths,masterFolderPath);
    filepathBottomWid = strFilepath(fileNum,filenameBottomWidths,masterFolderPath);
    filepathMitoStr = strFilepath(fileNum,filenameMitoStripes,masterFolderPath);
    % filepathMitoNonStr = strFilepath(fileNum,filenameMitoNonStripes,masterFolderPath);
    filepathStr = strFilepath(fileNum,filenameStripes,masterFolderPath);
    filepathNonStr = strFilepath(fileNum,filenameNonStripes,masterFolderPath);
    filepathStrUpper = strFilepath(fileNum,filenameStripesUpper,masterFolderPath);
    filepathNonStrUpper = strFilepath(fileNum,filenameNonStripesUpper,masterFolderPath);
    filepathStrBottom = strFilepath(fileNum,filenameStripesBottom,masterFolderPath);
    filepathNonStrBottom = strFilepath(fileNum,filenameNonStripesBottom,masterFolderPath);
    filepathMitoStrNum = strFilepath(fileNum,filenameMitoNumStr,masterFolderPath);
    filepathMitoNoDend = strFilepath(fileNum,filenameMitoNumDend,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathPatchesBinary = strFilepath(fileNum,filenamePatchesBinary,masterFolderPath);
    filepathNeuronBinary = strFilepath(fileNum,filenameNeuronBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
    filepathAllFitsWid = strFilepath(fileNum,filenameAllFitsWidths,masterFolderPath);
    filepathAllFitsUpperWid = strFilepath(fileNum,filenameAllFitsUpperWidths,masterFolderPath);
    filepathAllFitsBottomWid = strFilepath(fileNum,filenameAllFitsBottomWidths,masterFolderPath);
    
    try
        dataMitoStr = dlmread(filepathMitoStr,'',1,1);
    catch err
        disp(strcat(num2str(fileNum),': No stripes mitochondria'))
        dataMitoStr = [];
    end
    
    try
        try
            dataAnalysis = dlmread(filepathAna,'',1,1);
            % dataMitoNoStr = dlmread(filepathMitoNonStr,'',1,1);
            dataMitoStrNum = dlmread(filepathMitoStrNum,'',1,1);
            sizeMitoNum = size(dataMitoStrNum);
            sizeData = size(dataAnalysis);
            dataWid = dlmread(filepathWid);
            dataUpperWid = dlmread(filepathUpperWid);
            dataBottomWid = dlmread(filepathBottomWid);
            dataAllFitsWid = dlmread(filepathAllFitsWid);
            dataAllFitsUpperWid = dlmread(filepathAllFitsUpperWid);
            dataAllFitsBottomWid = dlmread(filepathAllFitsBottomWid);
        catch err
            disp(strcat(num2str(fileNum),': File reading error.'));
        end
        try
            dataMitoNoDend = dlmread(filepathMitoNoDend);
        catch err
            disp(strcat(num2str(fileNum),': AIS file reading failed (empty file).'));
            dataMitoNoDend = [];
        end
        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        try
            dataStripes = dlmread(filepathStr);
            dataStripesUpper = dlmread(filepathStrUpper);
            dataStripesBottom = dlmread(filepathStrBottom);
        catch err
            disp(strcat(num2str(fileNum),': No stripes actin data.'));
            dataStripes = [];
            dataStripesUpper = [];
            dataStripesBottom = [];
        end
        try
            dataNonStripes = dlmread(filepathNonStr);
            dataNonStripesUpper = dlmread(filepathNonStrUpper);
            dataNonStripesBottom = dlmread(filepathNonStrBottom);
        catch err
            disp(strcat(num2str(fileNum),': No non-stripes actin data.'));
            dataNonStripes = [];
            dataNonStripesUpper = [];
            dataNonStripesBottom = [];
        end
        dataStripesBest = dataStripes;
        dataNonStripesBest = dataNonStripes;
        
        %%% MODIFYING THE BEST STRIPES/NON-STRIPES DATA TO TAKE THE BEST FITTED
        %%% WIDTH, IN TERMS OF FIRSTLY MID, THEN UPPER, THEN BOTTOM
        [noStr,~] = size(dataStripes);
        [noNonStr,~] = size(dataNonStripes);
        
        for i=1:noStr
            if dataStripes(i,2) ~= 0
                dataStripesBest(i,:) = dataStripes(i,:);
            elseif dataStripesUpper(i,2) ~= 0
                dataStripesBest(i,:) = dataStripesUpper(i,:);
            elseif dataStripesBottom(i,2) ~= 0
                dataStripesBest(i,:) = dataStripesBottom(i,:);
            end
        end
        for i=1:noNonStr
            if dataNonStripes(i,2) ~= 0
                dataNonStripesBest(i,:) = dataNonStripes(i,:);
            elseif dataNonStripesUpper(i,2) ~= 0
                dataNonStripesBest(i,:) = dataNonStripesUpper(i,:);
            elseif dataNonStripesBottom(i,2) ~= 0
                dataNonStripesBest(i,:) = dataNonStripesBottom(i,:);
            end
        end
        
        %%% ADDING MITO WIDTHS AND STRIPES PARAMETER, ACTIN WIDTH AND
        %%% ACTIN CENTER. ADD ACTIN PARAMETERS FOR BEST, MID, UPPER AND
        %%% BOTTOM
        if not(isempty(dataMitoStr)) && not(isempty(dataStripes))
            dataMitoStrNum2 = transpose(nonzeros(dataMitoStrNum(1:end,1)));
            n=0;
            for i=dataMitoStrNum2
                n=n+1;
                dataAnalysis(i,8)=dataWid(i,2); %Mito fitted width
                dataAnalysis(i,9)=dataWid(i,3); %Mito fitted center position
                dataAnalysis(i,10)=dataWid(i,5); %Distance to nearest non-stripes binary map patch
                dataAnalysis(i,28)=dataWid(i,4); %Number of peaks in mito peak finder
                dataAnalysis(i,39)=dataWid(i,6); %Distance to nearest patches binary map patch
                dataAnalysis(i,13)=1; %Stripes parameter
                dataAnalysis(i,11)=dataStripesBest(n,2); %Actin best fitted width
                dataAnalysis(i,12)=dataStripesBest(n,3); %Actin best fitted center position
                dataAnalysis(i,21)=dataStripesBest(n,4); %Actin best fitted with double peak
                dataAnalysis(i,22)=dataStripesBest(n,5); %Actin best fitted with single peak
                dataAnalysis(i,23)=dataStripesBest(n,6); %Number of peaks in actin best peak finder
                dataAnalysis(i,85)=dataStripes(n,2); %Actin mid fitted width
                dataAnalysis(i,86)=dataStripes(n,3); %Actin mid fitted center position
                dataAnalysis(i,87)=dataStripes(n,4); %Actin mid fitted with double peak
                dataAnalysis(i,88)=dataStripes(n,5); %Actin mid fitted with single peak
                dataAnalysis(i,89)=dataStripes(n,6); %Number of peaks in actin mid peak finder
                dataAnalysis(i,91)=dataStripesUpper(n,2); %Actin upper fitted width
                dataAnalysis(i,92)=dataStripesUpper(n,3); %Actin upper fitted center position
                dataAnalysis(i,93)=dataStripesUpper(n,4); %Actin upper fitted with double peak
                dataAnalysis(i,94)=dataStripesUpper(n,5); %Actin upper fitted with single peak
                dataAnalysis(i,95)=dataStripesUpper(n,6); %Number of peaks in actin upper peak finder
                dataAnalysis(i,97)=dataStripesBottom(n,2); %Actin bottom fitted width
                dataAnalysis(i,98)=dataStripesBottom(n,3); %Actin bottom fitted center position
                dataAnalysis(i,99)=dataStripesBottom(n,4); %Actin bottom fitted with double peak
                dataAnalysis(i,100)=dataStripesBottom(n,5); %Actin bottom fitted with single peak
                dataAnalysis(i,101)=dataStripesBottom(n,6); %Number of peaks in actin bottom peak finder
            end
        elseif not(isempty(dataNonStripes))
            dataMitoNonStrNum2 = transpose(nonzeros(dataMitoStrNum(1:end,1)));
            n=0;
            for i=dataMitoNonStrNum2
                n=n+1;
                dataAnalysis(i,8)=dataWid(i,2); %Mito fitted width
                dataAnalysis(i,9)=dataWid(i,3); %Mito fitted center position
                dataAnalysis(i,10)=dataWid(i,5); %Distance to nearest non-stripes binary map patch
                dataAnalysis(i,28)=dataWid(i,4); %Number of peaks in mito peak finder
                dataAnalysis(i,39)=dataWid(i,6); %Distance to nearest patches binary map patch
                dataAnalysis(i,13)=0; %Stripes parameter
                dataAnalysis(i,11)=dataNonStripesBest(n,2); %Actin best fitted width
                dataAnalysis(i,12)=dataNonStripesBest(n,3); %Actin best fitted center position
                dataAnalysis(i,21)=dataNonStripesBest(n,4); %Actin best fitted with double peak
                dataAnalysis(i,22)=dataNonStripesBest(n,5); %Actin best fitted with single peak
                dataAnalysis(i,23)=dataNonStripesBest(n,6); %Number of peaks in actin best peak finder
                dataAnalysis(i,85)=dataNonStripes(n,2); %Actin mid fitted width
                dataAnalysis(i,86)=dataNonStripes(n,3); %Actin mid fitted center position
                dataAnalysis(i,87)=dataNonStripes(n,4); %Actin mid fitted with double peak
                dataAnalysis(i,88)=dataNonStripes(n,5); %Actin mid fitted with single peak
                dataAnalysis(i,89)=dataNonStripes(n,6); %Number of peaks in actin mid peak finder
                dataAnalysis(i,91)=dataNonStripesUpper(n,2); %Actin upper fitted width
                dataAnalysis(i,92)=dataNonStripesUpper(n,3); %Actin upper fitted center position
                dataAnalysis(i,93)=dataNonStripesUpper(n,4); %Actin upper fitted with double peak
                dataAnalysis(i,94)=dataNonStripesUpper(n,5); %Actin upper fitted with single peak
                dataAnalysis(i,95)=dataNonStripesUpper(n,6); %Number of peaks in actin upper peak finder
                dataAnalysis(i,97)=dataNonStripesBottom(n,2); %Actin bottom fitted width
                dataAnalysis(i,98)=dataNonStripesBottom(n,3); %Actin bottom fitted center position
                dataAnalysis(i,99)=dataNonStripesBottom(n,4); %Actin bottom fitted with double peak
                dataAnalysis(i,100)=dataNonStripesBottom(n,5); %Actin bottom fitted with single peak
                dataAnalysis(i,101)=dataNonStripesBottom(n,6); %Number of peaks in actin bottom peak finder
            end
        end
        if sizeMitoNum(2) ~= 1 && not(isempty(dataNonStripes))
            dataMitoNonStrNum2 = transpose(nonzeros(dataMitoStrNum(1:end,2)));
            n=0;
            for i=dataMitoNonStrNum2
                n=n+1;
                dataAnalysis(i,8)=dataWid(i,2); %Mito fitted width
                dataAnalysis(i,9)=dataWid(i,3); %Mito fitted center position
                dataAnalysis(i,10)=dataWid(i,5); %Distance to nearest non-stripes binary map patch
                dataAnalysis(i,28)=dataWid(i,4); %Number of peaks in mito peak finder
                dataAnalysis(i,39)=dataWid(i,6); %Distance to nearest patches binary map patch
                dataAnalysis(i,13)=0; %Stripes parameter
                dataAnalysis(i,11)=dataNonStripesBest(n,2); %Actin best fitted width
                dataAnalysis(i,12)=dataNonStripesBest(n,3); %Actin best fitted center position
                dataAnalysis(i,21)=dataNonStripesBest(n,4); %Actin best fitted with double peak
                dataAnalysis(i,22)=dataNonStripesBest(n,5); %Actin best fitted with single peak
                dataAnalysis(i,23)=dataNonStripesBest(n,6); %Number of peaks in actin bestpeak finder
                dataAnalysis(i,85)=dataNonStripes(n,2); %Actin mid fitted width
                dataAnalysis(i,86)=dataNonStripes(n,3); %Actin mid fitted center position
                dataAnalysis(i,87)=dataNonStripes(n,4); %Actin mid fitted with double peak
                dataAnalysis(i,88)=dataNonStripes(n,5); %Actin mid fitted with single peak
                dataAnalysis(i,89)=dataNonStripes(n,6); %Number of peaks in actin mid peak finder
                dataAnalysis(i,91)=dataNonStripesUpper(n,2); %Actin upper fitted width
                dataAnalysis(i,92)=dataNonStripesUpper(n,3); %Actin upper fitted center position
                dataAnalysis(i,93)=dataNonStripesUpper(n,4); %Actin upper fitted with double peak
                dataAnalysis(i,94)=dataNonStripesUpper(n,5); %Actin upper fitted with single peak
                dataAnalysis(i,95)=dataNonStripesUpper(n,6); %Number of peaks in actin upper peak finder
                dataAnalysis(i,97)=dataNonStripesBottom(n,2); %Actin bottom fitted width
                dataAnalysis(i,98)=dataNonStripesBottom(n,3); %Actin bottom fitted center position
                dataAnalysis(i,99)=dataNonStripesBottom(n,4); %Actin bottom fitted with double peak
                dataAnalysis(i,100)=dataNonStripesBottom(n,5); %Actin bottom fitted with single peak
                dataAnalysis(i,101)=dataNonStripesBottom(n,6); %Number of peaks in actin bottom peak finder
            end
        end
        
        %%% DENDRITE PARAMETER
        if not(isempty(dataAnalysis)) && not(isempty(dataMitoNoDend))
            dataMitoNoDend2 = transpose(nonzeros(dataMitoNoDend(1:end,1)));
            for i=dataMitoNoDend2
                dataAnalysis(i,14)=1; %Mito in the dendrites
            end
%             dataMitoNoNonDend2 = transpose(nonzeros(dataMitoNoDend(1:end,2)));
%             for i=dataMitoNoNonDend2
%                 dataAnalysis(i,14)=0; %Mito not in the dendrites
%             end
        end
%         disp('dend done')
        
        %%% SMALL PARAMETER
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,8) ~= 0 && dataAnalysis(i,8) <= 0.10
                    dataAnalysis(i,15)=1; %Mito width smaller than 100 nm
%                 else
%                     dataAnalysis(i,15)=0; %Mito width bigger than 100 nm
                end
            end
        end
%         disp('mito small done')
        
        %%% SMALL AREA PARAMETER
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,4) ~= 0 && dataAnalysis(i,4) <= 0.05
                    dataAnalysis(i,20)=1; %Mito area smaller than 0.05?m^2
%                 else
%                     dataAnalysis(i,20)=0; %Mito area bigger than 0.05?m^2
                end
            end
        end
%         disp('mito small done')
        
        %%% ACTIN SMALLER THAN MITOCHONDRIA PARAMETER
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,11) ~= 0 && dataAnalysis(i,8) ~= 0 && dataAnalysis(i,8) > dataAnalysis(i,11)
                    dataAnalysis(i,16)=1; %Mito bigger than actin width
%                 else
%                     dataAnalysis(i,16)=0; %Mito smaller than actin width
                end
            end
        end
        
        %%% MITOCHONDRIA WIDTH RATIOS - STILL USES THE OLD DEFINITION OF
        %%% THE WIDTH WITH THRESHOLDS DEFINED IN THIS INITIAL ANALYSIS
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                dataAnalysis(i,31) = dataUpperWid(i,2);
                dataAnalysis(i,32) = dataBottomWid(i,2);
                dataAnalysis(i,37) = dataUpperWid(i,3);
                dataAnalysis(i,38) = dataBottomWid(i,3);
                if dataWid(i,2) ~= 0 && dataUpperWid(i,2) ~= 0
                    dataAnalysis(i,17) = dataUpperWid(i,2)/dataWid(i,2); %Fitted mito upper/mid width ratio
                end
                if dataWid(i,2) ~= 0 && dataBottomWid(i,2) ~= 0
                    dataAnalysis(i,18) = dataBottomWid(i,2)/dataWid(i,2); %Fitted mito bottom/mid width ratio
                end
                if dataUpperWid(i,2) ~= 0 && dataBottomWid(i,2) ~= 0
                    dataAnalysis(i,19) = min(dataUpperWid(i,2),dataBottomWid(i,2))/max(dataUpperWid(i,2),dataBottomWid(i,2)); %Fitted mito bottom/upper width ratio
                end
            end
        end        
        
        %%% MITO-ACTIN DISTANCE/DISPLACEMENT - D
        %%% previous one-calculation-formula does not seemed to have worked
        %%% at all times, hence now split up to calculate distance between
        %%% left edge of actin and left edge of mito, and then right edge
        %%% of actin and right edge of mito. In the end, take the minimum
        %%% of the two, this is the distance that represent the closest
        %%% edges inside or the furthest away outside. 
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                actinDist = NaN(1,3);
                actinDistL = NaN(1,3);
                actinDistR = NaN(1,3);
                if dataAnalysis(i,85) ~= 0 && dataAnalysis(i,8) ~= 0
                    actinDistL(1) = (dataAnalysis(i,9)-dataAnalysis(i,8)/2+(actinLineProfLength-mitoLineProfLength)/2)-(dataAnalysis(i,86)-dataAnalysis(i,85)/2);
                    actinDistR(1) = (dataAnalysis(i,86)+dataAnalysis(i,85)/2)-(dataAnalysis(i,9)+dataAnalysis(i,8)/2+(actinLineProfLength-mitoLineProfLength)/2);
                    actinDist(1) = min(actinDistL(1),actinDistR(1));
                end
                if dataAnalysis(i,91) ~= 0 && dataAnalysis(i,31) ~= 0
                    actinDistL(2) = (dataAnalysis(i,37)-dataAnalysis(i,31)/2+(actinLineProfLength-mitoLineProfLength)/2)-(dataAnalysis(i,92)-dataAnalysis(i,91)/2);
                    actinDistR(2) = (dataAnalysis(i,92)+dataAnalysis(i,91)/2)-(dataAnalysis(i,37)+dataAnalysis(i,31)/2+(actinLineProfLength-mitoLineProfLength)/2);
                    actinDist(2) = min(actinDistL(2),actinDistR(2));
                end
                if dataAnalysis(i,97) ~= 0 && dataAnalysis(i,32) ~= 0
                    actinDistL(3) = (dataAnalysis(i,38)-dataAnalysis(i,32)/2+(actinLineProfLength-mitoLineProfLength)/2)-(dataAnalysis(i,98)-dataAnalysis(i,97)/2);
                    actinDistR(3) = (dataAnalysis(i,98)+dataAnalysis(i,97)/2)-(dataAnalysis(i,38)+dataAnalysis(i,32)/2+(actinLineProfLength-mitoLineProfLength)/2);
                    actinDist(3) = min(actinDistL(3),actinDistR(3));
                end
                % PICK THE ONE OF THE THREE DISTANCES THAT IS THE MOST
                % NEGATIVE, I.E. A MITOCHONDRIA THAT IS OUTSIDE IN ONE
                % OF THE THREE WILL BE DEEMED AS OUTSIDE. ALSO HAVE TO
                % CHANGE THE THREE DEFINITIONS ABOVE IF I WANT TO
                % CHANGE THIS.
                dataAnalysis(i,24) = min(actinDist); %Mito-actin distance D (negative = mito outside actin)
                if dataAnalysis(i,24) < 0
                    dataAnalysis(i,25) = 1; %Mito outside actin filament
                elseif isnan(dataAnalysis(i,24))
                    dataAnalysis(i,25) = NaN; %No actin distance possible to calculate
                end
            end
        end

        %%% MITO-ACTIN DISTANCE/DISPLACEMENT v2 - D2
        % Calculate the smallest absolute distance of all the possible
        % distances between the fitted actin and mito peak centers (i.e. 4
        % possible distances if the actin is fitted with a double peak, and
        % 2 possible distances if the actin is fitted with a single peak). 
        lpldiff = (actinLineProfLength - mitoLineProfLength)/2;
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                actinDist2 = NaN(1,3);
                actinDistM = NaN(1,4);
                actinDistU = NaN(1,4);
                actinDistB = NaN(1,4);
                % Middle mito/actin line profiles
                if dataAnalysis(i,85) ~= 0 && dataAnalysis(i,8) ~= 0
                    mC = dataAnalysis(i,9);
                    mW = dataAnalysis(i,8);
                    aC = dataAnalysis(i,86);
                    aW = dataAnalysis(i,85);
                    % Double actin peak
                    if dataAnalysis(i,87) == 1
                        actinDistM(1) = (mC - mW/2 + lpldiff) - (aC - aW/2);
                        actinDistM(2) = (mC + mW/2 + lpldiff) - (aC - aW/2);
                        actinDistM(3) = (aC + aW/2) - (mC - mW/2 + lpldiff);
                        actinDistM(4) = (aC + aW/2) - (mC + mW/2 + lpldiff);
                        actinDist2(1) = min(abs(actinDistM));
                    % Single actin peak
                    elseif dataAnalysis(i,88) == 1
                        actinDistM(1) = (mC - mW/2 + lpldiff) - (aC);
                        actinDistM(2) = (mC + mW/2 + lpldiff) - (aC);
                        actinDist2(1) = min(abs(actinDistM));
                    end
                end

                % Upper mito/actin line profiles
                if dataAnalysis(i,91) ~= 0 && dataAnalysis(i,31) ~= 0
                    mC = dataAnalysis(i,37);
                    mW = dataAnalysis(i,31);
                    aC = dataAnalysis(i,92);
                    aW = dataAnalysis(i,91);
                    % Double actin peak
                    if dataAnalysis(i,93) == 1
                        actinDistU(1) = (mC - mW/2 + lpldiff) - (aC - aW/2);
                        actinDistU(2) = (mC + mW/2 + lpldiff) - (aC - aW/2);
                        actinDistU(3) = (aC + aW/2) - (mC - mW/2 + lpldiff);
                        actinDistU(4) = (aC + aW/2) - (mC + mW/2 + lpldiff);
                        actinDist2(2) = min(abs(actinDistU));
                    % Single actin peak
                    elseif dataAnalysis(i,94) == 1
                        actinDistU(1) = (mC - mW/2 + lpldiff) - (aC);
                        actinDistU(2) = (mC + mW/2 + lpldiff) - (aC);
                        actinDist2(2) = min(abs(actinDistU));
                    end
                end

                % Bottom mito/actin line profiles
                if dataAnalysis(i,97) ~= 0 && dataAnalysis(i,32) ~= 0
                    mC = dataAnalysis(i,38);
                    mW = dataAnalysis(i,32);
                    aC = dataAnalysis(i,98);
                    aW = dataAnalysis(i,97);
                    % Double actin peak
                    if dataAnalysis(i,99) == 1 
                        actinDistB(1) = (mC - mW/2 + lpldiff) - (aC - aW/2);
                        actinDistB(2) = (mC + mW/2 + lpldiff) - (aC - aW/2);
                        actinDistB(3) = (aC + aW/2) - (mC - mW/2 + lpldiff);
                        actinDistB(4) = (aC + aW/2) - (mC + mW/2 + lpldiff);
                        actinDist2(3) = min(abs(actinDistB));
                    % Single actin peak
                    elseif dataAnalysis(i,100) == 1
                        actinDistB(1) = (mC - mW/2 + lpldiff) - (aC);
                        actinDistB(2) = (mC + mW/2 + lpldiff) - (aC);
                        actinDist2(3) = min(abs(actinDistB));
                    end
                end
                    
                % Pick the smallest distance of the three positions on
                % the mitochondria, if any of them succeeded to calculate.
                dataAnalysis(i,103) = min(actinDist2); %Mito-actin distance D2
                if dataAnalysis(i,103) < 0.05
                    dataAnalysis(i,104) = 1;
                elseif isnan(dataAnalysis(i,103))
                    dataAnalysis(i,104) = NaN; %No actin distance possible to calculate
                end
            end
        end
        
        %%% MITOCHONDRIA-PATCHES OVERLAPPING AREA
        if not(isempty(dataAnalysis))
            % Read the binary mito and patches images
            imagemitobinary = imread(filepathMitoBinary);
            imagemitobinary = logical(imagemitobinary);
            imagepatchesbinary = imread(filepathPatchesBinary);
            imagepatchesbinary = logical(imagepatchesbinary);
            for i=1:sizeData(1)
                overlappingarea = overlappingArea(bwselect(imagemitobinary,dataAnalysis(i,1)/pixelsize,dataAnalysis(i,2)/pixelsize,8),imagepatchesbinary,pixelsize);
                dataAnalysis(i,26) = overlappingarea; %Overlapping area in um^2
                dataAnalysis(i,27) = overlappingarea/dataAnalysis(i,4); %Percentual overlapping area of mitochondria area
            end
        end
        
        %%% MITOCHONDRIA-PROCESSES OVERLAPPING AREA
        if not(isempty(dataAnalysis))
            % Read the binary mito and patches images
            imagemitobinary = imread(filepathMitoBinary);
            imagemitobinary = logical(imagemitobinary);
            try
                imageneuronbinary = imread(filepathNeuronBinary);
                imageneuronbinary = logical(imageneuronbinary);
            catch err
                imageneuronbinary = zeros(size(imagemitobinary));
                imageneuronbinary = logical(imageneuronbinary);
            end
            try
                imageaisbinary = imread(filepathAISBinary);
                imageaisbinary = logical(imageaisbinary);
            catch err
                imageaisbinary = zeros(size(imagemitobinary));
                imageaisbinary = logical(imageaisbinary);
            end
            try
                imagesomabinary = imread(filepathSomaBinary);
                imagesomabinary = logical(imagesomabinary);
            catch err
                imagesomabinary = zeros(size(imagemitobinary));
                imagesomabinary = logical(imagesomabinary);
            end
            
            imageaxonbinary = imageneuronbinary .* ~imagesomabinary .* imageaisbinary;
            imagedendritebinary = imageneuronbinary .* ~imagesomabinary .* ~imageaisbinary;
            axonoverlappingarea = overlappingArea(imagemitobinary, imageaxonbinary, pixelsize);
            dendriteoverlappingarea = overlappingArea(imagemitobinary, imagedendritebinary, pixelsize);
            axonalarea = sum(sum(imageaxonbinary)) * pixelsize * pixelsize;
            dendriticarea = sum(sum(imagedendritebinary)) * pixelsize * pixelsize;
            for i=1:sizeData(1)
                dataAnalysis(i,33) = axonalarea; %Axonal area in um^2
                dataAnalysis(i,34) = dendriticarea; %Dendritic area in um^2
                dataAnalysis(i,35) = axonoverlappingarea; %Mito-axonal overlapping area in um^2
                dataAnalysis(i,36) = dendriteoverlappingarea; %Mito-dendritic overlapping area in um^2
            end
        end
        
        %%% MITOCHONDRIA FITTED WITH SINGLE OR DOUBLE PEAK, OR OTHERWISE
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,8) ~= 0 && dataAnalysis(i,28) == 2
                    dataAnalysis(i,29) = 1; %Mito fitted with double peak
                elseif dataAnalysis(i,8) ~= 0 && dataAnalysis(i,28) == 1
                    dataAnalysis(i,30) = 1; %Mito fitted with single peak
                end
            end
        end
        
        %%% MITOCHONDRIA BINARY SOMA CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                insomaparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imagesomabinary);
                if insomaparam ~= 0
                    dataAnalysis(i,109) = 1;
                elseif insomaparam == 0
                    dataAnalysis(i,109) = 1;
                end
            end
        end
                
        %%% ALL MITOCHONDRIA FITTING DATA AND PARAMETERS
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                dataAnalysis(i,40)=dataAllFitsWid(i,1); %Gaussian (1) or Lorentzian (0) fit
                dataAnalysis(i,41)=dataAllFitsWid(i,2); %Peak finder: Number of peaks
                dataAnalysis(i,42)=dataAllFitsWid(i,3); %Width of single fit
                dataAnalysis(i,43)=dataAllFitsWid(i,4); %Center position of single fit
                dataAnalysis(i,44)=dataAllFitsWid(i,5); %R-square value of single fit
                dataAnalysis(i,45)=dataAllFitsWid(i,6); %Width of double fit
                dataAnalysis(i,46)=dataAllFitsWid(i,7); %Center of double fit
                dataAnalysis(i,47)=dataAllFitsWid(i,8); %R-square value of double fit
                dataAnalysis(i,48)=dataAllFitsWid(i,9); %Location of first located peak for double fit
                dataAnalysis(i,49)=dataAllFitsWid(i,10); %Location of second located peak for double fit
                dataAnalysis(i,50)=dataAllFitsWid(i,11); %P2P distance between first two peaks in 3/4 peak fit
                dataAnalysis(i,51)=dataAllFitsWid(i,12); %P2P distance between 2/3 or 3/4 peaks in 3/4 peak fit
                dataAnalysis(i,52)=dataAllFitsWid(i,13); %P2P center of the first mito in 3/4 peak
                dataAnalysis(i,53)=dataAllFitsWid(i,14); %P2P center of the second mito in 3/4 peak

                dataAnalysis(i,55)=dataAllFitsUpperWid(i,1); %Gaussian (1) or Lorentzian (0) fit
                dataAnalysis(i,56)=dataAllFitsUpperWid(i,2); %Peak finder: Number of peaks
                dataAnalysis(i,57)=dataAllFitsUpperWid(i,3); %Width of single fit
                dataAnalysis(i,58)=dataAllFitsUpperWid(i,4); %Center position of single fit
                dataAnalysis(i,59)=dataAllFitsUpperWid(i,5); %R-square value of single fit
                dataAnalysis(i,60)=dataAllFitsUpperWid(i,6); %Width of double fit
                dataAnalysis(i,61)=dataAllFitsUpperWid(i,7); %Center of double fit
                dataAnalysis(i,62)=dataAllFitsUpperWid(i,8); %R-square value of double fit
                dataAnalysis(i,63)=dataAllFitsUpperWid(i,9); %Location of first located peak for double fit
                dataAnalysis(i,64)=dataAllFitsUpperWid(i,10); %Location of second located peak for double fit
                dataAnalysis(i,65)=dataAllFitsUpperWid(i,11); %P2P distance between first two peaks in 3/4 peak fit
                dataAnalysis(i,66)=dataAllFitsUpperWid(i,12); %P2P distance between 2/3 or 3/4 peaks in 3/4 peak fit
                dataAnalysis(i,67)=dataAllFitsUpperWid(i,13); %P2P center of the first mito in 3/4 peak
                dataAnalysis(i,68)=dataAllFitsUpperWid(i,14); %P2P center of the second mito in 3/4 peak

                dataAnalysis(i,70)=dataAllFitsBottomWid(i,1); %Gaussian (1) or Lorentzian (0) fit
                dataAnalysis(i,71)=dataAllFitsBottomWid(i,2); %Peak finder: Number of peakst
                dataAnalysis(i,72)=dataAllFitsBottomWid(i,3); %Width of single fit
                dataAnalysis(i,73)=dataAllFitsBottomWid(i,4); %Center position of single fit
                dataAnalysis(i,74)=dataAllFitsBottomWid(i,5); %R-square value of single fit
                dataAnalysis(i,75)=dataAllFitsBottomWid(i,6); %Width of double fit
                dataAnalysis(i,76)=dataAllFitsBottomWid(i,7); %Center of double fit
                dataAnalysis(i,77)=dataAllFitsBottomWid(i,8); %R-square value of double fit
                dataAnalysis(i,78)=dataAllFitsBottomWid(i,9); %Location of first located peak for double fit
                dataAnalysis(i,79)=dataAllFitsBottomWid(i,10); %Location of second located peak for double fit
                dataAnalysis(i,80)=dataAllFitsBottomWid(i,11); %P2P distance between first two peaks in 3/4 peak fit
                dataAnalysis(i,81)=dataAllFitsBottomWid(i,12); %P2P distance between 2/3 or 3/4 peaks in 3/4 peak fit
                dataAnalysis(i,82)=dataAllFitsBottomWid(i,13); %P2P center of the first mito in 3/4 peak
                dataAnalysis(i,83)=dataAllFitsBottomWid(i,14); %P2P center of the second mito in 3/4 peak
            end
        end
        
        disp(strcat(num2str(fileNum),': Data handling done.'))
        dlmwrite(filepathAnaSave,dataAnalysis,'delimiter','\t');
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end
end