%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200330
% Script to handle mitoSOX data, with a boolean output variable saying
% if the mitochondria has mitoSOX or not, and the average mitoSOX signal
% inside the mitochondria.
%
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\MitoSOX-MitographyAnalysis'),'\');
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
%%% MITOCHONDRIA FITTING BELOW

for fileNum = fileNumbers
    filepath = strFilepath(fileNum,filenameall,masterFolderPath);
    filepathupper = strFilepath(fileNum,filenameupper,masterFolderPath);
    filepathbottom = strFilepath(fileNum,filenamebottom,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathmito = strFilepath(fileNum,filenameallMito,masterFolderPath);
    filepathmask = strFilepath(fileNum,filenameallMask,masterFolderPath);
    filepathdend = strFilepath(fileNum,filenameallDend,masterFolderPath);
    filepathpatches = strFilepath(fileNum,filenamePatchesBinary,masterFolderPath);
    
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
        
        % Make the distance mapping matrix, convert to um
        imgrawnonstr = imread(filepathmask);
        imgrawpatches = imread(filepathpatches);
        distimgmatnonstr = bwdist(imgrawnonstr)*pixelsize;
        distimgmatpatches = bwdist(imgrawpatches./255)*pixelsize;
        
        % Load the binary AIS map
        imgdend = [];
        try
            if dendFiles
                imgdend = imread(filepathdend);
            end
        catch err
            disp(strcat(num2str(fileNum),': AIS-mito image load failed for image(mito)'));
        end
        
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
                if ~isempty(imgdend)
                    try
                        % Check if the mitochondria is in the AIS
                        if dendFiles
                            indendparam = mitoAIS(datamito(i,1),datamito(i,2),pixelsize,imgdend);
                            if indendparam ~= 0
                                indend = [indend; i];
                            elseif indendparam == 0
                                notIndend = [notIndend; i];
                            end
                        end
                    catch err
                        disp(strcat(num2str(fileNum),'(',num2str(i),')',': AIS-mito check failed for image(mito)'));
                    end
                end

                % Fit the mitochondria mid line profile
                try
                    %[wid1,wid2,center1,center2,nop,~] = mitoFit(xprofmid,yprofmid(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    %disp(strcat(num2str(fileNum),'(',num2str(i),')',': Start fitting'));
                    [gaussian,nop,widsingle,centersingle,rsqsingle,widdouble,centerdouble,rsqdouble,pos1double,pos2double,p2pdist1,p2pdist2,p2pcenter1,p2pcenter2,wid1,wid2,center1,center2,nofittedp] = mitoFitReturnAll(xprofmid,yprofmid(1:end,i),mitoSingleGaussTol,mitoDoubleGaussTol,mitoDoubleGaussTol2,gaussianFitting);
                    %disp('Fitting finished');
                    distnonstr = distNearestActinPatch(datamito(i,1),datamito(i,2),pixelsize,distimgmatnonstr);
                    distpatches = distNearestActinPatch(datamito(i,1),datamito(i,2),pixelsize,distimgmatpatches);
                    %disp('Find nearest actin patch finished');
                    mitoWidths(i,5) = distnonstr;
                    mitoWidths(i,6) = distpatches;
                    
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
        
        if length(indend)>length(notIndend)
            notIndend = [notIndend;zeros([length(indend)-length(notIndend) 1])];
        elseif length(indend)<length(notIndend)
            indend = [indend;zeros([length(notIndend)-length(indend) 1])];
        end
        dendNumbers = [indend notIndend];
        
        filesavenamewid = strFilepath(fileNum,'_MitoWidths.txt',masterFolderPath);
        filesavenameupperwid = strFilepath(fileNum,'_MitoUpperWidths.txt',masterFolderPath);
        filesavenamebottomwid = strFilepath(fileNum,'_MitoBottomWidths.txt',masterFolderPath);
        filesavenametp = strFilepath(fileNum,'_MitoThreePeaks.txt',masterFolderPath);
        filesavenameuppertp = strFilepath(fileNum,'_MitoUpperThreePeaks.txt',masterFolderPath);
        filesavenamebottomtp = strFilepath(fileNum,'_MitoBottomThreePeaks.txt',masterFolderPath);
        filesavenamedend = strFilepath(fileNum,'_MitoInDend.txt',masterFolderPath);
        filesavenameallwid = strFilepath(fileNum,'_MitoAllFitsWidths.txt',masterFolderPath);
        filesavenameallupperwid = strFilepath(fileNum,'_MitoAllFitsUpperWidths.txt',masterFolderPath);
        filesavenameallbottomwid = strFilepath(fileNum,'_MitoAllFitsBottomWidths.txt',masterFolderPath);

        dlmwrite(filesavenamewid,mitoWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenameupperwid,mitoUpperWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenamebottomwid,mitoBottomWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenametp,mitoThreePeaks,'delimiter','\t','precision',6);
        dlmwrite(filesavenameuppertp,mitoUpperThreePeaks,'delimiter','\t','precision',6);
        dlmwrite(filesavenamebottomtp,mitoBottomThreePeaks,'delimiter','\t','precision',6);
        dlmwrite(filesavenamedend,dendNumbers,'delimiter','\t','precision',4);
        dlmwrite(filesavenameallwid,mitoAllFitsWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenameallupperwid,mitoAllFitsUpperWidths,'delimiter','\t','precision',6);
        dlmwrite(filesavenameallbottomwid,mitoAllFitsBottomWidths,'delimiter','\t','precision',6);
        disp(filesavenamewid)
        
    catch err
        disp(strcat(num2str(fileNum),': No mito line profiles for this image, or some other mito fitting error'));
    end 
end

%% 
%%% STRIPES FITTING BELOW

filenameall = '_ActinStripesLineProfiles.txt';
filenameallalt = '_ActinStripesLineProfilesAlternative.txt';
filenameupper = '_ActinStripesLineProfilesUpper.txt';
filenameupperalt = '_ActinStripesLineProfilesUpperAlternative.txt';
filenamebottom = '_ActinStripesLineProfilesBottom.txt';
filenamebottomalt = '_ActinStripesLineProfilesBottomAlternative.txt';
noFile = 0;
filamentStripesWidthMidpoint = zeros(mitosPerFile,4,fileNumbers(end));
filamentStripesUpperWidthMidpoint = zeros(mitosPerFile,4,fileNumbers(end));
filamentStripesBottomWidthMidpoint = zeros(mitosPerFile,4,fileNumbers(end));

for fileNum = fileNumbers
    noFile = noFile + 1;
    
    filepath = strFilepath(fileNum,filenameall,masterFolderPath);
    filepathalt = strFilepath(fileNum,filenameallalt,masterFolderPath);
    filepathupper = strFilepath(fileNum,filenameupper,masterFolderPath);
    filepathupperalt = strFilepath(fileNum,filenameupperalt,masterFolderPath);
    filepathbottom = strFilepath(fileNum,filenamebottom,masterFolderPath);
    filepathbottomalt = strFilepath(fileNum,filenamebottomalt,masterFolderPath);
    
    try
        data = dlmread(filepath,'',1,1);
        dataalt = dlmread(filepathalt,'',1,1);
        dataupper = dlmread(filepathupper,'',1,1);
        dataupperalt = dlmread(filepathupperalt,'',1,1);
        databottom = dlmread(filepathbottom,'',1,1);
        databottomalt = dlmread(filepathbottomalt,'',1,1);
        xprof = data(3:end-2,1);
        yprof = data(3:end-2,2:end);
        xprofalt = dataalt(3:end-2,1);
        yprofalt = dataalt(3:end-2,2:end);
        xprofupper = dataupper(3:end-2,1);
        yprofupper = dataupper(3:end-2,2:end);
        xprofupperalt = dataupperalt(3:end-2,1);
        yprofupperalt = dataupperalt(3:end-2,2:end);
        xprofbottom = databottom(3:end-2,1);
        yprofbottom = databottom(3:end-2,2:end);
        xprofbottomalt = databottomalt(3:end-2,1);
        yprofbottomalt = databottomalt(3:end-2,2:end);

        % Fitting
        noProfiles = size(yprof);
        for i=1:noProfiles(2)
            %disp(strcat(num2str(i),' - Stripes'))
            try
                [width,center,nop,doublepeak,singlepeak,~,nofit] = actinFit(xprof,yprof(1:end,i),xprofalt,yprofalt(1:end,i),actinSingleGaussTol,actinDoubleGaussTol,actinGaussMinDistance,gaussianFitting);
                if nofit == 1
                    filamentStripesWidthMidpoint(i,1,noFile) = i;
                    filamentStripesWidthMidpoint(i,2,noFile) = width;
                    filamentStripesWidthMidpoint(i,3,noFile) = center;
                    filamentStripesWidthMidpoint(i,4,noFile) = doublepeak;
                    filamentStripesWidthMidpoint(i,5,noFile) = singlepeak;
                end
                filamentStripesWidthMidpoint(i,6,noFile) = nop;
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Actin stripes fitting error for image(mito)'));
            end
            try
                [widthupper,centerupper,nopupper,doublepeakupper,singlepeakupper,~,nofitupper] = actinFit(xprofupper,yprofupper(1:end,i),xprofupperalt,yprofupperalt(1:end,i),actinSingleGaussTol,actinDoubleGaussTol,actinGaussMinDistance,gaussianFitting);
                if nofitupper == 1
                    filamentStripesUpperWidthMidpoint(i,1,noFile) = i;
                    filamentStripesUpperWidthMidpoint(i,2,noFile) = widthupper;
                    filamentStripesUpperWidthMidpoint(i,3,noFile) = centerupper;
                    filamentStripesUpperWidthMidpoint(i,4,noFile) = doublepeakupper;
                    filamentStripesUpperWidthMidpoint(i,5,noFile) = singlepeakupper;
                end
                filamentStripesUpperWidthMidpoint(i,6,noFile) = nopupper;
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Actin stripes upper fitting error for image(mito)'));
            end
            try
                [widthbottom,centerbottom,nopbottom,doublepeakbottom,singlepeakbottom,~,nofitbottom] = actinFit(xprofbottom,yprofbottom(1:end,i),xprofbottomalt,yprofbottomalt(1:end,i),actinSingleGaussTol,actinDoubleGaussTol,actinGaussMinDistance,gaussianFitting);
                if nofitbottom == 1
                    filamentStripesBottomWidthMidpoint(i,1,noFile) = i;
                    filamentStripesBottomWidthMidpoint(i,2,noFile) = widthbottom;
                    filamentStripesBottomWidthMidpoint(i,3,noFile) = centerbottom;
                    filamentStripesBottomWidthMidpoint(i,4,noFile) = doublepeakbottom;
                    filamentStripesBottomWidthMidpoint(i,5,noFile) = singlepeakbottom;
                end
                filamentStripesBottomWidthMidpoint(i,6,noFile) = nopbottom;
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Actin stripes bottom fitting error for image(mito)'));
            end
        end
        
        filesavenameactin = strFilepath(fileNum,'_ActinStripes.txt',masterFolderPath);
        filesavenameactinupper = strFilepath(fileNum,'_ActinStripesUpper.txt',masterFolderPath);
        filesavenameactinbottom = strFilepath(fileNum,'_ActinStripesBottom.txt',masterFolderPath);

        dlmwrite(filesavenameactin,filamentStripesWidthMidpoint(1:end,1:end,noFile),'delimiter','\t','precision',4);
        dlmwrite(filesavenameactinupper,filamentStripesUpperWidthMidpoint(1:end,1:end,noFile),'delimiter','\t','precision',4);
        dlmwrite(filesavenameactinbottom,filamentStripesBottomWidthMidpoint(1:end,1:end,noFile),'delimiter','\t','precision',4);
        disp(filesavenameactin);
        
    catch err
        disp(strcat(num2str(fileNum),': Some actin stripes reading/fitting error for image'));
    end
end


%% 
%%% STRIPES FITTING ABOVE; NON-STRIPES FITTING BELOW

filenameall = '_ActinNonStripesLineProfiles.txt';
filenameallalt = '_ActinNonStripesLineProfilesAlternative.txt';
filenameupper = '_ActinNonStripesLineProfilesUpper.txt';
filenameupperalt = '_ActinNonStripesLineProfilesUpperAlternative.txt';
filenamebottom = '_ActinNonStripesLineProfilesBottom.txt';
filenamebottomalt = '_ActinNonStripesLineProfilesBottomAlternative.txt';
noFile = 0;
filamentNonStripesWidthMidpoint = zeros(mitosPerFile,4,fileNumbers(end));
filamentNonStripesUpperWidthMidpoint = zeros(mitosPerFile,4,fileNumbers(end));
filamentNonStripesBottomWidthMidpoint = zeros(mitosPerFile,4,fileNumbers(end));

for fileNum = fileNumbers
    noFile = noFile + 1;

    filepath = strFilepath(fileNum,filenameall,masterFolderPath);
    filepathalt = strFilepath(fileNum,filenameallalt,masterFolderPath);
    filepathupper = strFilepath(fileNum,filenameupper,masterFolderPath);
    filepathupperalt = strFilepath(fileNum,filenameupperalt,masterFolderPath);
    filepathbottom = strFilepath(fileNum,filenamebottom,masterFolderPath);
    filepathbottomalt = strFilepath(fileNum,filenamebottomalt,masterFolderPath);
    
    try
        data = dlmread(filepath,'',1,1);
        dataalt = dlmread(filepathalt,'',1,1);
        dataupper = dlmread(filepathupper,'',1,1);
        dataupperalt = dlmread(filepathupperalt,'',1,1);
        databottom = dlmread(filepathbottom,'',1,1);
        databottomalt = dlmread(filepathbottomalt,'',1,1);
        xprof = data(3:end-2,1);
        yprof = data(3:end-2,2:end);
        xprofalt = dataalt(3:end-2,1);
        yprofalt = dataalt(3:end-2,2:end);
        xprofupper = dataupper(3:end-2,1);
        yprofupper = dataupper(3:end-2,2:end);
        xprofupperalt = dataupperalt(3:end-2,1);
        yprofupperalt = dataupperalt(3:end-2,2:end);
        xprofbottom = databottom(3:end-2,1);
        yprofbottom = databottom(3:end-2,2:end);
        xprofbottomalt = databottomalt(3:end-2,1);
        yprofbottomalt = databottomalt(3:end-2,2:end);

        % Fitting
        noProfiles = size(yprof);
        for i=1:noProfiles(2)
            %disp(strcat(num2str(i),' - Non-stripes'))
            try
                [width,center,nop,doublepeak,singlepeak,~,nofit] = actinFit(xprof,yprof(1:end,i),xprofalt,yprofalt(1:end,i),actinSingleGaussTol,actinDoubleGaussTol,actinGaussMinDistance,gaussianFitting);
                if nofit == 1
                    filamentNonStripesWidthMidpoint(i,1,noFile) = i;
                    filamentNonStripesWidthMidpoint(i,2,noFile) = width;
                    filamentNonStripesWidthMidpoint(i,3,noFile) = center;
                    filamentNonStripesWidthMidpoint(i,4,noFile) = doublepeak;
                    filamentNonStripesWidthMidpoint(i,5,noFile) = singlepeak;
                end
                filamentNonStripesWidthMidpoint(i,6,noFile) = nop;
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Actin non-stripes fitting error for image(mito)'));
            end
            try
                [widthupper,centerupper,nopupper,doublepeakupper,singlepeakupper,~,nofitupper] = actinFit(xprofupper,yprofupper(1:end,i),xprofupperalt,yprofupperalt(1:end,i),actinSingleGaussTol,actinDoubleGaussTol,actinGaussMinDistance,gaussianFitting);
                if nofitupper == 1
                    filamentNonStripesUpperWidthMidpoint(i,1,noFile) = i;
                    filamentNonStripesUpperWidthMidpoint(i,2,noFile) = widthupper;
                    filamentNonStripesUpperWidthMidpoint(i,3,noFile) = centerupper;
                    filamentNonStripesUpperWidthMidpoint(i,4,noFile) = doublepeakupper;
                    filamentNonStripesUpperWidthMidpoint(i,5,noFile) = singlepeakupper;
                end
                filamentNonStripesUpperWidthMidpoint(i,6,noFile) = nopupper;
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Actin non-stripes upper fitting error for image(mito)'));
            end
            try
                [widthbottom,centerbottom,nopbottom,doublepeakbottom,singlepeakbottom,~,nofitbottom] = actinFit(xprofbottom,yprofbottom(1:end,i),xprofbottomalt,yprofbottomalt(1:end,i),actinSingleGaussTol,actinDoubleGaussTol,actinGaussMinDistance,gaussianFitting);
                if nofitbottom == 1
                    filamentNonStripesBottomWidthMidpoint(i,1,noFile) = i;
                    filamentNonStripesBottomWidthMidpoint(i,2,noFile) = widthbottom;
                    filamentNonStripesBottomWidthMidpoint(i,3,noFile) = centerbottom;
                    filamentNonStripesBottomWidthMidpoint(i,4,noFile) = doublepeakbottom;
                    filamentNonStripesBottomWidthMidpoint(i,5,noFile) = singlepeakbottom;
                end
                filamentNonStripesBottomWidthMidpoint(i,6,noFile) = nopbottom;
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Actin non-stripes bottom fitting error for image(mito)'));
            end     
        end
        
        filesavenameactin = strFilepath(fileNum,'_ActinNonStripes.txt',masterFolderPath);
        filesavenameactinupper = strFilepath(fileNum,'_ActinNonStripesUpper.txt',masterFolderPath);
        filesavenameactinbottom = strFilepath(fileNum,'_ActinNonStripesBottom.txt',masterFolderPath);

        dlmwrite(filesavenameactin,filamentNonStripesWidthMidpoint(1:end,1:end,noFile),'delimiter','\t','precision',4);
        dlmwrite(filesavenameactinupper,filamentNonStripesUpperWidthMidpoint(1:end,1:end,noFile),'delimiter','\t','precision',4);
        dlmwrite(filesavenameactinbottom,filamentNonStripesBottomWidthMidpoint(1:end,1:end,noFile),'delimiter','\t','precision',4);
        disp(filesavenameactin);
        
    catch err
        disp(strcat(num2str(fileNum),': Some actin non-stripes reading/fitting error for image'));
    end
end


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
filenameoxphos = '-OXPHOS.tif';

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
    filepathoxphos = strFilepath(fileNum,filenameoxphos,masterFolderPath);
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
        
        %%% MITOCHONDRIA OXPHOS CHECK AND FLAGGING
        % Load OXPHOS image
        imageoxphos = imread(filepathoxphos);
        % Load binary mitochondria image 
        imagemitobinary = imread(filepathMitoBinary);
        % Remove small objects and make labelled binary mitochondria image
        % flip axes of imagemitobinary so numbering matches previous
        % numbering in imageJ, i.e. in mitoAnalysis.text file
        imjbinsizelim = 0.006;  % binary object size limit in ImageJ (OMP = 0.006 um^2)
        imagemitobinary = bwareaopen(imagemitobinary,round(imjbinsizelim/pixelsize^2));
        [labelmito, num] = bwlabel(imagemitobinary');
        % flip axes back
        labelmito = labelmito';
        
        % mark all mitochondria that are touching the border
        imagemitobin = imbinarize(labelmito);
        bordermitoimg = imagemitobin - imclearborder(imagemitobin);
        labelbordermitoimg = labelmito .* bordermitoimg;
        bordermito = unique(labelbordermitoimg);
        if ~isempty(bordermito)
            bordermito(1) = [];  % remove 0 entry
        end
        for i = bordermito
            dataAnalysis(i,110) = 1;
        end
        
        if ~isempty(dataAnalysis)
            for i=1:sizeData(1)
                % get binary img of single mitochondria
                singlemitobinary = ismember(labelmito, i);
                % get a list of tmr pixels in this area
                oxphossignal = imageoxphos(singlemitobinary);
                % get average TMRE signal/pixel per mito, save to data (110)
                oxphossignalavg = mean(oxphossignal);
%                 if isempty(bordermito)
                dataAnalysis(i,111) = oxphossignalavg;
                % take care of the border mito later, so that we have a
                % value for all mitochondria here.
%                 else
%                     borderbool = dataAnalysis(i,10);
%                     if borderbool == 0
%                         dataAnalysis(i,111) = oxphossignalavg;
%                     else
%                         dataAnalysis(i,111) = nan;
%                     end
%                 end
            end

            %decide what is the limiting OXPHOS signal for pos/neg
            %signal, and save another variable - boolean yes/no
            % find thresh by double gaussian fit and find intersection
            numgroups = round(1.7*sqrt(sizeData(1)));
            oxphosvals = dataAnalysis(:,111);
            oxphosvals = oxphosvals(~isnan(oxphosvals));
            oxphosvals = sort(oxphosvals);
            % remove the biggest values, as they might be outliers, and
            % this will not affect the results if they are not
            oxphosvals = oxphosvals(1:end-round(sizeData(1)/30));
            % decide the binwidths and get bins from 0, otherwise the bins
            % start from min(oxphosvals), which might be high above 0, meaning
            % that the fit would not know what to fit around 0. If there is
            % no values close to 0, there is probably no non-signal mitos!
            binwid = (max(oxphosvals)-min(oxphosvals))/numgroups;
            binedges = 0:binwid:max(oxphosvals)+binwid;
            [cnts,edges] = histcounts(oxphosvals,numgroups,'Normalization','probability');
            edges(end) = [];
            x = edges + (edges(2)-edges(1))/2;
            [xData, yData] = prepareCurveData(x, cnts);

            % Set up fittype and options.
            % gaussian bkg + gaussian signal
            ft = fittype('gauss2');
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [0 0 0 0 median(tmrvals)*1/4 median(tmrvals)*1/4];
            opts.StartPoint = [0.2 5 3 0.2 median(tmrvals)*3/2 median(tmrvals)*1/2];
            opts.Upper = [0.5 median(tmrvals)*1/4 20 0.5 max(tmrvals) median(tmrvals)*3/2];

            % Fit model to data.
            [fitresult, gof] = fit(xData, yData, ft, opts);
            cfs = coeffvalues(fitresult);
            
            % sample the space and get the fitted gaussians
            stepsize = x(end)/max(2*max(oxphosvals), 100);
            xsampl = 0:stepsize:x(end);
            % exp + gaussian
            bkg = cfs(1).*exp(-((xsampl-cfs(2))./cfs(3)).^2);
            signalgauss = cfs(4).*exp(-((xsampl-cfs(5))./cfs(6)).^2);
%             % compare gaussians and set threshold to where they cross
%             compsign = abs(bkg-signalgauss);
%             compsign = compsign(1:round(cfs(4)/stepsize));
%             [~,idx] = min(compsign);
%             threshsignal = xsampl(idx);
            % look at total signal, between peaks, and see where it is min
            totsign = bkg+signalgauss;
            totsign = totsign(round(cfs(2)/stepsize):round(cfs(5)/stepsize));
            [~,idx] = min(totsign);
            threshsignal = xsampl(idx+round(cfs(2)/stepsize));
            
            % save boolean variable for which mito has oxphos signal above
            % thresh (signal) and which are below (no signal)
            for i=1:sizeData(1)
                oxphossignal = dataAnalysis(i,111);
                if isnan(oxphossignal)
                    dataAnalysis(i,112) = nan;
                elseif oxphossignal > threshsignal
                    dataAnalysis(i,112) = 1;
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