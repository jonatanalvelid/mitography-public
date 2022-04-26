%%%
% Mitography - Turnover analysis - data plotting - moving average
% Plotting the data from the turnover analysis.
%----------------------------
% Version: 210225
% Last updated features: New script
%
% @jonatanalvelid
%%%

clear

% Add function folder to filepath, so that those functions can be read.
functionFolder = fileparts(which('findFunctionFolders.m'));
addpath(genpath(functionFolder));
%masterFolderPath = strcat(uigetdir('E:\PhD\data_analysis\temp_analysis_turnover\NLGC_mice_Turnover OMP25_TMR-SiR'),'\');
masterFolderPath = strcat(uigetdir('X:\Mitography\NEW\Turnover'),'\');
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
        somadisttemp = datamito(:,params-3);
        tmrsignaltemp = datamito(:,params-2);
        sirsignaltemp = datamito(:,params-1);
        %signratiotemp = sirsignaltemp./tmrsignaltemp;
        areatemp = datamito(:,4);
        circtemp = datamito(:,params);
        
        %% Add somadist = 0 if somabool = 1
        %somadisttemp(somabooltemp==1) = 0;
        
        % Remove all somadist=0 and somabool=0 mitos (i.e. outside of
        % neuron of interest)
        idxrem = (somadisttemp==0 & somabooltemp==0);
        somadisttemp(idxrem) = [];
        %signratiotemp(idxrem) = [];
        tmrsignaltemp(idxrem) = [];
        sirsignaltemp(idxrem) = [];
        areatemp(idxrem) = [];
        circtemp(idxrem) = [];
        
        % Add to list of all mitochondria in all images
        somadist = vertcat(somadist,somadisttemp);
        tmrsign = vertcat(tmrsign,tmrsignaltemp);
        sirsign = vertcat(sirsign,sirsignaltemp);
        %signratio = vertcat(signratio,signratiotemp);
        area = vertcat(area,areatemp);
        circ = vertcat(circ,circtemp);
        
    catch err
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
%areathlo = 0.2;
areathhi = 100;
circth = 0;
%}
%signratiotemp = sirsign./tmrsign;
idx_keep = area<areathhi & area>areathlo & circ>circth;
sirsign = sirsign(idx_keep);
tmrsign = tmrsign(idx_keep);
%signratiotemp = signratiotemp(idx_keep);
somadist = somadist(idx_keep);
circ = circ(idx_keep);
area = area(idx_keep);

%%% Normalize the data
%signratiotempzeromean = mean(signratiotemp(somadist==0));
%signratio = sirsign./tmrsign;
%signratio = signratio/signratiotempzeromean;
signratio = sirsign./(tmrsign+sirsign);
%%%

mitodatatemp(:,1) = somadist;
mitodatatemp(:,2) = signratio;
mitodatatemp(:,3) = area;

mitodata = vertcat(mitodata,mitodatatemp);
xdata = mitodata(:,1);
ydata = mitodata(:,2);
%ydata(ydata>10) = 10;
%ydata(ydata<0.01) = 0.01;
xdata(isnan(ydata))=[];
ydata(isnan(ydata))=[];

%%% mean ratios for different distances
maxdist = ceil(max(somadist)/10)*10;
groupsize = 30;
movavgstep = 30;
dist_x = [];
means = [];
stds = [];
bin_n = [];

dist_x = [dist_x 0];
means = [means mean(ydata(xdata==0))];
stds = [stds std(ydata(xdata==0))];
bin_n = [bin_n length(ydata(xdata==0))];
fstr = sprintf('Mean+std in group 0: %.3f + %.3f',...
    means(end),stds(end));
disp(fstr)
for n=0:movavgstep:maxdist
    dist_x = [dist_x n+movavgstep/2];
    means = [means mean(ydata(xdata<n+groupsize & xdata>n))];
    bin_n = [bin_n length(ydata(xdata<n+groupsize & xdata>n))];
    %stds = [stds std(ydata(xdata<n+groupsize & xdata>n))];
    stds = [stds std(ydata(xdata<n+groupsize & xdata>n))/sqrt(bin_n(end))];  % SEMs
    fstr = sprintf('Mean+std in group %d-%d: %.3f + %.3f',n,n+groupsize,...
        means(end),stds(end));
    disp(fstr)
end

cellnumstr = strsplit(masterFolderPath,'\');
cellnumstr = cellnumstr{7};
%writematrix([bin_n;means;stds],strcat(masterFolderPath,cellnumstr,'_bins_30um_all.csv'));
writematrix([bin_n;means;stds],strcat(masterFolderPath,cellnumstr,'_bins_30um_mdvs.csv'));

%%% PLOTTING CODE

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.3 0.3 0.3];

xlimlow1 = 0;
xlimup1 = maxdist;
ylimlow1 = 0.1;
ylimup1 = 10;

ylimlow2 = 0;
ylimup2 = 1;

fontsize = 14;
opacity = 0.5;

%ylabeltext1 = 'Ratio, 580/sum (a.u.)';
ylabeltext1 = 'Ratio, SiR/sum (a.u.)';
%ylabeltext1 = 'Signal ratio, SiR/TMR (a.u.)';
xlabeltext1 = 'Distance to soma (um)';

%ratiopermitofiglog = figure('rend','painters','pos',[100 100 800 400]);
%%figure(1)
%%hold on
%h1 = scatter(xdata,ydata);
%xlim([xlimlow1 xlimup1])
%ylim([ylimlow1 ylimup1])
%xlabel(xlabeltext1)
%ylabel(ylabeltext1)
%set(gca,'FontSize',fontsize)
%set(gca,'TickDir','out');
%xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
%xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
%set(gca, 'YScale', 'log')
%yticks([0.01 0.1 1 10 100])
%yticklabels({'0.01','0.1','1','10','100'})

ratiopermitofiglin = figure('rend','painters','pos',[100 100 800 400]);
%figure(1)
%hold on
h2 = scatter(xdata,ydata);
xlim([xlimlow1 xlimup1])
ylim([ylimlow2 ylimup2])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0 0.25 0.5 0.75 1])

groupingratiosfig = figure('rend','painters','pos',[100 100 800 400]);
h3 = errorbar(dist_x,means,stds);
xlim([xlimlow1 xlimup1])
ylim([0 1])
xlabel(xlabeltext1)
ylabel(ylabeltext1)
set(gca,'FontSize',fontsize)
set(gca,'TickDir','out');
xticks([xlimlow1:(xlimup1-xlimlow1)/12:xlimup1])
xticklabels({xlimlow1,'','',(xlimup1-xlimlow1)/4,'','',(xlimup1-xlimlow1)/2,'','',3*(xlimup1-xlimlow1)/4,'','',xlimup1})
yticks([0 0.25 0.5 0.75 1])

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