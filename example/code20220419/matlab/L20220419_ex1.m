%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѧϰ����ڲ���ͼ�ϵ����������
% ѧϰʹ�ú�����rand��randn
% ��ߣ�ʹ�þ�����������ɾ��й涨�ֲ��������
clc;clear;close all;

% ����ͼ pattern.bmp ���������Ҷ�ֵ��30,150,230
% �Ҷ���Сֵ����0�����ֵ����255��
% �ɱ����������ֵ�����󳬳�[0 255]��Χ��
% Ҳ���ڲ��Խ�������
I = imread('..\\data\\pattern.bmp');% ע��˴��Ҷ�ֵ����
figure(1);hold on;
subplot(231);imshow(I);title('����ͼ','FontSize',14);
subplot(234);bar(imhist(I));title('����ͼֱ��ͼ','FontSize',14);

im = mat2gray(I,[0 255]);% ע��˴��Ҷ�ֵ����,д�� mat2gray(I)���������
% im��3����ֵ��0.1176��0.5882��0.9020
% Ϊ�򻯷��������ӵ�����ֵ��С��[-0.1 0.1]������
figure(1);hold on;
subplot(231);imshow(im);title('����ͼ','FontSize',14);
subplot(234);bar(imhist(im));title('����ͼֱ��ͼ','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������˹���� noiseg����ֵΪm������Ϊv
m = 0;
v = 0.001;
noise_n = randn(size(im,1),size(im,2)); % �õ��ɱ�׼��̬�ֲ����������ɵľ���
noiseg = sqrt(v)*noise_n + m; % �õ��涨��ֵ�ͷ�����̬�ֲ��������
% ��ʾ����ͼ�������ͼ���ֱ��ͼ
subplot(232);imshow(noiseg,[]);title('��˹����ͼ��','FontSize',14);
subplot(235);histogram(noiseg(:),64);title('��˹����ֱ��ͼ','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ڲ���ͼ�ϼӸ�˹����
fg = im + noiseg;
% ��ʾͼ��
subplot(233);imshow(fg);title('�Ӹ�˹�����Ĳ���ͼ','FontSize',14);
subplot(236);bar(imhist(fg));title('��������ͼֱ��ͼ','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �Ӿ������� noiseu ���� (-0.05,0.05) ������ȷֲ�
a = -0.05;b = 0.05;
noise_n = rand(size(im,1),size(im,2));% �õ�������(0,1)�ھ��ȷֲ������������
noiseu = (a+(b-a)*noise_n);
fu = im + noiseu;
% ��ʾͼ��
figure;
subplot(221);imshow(noiseu,[]);title('��������ͼ��');
subplot(222);histogram(noiseu(:),64);title('��������ֱ��ͼ');
subplot(223);imshow(fu);title('�Ӿ��������Ĳ���ͼ');
subplot(224);bar(imhist(fu));title('��������ͼֱ��ͼ');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������
% ʹ�þ�����������ɾ��й涨�ֲ��������
% �ο�ֱ��ͼƥ���˼·
a = -0.04;
b = 0.0032;
noise_n = rand(size(im,1),size(im,2));
noiser = (a + sqrt(-b*log(1-noise_n))); % ��������CDF�ķ�����
fr = im + noiser;
figure;
subplot(221);imshow(noiser,[]);title('��������ͼ��');
subplot(222);histogram(noiser(:),64);title('��������ֱ��ͼ');
subplot(223);imshow(fr);title('�����������Ĳ���ͼ');
subplot(224);bar(imhist(fr));title('��������ͼֱ��ͼ');






