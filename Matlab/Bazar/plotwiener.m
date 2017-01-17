function [  ] = plotwiener(dossier,focus,pasx,pasy)
%Permet de visualiser wiener en fonction de lambda
%ENTREES:
% dossier: mettre M ou 1 pour mesures et C ou 0 pour Calibration
% pasx et pasy: pas pour calcul de la moyenne

% SORTIES:
% 

if (exist('pasx','var'))
    pasx=pasx;
else
    pasx=0.5;
end

if (exist('pasy','var'))
    pasy=pasy;
else
    pasy=0.1;
end

% d=-11.2; %angle
% n=4;
% centrex=61;
% centrey=61;

focus=700;
slidermin=0;
if(dossier(1)=='M')|(dossier(1)=='m')|(dossier(1)==1)
    sliderpas=100;
    slidermax=1400;
elseif((dossier(1)=='C')|(dossier(1)=='c')|(dossier(1)==0))
    sliderpas=25;
    slidermax=1375;
end 
lambda=0;

    % Create a figure and axes
    f = figure('Visible','off');
    ax = axes('Units','pixels');
    testWiener(lambda,focus,pasx,pasy);
    % Create push button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 50 20],...
        'Callback', 'cla');      

   % Create slider
    sld = uicontrol('Style', 'slider',...
        'Min',slidermin,'Max',slidermax,'Value',focus,...
        'Position', [300 3 120 20],...
        'SliderStep',[sliderpas/slidermax sliderpas/slidermax],... %sliderstep en pourcentage
        'Callback', @replot); 
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[450 3 120 30],...
        'String','Moyenne selon lambda');
    
    % Make figure visible after adding all components
    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');
    


    function replot(source,callbackdata)
        val = source.Value
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
        testWiener(lambda,val,pasx,pasy)
        
    end
end