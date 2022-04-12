%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% imhist，histeq
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;close all;clc;

%% %%%%%%%%%%%%%%%%
Img = imread('tire.tif');
figure;imshow(Img);title('input image');
[counts,binLocations]=imhist(Img,256);
figure;bar(counts);title('input image histogtam');

ImgEq=histeq(Img);
figure;imshowpair(Img,ImgEq,'montage');title('histogtam equalization');
[counts,binLocations]=imhist(ImgEq,256);
figure;bar(counts);title('histogtam equalization');

%% 
RefImg = imread('cameraman.tif');
figure;imshow(RefImg);title('reference image');
[counts,binsL]=imhist(RefImg);
figure;bar(counts);title('reference image histogtam');

ImgTran = histeq(Img,counts);
figure;imshow(ImgTran);title('histogram specification image');
[counts,binsL]=imhist(ImgTran);
figure;bar(counts);title('result histogtam');

