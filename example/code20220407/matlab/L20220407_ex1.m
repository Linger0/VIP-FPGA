%%%%%%%%%%%%%%%%%%%%%%%
% fftshift 
%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;
imA=imread('..\\data\\Fig0427.tif');
figure;imshow(imA);title('ԭͼ��');

% Y = fftshift(X) ͨ������Ƶ�����ƶ����������ģ��������и���Ҷ�任 X��
% ��� X ���������� fftshift �Ὣ X ���������벿�ֽ��н�����
% ��� X �Ǿ����� fftshift �Ὣ X �ĵ�һ������������޽��������ڶ�������������޽�����
% ��� X �Ƕ�ά���飬�� fftshift ����ÿ��ά�Ƚ��� X �İ�ռ䡣
imAshift=fftshift(imA);
figure;imshow(imAshift);title('fftshift');

%%%%%%%%%%%%%%%%%%%%%%%
