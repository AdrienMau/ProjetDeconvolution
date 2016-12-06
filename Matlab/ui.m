function [ output_args ] = ui( input_args )

%GUI où on fait varier un paramètre


scrsz = get(groot,'ScreenSize'); %screensize

%DEFINITION DES VARIABLES DE BASE:
   %slider:
    sliderinitvalue = 0.001;
    slidermin=-10;
    slidermax=1;
    if ~exist('pas','var')
    pas=0.05;
    end

    %ACTION INITIALE
    img=double(rgb2gray(imread('particles.jpg')));



%     fpath2=strcat(fpath,'000700.2Ddbl'); %on affiche la 700 en premier
    h=figure('Position',[scrsz(3)/2 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]); % Place les figures côte à côte
      
    %crée la figure pour afficher les deux graphes
        f = figure('Visible','off','Position',[1 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]);
        ax = axes('Units','pixels');
        set(groot,'CurrentFigure',f);
    imshow2(img)
    
   % Create SLIDER
    sld = uicontrol('Style', 'slider',...
        'Min',slidermin,'Max',slidermax,'Value',sliderinitvalue,'SliderStep',[pas/(slidermax-slidermin) pas/(slidermax-slidermin)],...
        'Position', [300 3 120 20],...
        'Callback', @newvalue);
					
    % Add a TEXT uicontrol to label the slider.
        txt = uicontrol('Style','text',...
        'Position',[340 25 50 15],...
        'String',sliderinitvalue);
    
    % Make figure visble after adding all components
    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');
    
    function newvalue(source,callbackdata)
        val = source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
    
        VAL=val-mod(val,pas)
        %edit Text
        txt = uicontrol('Style','text',...
        'Position',[340 25 50 15],...
        'String',VAL);

        set(groot,'CurrentFigure',f);
        
        %APPEL FONCTION:

            img2=passe_hg(img,VAL,8);
            imshow(img2*2,[]);


    end
end

