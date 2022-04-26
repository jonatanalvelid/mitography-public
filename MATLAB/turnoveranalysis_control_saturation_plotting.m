%%%
% Mitography - Turnover analysis - control, single dye - data plotting
% Plotting the data from the turnover analysis controls.
%----------------------------
% Version: 201109
% Last updated features: New script
%
% @jonatanalvelid
%%%

%clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));
masterFolderPath = strcat(uigetdir('E:\PhD\Data analysis\temp_analysis_turnover\controls\saturaturation\0.5_500\combined\analysis'),'\');
fileList = dir(fullfile(masterFolderPath, '*turnoveranalysis.txt'));
filenumbers = [];
for i = 1:length(fileList)
    filenumbers(i) = str2num(fileList(i).name(1:3));
end

mitodatatemp = [];
mitodata = [];
somadist = [];
tmrsign = [];
sirsign = [];
area = [];
circ = [];

filenameallMito = '_turnoveranalysis.txt';

%%% GATHER DATA

for fileNum = filenumbers
    filepathmito = strFilepath2(fileNum,filenameallMito,masterFolderPath);
    
    try
        % Read the mito and line profile data
        datamito = dlmread(filepathmito,'',0,0);
        [num,params] = size(datamito);
        
        % Get somadist and number of nucleotides for all mito in image
        somabooltemp = datamito(:,params-4);
        tmrsignaltemp = datamito(:,params-2);
        sirsignaltemp = datamito(:,params-1);
        %signratiotemp = sirsignaltemp./tmrsignaltemp;
        areatemp = datamito(:,4);
        circtemp = datamito(:,params);
        
        %% Add somadist = 0 if somabool = 1
        %somadisttemp(somabooltemp==1) = 0;
        
%         % Remove all somadist=0 and somabool=0 mitos
%         idxrem = (somabooltemp==0);
%         tmrsignaltemp(idxrem) = [];
%         sirsignaltemp(idxrem) = [];
%         areatemp(idxrem) = [];
%         circtemp(idxrem) = [];
        
        % Add to list of all mitochondria in all images
        tmrsign = vertcat(tmrsign,tmrsignaltemp);
        sirsign = vertcat(sirsign,sirsignaltemp);
        area = vertcat(area,areatemp);
        circ = vertcat(circ,circtemp);
        
    catch err
        fprintf(1,'what');
        %fprintf(1,'Line of error:\n%i\n',err.stack(end).line);
        %fprintf(1,'The identifier was:\n%s\n',err.identifier);
        %fprintf(1,'There was an error! The message was:\n%s\n',err.message);
    end 
end

%{
areathlo = 0.03;
areathhi = 0.2;
circth = 0.8;
%}
%%{
areathlo = 0.03;
areathhi = 100;
circth = 0;
%}
%signratiotemp = sirsign./tmrsign;
idx_keep = area<areathhi & area>areathlo & circ>circth;
sirsign = sirsign(idx_keep);
tmrsign = tmrsign(idx_keep);
circ = circ(idx_keep);
area = area(idx_keep);

%%% Normalize the data
signratio = sirsign./(tmrsign+sirsign);  % SiR second dye
%signratio = tmrsign./(tmrsign+sirsign);  % TMR second dye
%%%

mitodatatemp(:,1) = signratio;
mitodatatemp(:,2) = area;

mitodata = vertcat(mitodata,mitodatatemp);
ydata = mitodata(:,1);
xdata = rand(size(ydata))*100;
%ydata(ydata>10) = 10;
%ydata(ydata<0.01) = 0.01;
xdata(isnan(ydata))=[];
ydata(isnan(ydata))=[];

%%% mean ratios for different distances
maxdist = ceil(max(xdata)/10)*10;
groupingdist = 30;
means = [];
stds = [];
bin_n = [];

means = [means mean(ydata(xdata==0))];
stds = [stds std(ydata(xdata==0))];
bin_n = [bin_n length(ydata(xdata==0))];
fstr = sprintf('Mean+std in group 0: %.3f + %.3f',...
    means(end),stds(end));
disp(fstr)
for n=0:groupingdist:maxdist
    means = [means mean(ydata(xdata<n+groupingdist & xdata>n))];
    stds = [stds std(ydata(xdata<n+groupingdist & xdata>n))];
    bin_n = [bin_n length(ydata(xdata<n+groupingdist & xdata>n))];
    fstr = sprintf('Mean+std in group %d-%d: %.3f + %.3f',n,n+groupingdist,...
        means(end),stds(end));
    disp(fstr)
end

cellnumstr = strsplit(masterFolderPath,'\');
cellnumstr = cellnumstr{7};
writematrix([bin_n;means;stds],strcat(masterFolderPath,cellnumstr,'_bins_30um_all.csv'));
%writematrix([bin_n;means;stds],strcat(masterFolderPath,cellnumstr,'_bins_30um_mdvs.csv'));

%%% PLOTTING CODE

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

xlimlow1 = 0;
xlimup1 = maxdist;
ylimlow1 = 0.001;
ylimup1 = 0.1;

ylimlow2 = 0;
ylimup2 = 0.05;

fontsize = 14;
opacity = 0.5;

%ylabeltext1 = 'Ratio, 580/sum (a.u.)';
ylabeltext1 = 'Ratio, SiR/sum (a.u.)';
%ylabeltext1 = 'Signal ratio, SiR/TMR (a.u.)';
xlabeltext1 = 'Distance to soma (um)';

ratioallboxplot = figure('rend','painters','pos',[100 100 300 400]);
%figure(1)
hold on
s1 = scatter(ones(size(ydata)),ydata,20,'k.','jitter','on','jitterAmount',0.1); 
h1 = boxplot(ydata,'Colors','r','Symbol','');
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
%xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
%xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
%set(gca, 'YScale', 'log')
ylim([0 1])
%yticks(linspace(0,0.1,0.01))
fprintf('Mean ratio: %.3f + %.3f\n',mean(ydata),std(ydata))
omp_3 = ydata;

% ratiopermitofiglin = figure('rend','painters','pos',[100 100 800 400]);
% %figure(1)
% %hold on
% h2 = scatter(xdata,ydata);
% xlim([xlimlow1 xlimup1])
% ylim([ylimlow2 ylimup2])
% xlabel(xlabeltext1)
% ylabel(ylabeltext1)
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
% xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
% yticks([0 0.25 0.5 0.75 1])
% 
% groupingratiosfig = figure('rend','painters','pos',[100 100 800 400]);
% h3 = errorbar([0 groupingdist/2:groupingdist:maxdist+groupingdist/2],means,stds);
% xlim([xlimlow1 xlimup1])
% ylim([0 1])
% xlabel(xlabeltext1)
% ylabel(ylabeltext1)
% set(gca,'FontSize',fontsize)
% set(gca,'TickDir','out');
% xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
% xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
% yticks([0 0.25 0.5 0.75 1])

%[~,edges] = histcounts(log10(ydata));

%ratiopermitofig_histo = figure('rend','painters','pos',[100 100 800 400]);
%histogram(ydata(xdata==0),10.^edges,'Normalization','probability')
%hold on
%for n=0:groupingdist:maxdist
%    histogram(ydata(xdata>n & xdata<n+groupingdist),10.^edges,'Normalization','probability')
%end
%set(gca, 'xscale','log')
%xlim([ylimlow1 ylimup1])
%legend()