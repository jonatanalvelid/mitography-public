%%% Mitochondria line profile fitting - OLD VERSION
function [wid1,wid2,center1,center2,nop] = mitoFitOld(xprof,yprof,singleTol,doubleTol)
    [xData, yData] = prepareCurveData(xprof,yprof);
    maxval = max(yData);
    middlepoint = xData(floor(length(xData)/2));
    [pks, locs, ~, ~] = findpeaks(yData,xData,'MinPeakDistance',0.050,'MinPeakHeight',maxval/3);
    nop = length(pks);
    [wid1,wid2,center1,center2]=deal(0);
    if length(pks) == 3
        wid1 = abs(locs(1)-locs(2));
        center1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
        wid2 = abs(locs(2)-locs(3));
        center2 = min(locs(2),locs(3))+abs(locs(2)-locs(3))/2;
    elseif length(pks) == 4
        wid1 = abs(locs(1)-locs(2));
        center1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
        wid2 = abs(locs(3)-locs(4));
        center2 = min(locs(3),locs(4))+abs(locs(3)-locs(4))/2;
    elseif length(pks) == 1
        middlepoint = xData(floor(length(xData)/2));
        expectedwidth = 0.160;
        % Set up fittype and options.
        ft = fittype( 'a*exp(-((x-b)/c)^2)+d', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [0 0 0 0];
        opts.Robust = 'LAR';
        opts.StartPoint = [maxval middlepoint expectedwidth/(2*sqrt(log(2))) 0.02*maxval];
        opts.Upper = [2*maxval xData(end) xData(end) 0.2*maxval];

        % Fit model to data.
        [fitresult, gof] = fit( xData, yData, ft, opts );
        coeffvals = coeffvalues(fitresult);

        % Save distances between the peaks, or refit with a single Gaussian
        if gof.rsquare > singleTol
            % Save the FWHM of the single Gaussian instead
            wid1 = 2*sqrt(log(2))*coeffvals(3);
            %Width of mitochondria fitting.
            center1 = coeffvals(2);
            %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization. 
        end
    elseif length(pks) == 2
        expectedwidth = 0.160;
        % Set up fittype and options.
        ft = fittype( 'a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+d', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [0.2*maxval 0.2*maxval 0 0 0 0 0];
        opts.Robust = 'LAR';
        opts.StartPoint = [maxval maxval middlepoint-0.2 middlepoint+0.2 expectedwidth/(2*sqrt(log(2))) expectedwidth/(2*sqrt(log(2))) 0.02*maxval];
        opts.Upper = [1.25*maxval 1.25*maxval xData(end) xData(end) xData(end)/(2*2*sqrt(log(2))) xData(end)/(2*2*sqrt(log(2)))  0.2*maxval];

        % Fit model to data.
        [fitresult, gof] = fit( xData, yData, ft, opts );
        coeffvals = coeffvalues(fitresult);

        if gof.rsquare > doubleTol % && abs(coeffvals(3)-coeffvals(4)) < 0.500
            wid1 = abs(coeffvals(3)-coeffvals(4));
            %Width of mitochondria fitting.
            center1 = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
            %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization.
        end
    end
end