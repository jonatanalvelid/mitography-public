%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200325
% New script to handle MitSOX data, with a boolean output variable saying
% if the mitochondria has MitSOX or not, and the average MitSOX signal
% inside the mitochondria. Based entirely on TMROnlyTest-way of analysing
% the data.
%
%%%

% clear all

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\MitoSOX-MitographyAnalysis\MATLAB-RL'),'\');
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

filenameallPxs = '_PixelSizes.txt';
filenameAnalysis = '_MitoAnalysis.txt';
filenameAnalysisSave = '_MitoAnalysisFull.txt';
filenameMitoBinary = '_MitoBinary.tif';
filenameSomaBinary = '-SomaBinary.tif';
filenameTMR = '-MitoSOX.tif';

for fileNum = 1:12%:10%fileNumbers
    
    filepathAnaSave = strFilepath(fileNum,filenameAnalysisSave,masterFolderPath);
    filepathAna = strFilepath(fileNum,filenameAnalysis,masterFolderPath);
    filepathpxs = strFilepath(fileNum,filenameallPxs,masterFolderPath);
    filepathTMR = strFilepath(fileNum,filenameTMR,masterFolderPath);
    filepathMitoBinary = strFilepath(fileNum,filenameMitoBinary,masterFolderPath);
    filepathSomaBinary = strFilepath(fileNum,filenameSomaBinary,masterFolderPath);
    
    try
        try
            dataAnalysis = dlmread(filepathAna,'',1,1);
            % dataMitoNoStr = dlmread(filepathMitoNonStr,'',1,1);
            sizeData = size(dataAnalysis);
        catch err
            disp(strcat(num2str(fileNum),': File reading error.'));
        end
        % Read the pixel size
        datapxs = dlmread(filepathpxs,'',1,1);
        pixelsize = datapxs(1,1);

        %%% MITOCHONDRIA TMR CHECK AND FLAGGING
        
        % Load TMR image
        imagetmr = imread(filepathTMR);
        % Load binary mitochondria image 
        imagemitobinary = imread(filepathMitoBinary);
        imsize = size(imagemitobinary);
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
            dataAnalysis(i,10) = 1;
        end

        if ~isempty(dataAnalysis)
            for i=1:sizeData(1)
                % get binary img of single mitochondria
                singlemitobinary = ismember(labelmito, i);
                % get a list of tmr pixels in this area
                tmrsignal = imagetmr(singlemitobinary);
                % get average TMR signal/pixel per mito, save to data (110)
                tmrsignalavg = mean(tmrsignal);
                if isempty(bordermito)
                    dataAnalysis(i,11) = tmrsignalavg;
                else
                    borderbool = dataAnalysis(i,10);
                    if borderbool == 0
                        dataAnalysis(i,11) = tmrsignalavg;
                    else
                        dataAnalysis(i,11) = nan;
                    end
                end
            end

            %decide what is the limiting TMR signal for positive/negative
            %signal, and save another variable - boolean yes/no
            % find thresh by double gaussian fit and find intersection
            numgroups = round(2*sqrt(sizeData(1)));
            tmrvals = dataAnalysis(:,11);
            tmrvals = tmrvals(~isnan(tmrvals));
            tmrvals = sort(tmrvals);
            % remove the biggest values, as they might be outliers, and
            % this will not affect the results if they are not
%             tmrvals = tmrvals(1:end-round(sizeData(1)/10));
            % decide the binwidths and get bins from 0, otherwise the bins
            % start from min(tmrvals), which might be high above 0, meaning
            % that the fit would not know what to fit around 0. If there is
            % no values close to 0, there is probably no non-signal mitos!
            binwid = (max(tmrvals)-min(tmrvals))/numgroups;
            binedges = 0:binwid:max(tmrvals)+binwid;
%             [cnts,edges] = histcounts(tmrvals,numgroups);
            [cnts,edges] = histcounts(tmrvals,binedges,'Normalization','probability');
            
%             % check if there are some leading zero-cnts bins, if so remove
%             zeroel = find(cnts);
%             cnts(1:zeroel(1)-1) = [];
%             edges(1:zeroel(1)-1) = [];
            
            edges(end) = [];
%             cnts = cnts/max(cnts);
            x = edges + (edges(2)-edges(1))/2;
            [xData, yData] = prepareCurveData( x, cnts );

            % Set up fittype and options.
            % gaussian bkg + gaussian signal
            ft = fittype( 'a*exp(-x/b)+a1*exp(-((x-b1)/c1)^2)', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [0 0 0.3 median(tmrvals)*1/4 median(tmrvals)*1/4];
            opts.StartPoint = [0.2 0.2 1 median(tmrvals) median(tmrvals)*1/2];
            opts.Upper = [0.5 0.5 3 max(tmrvals)*0.9 median(tmrvals)*3/2];

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            cfs = coeffvalues(fitresult);
            disp(cfs)
            
            % sample the space and get the fitted gaussians
            stepsize = x(end)/max(2*max(tmrvals),100);
            xsampl = 0:stepsize:x(end);
            % exp + gaussian
            bkg = cfs(1).*exp(-xsampl./cfs(3));
            signalgauss = cfs(2).*exp(-((xsampl-cfs(4))./cfs(5)).^2);
            % compare gaussians and set threshold to where they cross
            compsign = abs(bkg-signalgauss);
            compsign = compsign(1:round(cfs(4)/stepsize));
            [~,idx] = min(compsign);
            
            disp(xsampl(idx))
            threshsignal = xsampl(idx);
            
            figure()
            plot(xsampl,bkg)
            hold on
            plot(xsampl,signalgauss)
            plot(xsampl(1:round(cfs(4)/stepsize)),compsign)
            scatter(xData,yData)

            % save boolean variable for which mito has TMR signal above
            % thresh (signal) and which are below (no signal)
            for i=1:sizeData(1)
                tmrsignal = dataAnalysis(i,11);
                if tmrsignal > threshsignal
                    dataAnalysis(i,12) = 1;
                elseif isnan(tmrsignal)
                    dataAnalysis(i,12) = nan;
                else
                    dataAnalysis(i,12) = 0;
                end
            end
        end
        
    catch err
        disp(strcat(num2str(fileNum),': No image with this number or a file reading error.'))
    end
end