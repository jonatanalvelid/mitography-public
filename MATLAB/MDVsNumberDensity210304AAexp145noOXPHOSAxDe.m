clear all

save = 1;  % 1 == save, 0 == do not save

dirread = strcat('E:\PhD\data_analysis\antimycin\all_oxphos_numberdensity-axde-1oxppex','\');
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

%{
%%%%%%

%%% AXONS %%%

%%% All MDVs - AXONS
% Box plots with jittered scatter of MDV number densities for all MDVs
fields1 = fields(contains(fields,'aa') & contains(fields,'ax'));  % all fields for aa
fields2 = fields(contains(fields,'ct') & contains(fields,'ax'));  % all fields for ct

% MDV number densities for all MDVs - all exp
testname = 'All MDVs - all exp - ax';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-ax-all.tif')
end

% MDV number densities for all MDVs - exp 1
testname = 'All MDVs - exp 1 - ax';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-ax-all.tif')
end

% MDV number densities for all MDVs - exp 5
testname = 'All MDVs - exp 5 - ax';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-ax-all.tif')
end


%%% Tiny + big MDVs - AXONS
% Box plots with jittered scatter of MDV number densities for tiny+big ves
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'ax'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'ax'));  % all fields for t_p, b_p and ct

% MDV number densities for tiny+big ves - all exp
testname = 'All vesicles - all exp - ax';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-ax-allves.tif')
end

% MDV number densities for tiny+big ves - exp 1
testname = 'All vesicles - exp 1 - ax';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-ax-allves.tif')
end

% MDV number densities for tiny+big ves - exp 5
testname = 'All vesicles - exp 5 - ax';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-ax-allves.tif')
end



%%% Sticks - AXONS
% Box plots with jittered scatter of MDV number densities for sticks
fields1 = fields(contains(fields,'s_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'s_n') & contains(fields,'aa')& contains(fields,'ax'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'s_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'s_n') & contains(fields,'ct')& contains(fields,'ax'));  % all fields for t_p, b_p and ct

% MDV number densities for sticks - all exp
testname = 'All sticks - all exp - ax';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-ax-sticks.tif')
end

% MDV number densities for sticks - exp 1
testname = 'All sticks - exp 1 - ax';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-ax-sticks.tif')
end

% MDV number densities for sticks - exp 5
testname = 'All sticks - exp 5 - ax';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-ax-sticks.tif')
end


%%% Tiny vesicles - AXONS
% Box plots with jittered scatter of MDV number densities for tiny vesicles
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'ax'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'ax'));  % all fields for t_p, b_p and ct

% MDV number densities for tiny vesicles - all exp
testname = 'All tiny ves - all exp - ax';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-ax-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 1
testname = 'All tiny ves - exp 1 - ax';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-ax-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 5
testname = 'All tiny ves - exp 5 - ax';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-ax-tiny.tif')
end



%%% Big vesicles - AXONS
% Box plots with jittered scatter of MDV number densities for big vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'ax'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'ax'));  % all fields for t_p, b_p and ct

% MDV number densities for big vesicles - all exp
testname = 'All big ves - all exp - ax';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-ax-big.tif')
end

% MDV number densities for big vesicles - exp 1
testname = 'All big ves - exp 1 - ax';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-ax-big.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All big ves - exp 5 - ax';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-ax-big.tif')
end


%%%%%%

%%% DENDRITES %%%

%%% All MDVs - DENDRITES
% Box plots with jittered scatter of MDV number densities for all MDVs
fields1 = fields(contains(fields,'aa') & contains(fields,'de') );  % all fields for aa
fields2 = fields(contains(fields,'ct') & contains(fields,'de') );  % all fields for ct

% MDV number densities for all MDVs - all exp
testname = 'All MDVs - all exp - de';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-de-all.tif')
end

% MDV number densities for all MDVs - exp 1
testname = 'All MDVs - exp 1 - de';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-de-all.tif')
end

% MDV number densities for all MDVs - exp 5
testname = 'All MDVs - exp 5 - de';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-de-all.tif')
end


%%% Tiny + big MDVs - DENDRITES
% Box plots with jittered scatter of MDV number densities for tiny+big ves
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'de'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'de'));  % all fields for t_p, b_p and ct

% MDV number densities for tiny+big ves - all exp
testname = 'All vesicles - all exp - de';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-de-allves.tif')
end

% MDV number densities for tiny+big ves - exp 1
testname = 'All vesicles - exp 1 - de';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-de-allves.tif')
end

% MDV number densities for tiny+big ves - exp 5
testname = 'All vesicles - exp 5 - de';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-de-allves.tif')
end



%%% Sticks - DENDRITES
% Box plots with jittered scatter of MDV number densities for sticks
fields1 = fields(contains(fields,'s_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'s_n') & contains(fields,'aa') & contains(fields,'de'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'s_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'s_n') & contains(fields,'ct') & contains(fields,'de'));  % all fields for t_p, b_p and ct

% MDV number densities for sticks - all exp
testname = 'All sticks - all exp - de';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-de-sticks.tif')
end

% MDV number densities for sticks - exp 1
testname = 'All sticks - exp 1 - de';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-de-sticks.tif')
end

% MDV number densities for sticks - exp 5
testname = 'All sticks - exp 5 - de';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-de-sticks.tif')
end


