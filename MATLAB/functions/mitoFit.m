%%% Mitochondria line profile fitting
function [wid1,wid2,center1,center2,nop,nofittedp] = mitoFit(xprof,yprof,singleTol,doubleTol,doubleTol2,gaussian)
    % Peak finding and fitting parameters
    peakfitamplitudevariance = 0.2;

    [xData, yData] = prepareCurveData(xprof,yprof);
    maxval = max(yData);
    %middlepoint = xData(floor(length(xData)/2));
    [pks, locs, ~, ~] = findpeaks(yData,xData,'MinPeakDistance',0.050,'MinPeakHeight',maxval/3);
    nop = length(pks);
    [wid1,wid2,center1,center2,nofittedp]=deal(0);
    if length(pks) == 3
        wid1 = abs(locs(1)-locs(2));
        center1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
        wid2 = abs(locs(2)-locs(3));
        center2 = min(locs(2),locs(3))+abs(locs(2)-locs(3))/2;
        nofittedp = 3;
    elseif length(pks) == 4
        wid1 = abs(locs(1)-locs(2));
        center1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
        wid2 = abs(locs(3)-locs(4));
        center2 = min(locs(3),locs(4))+abs(locs(3)-locs(4))/2;
        nofittedp = 4;
    elseif length(pks) == 1
        if gaussian == 0
            % middlepoint = xData(floor(length(xData)/2));
            expectedwidth = 0.120;
            % Set up fittype and options.
            ft = fittype( 'a/(((x-b)/(0.5*c))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks(1) xData(3) expectedwidth/4 0];
            opts.Robust = 'LAR';
            opts.StartPoint = [pks(1) locs(1) expectedwidth 0.02*maxval];
            opts.Upper = [(1+peakfitamplitudevariance)*pks(1) xData(end-3) expectedwidth*4 0.2*pks(1)];

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);

            % Save distances between the peaks, or refit with a single Gaussian
            if gof.rsquare > singleTol
                % Width of mitochondria fitting.
                wid1 = coeffvals(3);
                % Center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization. 
                center1 = coeffvals(2);
                nofittedp = 1;
            end
        elseif gaussian == 1
            expectedwidth = 0.160;
            % Set up fittype and options.
            ft = fittype( 'a*exp(-((x-b)/(sqrt(2)*c))^2)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks(1) xData(3) expectedwidth/(2*sqrt(2*log(2)))/4 0];
            opts.Robust = 'LAR';
            opts.StartPoint = [pks(1) locs(1) expectedwidth/(2*sqrt(2*log(2))) 0.02*pks(1)];
            opts.Upper = [(1+peakfitamplitudevariance)*pks(1) xData(end-3) expectedwidth/(2*sqrt(2*log(2)))*4 0.2*pks(1)];
            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);

            % Save distances between the peaks, or refit with a single Gaussian
            if gof.rsquare > singleTol
                % Save the FWHM of the single Gaussian instead
                wid1 = 2*sqrt(2*log(2))*coeffvals(3);
                %Width of mitochondria fitting.
                center1 = coeffvals(2);
                %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization.
                nofittedp = 1;
            end           
        end
    elseif length(pks) == 2
        if gaussian == 0
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

            if gof.rsquare > doubleTol % && abs(coeffvals(3)-coeffvals(4)) < 0.500
                % Save the FWHM of the double Lorentzian.
                %Width of mitochondria fitting.
                wid1 = abs(coeffvals(3)-coeffvals(4));
                %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization.
                center1 = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                nofittedp = 2;
            elseif gof.rsquare > doubleTol2
                wid1 = abs(locs(1)-locs(2));
                center1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
                nofittedp = 2;
            end
        elseif gaussian == 1
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

            % Save distances between the peaks, or refit with a single Gaussian
            if gof.rsquare > singleTol
                % Save the FWHM of the single Gaussian instead
                wid1 = abs(coeffvals(3)-coeffvals(4));
                %Width of mitochondria fitting.
                center1 = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                %center of the actual mitochondria intensity, showing where the mitochondria is compared to the centroid from the binarization.
                nofittedp = 2;
            elseif gof.rsquare > doubleTol2
                wid1 = abs(locs(1)-locs(2));
                center1 = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
                nofittedp = 2;
            end
        end
    end
end
