%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰʹ�����º�����
% fft2,ifft2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% fft2 
%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;
imA=imread('..\\data\\Fig0427.tif');
imA=double(imresize(imA,[1024 1024]));
imB=double(imread('..\\data\\Fig0424.tif'));
figure(1);imshow(mat2gray(imA));title('ͼA');
figure(2);imshow(mat2gray(imB));title('ͼB');

% ����Ҷ�任����ע�⣺FA��FB�Ǹ�������
FA=(fft2(imA));
FB=(fft2(imB));

% ����Ҷ�任��Ƶ��
VA=abs(FA);
VB=abs(FB);
VAS=log(1+VA);
VBS=log(1+VB);
figure(3);imshow(mat2gray(fftshift(VAS)));title('ͼA��Ƶ��');
figure(4);imshow(mat2gray(fftshift(VBS)));title('ͼB��Ƶ��');

% ����Ҷ�任����λ
AA=angle(FA);
AB=angle(FB);
figure(5);imshow(mat2gray(fftshift(AA)));title('ͼA����λ');
figure(6);imshow(mat2gray(fftshift(AB)));title('ͼB����λ');

%%%%%%%%%%%%%%%%%%%%%%%
% ifft2 
%%%%%%%%%%%%%%%%%%%%%%%
% ����Ƶ�׺����
newDFT1 = VA.*exp(AA*1i); % ͼAƵ����ͼA��λ����
newDFT2 = VB.*exp(AB*1i); % ͼBƵ����ͼB��λ����
newDFT3 = VA.*exp(AB*1i); % ͼAƵ����ͼB��λ����
newDFT4 = VB.*exp(AA*1i); % ͼBƵ����ͼA��λ����

newImg1 = real(ifft2((newDFT1)));
newImg2 = real(ifft2((newDFT2)));
newImg3 = real(ifft2((newDFT3)));
newImg4 = real(ifft2((newDFT4)));

figure(7);imshow(mat2gray(newImg1));title('ͼAƵ����ͼA��λ����');
figure(8);imshow(mat2gray(newImg2));title('ͼBƵ����ͼB��λ����');
figure(9);imshow(mat2gray(newImg3));title('ͼAƵ����ͼB��λ����');
figure(10);imshow(mat2gray(newImg4));title('ͼBƵ����ͼA��λ����');

