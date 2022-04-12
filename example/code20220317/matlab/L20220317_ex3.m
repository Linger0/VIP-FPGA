%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  A = imread(filename)     %%%%%
%%%%%  imwrite(A,filename)        %%%%%

close all;clc;clear;

%% 1
filename ='..//data//vip.bmp';

img = imread(filename);
figure(1);imshow(img);title('RGB image');

%% 2
B=img(:,:,3);figure(2);imshow(B);title('Blue channel');

%% 3
G=img(:,:,2);figure(4);imshow(G);title('Green channel');

%% 4
R=img(:,:,1);figure(3);imshow(R);title('Red channel');

%% 5
gray = rgb2gray(img);
figure(5);imshow(gray);title('gray image');
