%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% fft2,ifft2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% fft2 
%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;
imA=imread('..\\data\\Fig0427.tif');
imA=double(imresize(imA,[1024 1024]));
imB=double(imread('..\\data\\Fig0424.tif'));
figure(1);imshow(mat2gray(imA));title('图A');
figure(2);imshow(mat2gray(imB));title('图B');

% 傅里叶变换——注意：FA、FB是复数矩阵
FA=(fft2(imA));
FB=(fft2(imB));

% 傅里叶变换的频谱
VA=abs(FA);
VB=abs(FB);
VAS=log(1+VA);
VBS=log(1+VB);
figure(3);imshow(mat2gray(fftshift(VAS)));title('图A的频谱');
figure(4);imshow(mat2gray(fftshift(VBS)));title('图B的频谱');

% 傅里叶变换的相位
AA=angle(FA);
AB=angle(FB);
figure(5);imshow(mat2gray(fftshift(AA)));title('图A的相位');
figure(6);imshow(mat2gray(fftshift(AB)));title('图B的相位');

%%%%%%%%%%%%%%%%%%%%%%%
% ifft2 
%%%%%%%%%%%%%%%%%%%%%%%
% 重组频谱和相角
newDFT1 = VA.*exp(AA*1i); % 图A频谱与图A相位重组
newDFT2 = VB.*exp(AB*1i); % 图B频谱与图B相位重组
newDFT3 = VA.*exp(AB*1i); % 图A频谱与图B相位重组
newDFT4 = VB.*exp(AA*1i); % 图B频谱与图A相位重组

newImg1 = real(ifft2((newDFT1)));
newImg2 = real(ifft2((newDFT2)));
newImg3 = real(ifft2((newDFT3)));
newImg4 = real(ifft2((newDFT4)));

figure(7);imshow(mat2gray(newImg1));title('图A频谱与图A相位重组');
figure(8);imshow(mat2gray(newImg2));title('图B频谱与图B相位重组');
figure(9);imshow(mat2gray(newImg3));title('图A频谱与图B相位重组');
figure(10);imshow(mat2gray(newImg4));title('图B频谱与图A相位重组');

