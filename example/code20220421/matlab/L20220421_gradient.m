%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ñ§Ï°º¯Êý£ºimgradientxy, imgradient
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
doc imgradientxy
doc imgradient

clc;clear;close all;
im = imread('..\\data\\bld.tif');
figure;imshow(im);
%%%%%% imgradientxy %%%%%%%%%%%%%%
[gx, gy] = imgradientxy(im,'prewitt');
figure;
imshowpair(abs(gx), abs(gy), 'montage');
title('Directional Gradients: x-direction(left), y-direction (right)')

%%%%%% imgradient %%%%%%%%%%%%%%
[gm, gd] = imgradient(im,'sobel');
figure;imshow(gm,[]);title('Gradient Magnitude');
figure;imshow(gd,[]);title('Gradient Direction');colormap jet;colorbar

d = (abs(gd)<10) & (gm > 100);
figure;imshow(d,[]);

d = (abs(gd)<40) & (abs(gd)>30) & (gm > 100);
figure;imshow(d,[]);
%%%%%% imgradient %%%%%%%%%%%%%%
[gmR, gdR] = imgradient(im,'roberts');
figure;imshow(gm,[]);title('Gradient Magnitude (roberts) ');

