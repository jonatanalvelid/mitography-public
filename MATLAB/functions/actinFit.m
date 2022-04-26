%%% Actin line profile fitting
function [width,center,nop,doublepeak,singlepeak,doublepeakdist,nofit] = actinFit(xprof,yprof,xprofalt,yprofalt,singleTol,doubleTol,actinmindist,gaussian)
    % Peak finding and fitting parameters
    peakprominence = 0.15;
    peakheight = 0.2;
    peakdistance = 0.120;
    peakfitamplitudevariance = 0.2;
    
    [xData, yData] = prepareCurveData(xprof,yprof);
    [xDataalt, yDataalt] = prepareCurveData(xprofalt,yprofalt);
    maxval = max(yprof);
    [pks, locs, ~, ~] = findpeaks(yData,xData,'MinPeakDistance',peakdistance,'SortStr','descend','MinPeakHeight',peakheight*maxval); %,'MinPeakProminence',peakprominence*maxval
    [pks2, locs2, ~, ~] = findpeaks(yData,xData,'MinPeakDistance',peakdistance,'MinPeakProminence',peakprominence*maxval,'MinPeakHeight',peakheight*maxval); %,'SortStr','descend'
    [pksalt, locsalt, ~, ~] = findpeaks(yDataalt,xDataalt,'MinPeakDistance',peakdistance,'SortStr','descend','MinPeakHeight',peakheight*maxval); %,'MinPeakProminence',peakprominence*maxval
    nop = length(pks);
    [width,center,doublepeak,singlepeak,doublepeakdist]=deal(0);
    nofit = 1;
    if gaussian == 0
        if length(pks)>3 || length(pksalt)>3
            nofit = 0;
        elseif length(pks)==1
            % Make a single Lorentzian fit
            expectedwidth = 0.150;
            % zeroPoints = (yData == 0);
            % outliers = excludedata(xData,yData,'indices',zeroPoints);
            % Set up fittype and options.
            ft = fittype( 'a/(((x-b)/(0.5*c))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks(1) xData(3) expectedwidth/3 0];
            opts.Robust = 'LAR';
            %opts.Exclude = outliers;
            opts.StartPoint = [pks(1) locs(1) expectedwidth 0];
            opts.Upper = [(1+peakfitamplitudevariance)*pks(1) xData(end-3) expectedwidth*5 0.2*maxval];

            % Fit model to data.
            [fitresultsingle, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresultsingle);

            % Save the width of the peak
            if gof.rsquare > singleTol
                width = coeffvals(3);
                center = coeffvals(2);
                singlepeak = 1;
            end
        elseif maxval > 0.01*255
            expectedwidth = 0.150;
            % zeroPoints = (yData == 0);
            % outliers = excludedata(xData,yData,'indices',zeroPoints);
            % Set up fittype and options.
            ft = fittype( 'a1/(((x-b1)/(0.5*c1))^2+1)+a2/(((x-b2)/(0.5*c2))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks2(1) (1-peakfitamplitudevariance)*pks2(end) xData(3) xData(3) expectedwidth/3 expectedwidth/3 0];
            opts.Robust = 'LAR';
            %opts.Exclude = outliers;
            opts.StartPoint = [pks2(1) pks2(end) locs2(1) locs2(end) expectedwidth expectedwidth 0];
            opts.Upper = [(1+peakfitamplitudevariance)*pks2(1) (1+peakfitamplitudevariance)*pks2(end) xData(end-3) xData(end-3) expectedwidth*5 expectedwidth*5 0.2*maxval];

            % Fit model to data.
            [fitresultdouble, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresultdouble);

            % Save distances between the peaks, or refit the alternative line
            % profiles with a double Lorentzian
            if abs(coeffvals(3)-coeffvals(4)) > actinmindist && gof.rsquare > doubleTol
                width = abs(coeffvals(3)-coeffvals(4));
                center = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                doublepeak = 1;
                %title(strcat(num2str(width),' um, doublePeak'));
            else
                [xData, yData] = prepareCurveData(xprofalt,yprofalt);
                maxval = max(yprofalt);
                % zeroPoints = (yData == 0);
                % outliers = excludedata(xData,yData,'indices',zeroPoints);
                % Set up fittype and options.
                ft = fittype( 'a1/(((x-b1)/(0.5*c1))^2+1)+a2/(((x-b2)/(0.5*c2))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
                opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
                opts.Display = 'Off';
                opts.Lower = [(1-peakfitamplitudevariance)*pksalt(1) (1-peakfitamplitudevariance)*pksalt(end) xData(3) xData(3) expectedwidth/3 expectedwidth/3 0];
                opts.Robust = 'LAR';
                %opts.Exclude = outliers;
                opts.StartPoint = [pksalt(1) pksalt(end) locsalt(1) locsalt(end) expectedwidth expectedwidth 0];
                opts.Upper = [(1+peakfitamplitudevariance)*pksalt(1) (1+peakfitamplitudevariance)*pksalt(end) xData(end-3) xData(end-3) expectedwidth*5 expectedwidth*5 0.2*maxval];

                % Fit model to data.
                [fitresultdoublealt, gof] = fit( xData, yData, ft, opts );
                coeffvals = coeffvalues(fitresultdoublealt);

                % Save distances between the peaks, or refit with p2p
                % distance between two highest peaks.

                if abs(coeffvals(3)-coeffvals(4)) > actinmindist && gof.rsquare > doubleTol
                    width = abs(coeffvals(3)-coeffvals(4));
                    center = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                    doublepeak = 1;
                else
                    if pks2(1) > maxval/5 && pks2(end) > maxval/5
                        peakdist = abs(locs2(1)-locs2(end));
                        centroid = min(locs2(1),locs2(end))+abs(locs2(1)-locs2(end))/2;
                        width = peakdist;
                        center = centroid;
                        doublepeakdist = 1;
                    end
                end
            end
        end
    elseif gaussian == 1
        if length(pks)>3 || length(pksalt)>3
            nofit = 0;
        elseif length(pks)==1
            % Make a single Gaussian fit
            expectedwidth = 0.150;
            % zeroPoints = (yData == 0);
            % outliers = excludedata(xData,yData,'indices',zeroPoints);
            % Set up fittype and options.
            ft = fittype( 'a*exp(-((x-b)/(sqrt(2)*c))^2)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks(1) xData(3) expectedwidth/(2*sqrt(2*log(2)))/3 0];
            opts.Robust = 'LAR';
            %opts.Exclude = outliers;
            opts.StartPoint = [pks(1) locs(1) expectedwidth/(2*sqrt(2*log(2))) 0.02*maxval];
            opts.Upper = [(1+peakfitamplitudevariance)*pks(1) xData(end-3) expectedwidth/(2*sqrt(2*log(2)))*5 0.2*maxval];

            % Fit model to data.
            [fitresultsingle, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresultsingle);

            % Save the width of the peak
            if gof.rsquare > singleTol
                width = 2*sqrt(2*log(2))*coeffvals(3);
                center = coeffvals(2);
                singlepeak = 1;
            end
        elseif maxval > 0.01*255
            expectedwidth = 0.150;
            % zeroPoints = (yData == 0);
            % outliers = excludedata(xData,yData,'indices',zeroPoints);
            % Set up fittype and options.
            ft = fittype( 'a1*exp(-((x-b1)/(sqrt(2)*c1))^2)+a2*exp(-((x-b2)/(sqrt(2)*c2))^2)+d', 'independent', 'x', 'dependent', 'y' );
            opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
            opts.Display = 'Off';
            opts.Lower = [(1-peakfitamplitudevariance)*pks2(1) (1-peakfitamplitudevariance)*pks2(end) xData(3) xData(3) expectedwidth/(2*sqrt(2*log(2)))/3 expectedwidth/(2*sqrt(2*log(2)))/3 0];
            opts.Robust = 'LAR';
            %opts.Exclude = outliers;
            opts.StartPoint = [pks2(1) pks2(end) locs2(1) locs2(end) expectedwidth/(2*sqrt(2*log(2))) expectedwidth/(2*sqrt(2*log(2))) 0.02*maxval];
            opts.Upper = [(1+peakfitamplitudevariance)*pks2(1) (1+peakfitamplitudevariance)*pks2(2) xData(end-3) xData(end-3) expectedwidth/(2*sqrt(2*log(2)))*5 expectedwidth/(2*sqrt(2*log(2)))*5 0.2*maxval];

            % Fit model to data.
            [fitresultdouble, gof] = fit( xData, yData, ft, opts );
            coeffvals = coeffvalues(fitresultdouble);

            % Save distances between the peaks, or refit the alternative line
            % profiles with a double Gaussian
            if abs(coeffvals(3)-coeffvals(4)) > actinmindist && gof.rsquare > doubleTol
                width = abs(coeffvals(3)-coeffvals(4));
                center = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                doublepeak = 1;
            else
                [xData, yData] = prepareCurveData(xprofalt,yprofalt);
                maxval = max(yprofalt);
                % zeroPoints = (yData == 0);
                % outliers = excludedata(xData,yData,'indices',zeroPoints);
                % Set up fittype and options.
                ft = fittype( 'a1*exp(-((x-b1)/(sqrt(2)*c1))^2)+a2*exp(-((x-b2)/(sqrt(2)*c2))^2)+d', 'independent', 'x', 'dependent', 'y' );
                opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
                opts.Display = 'Off';
                opts.Lower = [(1-peakfitamplitudevariance)*pksalt(1) (1-peakfitamplitudevariance)*pksalt(end) xData(3) xData(3) expectedwidth/(2*sqrt(2*log(2)))/3 expectedwidth/(2*sqrt(2*log(2)))/3 0];
                opts.Robust = 'LAR';
                %opts.Exclude = outliers;
                opts.StartPoint = [pksalt(1) pksalt(end) locsalt(1) locsalt(end) expectedwidth/(2*sqrt(2*log(2))) expectedwidth/(2*sqrt(2*log(2))) 0.02*maxval];
                opts.Upper = [(1+peakfitamplitudevariance)*pksalt(1) (1+peakfitamplitudevariance)*pksalt(end) xData(end-3) xData(end-3) expectedwidth/(2*sqrt(2*log(2)))*5 expectedwidth/(2*sqrt(2*log(2)))*5 0.2*maxval];

                % Fit model to data.
                [fitresultdoublealt, gof] = fit( xData, yData, ft, opts );
                coeffvals = coeffvalues(fitresultdoublealt);

                % Save distances between the peaks, or refit with p2p
                % distance between two highest peaks.

                if abs(coeffvals(3)-coeffvals(4)) > actinmindist && gof.rsquare > doubleTol
                    width = abs(coeffvals(3)-coeffvals(4));
                    center = min(coeffvals(3),coeffvals(4))+abs(coeffvals(3)-coeffvals(4))/2;
                    doublepeak = 1;
                else
                    if pks2(1) > maxval/5 && pks2(end) > maxval/5
                        peakdist = abs(locs2(1)-locs2(end));
                        centroid = min(locs2(1),locs2(end))+abs(locs2(1)-locs2(end))/2;
                        width = peakdist;
                        center = centroid;
                        doublepeakdist = 1;
                    end
                end
            end
        end
    end
end