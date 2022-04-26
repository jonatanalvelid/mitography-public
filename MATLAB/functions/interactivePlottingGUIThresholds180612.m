function interactivePlottingGUIThresholds180612(fontSizeGlobal, filamentWidthSNZ, mitoDisplacementEdgeS, mitoActinDistS, mitoActinDistD2S, filamentWidthNSNZ, mitoDisplacementEdgeNS,...
    mitoActinDistNS, mitoActinDistD2NS, mitoWidthS, mitoAreaS, mitoLengthS, nonzeroS, mitoWidthNS, mitoAreaNS, mitoLengthNS, nonzeroNS, mitoNonStripesDistS,...
    mitoNonStripesDistNS, mitoThreePeaksNonStripesDist, mitoWidthRatioUMS, mitoWidthRatioBMS, mitoWidthRatioUBS, mitoWidthRatioUMNS,...
    mitoWidthRatioBMNS, mitoWidthRatioUBNS, mitoPatchOverlapS, mitoPatchOverlapNS, filamentWidthPNZ, mitoDisplacementEdgeP, mitoActinDistP, mitoActinDistD2P,...
    filamentWidthNPNZ, mitoDisplacementEdgeNP, mitoActinDistNP, mitoActinDistD2NP, mitoWidthP, mitoAreaP, mitoLengthP, nonzeroP, mitoWidthNP, mitoAreaNP, mitoLengthNP,...
    nonzeroNP, mitoPatchOverlapP, mitoPatchOverlapNP, mitoNonStripesDistP, mitoNonStripesDistNP, paramName)
% Create two figures
h.f = figure('units','pixels','position',[2300 430 200 800],...
             'toolbar','none','menu','none');
h.fplot = figure('units','pixels','position',[20 100 2200 1100],...
             'toolbar','figure','menu','figure');
         
figure(h.f)
% Create pushbuttons   
h.p1 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,410,170,20],'string','Actin',...
                'callback',@p1_call); 
h.p2 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,360,170,20],'string','Primary morphology vs actin',...
                'callback',@p2_call); 
h.p3 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,310,170,20],'string','Primary morphology, SNS',...
                'callback',@p3_call); 
h.p4 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,260,170,20],'string','Mito lenght vs width',...
                'callback',@p4_call);
h.p5 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,210,170,20],'string','Patch distance',...
                'callback',@p5_call);
h.p6 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,160,170,20],'string','Primary morphology, all',...
                'callback',@p6_call);
h.p7 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,110,170,20],'string','Width ratios, SNS',...
                'callback',@p7_call);
h.p8 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,60,170,20],'string','Width ratios, all',...
                'callback',@p8_call);
h.p9 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,10,170,20],'string','Patch overlap',...
                'callback',@p9_call);
            
h.p10 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,460,170,20],'string','Update thresholds',...
                'callback',@p10_call);
h.p11 = uicontrol('style','pushbutton','units','pixels',...
                'position',[15,510,170,20],'string','Save figures',...
                'callback',@p11_call);
            
% Create parameter text boxes
txt1 = uicontrol('style','text','units','pixels',...
                'position',[15,720,170,20],'string','Double fit threshold (0-1)');
h.e(1) = uicontrol('style','edit','units','pixels',...
                'position',[15,700,170,20],'string','0.92');
txt2 = uicontrol('style','text','units','pixels',...
                'position',[15,650,170,20],'string','Double fit second threshold (0-1)');
h.e(2) = uicontrol('style','edit','units','pixels',...
                'position',[15,630,170,20],'string','0.7');
txt3 = uicontrol('style','text','units','pixels',...
                'position',[15,580,170,20],'string','Single fit threshold (0-1)');
h.e(3) = uicontrol('style','edit','units','pixels',...
                'position',[15,560,170,20],'string','0.98');

% Create parameter plot checkboxes
h.c = uicontrol('style','checkbox','units','pixels',...
                'position',[15,770,170,20],'string','Extra parameter plot');
            
