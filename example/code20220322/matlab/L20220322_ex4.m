clc;clear;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Img = imread('..\\data\\aerial.tif');
figure;imshow(Img);title('input image');

% operator ( gamma transformation )
gImg = mat2gray(Img);
Gamma = 0.4;
g4 = gImg.^Gamma;
figure;imshow(g4);title('gamma');

% % operator ( gamma transformation )
% g2 = imadjust(Img,[0 1],[0 1],4); %( gamma transformation )
% figure;imshow(g2);title('gamma');

