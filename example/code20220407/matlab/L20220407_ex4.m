clear;clc;close all;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����ͼ��ִ�и���Ҷ�任  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = mat2gray(imread('..\\data\\car_Moire.tif'));
figure;imshow(f);title('��ֽͼ��');

%����ͼ��0��䡢ִ��FFT������
[M,N] = size(f);
U = 2*M;
V = 2*N;
F=fftshift(fft2(f,U,V));
F_show = mat2gray(log(1+abs(F)));
figure;imshow(F_show);title('���ͼ������FFT������');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ��Ʋ�����˹�ݲ������˲���  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ͼ�ֹ��ҳ��ݲ�������Ƶ��
mypoint = [110 88;110 170; 223 81; 223 163 ];
mypoint(:,1) = mypoint(:,1)-N;
mypoint(:,2) = mypoint(:,2)-M;
% ������������
u = -N:N-1;
v = -M:M-1;
[U,V] = meshgrid(u,v);
%�����˲�������
D0 = 30; % ���ý�ֹƵ��
n = 4; % 2*����
H_NR = ones(size(F));
% �ֱ���4������Ƶ��λ���Ϸ��ò�����˹��ͨ�˲���
for p = 1:length(mypoint)
    % ����Ƶ��
    D = hypot(U-mypoint(p,1),V-mypoint(p,2));% ����ÿ���㵽����Ƶ�ʵľ���
    H = 1./(1+(D0./D).^(2*n));% ������˹��ͨ�˲���
    H_NR = H.*H_NR;
    % �ԳƵ�����Ƶ��
    D = hypot(U+mypoint(p,1),V+mypoint(p,2));
    H = 1./(1+(D0./D).^(2*n));% ������˹��ͨ�˲���
    H_NR = H.*H_NR;
end
figure;imshow(mat2gray(H_NR));title('������˹�ݲ������˲���');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ƶ���˲�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G = F.*H_NR ;
figure;imshow(mat2gray(log(1+abs(G))));title('Ƶ���˲���');

% ƽ�ƣ�ִ��IFFT��ȡʵ�����ü�ͼ��
g =real(ifft2(fftshift(G)));
g = g(1:1:M,1:1:N);     

% ��ʾ���
figure;hold on;
subplot(121);imshow(f);title('ԭͼ');
subplot(122);imshow(mat2gray(g));title('�����');
