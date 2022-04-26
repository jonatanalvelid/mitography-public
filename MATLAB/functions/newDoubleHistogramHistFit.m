%%% Create a new double histogram
function [] = newDoubleHistogramHistFit(vals1,vals2,boundlow,stepwidth,boundup,xlimlow,xlimup,ylimup,xlabeltext,titletext,fontsize,legend1,legend2)
    hold on
    histfit(vals1,floor((boundup-boundlow)/stepwidth),'GeneralizedExtremeValue')
    histfit(vals2,floor((boundup-boundlow)/stepwidth),'GeneralizedExtremeValue')
    %histogram(vals1,boundlow:stepwidth:boundup,'Normalization','probability');
    %histogram(vals2,boundlow:stepwidth:boundup,'Normalization','probability');
    xlim([xlimlow xlimup])
    xlabel(xlabeltext)
    ylim([0 ylimup])
    ylabel('Norm. frequency')
    title(strcat(titletext,', N1=',num2str(length(vals1)),', N2=',num2str(length(vals2))))
    legend(legend1, legend2)
    set(gca,'FontSize',fontsize)
end