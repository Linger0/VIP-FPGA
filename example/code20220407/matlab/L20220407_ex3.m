% 此程序是频率域理想低通滤波器示例   
% 注意：本程序傅里叶变换后 移中
% 原点位于图像中心

clc;clear;close all;

% 输入原图像
f = imread('..\\data\\Fig0441.tif');
figure;imshow(f);title('原图');
f = im2double(f);

% 计算填充图像大小
[M,N] = size(f);
M2 = 2*M;
N2 = 2*N;

% 傅里叶变换
F = fftshift(fft2(f,M2,N2));
figure;imshow(mat2gray(log(1+abs(F))));title('傅里叶频谱');

% 设计滤波器
% 生成网格坐标
u = -N:N-1;
v = -M:M-1;
[U,V] = meshgrid(u,v);

% 设计滤波器
D = hypot(U,V); % 平方和的开方 
D0 = 60; % 截止频率 [10 30 60 160 460]

H = mat2gray( D <= D0 );% 理想低通滤波器
figure;imshow(H);title('频域滤波器');

% 频域滤波
G = F.*H;
figure;imshow(mat2gray(log(1+abs(G))));title('滤波后频谱');

 % 滤除的功率占比
 1-sum(sum(abs(G).^2))/sum(sum(abs(F).^2))

% 傅里叶逆变换，裁剪图像
g0 = ifft2(fftshift(G));
g = g0(1:M,1:N);
g = real(g);
figure;imshow(g);title('滤波后图像');

% % 频域滤波器的空间域形式
hh = real(ifft2(fftshift(H)));
figure;imshow(mat2gray(fftshift(hh)));title('空间域滤波器');




