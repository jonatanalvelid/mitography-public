%%% Create a new histogram
function [] = newHistogram(vals,boundlow,stepwidth,boundup,xlimlow,xlimup,ylimup,xlabeltext,titletext,fontsize)
    hold on
    histogram(vals,boundlow:stepwidth:boundup,'Normalization','probability')
    xlim([xlimlow xlimup])
    xlabel(xlabeltext)
    ylim([0 ylimup])
    ylabel('Norm. frequency')
    title(strcat(titletext,', N=',num2str(length(vals))))
    set(gca,'FontSize',fontsize)
end