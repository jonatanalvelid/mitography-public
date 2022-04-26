%%%
%
% Mitography main code. Analyses all info and line profiles spitted out
% from the ImageJ Mitography script, and gives the info per mitochonrdia
% out.
%
%----------------------------
%
% Version: 200325
% New script to handle OXPHOS data, with a boolean output variable saying
% if the mitochondria has OXPHOS or not, and the average OXPHOS signal
% inside the mitochondria. Based entirely on TMROnlyTest-way of analysing
% the data.
%
%%%

% clear all

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));

masterFolderPath = strcat(uigetdir('X:\Mitography\OXPHOS-MitographyAnalysis\MATLAB RL'),'\');
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
filenameTMR = '-OXPHOS.tif';
% dataAnalysis = [];
% tmrvalsall = [];

for fileNum = 1:10%fileNumbers
    
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
            numgroups = round(1.7*sqrt(sizeData(1)));
            tmrvals = dataAnalysis(:,11);
            tmrvals = tmrvals(~isnan(tmrvals));
            tmrvals = sort(tmrvals);
            % remove the biggest values, as they might be outliers, and
            % this will not affect the results if they are not
            tmrvals = tmrvals(1:end-round(sizeData(1)/30));
            % decide the binwidths and get bins from 0, otherwise the bins
            % start from min(tmrvals), which might be high above 0, meaning
            % that the fit would not know what to fit around 0. If there is
            % no values close to 0, there is probably no non-signal mitos!
            binwid = (max(tmrvals)-min(tmrvals))/numgroups;
            binedges = 0:binwid:max(tmrvals)+binwid;
%             [cnts,edges] = histcounts(tmrvals,numgroups);
            [cnts,edges] = histcounts(tmrvals,binedges,'Normalization','probability');
            
%             % add all tmrvals to a set
%             tmrvalsall = [tmrvalsall; tmrvals];
            
            % check if there are some leading zero-cnts bins, if so remove
%             zeroel = find(cnts);
%             cnts(1:zeroel(1)-1) = [];
%             edges(1:zeroel(1)-1) = [];
            
            edges(end) = [];
%             cnts = cnts/max(cnts);
            x = edges + (edges(2)-edges(1))/2;
            [xData, yData] = prepareCurveData( x, cnts );

            %{
            % Set up fittype and options.
            % gaussian bkg + gaussian signal
            ft = fittype( 'a*exp(-x/b)+a1*exp(-((x-b1)/c1)^2)', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [a:0   a1:0    b:0.3   b1:median(tmrvals)*1/4     c1:median(tmrvals)*1/4];
            opts.StartPoint = [a:0.2    a1:0.2  b:1     b1:median(tmrvals)  c1:median(tmrvals)*1/2];
            opts.Upper = [a:0.5     a1:0.5  b:3  b1:max(tmrvals)*0.9  c1:median(tmrvals)*3/2];

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
            %}
            
            % Set up fittype and options.
            % gaussian bkg + gaussian signal
            ft = fittype('gauss2');
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [0 0 0 0 median(tmrvals)*1/4 median(tmrvals)*1/4];
            opts.StartPoint = [0.2 5 3 0.2 median(tmrvals)*3/2 median(tmrvals)*1/2];
            opts.Upper = [0.5 median(tmrvals)*1/4 20 0.5 max(tmrvals) median(tmrvals)*3/2];

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            cfs = coeffvalues(fitresult);
            disp(cfs)
            
            % sample the space and get the fitted gaussians
            stepsize = x(end)/max(2*max(tmrvals),100);
            xsampl = 0:stepsize:x(end);
            % gaussian + gaussian
            bkg = cfs(1).*exp(-((xsampl-cfs(2))./cfs(3)).^2);
            signalgauss = cfs(4).*exp(-((xsampl-cfs(5))./cfs(6)).^2);
            % compare gaussians and set threshold to where they cross
%             compsign = abs(bkg-signalgauss);
            totsign = bkg+signalgauss;
%             compsign = compsign(round(cfs(2)/stepsize):round(cfs(5)/stepsize));
            totsign = totsign(round(cfs(2)/stepsize):round(cfs(5)/stepsize));
%             [~,idx] = min(compsign);
            [~,idx] = min(totsign);
            
            disp(xsampl(idx+round(cfs(2)/stepsize)))
            threshsignal = xsampl(idx+round(cfs(2)/stepsize));
            
            figure()
            plot(xsampl,bkg)
            hold on
            plot(xsampl,signalgauss)
            plot(xsampl(round(cfs(2)/stepsize):round(cfs(5)/stepsize)),totsign)
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