%%%
% Boxplot number density from experiments with MDMs split up in
% tinymdv/bigmdv/stick + glucos/antimycin + axon/dendrite
%
% @jonatanalvelid
%%%

clear

% Add functions folder to filepath and get data folder path
filename = matlab.desktop.editor.getActiveFilename;
parentfolder = getfield(fliplr(regexp(fileparts(fileparts(filename)),'/','split')),{1});
doubleparentfolder = getfield(fliplr(regexp(fileparts(fileparts(fileparts(fileparts(filename)))),'/','split')),{1});
functionsfolder = fullfile(parentfolder{1},'functions');
addpath(functionsfolder);
datafolder = fullfile(doubleparentfolder{1},'example-data');

%%%
% Parameters
% deconvolution
save = 0;  % boolean for saving figs or not
% data folder
dirread = fullfile(datafolder,'numberdensity','oxphos-axde\');
%%%

datalist = dir(fullfile(dirread,'*.mat'));

for i=1:numel(datalist)
    filename = datalist(i).name;

    disp(' ')
    disp(filename)
    
    data = load(strcat(datalist(i).folder,'\',filename)).data_exp;
    data_allexp(i) = data;
end
% get all fieldnames of the datastruct
fields = fieldnames(data_allexp);


%%% All MDVs - DENDRITES VS AXONS - CONTROL
% Box plots with jittered scatter of number densities for all MDVs
fields1 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'ax'));  % t and b in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'de'));  % t and b in ct and de

% Number densities for all MDVs - all exp
testname = 'All MDVs - gl - de vs ax';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'Axons','Dendrites'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-devax-gl-allmdvs.tif')
end

%%% All MDMs - DENDRITES VS AXONS - CONTROL
% Box plots with jittered scatter of MDV number densities for all vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'s_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'s_n') & contains(fields,'ct') & contains(fields,'ax'));  % t, b and s in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'s_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'s_n') & contains(fields,'ct') & contains(fields,'de'));  % t, b and s in ct and ax

% Number densities for all MDMs
testname = 'All MDMs - all exp - gl - de vs ax';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'Axons','Dendrites'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-devax-gl-allmdms.tif')
end



%%% All vesicles - DENDRITES VS AXONS - AA
% Box plots with jittered scatter of number densities for all MDVs
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'ax'));  % t and b in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'de'));  % t and b in ct and de

% Number densities for all MDVs
testname = 'All MDVs - aa - de vs ax';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'Axons','Dendrites'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-devax-aa-allmdvs.tif')
end

%%% All MDVs - DENDRITES VS AXONS - AA
% Box plots with jittered scatter of number densities for all MDMs
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'s_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'s_n') & contains(fields,'aa') & contains(fields,'ax'));  % t, b and s in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'s_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'s_n') & contains(fields,'aa') & contains(fields,'de'));  % t, b and s in ct and ax

% Number densities for all MDMs
testname = 'All MDMs - aa - de vs ax';
plotdata1 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields1)
        tempdata = data_allexp(i).(fields1{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                %disp(expdata)
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata1 = cat(1,plotdata1,expdata);
end
plotdata2 = [];
for i=1:length(data_allexp)
    expdata = [];
    for idx = 1:length(fields2)
        tempdata = data_allexp(i).(fields2{idx});
        if ~isempty(tempdata)
            if i == 1
                tempdata(isnan(tempdata)) = 0;
            end
            %disp(tempdata)
            if idx == 1
                expdata = tempdata;
            else
                expdata = expdata + tempdata;
            end
        end
    end
    plotdata2 = cat(1,plotdata2,expdata);
end
labels = {'Axons','Dendrites'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-devax-aa-allmdms.tif')
end



function [] = numberdensity_boxplot(data1, data2, labels, infoname)
    grouping = [ones(size(data1));2*ones(size(data2))];
    
    disp(' ')
    [~,p] = ttest2(data1,data2);
    disp(infoname)
    fprintf('T-test : %f \n', p)
    
    figure('Position', [600 200 200 300])
    hold on
    allplotdata = [data1;data2];
    s1 = scatter(1*ones(size(data1)),data1,40,'rx','jitter','on','jitterAmount',0.09);
    s2 = scatter(2*ones(size(data2)),data2,40,'kx','jitter','on','jitterAmount',0.09);
    boxplot(allplotdata,grouping,'Labels',labels,'Symbol','')
    ylabel('Number density (/100 ??m)')
    ylim([0 20])
    title(sprintf('%s \n t-test : %.2g', infoname, p))

end
