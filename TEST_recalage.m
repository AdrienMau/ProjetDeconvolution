% Test de recalage d'images avec des fonctions de la bibiloth�que matlab
%clear all
close all
clc

%% Automatique, bas� sur l'intensit� (cf tuto matlab)
% 1:Loading images
im_ref = rgb2gray(imread('recalage1.jpg'));
im_moving = rgb2gray(imread('recalage2.jpg'));
%-- test avec images de r�solutions diff�rentes
im_moving = ait_undersample(im_moving,2); % ne fonctionne pas directement - � REPPRENDRE !
%----------------------------------------------
figure, imshowpair(im_moving, im_ref, 'montage');
title('Originales');
figure, imshowpair(im_moving, im_ref);
title('Originales - comparaison');

% 2:Setting up the original registration
[optimizer,metric] = imregconfig('monomodal');
im_movingRegisteredDefault = imregister(im_moving, im_ref,'similarity', optimizer, metric);
figure, imshowpair(im_movingRegisteredDefault, im_ref);
title('A:Recalage par d�faut');

% 3:Improce the registration
disp(optimizer)
disp(metric)
% optimizer.InitialRadius = optimizer.InitialRadius/3.5;
% optimizer.MaximumIterations = 300;
% ...

% 4:Use Initial Conditions to improve registration
tformRigid = imregtform(im_moving, im_ref,'rigid',optimizer,metric);
Rim_ref = imref2d(size(im_ref));
im_movingRegisteredRigid = imwarp(im_moving,tformRigid,'OutputView',Rim_ref);
figure, imshowpair(im_movingRegisteredRigid, im_ref);
title('C: Recalage bas� sur mod�le de transformation rigide.');
im_movingRegisteredSimilarityWithIC = imregister(im_moving,im_ref,'similarity',optimizer,metric,...
    'InitialTransformation',tformRigid);
figure, imshowpair(im_movingRegisteredSimilarityWithIC,im_ref);
title('D: Recalage bas� sur mod�le de transfo Similarity avec CI (transfo rigide).');


%% 
