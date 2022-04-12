%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% fspecial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%
%  线性平滑滤波器 示例 %
%%%%%%%%%%
% 线性平滑滤波器
clc;close all;clear;
img = mat2gray(imread('..\\data\\lenna_gray.jpg'));
figure;imshow(img);title('原图像');
% 设计滤波器：
h=[1 1 1;1 5 1;1 1 1];
h=h/sum(h(:))
f_average = fspecial('average',[3 3])
% 线性滤波：
img_average1 = imfilter(img,h);
figure;imshow(img_average1);title('平滑图像1（均值滤波后）');
img_average2 = imfilter(img,f_average);
figure;imshow(img_average2);title('平滑图像2（均值滤波后）');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%
% 锐化滤波器 示例 %
%%%%%%%%%%
% 二阶导数锐化滤波器
f_laplacian = fspecial('laplacian',0)
% 一阶导数锐化滤波器
f_prewitt = fspecial('prewitt')
f_sobel = fspecial('sobel')
f_scharr = [3 10 3;0 0 0;-3 -10 -3]

%%%%%%%%%%%%
% 拉普拉斯锐化 示例 %
%%%%%%%%%%%%
close all;
img = mat2gray(imread('moon.tif'));
figure;
subplot(121);imshow(img);title('原图像');

f_laplacian = fspecial('laplacian',0)
img_laplacian = imfilter(img,f_laplacian);
img_enhance = img - img_laplacian;

subplot(122);imshow(img_enhance);title('增强图像');

%%%%%%%%%%%%
%     梯度图像 示例    %
%%%%%%%%%%%%
close all;
img = mat2gray(imread('circuit.tif'));
figure;imshow(img);title('原图像');

f_sobel_h = fspecial('sobel') % emphasizes horizontal edges
f_sobel_v = f_sobel_h' % emphasizes vertical edges

img_sobel_h =  imfilter(img,f_sobel_h);
figure;imshow(mat2gray(img_sobel_h));title('sobel horizontal');
img_sobel_v =  imfilter(img,f_sobel_v);
figure;imshow(mat2gray(img_sobel_v));title('sobel vertical');
img_sobel = abs(img_sobel_h) + abs(img_sobel_v);
figure;imshow(img_sobel);title('梯度幅值图像');

