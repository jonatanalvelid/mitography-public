%%%%%
% MitoSOX vs mito size (MDVs)
% -------------------------------------------------------
% Boxplot and scatter mitoSOX intensity vs <250/>250 nm mitochondria. 
% @Jonatan Alvelid
% Created: 2019-11-01
% Modified: 2022-04-26
%%%%%
addpath('C:\Users\jonatan.alvelid\Documents\GitHub\Mitography\MATLAB\functions');
datafolderpath = 'T:\RedSTED\Data\Imspector\Giovanna\20190930_live_mitoSOX\';
meanmitosoxsmall = zeros(4,1);
meanmitosoxbig = zeros(4,1);
for i=1:4
    filenamecell = sprintf('Cell%d.dat',i);
    filepathcell = strcat(datafolderpath,filenamecell);
    replaceComma(filepathcell)
    datacell = importdata(filepathcell,'\t');
    
    % Create separate vectors with <250 and >250 nm long axis meanMitoSOX
    % values
    mitosoxSmall = datacell.data((datacell.data(:,4) <= 0.250),6);
    meanmitosoxsmall(i) = mean(mitosoxSmall);
    mitosoxBig = datacell.data((datacell.data(:,4) >= 0.250),6);
    meanmitosoxbig(i) = mean(mitosoxBig);
    
    mitosox = [mitosoxSmall; mitosoxBig];
    
    % Create a grouping variable that assigns the same value to rows that
    % correspond to the same vector in x.
    g1 = repmat({'<250 nm'},length(mitosoxSmall),1);
    g2 = repmat({'>250 nm'},length(mitosoxBig),1);
    g = [g1; g2];
    
    % Create the box plots and scatter points on top
    figure('rend','painters','pos',[500 100 350 600]);
    boxplot(mitosox,g,'OutlierSize',0.01)
    ylim([0,100])
    hold on
    h1 = scatter(ones(size(mitosoxSmall)).*(1+(rand(size(mitosoxSmall))-0.5)/10),mitosoxSmall,25,'b','filled');
    h2 = scatter(ones(size(mitosoxBig)).*(2+(rand(size(mitosoxBig))-0.5)/10),mitosoxBig,25,'r','filled');
    h1.MarkerFaceAlpha = 0.4;
    h2.MarkerFaceAlpha = 0.4;
    ylabel('Mean mitoSOX [avg cnts]')
    set(gca,'FontSize',18)
    
    % Print mean mitoSOX values
    disp(filenamecell)
    disp('Mean mitoSOX, <250 nm')
    disp(meanmitosoxsmall(i))
    disp('Mean mitoSOX, >250 nm')
    disp(meanmitosoxbig(i))
    disp('')
    disp('')
end

figure(5)
plot((1:4),meanmitosoxsmall,'b')
hold on
plot((1:4),meanmitosoxbig,'r')
legend('Mean mitoSOX, <250 nm','Mean mitoSOX, >250 nm','Location','northwest')
ylabel('Mean mitoSOX [arb.u.]')
xlabel('Cell number')
xticks([1:4])
ylim([0,30])
set(gca,'FontSize',18)
