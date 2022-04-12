%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰʹ�����º�����
% fspecial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%
%  ����ƽ���˲��� ʾ�� %
%%%%%%%%%%
% ����ƽ���˲���
clc;close all;clear;
img = mat2gray(imread('..\\data\\lenna_gray.jpg'));
figure;imshow(img);title('ԭͼ��');
% ����˲�����
h=[1 1 1;1 5 1;1 1 1];
h=h/sum(h(:))
f_average = fspecial('average',[3 3])
% �����˲���
img_average1 = imfilter(img,h);
figure;imshow(img_average1);title('ƽ��ͼ��1����ֵ�˲���');
img_average2 = imfilter(img,f_average);
figure;imshow(img_average2);title('ƽ��ͼ��2����ֵ�˲���');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%
% ���˲��� ʾ�� %
%%%%%%%%%%
% ���׵������˲���
f_laplacian = fspecial('laplacian',0)
% һ�׵������˲���
f_prewitt = fspecial('prewitt')
f_sobel = fspecial('sobel')
f_scharr = [3 10 3;0 0 0;-3 -10 -3]

%%%%%%%%%%%%
% ������˹�� ʾ�� %
%%%%%%%%%%%%
close all;
img = mat2gray(imread('moon.tif'));
figure;
subplot(121);imshow(img);title('ԭͼ��');

f_laplacian = fspecial('laplacian',0)
img_laplacian = imfilter(img,f_laplacian);
img_enhance = img - img_laplacian;

subplot(122);imshow(img_enhance);title('��ǿͼ��');

%%%%%%%%%%%%
%     �ݶ�ͼ�� ʾ��    %
%%%%%%%%%%%%
close all;
img = mat2gray(imread('circuit.tif'));
figure;imshow(img);title('ԭͼ��');

f_sobel_h = fspecial('sobel') % emphasizes horizontal edges
f_sobel_v = f_sobel_h' % emphasizes vertical edges

img_sobel_h =  imfilter(img,f_sobel_h);
figure;imshow(mat2gray(img_sobel_h));title('sobel horizontal');
img_sobel_v =  imfilter(img,f_sobel_v);
figure;imshow(mat2gray(img_sobel_v));title('sobel vertical');
img_sobel = abs(img_sobel_h) + abs(img_sobel_v);
figure;imshow(img_sobel);title('�ݶȷ�ֵͼ��');

