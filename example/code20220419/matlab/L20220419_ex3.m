%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 在测试图上添加高斯噪声
% 通过测试图中的平坦区域子图估计噪声参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;

% 测试图 pattern.bmp 仅有三个灰度值：30,150,230
% 不用黑0和白255，可方便叠加均值为0的噪声(噪声值有正有负，避免超出0-255)
im = mat2gray(imread('..\\data\\pattern.bmp'),[0 255]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加高斯噪声，均值为m，方差为v
%产生高斯噪声 noiseg
m = 0;
v = 0.001;
noise_randn = randn(size(im,1),size(im,2));
noiseg = sqrt(v)*noise_randn + m;
%在测试图上加高斯噪声
fg_noise = im + noiseg;
% 显示图像
figure;
subplot(131);imshow(im);title('测试图');
subplot(132);histogram(noiseg(:),64);title('高斯噪声直方图');
subplot(133);imshow(fg_noise);title('加高斯噪声的测试图');

% 估计高斯噪声
patchn1 = imcrop(fg_noise,[45 45 15 80]);
hist1 = imhist(patchn1);
figure;
subplot(121);imshow(patchn1);title('用于估计噪声的子图');
subplot(122);bar(hist1,'LineStyle','-','LineWidth',1);title('子图的直方图');

mu = mean(patchn1(:));
sig = std(patchn1(:));

% 高斯函数拟合
figure;title('高斯函数拟合');
x = 0:255;
x=x/255;
g = 1/(sqrt(2*pi)*sig)*exp(-((x-mu).^2)/(2*sig^2));
ng = g*sum(hist1)/sum(g);
hold on;
bar(x,hist1);
plot(x,ng,'k-','linewidth',2)

% 在命令行窗口查看结果
mest = mu*256 % = 150
vest= sig^2 % = 0.001
v

