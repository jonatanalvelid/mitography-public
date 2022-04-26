%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200513
% Handle only mito morphology and TMRE/OMP signal. 
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('E:\PhD\Data analysis\Mitography - temp copy\TMRE\MATLAB-RL-new'),'\');
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
mitosPerFile = 1000;
mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
gaussianFitting = 1;

filenameall = '_MitoLineProfiles.txt';
filenameupper = '_MitoUpperLineProfiles.txt';
filenamebottom = '_MitoBottomLineProfiles.txt';
filenameallPxs = '_PixelSizes.txt';
filenameallMito = '_MitoAnalysis.txt';
fileNumbers = 1:lastFileNumber;
% fileNumbers = 23;

%% 
%%% MITOCHONDRIA FITTING BELOW

for fileNum = fileNumbers
    filepath = strFilepath(fileNum,filenameall,masterFolderPath);
    filepathupper = strFilepath(fileNum,filenameupper,masterFolderPath);
    filepathbottom = strFilepath(fileNum,filenamebottom,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathmito = strFilepath(fileNum,filenameallMito,masterFolderPath);
    
    % Lists for numbers of which mitochondria are in the AIS and which not
    indend = [];
    notIndend = [];
    
    try
        % Read the mito and line profile data
        datamid = dlmread(filepath,'',1,1);
        dataupper = dlmread(filepathupper,'',1,1);
        databottom = dlmread(filepathbottom,'',1,1);
        datamito = dlmread(filepathmito,'',1,1);
        xprofmid = datamid(3:end-2,1);
        xprofupper = dataupper(3:end-2,1);
        xprofbottom = databottom(3:end-2,1);
        yprofmid = datamid(3:end-2,2:end);
        yprofupper = dataupper(3:end-2,2:end);
        yprofbottom = databottom(3:end-2,2:end);

        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
        % Fitting
        noProfiles = size(yprofmid);
        mitoWidths = zeros(noProfiles(2),5);
        mitoUpperWidths = zeros(noProfiles(2),5);
        mitoBottomWidths = zeros(noProfiles(2),5);
        mitoThreePeaks = zeros(noProfiles(2),7);
        mitoUpperThreePeaks = zeros(noProfiles(2),7);
        mitoBottomThreePeaks = zeros(noProfiles(2),7);
        mitoAllFitsWidths = zeros(noProfiles(2),14);
        mitoAllFitsUpperWidths = zeros(noProfiles(2),14);
        mitoAllFitsBottomWidths = zeros(noProfiles(2),14);
        for i=1:noProfiles(2)
            try
                % Fit the mitochondria mid line profile
                try
                    %[wid1,wid2,center1,center2,nop,~] = mitoFit(xprofmid,yprofmid(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    %disp(strcat(num2str(fileNum),'(',num2str(i),')',': Start fitting'));
                    [gaussian,nop,widsingle,centersingle,rsqsingle,widdouble,centerdouble,rsqdouble,pos1double,pos2double,p2pdist1,p2pdist2,p2pcenter1,p2pcenter2,wid1,wid2,center1,center2,nofittedp] = mitoFitReturnAll(xprofmid,yprofmid(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    %disp('Fitting finished');
                    distnonstr = 0;
                    distpatches = 0;
                    
                    % Save all the mito fit values
                    mitoAllFitsWidths(i,1) = gaussian;
                    mitoAllFitsWidths(i,2) = nop;
                    mitoAllFitsWidths(i,3) = widsingle;
                    mitoAllFitsWidths(i,4) = centersingle;
                    mitoAllFitsWidths(i,5) = rsqsingle;
                    mitoAllFitsWidths(i,6) = widdouble;
                    mitoAllFitsWidths(i,7) = centerdouble;
                    mitoAllFitsWidths(i,8) = rsqdouble;
                    mitoAllFitsWidths(i,9) = pos1double;
                    mitoAllFitsWidths(i,10) = pos2double;
                    mitoAllFitsWidths(i,11) = p2pdist1;
                    mitoAllFitsWidths(i,12) = p2pdist2;
                    mitoAllFitsWidths(i,13) = p2pcenter1;
                    mitoAllFitsWidths(i,14) = p2pcenter2;
                    
                    if wid2 == 0
                        if wid1 ~= 0
                            mitoWidths(i,1) = i;
                        end
                        mitoWidths(i,2) = wid1;
                        mitoWidths(i,3) = center1;
                        mitoWidths(i,4) = nop;
                    else
                        if wid1 ~= 0 && wid2 ~= 0
                            mitoThreePeaks(i,1) = i;
                        end
                        mitoThreePeaks(i,2) = wid1;
                        mitoThreePeaks(i,3) = center1;
                        mitoThreePeaks(i,4) = wid2;
                        mitoThreePeaks(i,5) = center2;
                        mitoThreePeaks(i,6) = nop;
                        mitoThreePeaks(i,7) = distnonstr;
                        mitoThreePeaks(i,7) = distpatches;
                    end
                catch err
                    disp(strcat(num2str(fileNum),'(',num2str(i),')',': Mito mid line profile fitting error for image(mito)'));
                end
                
                % Fit the mitochondria upper line profile
                try
                    %[wid1,wid2,center1,center2,nop,~] = mitoFit(xprofupper,yprofupper(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    [gaussian,nop,widsingle,centersingle,rsqsingle,widdouble,centerdouble,rsqdouble,pos1double,pos2double,p2pdist1,p2pdist2,p2pcenter1,p2pcenter2,wid1,wid2,center1,center2,nofittedp] = mitoFitReturnAll(xprofupper,yprofupper(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    dist = 0;
                    
                    % Save all the mito fit values
                    mitoAllFitsUpperWidths(i,1) = gaussian;
                    mitoAllFitsUpperWidths(i,2) = nop;
                    mitoAllFitsUpperWidths(i,3) = widsingle;
                    mitoAllFitsUpperWidths(i,4) = centersingle;
                    mitoAllFitsUpperWidths(i,5) = rsqsingle;
                    mitoAllFitsUpperWidths(i,6) = widdouble;
                    mitoAllFitsUpperWidths(i,7) = centerdouble;
                    mitoAllFitsUpperWidths(i,8) = rsqdouble;
                    mitoAllFitsUpperWidths(i,9) = pos1double;
                    mitoAllFitsUpperWidths(i,10) = pos2double;
                    mitoAllFitsUpperWidths(i,11) = p2pdist1;
                    mitoAllFitsUpperWidths(i,12) = p2pdist2;
                    mitoAllFitsUpperWidths(i,13) = p2pcenter1;
                    mitoAllFitsUpperWidths(i,14) = p2pcenter2;
                    
                    if wid2 == 0
                        if wid1 ~= 0
                            mitoUpperWidths(i,1) = i;
                        end
                        mitoUpperWidths(i,2) = wid1;
                        mitoUpperWidths(i,3) = center1;
                        mitoUpperWidths(i,4) = nop;
                        mitoUpperWidths(i,5) = dist;
                    else
                        if wid1 ~= 0 && wid2 ~= 0
                            mitoUpperThreePeaks(i,1) = i;
                        end
                        mitoUpperThreePeaks(i,2) = wid1;
                        mitoUpperThreePeaks(i,3) = center1;
                        mitoUpperThreePeaks(i,4) = wid2;
                        mitoUpperThreePeaks(i,5) = center2;
                        mitoUpperThreePeaks(i,6) = nop;
                        mitoUpperThreePeaks(i,7) = dist;
                    end  
                catch err
                    disp(strcat(num2str(fileNum),'(',num2str(i),')',': Mito upper line profile fitting error for image(mito)'));
                end

                % Fit the mitochondria bottom line profile
                try
                    %[wid1,wid2,center1,center2,nop,~] = mitoFit(xprofbottom,yprofbottom(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    [gaussian,nop,widsingle,centersingle,rsqsingle,widdouble,centerdouble,rsqdouble,pos1double,pos2double,p2pdist1,p2pdist2,p2pcenter1,p2pcenter2,wid1,wid2,center1,center2,nofittedp] = mitoFitReturnAll(xprofbottom,yprofbottom(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    dist = 0;
                    
                    % Save all the mito fit values
                    mitoAllFitsBottomWidths(i,1) = gaussian;
                    mitoAllFitsBottomWidths(i,2) = nop;
                    mitoAllFitsBottomWidths(i,3) = widsingle;
                    mitoAllFitsBottomWidths(i,4) = centersingle;
                    mitoAllFitsBottomWidths(i,5) = rsqsingle;
                    mitoAllFitsBottomWidths(i,6) = widdouble;
                    mitoAllFitsBottomWidths(i,7) = centerdouble;
                    mitoAllFitsBottomWidths(i,8) = rsqdouble;
                    mitoAllFitsBottomWidths(i,9) = pos1double;
                    mitoAllFitsBottomWidths(i,10) = pos2double;
                    mitoAllFitsBottomWidths(i,11) = p2pdist1;
                    mitoAllFitsBottomWidths(i,12) = p2pdist2;
                    mitoAllFitsBottomWidths(i,13) = p2pcenter1;
                    mitoAllFitsBottomWidths(i,14) = p2pcenter2;
                    
                    if wid2 == 0
                        if wid1 ~= 0
                            mitoBottomWidths(i,1) = i;
                        end
                        mitoBottomWidths(i,2) = wid1;
                        mitoBottomWidths(i,3) = center1;
                        mitoBottomWidths(i,4) = nop;
                        mitoBottomWidths(i,5) = dist;
                    else
                        if wid1 ~= 0 && wid2 ~= 0
                            mitoBottomThreePeaks(i,1) = i;
                        end
                        mitoBottomThreePeaks(i,2) = wid1;
                        mitoBottomThreePeaks(i,3) = center1;
                        mitoBottomThreePeaks(i,4) = wid2;
                        mitoBottomThreePeaks(i,5) = center2;
                        mitoBottomThreePeaks(i,6) = nop;
                        mitoBottomThreePeaks(i,7) = dist;
                    end 
                catch err
                    disp(strcat(num2str(fileNum),'(',num2str(i),')',': Mito bottom line profile fitting error for image(mito)'));
                end
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Mito fitting error for image(mito)'));
            end
        end
        
        filesavenamewid = strFilepath(fileNum,'_MitoWidths.txt',masterFolderPath);
        filesavenameupperwid = strFilepath(fileNum,'_MitoUpperWidths.txt',masterFolderPath);
        filesavenamebottomwid = strFilepath(fileNum,'_MitoBottomWidths.txt',masterFolderPath);
        filesavenametp = strFilepath(fileNum,'_MitoThreePeaks.txt',masterFolderPath);
        filesavenameuppertp = strFilepath(fileNum,'_MitoUpperThreePeaks.txt',masterFolderPath);
        filesavenamebottomtp = strFilepath(fileNum,'_MitoBottomThreePeaks.txt',masterFolderPath);
        filesavenameallwid = strFilepath(fileNum,'_MitoAllFitsWidths.txt',masterFolderPath);
        filesavenameallupperwid = strFilepath(fileNum,'_MitoAllFitsUpperWidths.txt',masterFolderPath);
        filesavenameallbottomwid = strFilepath(fileNum,'_MitoAllFitsBottomWidths.txt',masterFolderPath);

        dlmwrite(filesavenamewid,mitoWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenameupperwid,mitoUpperWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenamebottomwid,mitoBottomWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenametp,mitoThreePeaks,'delimiter','\t','precision',6);
        dlmwrite(filesavenameuppertp,mitoUpperThreePeaks,'delimiter','\t','precision',6);
        dlmwrite(filesavenamebottomtp,mitoBottomThreePeaks,'delimiter','\t','precision',6);
        dlmwrite(filesavenameallwid,mitoAllFitsWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenameallupperwid,mitoAllFitsUpperWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenameallbottomwid,mitoAllFitsBottomWidths,'delimiter','\t','precision',6);
        disp(filesavenamewid)
        
    catch err
        disp(strcat(num2str(fileNum),': No mito line profiles for this image, or some other mito fitting error'));
    end 
end

%% 
%%% COMBINE THE MITO AND ACTIN FILES, TO SAVE THE LOCAL ACTIN WIDTH WITH
%%% EVERY MITOCHONDRIA DIRECTLY, IN THE SAME FILE, INSTEAD OF READING FROM
%%% ALL THREE FILES AT THE SAME TIME LATER AT THE TIME OF PLOTTING.

filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameWidths = '_MitoWidths.txt';
filenameUpperWidths = '_MitoUpperWidths.txt';
filenameBottomWidths = '_MitoBottomWidths.txt';
filenameAllFitsWidths = '_MitoAllFitsWidths.txt';
filenameAllFitsUpperWidths = '_MitoAllFitsUpperWidths.txt';
filenameAllFitsBottomWidths = '_MitoAllFitsBottomWidths.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenameSomaBinary = '-SomaBinary.tif';
filenameBkgBinary = '-BkgBinary.tif';
filenameAISBinary = '-AISBinary.tif';
filenameTMRE = '-TMR.tif';
filenameMito = '-Mitochondria.tif';

for fileNum = fileNumbers
    
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(fileNum,filenameAnalysis,masterFolderPath);
    filepathWid = strFilepath(fileNum,filenameWidths,masterFolderPath);
    filepathUpperWid = strFilepath(fileNum,filenameUpperWidths,masterFolderPath);
    filepathBottomWid = strFilepath(fileNum,filenameBottomWidths,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathTMRE = strFilepath(fileNum,filenameTMRE,masterFolderPath);
    filepathMito = strFilepath(fileNum,filenameMito,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    filepathBkgBinary = strFilepath(fileNum,filenameBkgBinary,masterFolderPath);
    filepathAISBinary = strFilepath(fileNum,filenameAISBinary,masterFolderPath);
    filepathAllFitsWid = strFilepath(fileNum,filenameAllFitsWidths,masterFolderPath);
    filepathAllFitsUpperWid = strFilepath(fileNum,filenameAllFitsUpperWidths,masterFolderPath);
    filepathAllFitsBottomWid = strFilepath(fileNum,filenameAllFitsBottomWidths,masterFolderPath);
 
    try
        try
            dataAnalysis = dlmread(filepathAna,'',1,1);
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
        % Read images
        imagemitobinary = imread(filepathMitoBinary);
        imagemitobinary = logical(imagemitobinary);
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
        try
            imagebkgbinary = imread(filepathBkgBinary);
            imagebkgbinary = logical(imagebkgbinary);
        catch err
            imagebkgbinary = zeros(size(imagemitobinary));
            imagebkgbinary = logical(imagebkgbinary);
        end
        try
            imagetmre = imread(filepathTMRE);
%             imagetmre = logical(imagetmre);
        catch err
            imagetmre = zeros(size(imagemitobinary));
%             imagetmre = logical(imagetmre);
        end
        try
            imageomp = imread(filepathMito);
%             imageomp = logical(imageomp);
        catch err
            imageomp = zeros(size(imagemitobinary));
%             imageomp = logical(imageomp);
        end

        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);
        
        %%% ADDING MITO WIDTHS PARAMETERS
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                dataAnalysis(i,8) = dataWid(i,2); %Mito fitted width
                dataAnalysis(i,9) = dataWid(i,3); %Mito fitted center position
                dataAnalysis(i,10) = dataWid(i,5); %Distance to nearest non-stripes binary map patch
                dataAnalysis(i,28) = dataWid(i,4); %Number of peaks in mito peak finder
            end
        end
        
        %%% SMALL PARAMETER
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,8) ~= 0 && dataAnalysis(i,8) <= 0.10
                    dataAnalysis(i,15) = 1; %Mito width smaller than 100 nm
                end
            end
        end
%         disp('mito small done')
        
        %%% SMALL AREA PARAMETER
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                if dataAnalysis(i,4) ~= 0 && dataAnalysis(i,4) <= 0.05
                    dataAnalysis(i,20) = 1; %Mito area smaller than 0.05?m^2
                end
            end
        end
%         disp('mito small done')

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
                    dataAnalysis(i,109) = 1;  % SOMA
                elseif insomaparam == 0
                    dataAnalysis(i,109) = 0;  % SOMA
                end
            end
        end
        
        %%% MITOCHONDRIA BINARY BKG CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                inbkgparam = mitoAIS(dataAnalysis(i,1),dataAnalysis(i,2),pixelsize,imagebkgbinary);
                if inbkgparam ~= 0
                    dataAnalysis(i,116) = 1;  % BKG
                elseif inbkgparam == 0
                    dataAnalysis(i,116) = 0;  % BKG
                end
            end
        end
        
        %%% MITOCHONDRIA BINARY BORDER CHECK AND FLAGGING
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                % label mitos with flipped axes, to mimic ImageJ labeling
                [labelmito, num] = bwlabel(imagemitobinary');
                % flip axes back
                labelmito = labelmito';
                % mark all mitochondria that are touching the border
                %imagemitobin = imbinarize(labelmito);
                bordermitoimg1 = imagemitobinary - imclearborder(imagemitobinary);
                n = 2;
                imagemitobinary2 = imagemitobinary(n+1:end-n,n+1:end-n);
                bordermitoimg2 = imagemitobinary2 - imclearborder(imagemitobinary2);
                bordermitoimg2 = padarray(bordermitoimg2,[n n]);
                labelbordermitoimg = labelmito .* (bordermitoimg1 | bordermitoimg2);
                bordermito = nonzeros(unique(labelbordermitoimg));
                for m = bordermito
                    dataAnalysis(m,110) = 1;  % BORDER
                end
            end
        end
        
        %%% MITOCHONDRIA TMRE CHECK AND FLAGGING & OMP25 SIGNAL CHECK
        if not(isempty(dataAnalysis))
            for i=1:sizeData(1)
                % get binary img of single mitochondria
                singlemitobinary = ismember(labelmito, i);
                % get a list of tmre and omp pixels in this area
                tmresignal = imagetmre(singlemitobinary);
                ompsignal = imageomp(singlemitobinary);
                % get average TMRE and OMP signal/pixel per mito
                tmresignalavg = mean(tmresignal);
                ompsignalavg = mean(ompsignal);
                dataAnalysis(i,111) = tmresignalavg;  % TMRE SIGNAL
                dataAnalysis(i,115) = ompsignalavg;  % OMP25 SIGNAL
            end

            %decide what is the limiting TMRE signal for positive/negative
            %signal, and save another variable - boolean yes/no
            % find thresh by double gaussian fit and find intersection
            numgroups = round(3*sqrt(sizeData(1)));
            tmrevals = dataAnalysis(:,111);
            [cnts,edges] = histcounts(tmrevals,numgroups);
            edges(end) = [];
            cnts = cnts/max(cnts);
            x = edges + (edges(2)-edges(1))/2;
            [xData, yData] = prepareCurveData(x, cnts);

            % Set up fittype and options.
            % gaussian bkg + gaussian signal
            ft = fittype( 'a*exp(-x/b)+a1*exp(-((x-b1)/c1)^2)', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [0 0 0.3 max(tmrevals)*1/4 max(tmrevals)*1/8];
            opts.StartPoint = [1 0.5 1 max(tmrevals)*1/2 max(tmrevals)*1/2];
            opts.Upper = [10 1.5 10 max(tmrevals)*3/4 max(tmrevals)];

            % Fit model to data.
            [fitresult, gof] = fit(xData, yData, ft, opts);
            cfs = coeffvalues(fitresult);
            
            % sample the space and get the fitted gaussians
            stepsize = x(end)/max(2*max(tmrevals), 100);
            xsampl = 0:stepsize:x(end);
            % exp + gaussian
            bkg = cfs(1).*exp(-xsampl./cfs(3));
            signalgauss = cfs(2).*exp(-((xsampl-cfs(4))./cfs(5)).^2);
            % compare gaussians and set threshold to where they cross
            compsign = abs(bkg-signalgauss);
            compsign = compsign(1:round(cfs(4)/stepsize));
            [~,idx] = min(compsign);
            threshsignal = xsampl(idx);
            
            % save boolean variable for which mito has TMR signal above
            % thresh (signal) and which are below (no signal)
            for i=1:sizeData(1)
                tmresignal = dataAnalysis(i,111);
                if tmresignal > threshsignal
                    dataAnalysis(i,112) = 1;  % TMRE PARAM
                else
                    dataAnalysis(i,112) = 0;
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