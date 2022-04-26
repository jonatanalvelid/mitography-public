%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: \\X:\TestaLab\Mitography\TMR-MitographyAnalysis\mitoData-RL-200403-doublepeakAR.mat

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

% % All mito
areathresh = 0.086;
areathresh2 = 1.5;
ARthresh1 = 0.5;
% h1var = mitoWidtht(mitoTMREparam==1);  % All TMRE+ mito
mitoWidthtemp = mitoWidthm(mitoAream<areathresh);  % All area-small AR-small mito
% h3var = mitoAreat(mitoTMREparam==1);  % All TMRE+ mito
mitoAreatemp = mitoAream(mitoAream<areathresh);  % All area-small AR-small mito
% h5var = mitoLengtht(mitoTMREparam==1);  % All TMRE+ mito
mitoLengthtemp = mitoLengthm(mitoAream<areathresh);  % All area-small AR-small mito
% h5var = mitoARt(mitoTMREparam==1);  % All TMRE+ mito
mitoARtemp = mitoARm(mitoAream<areathresh);  % All area-small AR-small mito
mitoTMREparamtemp = mitoMitoSOXparam(mitoAream<areathresh);  % All area-small AR-small mito
mitodpparamtemp = mitodoublepeakparam(mitoAream<areathresh);  % All area-small AR-small mito

mitobigtemp = mitoARm(mitoAream>areathresh);  % All area-small AR-small mito
mitobigdpparamtemp = mitodoublepeakparam(mitoAream>areathresh);  % All area-small AR-small mito

% Split mitos based on double peak param
mitostickdp = mitoARtemp(mitoARtemp<ARthresh1 & mitodpparamtemp==1);
mitostickndp = mitoARtemp(mitoARtemp<ARthresh1 & mitodpparamtemp==0);
mitovesdp = mitoARtemp(mitoARtemp>ARthresh1 & mitodpparamtemp==1);
mitovesndp = mitoARtemp(mitoARtemp>ARthresh1 & mitodpparamtemp==0);
mitosmalldp = mitoARtemp(mitodpparamtemp==1);
mitosmallndp = mitoARtemp(mitodpparamtemp==0);
mitobigdp = mitobigtemp(mitobigdpparamtemp==1);
mitobigndp = mitobigtemp(mitobigdpparamtemp==0);
mitoalldp = mitoARm(mitodoublepeakparam==1);
mitoallndp = mitoARm(mitodoublepeakparam==0);
%}

disp('All')
disp(length(mitoallndp)/length([mitoalldp', mitoallndp']))
disp('All big')
disp(length(mitobigndp)/length([mitobigdp', mitobigndp']))
disp('All small')
disp(length(mitosmallndp)/length([mitosmalldp', mitosmallndp']))
disp('Sticks')
disp(length(mitostickndp)/length([mitostickdp', mitostickndp']))
disp('Vesicles')
disp(length(mitovesndp)/length([mitovesdp', mitovesndp']))