%%% Tiny vesicles - DENDRITES
% Box plots with jittered scatter of MDV number densities for tiny vesicles
fields1 = fields(contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'de'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'de'));  % all fields for t_p, b_p and ct

% MDV number densities for tiny vesicles - all exp
testname = 'All tiny ves - all exp - de';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-de-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 1
testname = 'All tiny ves - exp 1 - de';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-de-tiny.tif')
end

% MDV number densities for tiny vesicles - exp 5
testname = 'All tiny ves - exp 5 - de';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-de-tiny.tif')
end



%%% Big vesicles - DENDRITES
% Box plots with jittered scatter of MDV number densities for big vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'de'));  % all fields for t_p, b_p and aa
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'de'));  % all fields for t_p, b_p and ct

% MDV number densities for big vesicles - all exp
testname = 'All big ves - all exp - de';
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-expall-de-big.tif')
end

% MDV number densities for big vesicles - exp 1
testname = 'All big ves - exp 1 - de';
plotdata1 = [];
for i=1
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
for i=1
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp1-de-big.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All big ves - exp 5 - de';
plotdata1 = [];
for i=2
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
for i=2
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
labels = {'AA','Glucose'};
numberdensity_boxplot(plotdata1, plotdata2, labels, testname)
if save
    saveas(gcf, 'mdvdensity-aavgl-exp5-de-big.tif')
end


%%%%%%
%}

%{
%%% All vesicles - DENDRITES VS AXONS - CONTROL
% Box plots with jittered scatter of MDV number densities for all vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'ax'));  % t and b in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'de'));  % t and b in ct and de

% MDV number densities for big vesicles - exp 1
testname = 'All ves - exp 1 - gl - de vs ax';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-devax-gl-exp1-allves.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All ves - exp 5 - gl - de vs ax';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-devax-gl-exp5-allves.tif')
end

% MDV number densities for tiny vesicles - all exp
testname = 'All ves - all exp - gl - de vs ax';
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
    saveas(gcf, 'mdvdensity-devax-gl-expall-allves.tif')
end
%}

%{
%%% All MDVs - DENDRITES VS AXONS - CONTROL
% Box plots with jittered scatter of MDV number densities for all vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'s_p') & contains(fields,'ct') & contains(fields,'ax') | contains(fields,'s_n') & contains(fields,'ct') & contains(fields,'ax'));  % t, b and s in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'s_p') & contains(fields,'ct') & contains(fields,'de') | contains(fields,'s_n') & contains(fields,'ct') & contains(fields,'de'));  % t, b and s in ct and ax

% MDV number densities for big vesicles - exp 1
testname = 'All MDVs - exp 1 - gl - de vs ax';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-devax-gl-exp1-allmdvs.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All MDVs - exp 5 - gl - de vs ax';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-devax-gl-exp5-allmdvs.tif')
end

% MDV number densities for tiny vesicles - all exp
testname = 'All MDVs - all exp - gl - de vs ax';
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
    saveas(gcf, 'mdvdensity-devax-gl-expall-allmdvs.tif')
end
%}

%%{
%%% All vesicles - DENDRITES VS AXONS - AA
% Box plots with jittered scatter of MDV number densities for all vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'ax'));  % t and b in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'de'));  % t and b in ct and de

% MDV number densities for big vesicles - exp 1
testname = 'All ves - exp 1 - aa - de vs ax';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-devax-aa-exp1-allves.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All ves - exp 5 - aa - de vs ax';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-devax-aa-exp5-allves.tif')
end

% MDV number densities for tiny vesicles - all exp
testname = 'All ves - all exp - aa - de vs ax';
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
    saveas(gcf, 'mdvdensity-devax-aa-expall-allves.tif')
end
%%}

%%{
%%% All MDVs - DENDRITES VS AXONS - AA
% Box plots with jittered scatter of MDV number densities for all vesicles
fields1 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'s_p') & contains(fields,'aa') & contains(fields,'ax') | contains(fields,'s_n') & contains(fields,'aa') & contains(fields,'ax'));  % t, b and s in ct and ax
fields2 = fields(contains(fields,'b_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'b_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'t_n') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'s_p') & contains(fields,'aa') & contains(fields,'de') | contains(fields,'s_n') & contains(fields,'aa') & contains(fields,'de'));  % t, b and s in ct and ax

% MDV number densities for big vesicles - exp 1
testname = 'All MDVs - exp 1 - aa - de vs ax';
plotdata1 = [];
for i=1
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
for i=1
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
    saveas(gcf, 'mdvdensity-devax-aa-exp1-allmdvs.tif')
end

% MDV number densities for big vesicles - exp 5
testname = 'All MDVs - exp 5 - aa - de vs ax';
plotdata1 = [];
for i=2
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
for i=2
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
    saveas(gcf, 'mdvdensity-devax-aa-exp5-allmdvs.tif')
end

% MDV number densities for tiny vesicles - all exp
testname = 'All MDVs - all exp - aa - de vs ax';
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
    saveas(gcf, 'mdvdensity-devax-aa-expall-allmdvs.tif')
end
%%}





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
    ylabel('Number density (/100 µm)')
    ylim([0 20])
    title(sprintf('%s \n t-test : %.2g', infoname, p))

end
