%%%%%%%%%%%%%%%%%%%%%
% �鿴Matlab�ĵ���ѧϰ���º�����
% strel
% imdilate | imerode
% imclose | imopen
% imtophat | imbothat
% 
% ���磺�������д������룺
% doc strel
%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;

im=mat2gray(imread('..\\data\\rice.png'),[0 255]);
figure;imshow(im);title('ԭͼ��');
figure;bar(imhist(im));title('ԭͼ��ֱ��ͼ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Otsuȫ����ֵ�ָ�
[Th1,EM1] = graythresh(im);
mymask1 = imbinarize(im,Th1);
figure;imshow(mymask1);title('Otsu��ֵ�ָ�');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% ��ñ�˲�
se = strel('disk',11);
se.Neighborhood % 21��21 logical ����
im_tophat=imtophat(im,se);
figure;imshow(im_tophat);title('��ñ�˲�');
figure;bar(imhist(im_tophat));title('��ñ�˲�ֱ��ͼ');
[Th2,EM2] = graythresh(im_tophat);
mymask2 = imbinarize(im_tophat,Th2);
figure;imshow(mymask2);title('��ñ�˲�+Otsu��ֵ�ָ�');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
