%%% Create a new scatter plot
function [] = newScatter(xval,yval,xlimlow,xlimup,ylimlow,ylimup,xlabeltext,ylabeltext,titletext,fontsize)
    hold on
    scatter(xval,yval)
    xlim([xlimlow xlimup])
    xlabel(xlabeltext)
    ylim([ylimlow ylimup])
    ylabel(ylabeltext)
    title(strcat(titletext,', N=',num2str(length(xval))))
    set(gca,'FontSize',fontsize)
end