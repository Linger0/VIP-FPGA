%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ͼ��ԭ
% ���˲���ά���˲���ԭ��ͬ����ǿ�ȣ�����˻�ͼ���Ч��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����˻�ͼ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ͼ�� f
f = mat2gray(imread('..\\data\\original_DIP.tif'));

% ����˻�����������PSF�� Ƶ��H��
LEN = 50; % len specifies the length of the motion
THETA = -60; % theta specifies the angle of motion in degrees in a counter-clockwise direction
psf = fspecial('motion',LEN,THETA);% �ռ��� PSF
H = psf2otf(psf, size(f)); % Ƶ���� H

% �������
noise_m = 0;
noise_v = 0; 
noise_v = 5*10^-7; 
noise_v = 5*10^-4; 
noise_gaussian = noise_m + sqrt(noise_v)*randn(size(f));

% �����˻�ͼ���˶�ģ��+��˹����
% �����˶�ģ����ͼ��fb
% ���˶�ģ���͸�˹������ͼ��fbn
fb = imfilter(f,psf,'conv','circular');
figure;imshow(fb);title('�����˶�ģ�����˻�ͼ��');
fbn = fb + noise_gaussian;
figure;imshow(fbn);title('���˶�ģ�����������˻�ͼ��');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���˻�ͼ�� fbn ���и�ԭ
% ����ά���˲�����ʽд����
% ������֪�˻����� H
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������˲��� H_i
S_n = 0;
S_f = 1;
denom = (abs(H).^2).*S_f+S_n;
denom = max(denom, sqrt(eps));
H_i = (conj(H) .* S_f)./denom;

% ���ά���˲��� H_wiener
% ���� ���ű�
estimated_nsr = noise_v/var(f(:));
% ����˲���
S_n = estimated_nsr; % ��������S_n��ֵ����úõĸ�ԭЧ��
S_f = 1;
denom = (abs(H).^2).*S_f+S_n;
denom = max(denom, sqrt(eps));
H_wiener = (conj(H) .* S_f)./denom; % ά���˲���

% ��ԭ
fbni_hat = ifft2(H_i .* fft2(fbn));
fbnw_hat = ifft2(H_wiener .* fft2(fbn));

figure;imshow(fbni_hat);title('���˲�','FontSize',16);
figure;imshow(fbnw_hat);title('ά���˲�','FontSize',16);

