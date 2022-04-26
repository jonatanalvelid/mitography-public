%%% Actin line profile fitting - OLD VERSION
function [width,center,nop,doublepeak,singlepeak] = actinFitOld(xprof,yprof,xprofalt,yprofalt,singleTol,doubleTol,mindist)
    [xData, yData] = prepareCurveData(xprof,yprof);
    maxval = max(yData);
    [pks, locs, ~, p] = findpeaks(yData,xData,'SortStr','descend','MinPeakDistance',0.120,'MinPeakHeight',maxval/8);
    nop = length(pks);
    [width,center,doublepeak,singlepeak]=deal(0);
    if length(pks)>3
        [width,center,doublepeak,singlepeak]=deal(0);
    elseif length(pks)==1
        % Make a single Gaussian fit
        middlepoint = xData(floor(length(xData)/2));
        expectedwidth = 0.150;
        zeroPoints = (yData == 0);
        outliers = excludedata(xData,yData,'indices',zeroPoints);
        % Set up fittype and options.
        ft = fittype( 'a*exp(-((x-b)/c)^2)+d', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [0.7*maxval 0 0 0];
        opts.Robust = 'LAR';
        opts.Exclude = outliers;
        opts.StartPoint = [maxval middlepoint expectedwidth/(2*sqrt(log(2))) 0.02*maxval];
        opts.Upper = [1.25*maxval xData(end) xData(end)/(2*2*sqrt(log(2)))  0.2*maxval];

        % Fit model to data.
        [fitresult, gof] = fit( xData, yData, ft, opts );
        coeffvals = coeffvalues(fitresult);

        % Save the width of the peak
        if gof.rsquare > singleTol
            width = 2*sqrt(log(2))*coeffvals(3);
            center = coeffvals(2);
            singlepeak = 1;
        end
    elseif maxval > 0.0005*255
        middlepoint = xData(floor(length(xData)/2));
        expectedwidth = 0.400;
        zeroPoints = (yData == 0);
        outliers = excludedata(xData,yData,'indices',zeroPoints);
        % Set up fittype and options.
        ft = fittype( 'a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+d', 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.Lower = [0.2*maxval 0.2*maxval 0 0 0 0 0];
        opts.Robust = 'LAR';
        opts.Exclude = outliers;
        opts.StartPoint = [maxval maxval middlepoint-0.2 middlepoint+0.2 expectedwidth/(2*sqrt(log(2))) expectedwidth/(2*sqrt(log(2))) 0.02*maxval];
        opts.Upper = [1.25*maxval 1.25*maxval xData(end) xData(end) xData(end)/(2*2*sqrt(log(2))) xData(end)/(2*2*sqrt(log(2)))  0.2*maxval];

        % Fit model to data.
        [fitresult, gof] = fit( xData, yData, ft, opts );
        coeffvals = coeffvalues(fitresult);

        % Save distances between the peaks, or refit the alternative line
        % profiles with a double Gaussian
        if abs(coeffvals(3)-coeffvals(4)) > mindist && gof.rsquare > doubleTol
            width = abs(coeffvals(3)-coeffvals(4));
            center = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
            doublepeak = 1;
        else
            [xData, yData] = prepareCurveData(xprofalt,yprofalt);
            maxval = max(yData);
            middlepoint = xData(floor(length(xData)/2));
            expectedwidth = 0.400;  % IS THIS REALLY CORRECT???
            zeroPoints = (yData == 0);
            outliers = excludedata(xData,yData,'indices',zeroPoints);

            % Set up fittype and options.
            ft = fittype( 'a1*exp(-((x-b1)/c1)^2)+a2*exp(-((x-b2)/c2)^2)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [0.2*maxval 0.2*maxval 0 0 0.05 0.05 0];
            opts.Robust = 'LAR';
            opts.Exclude = outliers;
            opts.StartPoint = [maxval maxval middlepoint-0.2 middlepoint+0.2 expectedwidth/(2*sqrt(log(2))) expectedwidth/(2*sqrt(log(2))) 0.02*maxval];
            opts.Upper = [1.25*maxval 1.25*maxval xData(end) xData(end) xData(end)/(2*2*sqrt(log(2))) xData(end)/(4*2*sqrt(log(2)))  0.2*maxval];

            % Fit model to data.
            [fitresult, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresult);

            % Save distances between the peaks, or refit with p2p
            % distance between two highest peaks.

            if abs(coeffvals(3)-coeffvals(4)) > mindist && gof.rsquare > doubleTol
                width = abs(coeffvals(3)-coeffvals(4));
                center = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                doublepeak = 1;
            else
                if length(pks)>1
                    if p(1) > maxval/10 && p(2) > maxval/10

                        if (locs(1)==xData(1) || locs(1)==xData(end)) && (locs(2)==xData(1) || locs(2)==xData(end))
                            peakstatus = 3;
                        elseif locs(1)==xData(1) || locs(1)==xData(end)
                            peakstatus = 1;
                        elseif locs(2)==xData(1) || locs(2)==xData(end)
                            peakstatus = 2;
                        else
                            peakstatus = 0;
                        end

                        if peakstatus == 0
                            peakdist = abs(locs(1)-locs(2));
                            centroid = min(locs(1),locs(2))+abs(locs(1)-locs(2))/2;
                        elseif peakstatus == 1 && length(pks)>2
                            peakdist = abs(locs(3)-locs(2));
                            centroid = min(locs(3),locs(2))+abs(locs(3)-locs(2))/2;                               
                        elseif peakstatus == 2 && length(pks)>2
                            peakdist = abs(locs(1)-locs(3));
                            centroid = min(locs(1),locs(3))+abs(locs(1)-locs(3))/2;                         
                        elseif peakstatus == 3 && length(pks)>3
                            peakdist = abs(locs(3)-locs(4));
                            centroid = min(locs(3),locs(4))+abs(locs(3)-locs(4))/2;                               
                        else
                            peakdist = 0;
                            centroid = 0;
                        end
                        width = peakdist;
                        center = centroid;
                        doublepeak = 1;
                    end
                end
            end
        end
    end
end