   %NET %Test of is_clear.
   
figure
I=double(rgb2gray(imread('particles.jpg')));
Iblur = imgaussfilt(I, 5);
Iblur2 = imgaussfilt(I, 10);

subplot(221)
imshow2(I);
subplot(222)
imshow2(Iblur);
subplot(223)
imshow2(Iblur2);
    seuil=mean(mean(I));
net=[is_clear(I,1),is_clear(Iblur,1),is_clear(Iblur2,1)]
net2=[is_clear(I,2,seuil),is_clear(Iblur,2,seuil),is_clear(Iblur2,2,seuil)]
net3=[is_clear(I,3),is_clear(Iblur,3),is_clear(Iblur2,3)]
    