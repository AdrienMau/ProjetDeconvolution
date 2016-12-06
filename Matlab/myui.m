function [] = myui( pas )
% crée le slider pour l'affichage des images et des graphes
% Le slider fait varier la profondeur Z et charge les images en conséquence
% affiche l'image avec des traits correspondant à l'inclinaison des franges
% nécessite bin2mat
%%
% global trucglobal;


if ~exist('pas','var')
    pas=1;
end


scrsz = get(groot,'ScreenSize'); %screensize
initvalue = 100;

%     fpath2=strcat(fpath,'000700.2Ddbl'); %on affiche la 700 en premier
%     h=figure('Position',[scrsz(3)/2 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]); % Place les figures côte à côte

      
    %crée la figure pour afficher les deux graphes
    f = figure('Visible','off','Position',[1 scrsz(4)/4 scrsz(3)/2 scrsz(4)/2]);
    ax = axes('Units','pixels');
    set(groot,'CurrentFigure',f);
    im=imread('cameraman.tif');
    image=imshow(im,'DisplayRange',[min(im(:)) max(im(:))],'InitialMagnification','fit');hold on;
    title('');
    
   % Create slider
    sld = uicontrol('Style', 'slider',...
        'Min',0,'Max',1400,'Value',700,'SliderStep',[pas/1400 pas/1400],...
        'Position', [300 3 120 20],...
        'Callback', @replot);
					
    % Add a text uicontrol to label the slider.
    txt = uicontrol('Style','text',...
        'Position',[10 -5 120 30],...
        'String',initvalue);
    
    % Make figure visble after adding all components
    f.Visible = 'on';
    % This code uses dot notation to set properties. 
    % Dot notation runs in R2014b and later.
    % For R2014a and earlier: set(f,'Visible','on');
    
    function replot(source,callbackdata)
        val = source.Value;
        % For R2014a and earlier:
        % val = 51 - get(source,'Value');
    
        r=mod(val,pas);
            if(r)%arrondi la valeur du slide au PAS le plus proche
               val=val-r; 
            end
        txt = uicontrol('Style','text',...
        'Position',[10 -5 120 30],...
        'String',r);

        set(groot,'CurrentFigure',f);
        image=imshow(im,'DisplayRange',[min(im(:)) max(im(:))],'InitialMagnification','fit');hold off;
    
 
    end
end