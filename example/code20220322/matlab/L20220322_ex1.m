%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰʹ�����º�����
% imresize
% �۲�����ڲ�ֵ��Ч��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% interpolation  %%%%%%%%%%%%
close all;clc;clear;

filename ='..\\data\\eye.jpg';
img = imread(filename);
figure(1);imshow(img);

img_nearest=imresize(img,15,'nearest');
figure(2);imshow(img_nearest);title('nearest');


