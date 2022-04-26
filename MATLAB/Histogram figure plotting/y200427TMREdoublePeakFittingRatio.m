%%% MULTIPLE HISTOGRAM PLOTTING
% Dataset: \\X:\TestaLab\Mitography\TMR-MitographyAnalysis\mitoData-RL-200403-doublepeakAR.mat

colors = lines(2);
gray = [0.6 0.6 0.6];
lightGray = [0.7 0.7 0.7];
darkGray = [0.2 0.2 0.2];

% % All mito
areathresh = 0.086;
ARthresh1 = 0.5;
% h1var = mitoWidtht(mitoTMREparam==1);  % All TMRE+ mito
mitoWidthtemp = mitoWidtht(mitoAreat<areathresh);  % All area-small AR-small mito
% h3var = mitoAreat(mitoTMREparam==1);  % All TMRE+ mito
mitoAreatemp = mitoAreat(mitoAreat<areathresh);  % All area-small AR-small mito
% h5var = mitoLengtht(mitoTMREparam==1);  % All TMRE+ mito
mitoLengthtemp = mitoLengtht(mitoAreat<areathresh);  % All area-small AR-small mito
% h5var = mitoARt(mitoTMREparam==1);  % All TMRE+ mito
mitoARtemp = mitoARt(mitoAreat<areathresh);  % All area-small AR-small mito
mitoTMREparamtemp = mitoTMREparam(mitoAreat<areathresh);  % All area-small AR-small mito
mitodpparamtemp = mitodoublepeakparamt(mitoAreat<areathresh);  % All area-small AR-small mito

mitobigtemp = mitoARt(mitoAreat>areathresh);  % All area-small AR-small mito
mitobigdpparamtemp = mitodoublepeakparamt(mitoAreat>areathresh);  % All area-small AR-small mito

% Split mitos based on double peak param
mitostickTMREpdp = mitoARtemp(mitoARtemp<ARthresh1 & mitoTMREparamtemp==1 & mitodpparamtemp==1);
mitostickTMREpndp = mitoARtemp(mitoARtemp<ARthresh1 & mitoTMREparamtemp==1 & mitodpparamtemp==0);
mitostickTMREndp = mitoARtemp(mitoARtemp<ARthresh1 & mitoTMREparamtemp==0 & mitodpparamtemp==1);
mitostickTMREnndp = mitoARtemp(mitoARtemp<ARthresh1 & mitoTMREparamtemp==0 & mitodpparamtemp==0);
mitovesdp = mitoARtemp(mitoARtemp>ARthresh1 & mitodpparamtemp==1);
mitovesndp = mitoARtemp(mitoARtemp>ARthresh1 & mitodpparamtemp==0);
mitosmalldp = mitoARtemp(mitodpparamtemp==1);
mitosmallndp = mitoARtemp(mitodpparamtemp==0);
mitobigdp = mitobigtemp(mitobigdpparamtemp==1);
mitobigndp = mitobigtemp(mitobigdpparamtemp==0);
mitoalldp = mitoARt(mitodoublepeakparamt==1);
mitoallndp = mitoARt(mitodoublepeakparamt==0);
%}

disp('All')
disp(length(mitoallndp)/length([mitoalldp', mitoallndp']))
disp('All big')
disp(length(mitobigndp)/length([mitobigdp', mitobigndp']))
disp('All small')
disp(length(mitosmallndp)/length([mitosmalldp', mitosmallndp']))
disp('Sticks, TMRE+')
disp(length(mitostickTMREpndp)/length([mitostickTMREpdp', mitostickTMREpndp']))
disp('Sticks, TMRE-')
disp(length(mitostickTMREpndp)/length([mitostickTMREndp', mitostickTMREnndp']))
disp('Vesicles')
disp(length(mitovesndp)/length([mitovesdp', mitovesndp']))
