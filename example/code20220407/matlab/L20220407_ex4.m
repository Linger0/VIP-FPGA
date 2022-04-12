clear;clc;close all;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 加载图像，执行傅里叶变换  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = mat2gray(imread('..\\data\\car_Moire.tif'));
figure;imshow(f);title('报纸图像');

%空域图像0填充、执行FFT，移中
[M,N] = size(f);
U = 2*M;
V = 2*N;
F=fftshift(fft2(f,U,V));
F_show = mat2gray(log(1+abs(F)));
figure;imshow(F_show);title('填充图像后进行FFT并移中');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 设计布特沃斯陷波带阻滤波器  %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 依据上图手工找出陷波的中心频率
mypoint = [110 88;110 170; 223 81; 223 163 ];
mypoint(:,1) = mypoint(:,1)-N;
mypoint(:,2) = mypoint(:,2)-M;
% 生成网格坐标
u = -N:N-1;
v = -M:M-1;
[U,V] = meshgrid(u,v);
%设置滤波器参数
D0 = 30; % 设置截止频率
n = 4; % 2*阶数
H_NR = ones(size(F));
% 分别在4对中心频率位置上放置布特沃斯高通滤波器
for p = 1:length(mypoint)
    % 中心频率
    D = hypot(U-mypoint(p,1),V-mypoint(p,2));% 计算每个点到中心频率的距离
    H = 1./(1+(D0./D).^(2*n));% 布特沃斯高通滤波器
    H_NR = H.*H_NR;
    % 对称的中心频率
    D = hypot(U+mypoint(p,1),V+mypoint(p,2));
    H = 1./(1+(D0./D).^(2*n));% 布特沃斯高通滤波器
    H_NR = H.*H_NR;
end
figure;imshow(mat2gray(H_NR));title('布特沃斯陷波带阻滤波器');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 频域滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
G = F.*H_NR ;
figure;imshow(mat2gray(log(1+abs(G))));title('频域滤波后');

% 平移，执行IFFT，取实部，裁剪图像
g =real(ifft2(fftshift(G)));
g = g(1:1:M,1:1:N);     

% 显示结果
figure;hold on;
subplot(121);imshow(f);title('原图');
subplot(122);imshow(mat2gray(g));title('处理后');
