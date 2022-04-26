%%%
% Mitochondria width fitting from line profile files
%
% Input: One file per image (Image_xxx_MitoLineProfiles.txt),
% containing all the line profiles of all mitochondria in that image. First
% column is just the row number, the second is x (distance along line
% profile) for all line profiles, and the rest of the columns are the
% various line profile intensity values. 
%
% Output: results, with rows as the inputted image files, each with a
% matrix of results, where each row is a mitochondria, and these are the
% columns:
% col1: Mitochondria number (0 if the fit failed)
% col2: The mitochondria width from the fitting
% col3: The mitochondria center from the fitting
% col4: Number of Gaussians used in the best fitting
% col5: Number of peaks detected in the line profile
%
%----------------------------------------------
% Version: 201210
% @jonatanalvelid
%%%

clear

masterFolderPath = strcat(uigetdir('X:\Martina'),'\');
%masterFolderPath = 'X:\Martina\';

lastFileNumber = input('What is the number of the last file? ');
%lastFileNumber = 1;

results = struct();
allresults = struct();

mitoSingleGaussTol = 0.98;
mitoDoubleGaussTol = 0.92;
mitoDoubleGaussTol2 = 0.7;
gaussianFitting = 1;
filenameall = '_MitoLineProfiles.txt';
fileNumbers = 1:lastFileNumber;

%% 
for fileNum = fileNumbers
    if fileNum < 10
        filepath = strcat(masterFolderPath,'Image_00',int2str(fileNum),filenameall);
    else
        filepath = strcat(masterFolderPath,'Image_0',int2str(fileNum),filenameall);
    end
    
    % Lists for numbers of which mitochondria are in the AIS and which not
    indend = [];
    notIndend = [];
    
    try
        % Read the mito and line profile data
        data = dlmread(filepath,'',1,1);
        xprof = data(3:end-2,1);
        yprof = data(3:end-2,2:end);
        
        % Fitting
        noProfiles = size(yprof);
        mitoWidths = zeros(noProfiles(2),5);
        mitoAllFitsWidths = zeros(noProfiles(2),14);
        for i=1:noProfiles(2)
            % Fit the mitochondria mid line profile
            try
                [gaussian,nop,widsingle,centersingle,rsqsingle,...
                    widdouble,centerdouble,rsqdouble,pos1double,...
                    pos2double,p2pdist1,p2pdist2,p2pcenter1,...
                    p2pcenter2,wid1,wid2,center1,center2,nofittedp]...
                    = mitoFitReturnAll(xprof,yprof(1:end,i),...
                    mitoSingleGaussTol,mitoDoubleGaussTol,...
                    mitoDoubleGaussTol2,gaussianFitting);
                % Save extracted width, center of mito, and number of
                % peaks, according to the fitting thresholds set above
                if wid2 == 0
                    if wid1 ~= 0
                        mitoWidths(i,1) = i;
                    end
                    mitoWidths(i,2) = wid1;  % extracted width (single or double gaussian)
                    mitoWidths(i,3) = center1;  % extracted mito center
                    mitoWidths(i,4) = nofittedp;  % number of gaussians in fit
                    mitoWidths(i,5) = nop;  % number of peaks in line profile
                end
                    
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
            catch err
                disp(strcat(num2str(fileNum),'(',num2str(i),')',': Mito mid line profile fitting error for image(mito)'));
            end
        end
    catch err
        disp(strcat(num2str(fileNum),': Error reading this file number'));
    end
    results(fileNum).fitresults = mitoWidths;
    allresults(fileNum).fitresults = mitoAllFitsWidths;
end

clearvars -except results allresults

%% FITTING FUNCTION
%%% Mitochondria line profile fitting - all fits saved
function [gaussian,nop,widsingle,centersingle,rsqsingle,widdouble,centerdouble,rsqdouble,pos1double,pos2double,p2pdist1,p2pdist2,p2pcenter1,p2pcenter2,wid1,wid2,center1,center2,nofittedp] = mitoFitReturnAll(xprof,yprof,singleTol,doubleTol,doubleTol2,gaussian)
    % Peak finding and fitting parameters
    peakfitamplitudevariance = 0.2;
    [xData, yData] = prepareCurveData(xprof,yprof);
    maxval = max(yData);
    %middlepoint = xData(floor(length(xData)/2));
    [pks, locs, ~, ~] = findpeaks(yData,xData,'MinPeakDistance',0.050,'MinPeakHeight',maxval/3);
    [pksdes, locsdes, ~, ~] = findpeaks(yData,xData,'MinPeakDistance',0.050,'MinPeakHeight',maxval/3,'SortStr','descend');
    nop = length(pks);
    [widsingle,centersingle,rsqsingle,widdouble,centerdouble,rsqdouble,pos1double,pos2double,p2pdist1,p2pdist2,p2pcenter1,p2pcenter2,wid1,wid2,center1,center2,nofittedp]=deal(0);
    if nop == 3
        p2pdist1 = abs(locs(1)-locs(2));
        p2pcenter1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
        p2pdist2 = abs(locs(2)-locs(3));
        p2pcenter2 = min(locs(2),locs(3))+abs(locs(2)-locs(3))/2;
    elseif nop == 4
        p2pdist1 = abs(locs(1)-locs(2));
        p2pcenter1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
        p2pdist2 = abs(locs(3)-locs(4));
        p2pcenter2 = min(locs(3),locs(4))+abs(locs(3)-locs(4))/2;
    elseif nop == 1 || nop == 2
        if gaussian == 0
            %%% SINGLE FIT
            % middlepoint = xData(floor(length(xData)/2));
            expectedwidth = 0.120;
            % Set up fittype and options.
            ft = fittype( 'a/(((x-b)/(0.5*c))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pksdes(1) xData(3) expectedwidth/4 0];
            opts.Robust = 'LAR';
            opts.StartPoint = [pksdes(1) locsdes(1) expectedwidth 0.02*maxval];
            opts.Upper = [(1+peakfitamplitudevariance)*pksdes(1) xData(end-3) expectedwidth*4 0.2*pksdes(1)];

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);

            % R-square value of the fit.
            rsqsingle = gof.rsquare;
            % Width of mitochondria fitting.
            widsingle = coeffvals(3);
            % Center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization. 
            centersingle = coeffvals(2);
            
            %%% DOUBLE FIT
            if nop == 1
                pks(2) = pks(1);
                locs(2) = locs(1);
            end
            expectedwidth = 0.120;
            % Set up fittype and options.
            ft = fittype( 'a1/(((x-b1)/(0.5*c1))^2+1)+a2/(((x-b2)/(0.5*c2))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks(1) (1-peakfitamplitudevariance)*pks(2) xData(3) xData(3) expectedwidth/4 expectedwidth/4 0];
            opts.Robust = 'LAR';
            opts.StartPoint = [pks(1) pks(2) locs(1) locs(2) expectedwidth expectedwidth 0.02*pks(1)];
            opts.Upper = [(1+peakfitamplitudevariance)*pks(1) (1+peakfitamplitudevariance)*pks(2) xData(end-3) xData(end-3) expectedwidth*4 expectedwidth*4 0.2*pks(1)];

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);
            
            % R-square value of the fit.
            rsqdouble = gof.rsquare;
            %Width of mitochondria fitting.
            widdouble = abs(coeffvals(3)-coeffvals(4));
            %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization.
            centerdouble = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
            % Position of the peaks found
            pos1double = locs(1);
            pos2double = locs(2);
            
        elseif gaussian == 1
            %%% SINGLE FIT
            expectedwidth = 0.160;
            % Set up fittype and options.
            ft = fittype( 'a*exp(-((x-b)/(sqrt(2)*c))^2)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pksdes(1) xData(3) expectedwidth/(2*sqrt(2*log(2)))/4 0];
            opts.Robust = 'LAR';
            opts.StartPoint = [pksdes(1) locsdes(1) expectedwidth/(2*sqrt(2*log(2))) 0.02*pksdes(1)];
            opts.Upper = [(1+peakfitamplitudevariance)*pksdes(1) xData(end-3) expectedwidth/(2*sqrt(2*log(2)))*4 0.2*pksdes(1)];
            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);

            % R-square value of the fit.
            rsqsingle = gof.rsquare;
            % Width of mitochondria fitting.
            widsingle = 2*sqrt(2*log(2))*coeffvals(3);
            % Center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization. 
            centersingle = coeffvals(2);
            %%% DOUBLE FIT
            if nop == 1
                pks(2) = pks(1);
                locs(2) = locs(1);
            end
            expectedwidth = 0.160;
            % Set up fittype and options.
            ft = fittype( 'a1*exp(-((x-b1)/(sqrt(2)*c1))^2)+a2*exp(-((x-b2)/(sqrt(2)*c2))^2)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks(1) (1-peakfitamplitudevariance)*pks(2) xData(3) xData(3) expectedwidth/(2*sqrt(2*log(2)))/4 expectedwidth/(2*sqrt(2*log(2)))/4 0];
            opts.Robust = 'LAR';
            opts.StartPoint = [pks(1) pks(2) locs(1) locs(2) expectedwidth/(2*sqrt(2*log(2))) expectedwidth/(2*sqrt(2*log(2))) 0.02*pks(1)];
            opts.Upper = [(1+peakfitamplitudevariance)*pks(1) (1+peakfitamplitudevariance)*pks(2) xData(end-3) xData(end-3) expectedwidth/(2*sqrt(2*log(2)))*4 expectedwidth/(2*sqrt(2*log(2)))*4 0.2*pks(1)];
            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);

            % R-square value of the fit.
            rsqdouble = gof.rsquare;
            %Width of mitochondria fitting.
            widdouble = abs(coeffvals(3)-coeffvals(4));
            %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization.
            centerdouble = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
            % Position of the peaks found
            pos1double = locs(1);
            pos2double = locs(2);
            
        end
    end
    
    % Assign the classical widths and center values, in order to keep
    % saving those as normal and add all the new values to later columns in
    % the data, to use if I want. This is to stay consistent. 
    if nop == 3 || nop == 4
        wid1 = p2pdist1;
        center1 = p2pcenter1;
        wid2 = p2pdist2;
        center2 = p2pcenter2;
        nofittedp = nop;
    elseif nop == 1
        if rsqsingle > singleTol
            wid1 = widsingle;
            center1 = centersingle;
            nofittedp = nop;
        end
    elseif nop == 2
        if rsqdouble > doubleTol
            wid1 = widdouble;
            center1 = centerdouble;
            nofittedp = nop;
        elseif rsqdouble > doubleTol2
            wid1 = abs(pos1double - pos2double);
            center1 = min(pos1double,pos2double)+wid1/2;
            nofittedp = nop;
        end
    end
end