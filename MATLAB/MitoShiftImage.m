function [SeriesShift,temp]=MitoShiftImage(Avger,scale,smoothYN,fittingYN)
% Normal run of the script; use the following input parameters:
% (USED FOR 180504 IMAGES, ~PROBABLY~ ALSO FOR THE FIRST BATCH IMAGES):
% Avger - 1 (otherwise get much shorter frame time) (SHOULD CHANGE THIS SO
% THAT IT DOES A ROLLING FRAME AVERAGE INSTEAD MAYBE?
% Scale - (Pixel size, normally 30 nm)
% SmoothYN - 0 (not really needed when fitting is done anyway)
% FittingYN - 1 (because fitting is more robust for my data)

% Read the whole time series stack, store in a big matrix
fname = 'FixedSample1-mito-001.tif';
% fname1 = 'Sample3-004-raw.tif';
info = imfinfo(fname);
num_images = numel(info);
imsize = [info(1).Height info(2).Width floor(num_images/2)];
imMatrix = zeros(imsize(1),imsize(2),imsize(3));
%imLines = zeros(imsize(3),imsize(2));
imLines = zeros(imsize(3),imsize(2));
xline = 1:imsize(2);
for i = 1:imsize(3)
    imMatrix(:,:,i) = imread(fname, i);
end

for i = 1:imsize(3)
    %wideLine = imMatrix(:,round(imsize(2)/2)-2:round(imsize(2)/2)+2,i);
    imLines(i,:) = mean(imMatrix(round(imsize(1)/2)-2:round(imsize(1)/2)+2,:,i),1); %Take the 5 middle lines
end
[h,~]=size(imLines);
n=floor(h/Avger);
SeriesShift=zeros(n,1);
SeriesCenter=zeros(n,1);
temp=zeros(n,1);
figure(2);
subplot(2,3,[1,4]);
imagesc(imLines);
subplot(2,3,[2,3]);
%plot(mean(imLines(1:Avger,:)));
hold on
for k=0:1:n-1
    H_line=mean(imLines(1+k*Avger:(k+1)*Avger,:),1);
    if smoothYN
        H_line=smooth(H_line,3);
    end
    H_line_norm = H_line./max(H_line);
    if fittingYN
        plot(H_line_norm);
        [SeriesShift(k+1),SeriesCenter(k+1),temp(k+1)]=MitoFit(xline,H_line);
    else
        plot(H_line_norm);
        [SeriesShift(k+1),temp(k+1)]=MitoShiftFinder(H_line,scale);
    end
end
ylabel('Norm. intensity [arb. u.]');
xlabel('Pixel position');
SeriesShift = SeriesShift.*scale;
SeriesCenter = SeriesCenter.*scale;
rollingAvgSize = 10;
SeriesShiftRunningAverage = zeros(n,1);
SeriesCenterRunningAverage = zeros(n,1);
for i = 1:n
    if i < rollingAvgSize
        SeriesShiftRunningAverage(i) = mean(SeriesShift(1:i+(rollingAvgSize-1)));
        SeriesCenterRunningAverage(i) = mean(SeriesCenter(1:i+(rollingAvgSize-1)));
    elseif i > n-(rollingAvgSize-1)
        SeriesShiftRunningAverage(i) = mean(SeriesShift(i-(rollingAvgSize-1):end));
        SeriesCenterRunningAverage(i) = mean(SeriesCenter(i-(rollingAvgSize-1):end));
    else
        SeriesShiftRunningAverage(i) = mean(SeriesShift(i-(rollingAvgSize-1):i+(rollingAvgSize-1)));
        SeriesCenterRunningAverage(i) = mean(SeriesCenter(i-(rollingAvgSize-1):i+(rollingAvgSize-1)));
    end
end
SeriesCenter = SeriesCenter-SeriesCenterRunningAverage(1);
SeriesCenterRunningAverage = SeriesCenterRunningAverage-SeriesCenterRunningAverage(1);

subplot(2,3,5);
plot(SeriesShift);
hold on
plot(SeriesShiftRunningAverage);
ylabel('Width [nm]');
xlabel('Frame #');

subplot(2,3,6);
plot(SeriesCenter);
hold on
plot(SeriesCenterRunningAverage);
ylabel('Center position [nm]');
xlabel('Frame #');

set(gcf, 'Position', get(0, 'Screensize'));
end

% Mito double Lorentzian fitting
function [width,center,temp] = MitoFit(xprof,yprof)
    peakfitamplitudevariance = 0.2;
    [xData,yData] = prepareCurveData(xprof,yprof);
    maxval = max(yData);
    [pks,locs,~,~] = findpeaks(yData,xData,'MinPeakDistance',0.050,'MinPeakHeight',maxval/3,'SortStr','descend');
    %expectedwidth = 0.100;
    expectedwidth = 4;
    
    % Set up fittype and options.
    ft = fittype( 'a1/(((x-b1)/(0.5*c1))^2+1)+a2/(((x-b2)/(0.5*c2))^2+1)+d', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Robust = 'LAR';
    if size(pks) == 1
        opts.Lower = [(1-peakfitamplitudevariance)*pks(1) (1-peakfitamplitudevariance)*pks(1) xData(3) xData(3) expectedwidth/4 expectedwidth/4 0];
        opts.StartPoint = [pks(1) pks(1) locs(1) locs(1) expectedwidth expectedwidth 0];
        opts.Upper = [(1+peakfitamplitudevariance)*pks(1) (1+peakfitamplitudevariance)*pks(1) xData(end-3) xData(end-3) expectedwidth*4 expectedwidth*4 0.2*pks(1)];
    else
        opts.Lower = [(1-peakfitamplitudevariance)*pks(1) (1-peakfitamplitudevariance)*pks(2) xData(3) xData(3) expectedwidth/4 expectedwidth/4 0];
        opts.StartPoint = [pks(1) pks(2) locs(1) locs(2) expectedwidth expectedwidth 0];
        opts.Upper = [(1+peakfitamplitudevariance)*pks(1) (1+peakfitamplitudevariance)*pks(2) xData(end-3) xData(end-3) expectedwidth*4 expectedwidth*4 0.2*pks(1)];
    end

    % Fit model to data and get the width and r-square value.
    [fitresult,gof] = fit( xData, yData, ft, opts );
    coeffvals = coeffvalues(fitresult);
    temp = gof.rsquare;
    width = abs(coeffvals(3)-coeffvals(4));
    center = min(coeffvals(3),coeffvals(4))+width/2;
end
