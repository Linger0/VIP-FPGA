%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 图像复原
% 逆滤波和维纳滤波复原不同噪声强度（方差）退化图像的效果
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 产生退化图像
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 读入图像 f
f = mat2gray(imread('..\\data\\original_DIP.tif'));

% 设计退化函数（空域：PSF， 频域：H）
LEN = 50; % len specifies the length of the motion
THETA = -60; % theta specifies the angle of motion in degrees in a counter-clockwise direction
psf = fspecial('motion',LEN,THETA);% 空间域 PSF
H = psf2otf(psf, size(f)); % 频率域 H

% 设计噪声
noise_m = 0;
noise_v = 0; 
noise_v = 5*10^-7; 
noise_v = 5*10^-4; 
noise_gaussian = noise_m + sqrt(noise_v)*randn(size(f));

% 产生退化图像：运动模糊+高斯噪声
% 仅有运动模糊的图像：fb
% 有运动模糊和高斯噪声的图像：fbn
fb = imfilter(f,psf,'conv','circular');
figure;imshow(fb);title('仅有运动模糊的退化图像');
fbn = fb + noise_gaussian;
figure;imshow(fbn);title('有运动模糊和噪声的退化图像');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 对退化图像 fbn 进行复原
% 对照维纳滤波器公式写代码
% 假设已知退化函数 H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 设计逆滤波器 H_i
S_n = 0;
S_f = 1;
denom = (abs(H).^2).*S_f+S_n;
denom = max(denom, sqrt(eps));
H_i = (conj(H) .* S_f)./denom;

% 设计维纳滤波器 H_wiener
% 估计 噪信比
estimated_nsr = noise_v/var(f(:));
% 设计滤波器
S_n = estimated_nsr; % 交互调整S_n的值来获得好的复原效果
S_f = 1;
denom = (abs(H).^2).*S_f+S_n;
denom = max(denom, sqrt(eps));
H_wiener = (conj(H) .* S_f)./denom; % 维纳滤波器

% 复原
fbni_hat = ifft2(H_i .* fft2(fbn));
fbnw_hat = ifft2(H_wiener .* fft2(fbn));

figure;imshow(fbni_hat);title('逆滤波','FontSize',16);
figure;imshow(fbnw_hat);title('维纳滤波','FontSize',16);

