%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ڲ���ͼ����Ӹ�˹����
% ͨ������ͼ�е�ƽ̹������ͼ������������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;

% ����ͼ pattern.bmp ���������Ҷ�ֵ��30,150,230
% ���ú�0�Ͱ�255���ɷ�����Ӿ�ֵΪ0������(����ֵ�����и������ⳬ��0-255)
im = mat2gray(imread('..\\data\\pattern.bmp'),[0 255]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӹ�˹��������ֵΪm������Ϊv
%������˹���� noiseg
m = 0;
v = 0.001;
noise_randn = randn(size(im,1),size(im,2));
noiseg = sqrt(v)*noise_randn + m;
%�ڲ���ͼ�ϼӸ�˹����
fg_noise = im + noiseg;
% ��ʾͼ��
figure;
subplot(131);imshow(im);title('����ͼ');
subplot(132);histogram(noiseg(:),64);title('��˹����ֱ��ͼ');
subplot(133);imshow(fg_noise);title('�Ӹ�˹�����Ĳ���ͼ');

% ���Ƹ�˹����
patchn1 = imcrop(fg_noise,[45 45 15 80]);
hist1 = imhist(patchn1);
figure;
subplot(121);imshow(patchn1);title('���ڹ�����������ͼ');
subplot(122);bar(hist1,'LineStyle','-','LineWidth',1);title('��ͼ��ֱ��ͼ');

mu = mean(patchn1(:));
sig = std(patchn1(:));

% ��˹�������
figure;title('��˹�������');
x = 0:255;
x=x/255;
g = 1/(sqrt(2*pi)*sig)*exp(-((x-mu).^2)/(2*sig^2));
ng = g*sum(hist1)/sum(g);
hold on;
bar(x,hist1);
plot(x,ng,'k-','linewidth',2)

% �������д��ڲ鿴���
mest = mu*256 % = 150
vest= sig^2 % = 0.001
v

