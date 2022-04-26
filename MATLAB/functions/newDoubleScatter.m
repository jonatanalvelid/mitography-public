%%% Create a new double scatter plot
function [] = newDoubleScatter(xval1,xval2,yval1,yval2,xlimlow,xlimup,ylimlow,ylimup,xlabeltext,ylabeltext,titletext,fontsize,legend1,legend2)
    scatter(xval1,yval1);
    hold on
    scatter(xval2,yval2);
    xlim([xlimlow xlimup])
    xlabel(xlabeltext)
    ylim([ylimlow ylimup])
    ylabel(ylabeltext)
    title(strcat(titletext,', N1=',num2str(length(xval1)),', N2=',num2str(length(xval2))))
    legend(legend1,legend2)
    set(gca,'FontSize',fontsize)
end