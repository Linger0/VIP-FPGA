clc;
close all;
clear;
%%%%%%%%%%%%%%%
Imag = imread('..\\data\\skeleton_orig.tif');

% A
A_img_Ori = mat2gray(Imag);
figure;imshow(A_img_Ori);title('A','Fontsize',16);
figure;bar(imhist(A_img_Ori));

% B
f_laplacian8 = [-1 -1 -1;-1 8 -1;-1 -1 -1]
B_img_laplacian =  imfilter(A_img_Ori,f_laplacian8);
figure;imshow(mat2gray(B_img_laplacian));title('B','Fontsize',16);
imwrite(mat2gray(B_img_laplacian),'B_img_laplacian.bmp','bmp');

% C
C_img_AaddB = A_img_Ori+B_img_laplacian;
figure;imshow(C_img_AaddB);title('C','Fontsize',16);
imwrite((C_img_AaddB),'C_img_AaddB.bmp','bmp');

% D
f_sobel = fspecial('sobel');
f_sobel_v = -1.*f_sobel
f_sobel_h = f_sobel_v'
img_sobel_v =  imfilter(A_img_Ori,f_sobel_v);
img_sobel_h =  imfilter(A_img_Ori,f_sobel_h);
D_img_sobel = abs(img_sobel_v)+abs(img_sobel_h);
figure;imshow(mat2gray(D_img_sobel));title('D','Fontsize',16);
imwrite(mat2gray(D_img_sobel),'D_img_sobel.bmp','bmp');

% E
f_average = fspecial('average',[5 5])
E_img_averagesobel = imfilter(D_img_sobel,f_average);
figure;imshow(mat2gray(E_img_averagesobel));title('E','Fontsize',16);
imwrite(mat2gray(E_img_averagesobel),'E_img_averagesobel.bmp','bmp');

% F
F_img_CimgMultEimg=B_img_laplacian.*E_img_averagesobel;
figure;imshow((F_img_CimgMultEimg));title('F','Fontsize',16);
imwrite(F_img_CimgMultEimg,'F_img_CimgMultEimg.bmp','bmp');

% G
G_img_AimgAddFimg=A_img_Ori+F_img_CimgMultEimg;
figure;imshow((G_img_AimgAddFimg));title('G','Fontsize',16);
imwrite(G_img_AimgAddFimg,'G_img_AimgAddFimg.bmp','bmp');

% H
gamma = 0.5;
H_img_gamma = imadjust(G_img_AimgAddFimg,[0 1],[0 1],gamma);
figure;imshow((H_img_gamma));title('H','Fontsize',16);
imwrite(H_img_gamma,'H_img_gamma.bmp','bmp');