% % Explanatory text
% txt8 = uicontrol('style','text','units','pixels',...
%                 'position',[10,250,200,100],'string','13 - Stripes, 14 - AIS, 15 - Small width, 16 - Mito>actin, 20 - Small area');              
%             

    % Pushbutton callback
    
    % Update thresholds when pressing update button
    function p10_call(varargin)
        clf(h.fplot)
        thresholds = get(h.e,'String');
        thresholdsNumber = str2double(thresholds(1:3));
        doubleThreshold = thresholdsNumber(1);
        doubleSecondThreshold = thresholdsNumber(2);
        singleThreshold = thresholdsNumber(3);
        [filamentWidthSNZ, mitoDisplacementEdgeS, mitoActinDistS, mitoActinDistD2S, filamentWidthNSNZ, mitoDisplacementEdgeNS,...
            mitoActinDistNS, mitoActinDistD2NS, mitoWidthS, mitoAreaS, mitoLengthS, nonzeroS, mitoWidthNS, mitoAreaNS, mitoLengthNS, nonzeroNS, mitoNonStripesDistS,...
            mitoNonStripesDistNS, mitoThreePeaksNonStripesDist, mitoWidthRatioUMS, mitoWidthRatioBMS, mitoWidthRatioUBS, mitoWidthRatioUMNS,...
            mitoWidthRatioBMNS, mitoWidthRatioUBNS, mitoPatchOverlapS, mitoPatchOverlapNS, filamentWidthPNZ, mitoDisplacementEdgeP, mitoActinDistP, mitoActinDistD2P,...
            filamentWidthNPNZ, mitoDisplacementEdgeNP, mitoActinDistNP, mitoActinDistD2NP, mitoWidthP, mitoAreaP, mitoLengthP, nonzeroP, mitoWidthNP, mitoAreaNP, mitoLengthNP,...
            nonzeroNP, mitoPatchOverlapP, mitoPatchOverlapNP, mitoNonStripesDistP, mitoNonStripesDistNP, paramName] = updateData180612(doubleThreshold, doubleSecondThreshold, singleThreshold);
    end

    % Save all the figures
    function p11_call(varargin)
        
    end
    
    % Functions showing the plot you want whenever a button is pressed
    function p1_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
            %%%Mito displacement and filament width histogram
            subplot(1,4,1)
            newDoubleHistogram(filamentWidthPNZ,filamentWidthNPNZ,0,0.07,1.4,0,1.5,0.4,'Local filament width [µm]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            legend(paramName,strcat('Non-',paramName));
            
            subplot(1,4,2)
            newDoubleHistogram(mitoDisplacementEdgeP,mitoDisplacementEdgeNP,-0.8,0.08,0.8,-0.8,0.8,0.4,'Old mito-actin distance [µm]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            legend(paramName,strcat('Non-',paramName));
            
            subplot(1,4,3)
            newDoubleHistogram(mitoActinDistP,mitoActinDistNP,-1,0.08,0.7,-1,0.7,0.4,'Mito-actin distance D [µm]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            legend(paramName,strcat('Non-',paramName));
            
            subplot(1,4,4)
            newDoubleHistogram(mitoActinDistD2P,mitoActinDistD2NP,0,0.04,1,0,1,0.4,'Mito-actin distance D2 [µm]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            legend(paramName,strcat('Non-',paramName));
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito displacement and filament width histogram
            subplot(1,4,1)
            newDoubleHistogram(filamentWidthSNZ,filamentWidthNSNZ,0,0.07,1.4,0,1.5,0.4,'Local filament width [µm]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            legend('MPS','Non-MPS');
            
            subplot(1,4,2)
            newDoubleHistogram(mitoDisplacementEdgeS,mitoDisplacementEdgeNS,-0.8,0.08,0.8,-0.8,0.8,0.4,'Old mito-actin distance [µm]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            legend('MPS','Non-MPS');
            
            subplot(1,4,3)
            newDoubleHistogram(mitoActinDistS,mitoActinDistNS,-1,0.08,0.7,-1,0.7,0.4,'Mito-actin distance D [µm]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            legend('MPS','Non-MPS');
            
            subplot(1,4,4)
            newDoubleHistogram(mitoActinDistD2S,mitoActinDistD2NS,0,0.04,1,0,1,0.4,'Mito-actin distance D2 [µm]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            legend('MPS','Non-MPS');
        end
    end

    function p2_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito width, length and area vs filament width plotting
            subplot(2,3,1)
            newScatter(filamentWidthPNZ,mitoWidthP(nonzeroP),0,1.5,0,0.5,'Local filament width [µm]','Mitochondria width [µm]',paramName,fontSizeGlobal);
            newScatter(filamentWidthNPNZ,mitoWidthNP(nonzeroNP),0,1.5,0,0.5,'Local filament width [µm]','Mitochondria width [µm]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(2,3,2)
            newScatter(filamentWidthPNZ,mitoAreaP(nonzeroP),0,1.5,0,1,'Local filament width [µm]','Mitochondria area [µm^2]',paramName,fontSizeGlobal);
            newScatter(filamentWidthNPNZ,mitoAreaNP(nonzeroNP),0,1.5,0,1,'Local filament width [µm]','Mitochondria area [µm^2]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(2,3,3)
            newScatter(filamentWidthPNZ,mitoLengthP(nonzeroP),0,1.5,0,5,'Local filament width [µm]','Mitochondria length [µm]',paramName,fontSizeGlobal);
            newScatter(filamentWidthNPNZ,mitoLengthNP(nonzeroNP),0,1.5,0,5,'Local filament width [µm]','Mitochondria length [µm]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(2,3,4)
            newScatter(filamentWidthNPNZ,mitoWidthNP(nonzeroNP),0,1.5,0,0.5,'Local filament width [µm]','Mitochondria width [µm]',strcat('Non-',paramName),fontSizeGlobal);
            subplot(2,3,5)
            newScatter(filamentWidthNPNZ,mitoAreaNP(nonzeroNP),0,1.5,0,1,'Local filament width [µm]','Mitochondria area [µm^2]',strcat('Non-',paramName),fontSizeGlobal);
            subplot(2,3,6)
            newScatter(filamentWidthNPNZ,mitoLengthNP(nonzeroNP),0,1.5,0,5,'Local filament width [µm]','Mitochondria length [µm]',strcat('Non-',paramName),fontSizeGlobal);
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito width, length and area vs filament width plotting
            subplot(2,3,1)
            newScatter(filamentWidthSNZ,mitoWidthS(nonzeroS),0,1.5,0,0.5,'Local filament width [µm]','Mitochondria width [µm]','Stripes',fontSizeGlobal);
            newScatter(filamentWidthNSNZ,mitoWidthNS(nonzeroNS),0,1.5,0,0.5,'Local filament width [µm]','Mitochondria width [µm]','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(2,3,2)
            newScatter(filamentWidthSNZ,mitoAreaS(nonzeroS),0,1.5,0,1,'Local filament width [µm]','Mitochondria area [µm^2]','Stripes',fontSizeGlobal);
            newScatter(filamentWidthNSNZ,mitoAreaNS(nonzeroNS),0,1.5,0,1,'Local filament width [µm]','Mitochondria area [µm^2]','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(2,3,3)
            newScatter(filamentWidthSNZ,mitoLengthS(nonzeroS),0,1.5,0,5,'Local filament width [µm]','Mitochondria length [µm]','Stripes',fontSizeGlobal);
            newScatter(filamentWidthNSNZ,mitoLengthNS(nonzeroNS),0,1.5,0,5,'Local filament width [µm]','Mitochondria length [µm]','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(2,3,4)
            newScatter(filamentWidthNSNZ,mitoWidthNS(nonzeroNS),0,1.5,0,0.5,'Local filament width [µm]','Mitochondria width [µm]','Non-stripes',fontSizeGlobal);
            subplot(2,3,5)
            newScatter(filamentWidthNSNZ,mitoAreaNS(nonzeroNS),0,1.5,0,1,'Local filament width [µm]','Mitochondria area [µm^2]','Non-stripes',fontSizeGlobal);
            subplot(2,3,6)
            newScatter(filamentWidthNSNZ,mitoLengthNS(nonzeroNS),0,1.5,0,5,'Local filament width [µm]','Mitochondria length [µm]','Non-stripes',fontSizeGlobal);
        end
    end

    function p3_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
            if isempty(mitoWidthP)
                mitoWidthP = [0];
            end
            if isempty(mitoWidthNP)
                mitoWidthNP = [0];
            end
            if isempty(mitoWidthS)
                mitoWidthS = [0];
            end
            if isempty(mitoWidthNS)
                mitoWidthNS = [0];
            end
            if isempty(mitoLengthP)
                mitoLengthP = [0];
            end
            if isempty(mitoLengthNP)
                mitoLengthNP = [0];
            end
            if isempty(mitoLengthS)
                mitoLengthS = [0];
            end
            if isempty(mitoLengthNS)
                mitoLengthNS = [0];
            end
            if isempty(mitoAreaP)
                mitoAreaP = [0];
            end
            if isempty(mitoAreaNP)
                mitoAreaNP = [0];
            end
            if isempty(mitoAreaS)
                mitoAreaS = [0];
            end
            if isempty(mitoAreaNS)
                mitoAreaNS = [0];
            end
            %%%Mito width, length and area plotting
            subplot(1,3,1)    
            newDoubleHistogram(mitoWidthP,mitoWidthNP,0,0.015,1,0,0.6,0.2,'Mitochondria width [µm]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            %newDoubleHistFit(mitoWidthP,mitoWidthNP,0,0.015,1)
            legend(paramName,strcat('Non-',paramName));
            
            subplot(1,3,2)
            newDoubleHistogram(mitoAreaP,mitoAreaNP,0,0.05,20,0,2,0.2,'Mitochondria area [µm^2]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            %newDoubleHistFit(mitoAreaP,mitoAreaNP,0,0.05,20)
            legend(paramName,strcat('Non-',paramName));
            
            subplot(1,3,3)
            newDoubleHistogram(mitoLengthP,mitoLengthNP,0,0.1,20,0,4,0.2,'Mitochondria length [µm]','',fontSizeGlobal,paramName,strcat('Non-',paramName))
            %newDoubleHistFit(mitoLengthP,mitoLengthNP,0,0.1,20)
            legend(paramName,strcat('Non-',paramName));
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito width, length and area plotting
            subplot(1,3,1) 
            newDoubleHistogram(mitoWidthS,mitoWidthNS,0,0.015,1,0,0.6,0.2,'Mitochondria width [µm]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            %newDoubleHistFit(mitoWidthS,mitoWidthNS,0,0.015,1)
            legend('MPS','Non-MPS');
            
            subplot(1,3,2)
            newDoubleHistogram(mitoAreaS,mitoAreaNS,0,0.05,20,0,2,0.2,'Mitochondria area [µm^2]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            %newDoubleHistFit(mitoAreaS,mitoAreaNS,0,0.05,20)
            legend('MPS','Non-MPS');
            
            subplot(1,3,3)
            newDoubleHistogram(mitoLengthS,mitoLengthNS,0,0.1,20,0,4,0.2,'Mitochondria length [µm]','',fontSizeGlobal,'MPS',strcat('Non-','MPS'))
            %newDoubleHistFit(mitoLengthS,mitoLengthNS,0,0.1,20)
            legend('MPS','Non-MPS');
        end
    end

    function p4_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
            %%%Mito length vs mito width plotting
            subplot(2,3,1)
            newScatter(mitoWidthP,mitoLengthP,0,0.5,0,5,'Mitochondria width [µm]','Mitochondria length [µm]',paramName,fontSizeGlobal);
            newScatter(mitoWidthNP,mitoLengthNP,0,0.5,0,5,'Mitochondria width [µm]','Mitochondria length [µm]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(2,3,2)
            newHistogram((mitoLengthP./mitoWidthP),0.5,1,19.5,0,20,0.3,'Mitochondria length/mitochondria width [arb.u.]',paramName,fontSizeGlobal);
            newHistogram((mitoLengthNP./mitoWidthNP),0.5,1,19.5,0,20,0.3,'Mitochondria length/mitochondria width [arb.u.]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(2,3,3)
            yvar = mitoLengthP./mitoWidthP;
            newScatter(filamentWidthPNZ,yvar(nonzeroP),0,1.5,0,15,'Local filament width [µm]','Mitochondria length/mitochondria width [arb.u.]',paramName,fontSizeGlobal);
            yvar = mitoLengthNP./mitoWidthNP;
            newScatter(filamentWidthNPNZ,yvar(nonzeroNP),0,1.5,0,15,'Local filament width [µm]','Mitochondria length/mitochondria width [arb.u.]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(2,3,4)
            newScatter(mitoWidthNP,mitoLengthNP,0,0.5,0,5,'Mitochondria width [µm]','Mitochondria length [µm]',strcat('Non-',paramName),fontSizeGlobal);
            subplot(2,3,5)
            newHistogram((mitoLengthNP./mitoWidthNP),0.5,1,19.5,0,20,0.3,'Mitochondria length/mitochondria width [arb.u.]',strcat('Non-',paramName),fontSizeGlobal);
            subplot(2,3,6)
            yvar = mitoLengthNP./mitoWidthNP;
            newScatter(filamentWidthNPNZ,yvar(nonzeroNP),0,1.5,0,15,'Local filament width [µm]','Mitochondria length/mitochondria width [arb.u.]',strcat('Non-',paramName),fontSizeGlobal);
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito length vs mito width plotting
            subplot(2,3,1)
            newScatter(mitoWidthS,mitoLengthS,0,0.5,0,5,'Mitochondria width [µm]','Mitochondria length [µm]','Stripes',fontSizeGlobal);
            newScatter(mitoWidthNS,mitoLengthNS,0,0.5,0,5,'Mitochondria width [µm]','Mitochondria length [µm]','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(2,3,2)
            newHistogram((mitoLengthS./mitoWidthS),0.5,1,19.5,0,20,0.3,'Mitochondria length/mitochondria width [arb.u.]','Stripes',fontSizeGlobal);
            newHistogram((mitoLengthNS./mitoWidthNS),0.5,1,19.5,0,20,0.3,'Mitochondria length/mitochondria width [arb.u.]','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(2,3,3)
            yvar = mitoLengthS./mitoWidthS;
            newScatter(filamentWidthSNZ,yvar(nonzeroS),0,1.5,0,15,'Local filament width [µm]','Mitochondria length/mitochondria width [arb.u.]','Stripes',fontSizeGlobal);
            yvar = mitoLengthNS./mitoWidthNS;
            newScatter(filamentWidthNSNZ,yvar(nonzeroNS),0,1.5,0,15,'Local filament width [µm]','Mitochondria length/mitochondria width [arb.u.]','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(2,3,4)
            newScatter(mitoWidthNS,mitoLengthNS,0,0.5,0,5,'Mitochondria width [µm]','Mitochondria length [µm]','Non-stripes',fontSizeGlobal);
            subplot(2,3,5)
            newHistogram((mitoLengthNS./mitoWidthNS),0.5,1,19.5,0,20,0.3,'Mitochondria length/mitochondria width [arb.u.]','Non-stripes',fontSizeGlobal);
            subplot(2,3,6)
            yvar = mitoLengthNS./mitoWidthNS;
            newScatter(filamentWidthNSNZ,yvar(nonzeroNS),0,1.5,0,15,'Local filament width [µm]','Mitochondria length/mitochondria width [arb.u.]','Non-stripes',fontSizeGlobal);
        end
    end

    function p5_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito non-stripes distance histogram - three peaks mito vs all other mito
            subplot(1,3,1)
            newHistogram(mitoNonStripesDistP,0,0.1,15,0,7,0.3,'Distance to closest actin patch [µm]','',fontSizeGlobal);
            newHistogram(mitoNonStripesDistNP,0,0.1,15,0,7,0.3,'Distance to closest actin patch [µm]','',fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
            subplot(1,3,2)
            newHistogram([mitoNonStripesDistP;mitoNonStripesDistNP],0,0.1,15,0,7,0.15,'Distance to closest actin patch [µm]','All mito',fontSizeGlobal);
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito non-stripes distance histogram - three peaks mito vs all other mito
            subplot(1,3,1)
            newHistogram(mitoNonStripesDistS,0,0.1,15,0,7,0.3,'Distance to closest actin patch [µm]','',fontSizeGlobal);
            newHistogram(mitoNonStripesDistNS,0,0.1,15,0,7,0.3,'Distance to closest actin patch [µm]','',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(1,3,2)
            newHistogram([mitoNonStripesDistS;mitoNonStripesDistNS],0,0.1,15,0,7,0.15,'Distance to closest actin patch [µm]','All mito',fontSizeGlobal);
            subplot(1,3,3)
            newHistogram(mitoThreePeaksNonStripesDist,0,0.1,15,0,7,0.15,'Distance to closest actin patch [µm]','Three-peaks mito',fontSizeGlobal);
        end
    end

    function p6_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito width, length and area histogram - all mito
            subplot(1,3,1)
            newHistogram([mitoWidthS;mitoWidthNS],0,0.015,1,0,0.6,0.2,'Mitochondria width [µm]','All mito',fontSizeGlobal);
            subplot(1,3,2)
            newHistogram([mitoAreaS;mitoAreaNS],0,0.05,20,0,2,0.2,'Mitochondria area [µm^2]','All mito',fontSizeGlobal);
            subplot(1,3,3)
            newHistogram([mitoLengthS;mitoLengthNS],0,0.1,4,0,4,0.2,'Mitochondria length [µm]','All mito',fontSizeGlobal);
        end
    end

    function p7_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito width ratios
            subplot(1,3,1)
            newHistogram(mitoWidthRatioUMS,0,0.1,3,0,3,0.25,'Mitochondria width ratio - Upper/Mid','Stripes',fontSizeGlobal);
            newHistogram(mitoWidthRatioUMNS,0,0.1,3,0,3,0.25,'Mitochondria width ratio - Upper/Mid','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(1,3,2)
            newHistogram(mitoWidthRatioBMS,0,0.1,3,0,3,0.25,'Mitochondria width ratio - Bottom/Mid','Stripes',fontSizeGlobal);
            newHistogram(mitoWidthRatioBMNS,0,0.1,3,0,3,0.25,'Mitochondria width ratio - Bottom/Mid','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
            subplot(1,3,3)
            newHistogram(mitoWidthRatioUBS,0,0.05,1,0,1,0.25,'Mitochondria width ratio - Upper/Bottom','Stripes',fontSizeGlobal);
            newHistogram(mitoWidthRatioUBNS,0,0.05,1,0,1,0.25,'Mitochondria width ratio - Upper/Bottom','Non-stripes',fontSizeGlobal);
            legend('MPS','Non-MPS');
        end
    end

    function p8_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito width ratios - all mito
            subplot(1,3,1)
            newHistogram([mitoWidthRatioUMS;mitoWidthRatioUMNS],0,0.1,3,0,3,0.25,'Mitochondria width ratio - Upper/Mid','All',fontSizeGlobal);
            subplot(1,3,2)
            newHistogram([mitoWidthRatioBMS;mitoWidthRatioBMNS],0,0.1,3,0,3,0.25,'Mitochondria width ratio - Bottom/Mid','All',fontSizeGlobal);
            subplot(1,3,3)
            newHistogram([mitoWidthRatioUBS;mitoWidthRatioUBNS],0,0.05,1,0,1,0.25,'Mitochondria width ratio - Upper/Bottom','All',fontSizeGlobal);
        end
    end

    function p9_call(varargin)
        paramPlots = get(h.c,'Value');
        if paramPlots
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito-patch overlap - param vs non-param
            subplot(1,1,1)
            newHistogram(mitoPatchOverlapP,0,0.02,1,0,1,0.05,'Mitochondria-patch overlapping area [arb. u.]',paramName,fontSizeGlobal);
            newHistogram(mitoPatchOverlapNP,0,0.02,1,0,1,0.05,'Mitochondria-patch overlapping area [arb. u.]',strcat('Non-',paramName),fontSizeGlobal);
            legend(paramName,strcat('Non-',paramName));
%             subplot(2,3,5)
%             newHistogram(mitoPatchOverlapNP,0,0.05,1,0,1,0.7,'Mitochondria-patch overlapping area [arb. u.]',strcat('Non-',paramName),fontSizeGlobal);
        else
            figure(h.fplot)
            clf(h.fplot)
            %%% Mito-patch overlap - all mito
            subplot(1,2,1)
            newHistogram([mitoPatchOverlapS;mitoPatchOverlapNS],0,0.02,1,0,1,0.05,'Mitochondria-patch overlapping area','All',fontSizeGlobal);
            subplot(1,2,2)
            newDoubleHistogram(mitoPatchOverlapS,mitoPatchOverlapNS,0,0.02,1,0,1,0.05,'Mitochondria-patch overlapping area','',fontSizeGlobal,'MPS','Non-MPS')
            legend('MPS','Non-MPS');
%             subplot(2,3,2)
%             newHistogram(mitoPatchOverlapS,0,0.05,1,0,1,0.7,'Mitochondria-patch overlapping area [arb. u.]','Stripes',fontSizeGlobal);
%             newHistogram(mitoPatchOverlapNS,0,0.05,1,0,1,0.7,'Mitochondria-patch overlapping area [arb. u.]','Non-stripes',fontSizeGlobal);
%             subplot(2,3,5)
%             newHistogram(mitoPatchOverlapNS,0,0.05,1,0,1,0.7,'Mitochondria-patch overlapping area [arb. u.]','Non-stripes',fontSizeGlobal);
        end
    end
end