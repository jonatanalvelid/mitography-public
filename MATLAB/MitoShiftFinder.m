function [shift,temp]=MitoShiftFinder(Signal,StepSize)
[h,w]=size(Signal);
if h > w
    Signal=Signal';
end
[r,lags]=xcorr(Signal);
high=max(r);
fo=fitoptions('Gauss3','StartPoint', [high/2, -10, 4, high, 0, 8, high/2, 10, 4],'Lower',[0 -inf 0 0 -1 0 0 0 0],'upper', [inf 0 inf inf 1 inf inf inf inf]);
[cfit,gof]=fit(lags',r','Gauss3',fo);
shift=((cfit.b3-cfit.b1)*StepSize)/2;
%temp.R=gof.rsquare;
temp=gof.rsquare;
end