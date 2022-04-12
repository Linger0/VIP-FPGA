%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% imresize
% 观察最近邻插值的效果
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% interpolation  %%%%%%%%%%%%
close all;clc;clear;

filename ='..\\data\\eye.jpg';
img = imread(filename);
figure(1);imshow(img);

img_nearest=imresize(img,15,'nearest');
figure(2);imshow(img_nearest);title('nearest');


