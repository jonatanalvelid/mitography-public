%%% Create a new double histogram
function [] = newDoubleHistFit(vals1,vals2,boundlow,stepwidth,boundup)
    hold on
    pdWidthP = fitdist(vals1,'GeneralizedExtremeValue');
    pdWidthNP = fitdist(vals2,'GeneralizedExtremeValue');
    x_values = boundlow:stepwidth/10:boundup;
    yWidthP = pdf(pdWidthP,x_values);
    yWidthNP = pdf(pdWidthNP,x_values);
    plot(x_values,yWidthP)
    plot(x_values,yWidthNP)
end