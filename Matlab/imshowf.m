function [] = imshowf(img,amp_or_phase)
%Plot a Fourier Transform, with magnitude and phase
%You can choose to selectively plot the amplitude or the phase by
%giving the value 1 or 2 to amp_or_phase.

%Author: Adrien Mau, also known as Mrjaune

    %Verif.
    if (~exist('amp_or_phase','var'))
        amp_or_phase=0;
    else %value 1 or 2 only
        amp_or_phase=(amp_or_phase==1)+(amp_or_phase==2)*2;
    end

    %Plot
    if(amp_or_phase==1)     %plot amplitude
        imagesc(100*log(1+abs(img))); colormap(gray); 
        title('Amplitude');
    elseif(amp_or_phase==2)   %plot phase
        imagesc(angle(img));  colormap(gray);
        title('Phase');
        
    elseif (amp_or_phase==0)   %plot both
        subplot(1,2,1);
        imagesc(100*log(1+abs(img))); colormap(gray); 
        title('Amplitude');

        subplot(1,2,2);
        imagesc(angle(img));  colormap(gray);
        title('Phase');       
    end

end