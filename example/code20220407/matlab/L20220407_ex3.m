% �˳�����Ƶ���������ͨ�˲���ʾ��   
% ע�⣺��������Ҷ�任�� ����
% ԭ��λ��ͼ������

clc;clear;close all;

% ����ԭͼ��
f = imread('..\\data\\Fig0441.tif');
figure;imshow(f);title('ԭͼ');
f = im2double(f);

% �������ͼ���С
[M,N] = size(f);
M2 = 2*M;
N2 = 2*N;

% ����Ҷ�任
F = fftshift(fft2(f,M2,N2));
figure;imshow(mat2gray(log(1+abs(F))));title('����ҶƵ��');

% ����˲���
% ������������
u = -N:N-1;
v = -M:M-1;
[U,V] = meshgrid(u,v);

% ����˲���
D = hypot(U,V); % ƽ���͵Ŀ��� 
D0 = 60; % ��ֹƵ�� [10 30 60 160 460]

H = mat2gray( D <= D0 );% �����ͨ�˲���
figure;imshow(H);title('Ƶ���˲���');

% Ƶ���˲�
G = F.*H;
figure;imshow(mat2gray(log(1+abs(G))));title('�˲���Ƶ��');

 % �˳��Ĺ���ռ��
 1-sum(sum(abs(G).^2))/sum(sum(abs(F).^2))

% ����Ҷ��任���ü�ͼ��
g0 = ifft2(fftshift(G));
g = g0(1:M,1:N);
g = real(g);
figure;imshow(g);title('�˲���ͼ��');

% % Ƶ���˲����Ŀռ�����ʽ
hh = real(ifft2(fftshift(H)));
figure;imshow(mat2gray(fftshift(hh)));title('�ռ����˲���');




