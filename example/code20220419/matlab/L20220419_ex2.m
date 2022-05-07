%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰʹ�ú�����imnoise
% ���� imnoise ��ͼ����ϸ�˹��������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clc;clear;

% ����ͼ pattern.bmp ���������Ҷ�ֵ��30,150,230
% �Ҷ���Сֵ����0�����ֵ����255��
% �ɱ����������ֵ�����󳬳�[0 255]��Χ��
% Ҳ���ڲ��Խ�������
im = mat2gray(imread('..\\data\\pattern.bmp'),[0 255]);% ע��˴��Ҷ�ֵ����
% im ��3���Ҷ���ֵ��0.1176��0.5882��0.9020

%%%%%%%%%%%%%%%%%%
% �ڲ���ͼ�ϼ�����
% imnoise expects pixel values of data type double and single to be in the range [0, 1]. 
% You can use the rescale function to adjust pixel values to the expected range. 
% If your image is type double or single with values outside the range [0,1], 
% then imnoise clips input pixel values to the range [0, 1] before adding noise.

% �ӽ������� 
d = 0.2;
im_sp = imnoise(im,'salt & pepper',d); % adds salt and pepper noise, where d is the noise density. This affects approximately d*numel(I) pixels.

% ��ʾͼ��
figure;
subplot(221);imshow(im);subplot(223);bar(imhist(im),'BarWidth',3);
subplot(222);imshow(im_sp,[]);subplot(224);bar(imhist(im_sp),'BarWidth',3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӹ�˹��������ֵ = m ������ = var
m = 0;
v = 0.001; % var = std^2
im_g = imnoise(im,'gaussian',m,v); % adds Gaussian white noise with mean m and variance var.
figure;subplot(121);imshow(im_g,[]);subplot(122);bar(imhist(im_g),'BarWidth',3);

