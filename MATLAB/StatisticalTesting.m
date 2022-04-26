%%%
% Mitography - Datasets - Statistical testing
% Test different statistical tests to compare the distributions from
% different datasets and dataset splits.
%----------------------------
% Version: 200402
% Last version: New script. 
%
% @jonatanalvelid
%%%

% Statistical tests to try:
% kstest2, kruskalwallis, 
% ranksum test (Mann-Whitney U test) only tests for if the distributions
% have the same median or not, not if the distributions are different
% otherwise/the shape of the distribution. Hence do not use in this case. 

testnames = {'kstest2','kruskalwallis'};

testresults = struct();
testresults.TMREmitoSOX = [];

% prep variables
mitoARm = mitoWidthm./mitoLengthm;
mitoARt = mitoWidtht./mitoLengtht;
% get all testresults
testresults.TMREmitoSOX.area = alltests(mitoAream,mitoAreat,testnames);
testresults.TMREmitoSOX.width = alltests(mitoWidthm,mitoWidtht,testnames);
testresults.TMREmitoSOX.length = alltests(mitoLengthm,mitoLengtht,testnames);
testresults.TMREmitoSOX.aspectratio = alltests(mitoARm,mitoARt,testnames);
% display results
disp('TMRE v MitoSOX - Area')
disp(testresults.TMREmitoSOX.area)
disp('TMRE v MitoSOX - Width')
disp(testresults.TMREmitoSOX.width)
disp('TMRE v MitoSOX - Length')
disp(testresults.TMREmitoSOX.length)
disp('TMRE v MitoSOX - Aspect ratio')
disp(testresults.TMREmitoSOX.aspectratio)


function restable = alltests(pop1,pop2,testnames)
    % ks test
    if any(strcmp('kstest2',testnames))
        disp('kstest2')
        [~,pks,ks2stat] = kstest2(pop1,pop2);
    end
    % kw test
    if any(strcmp('kruskalwallis',testnames))
        disp('kruskalwallis')
        kwdata = [pop1;pop2];
        kwlabels = [ones(length(pop1),1);zeros(length(pop2),1)];
        pkw = kruskalwallis(kwdata,kwlabels,'off');
    end
    % summarize results in table
    restable = table([pks,ks2stat],pkw,'VariableNames',testnames);
end
