%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰʹ�����º�����
% imfilter, padarray, filter2, conv2
% mat2gray��rescale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear;

%%%%%%%%%%%%
%  �ռ��˲� ʾ��    %
%%%%%%%%%%%%
% ����ͼ��
A=zeros(512,512);
A(1:256,257:512)=255;
A(257:512,1:256)=255;
figure;hold on;imshow(uint8(A));title('ԭͼ');
% ����˲���
h=ones(21,21)/(21*21);
% �����˲�
B= imfilter(A,h); % the center of the kernel is floor((size(h) + 1)/2).
% ��ʾ�����ע��imshow�������������ͣ�
figure;hold on;imshow(B);title('�˲���');
figure;hold on;imshow(uint8(B));title('�˲���');
figure;hold on;imshow(rescale(B));title('�˲���');% scales the entries of an array to the interval [0,1]. 
figure;hold on;imshow(mat2gray(B));title('�˲���');% mat2gray: returned as a numeric matrix with values in the range [0, 1].Data Types: double
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ò�ͬ�߽���䷽��
close all
B1= imfilter(A,h,0); % ʹ��pֵ��䣨p=0�� 
B2= imfilter(A,h,'replicate'); % ����ͼ��߽����ص�ֵ
B3= imfilter(A,h,'symmetric'); % ����ͼ��߽����ص�ֵ
B4= imfilter(A,h,'circular'); % ������չ

% ��ʾ���
figure;
subplot(231);imshow(mat2gray(A));title('ԭͼ');
subplot(232);imshow(mat2gray(B1));title('���0');
subplot(233);imshow(mat2gray(B2));title('���Ʊ߽�');
subplot(235);imshow(mat2gray(B3));title('������չ');
subplot(236);imshow(mat2gray(B4));title('������չ');

% B0��B1�Ƿ���ͬ��
% B2��B3�Ƿ���ͬ��
% B1��B4�Ƿ���ͬ��

% ���0 �� ������չ ����Ĳ���
figure;hold on;
plot(B1(128,1:12),'r*-');
plot(B4(128,1:12),'b*-');
legend('���0','������չ');

Sub_1_4 = B1-B4;
figure;imshow(rescale((Sub_1_4)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

