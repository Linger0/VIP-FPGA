clc;clear;close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 读取视频中指定像素的120帧的红色分量
videoReader = vision.VideoFileReader('..\\data\\visiontraffic.avi');
mypixel_1 = zeros(120,1);
for i = 1:120
    frame = step(videoReader); % read the next video frame
    img = frame;
    mypixel_1(i,:) = double(img(107,487,1))*255;
end
release(videoReader); 
figure;plot(mypixel_1,'r');

% 画出红色分量直方图
pixelhist=hist(mypixel_1,[0:255]);
figure;bar(pixelhist/120);

% 混合高斯模型 k=1
MixNumber = 1;
GMModel = fitgmdist(mypixel_1,MixNumber);
figure;bar(pixelhist/120);hold on;
for i=1:MixNumber
    x=0:0.2:255;
    Sigma = GMModel.Sigma(i);
    Sigma = sqrt(Sigma);
    mu = GMModel.mu(i);
    a = GMModel.ComponentProportion(i);
    y(i,:) = a*exp(-(x-mu).^2/(2*Sigma^2))/(Sigma*sqrt(2*pi));
    plot(x,y(i,:),'LineWidth',2);
end
axis([120 140 0 0.3]);

% 混合高斯模型 k=2
MixNumber = 2;
GMModel = fitgmdist(mypixel_1,MixNumber);
figure;bar(pixelhist/120);hold on;
for i=1:MixNumber
    x=0:0.2:255;
    Sigma = GMModel.Sigma(i);
    Sigma = sqrt(Sigma);
    mu = GMModel.mu(i);
    a = GMModel.ComponentProportion(i);
    y(i,:) = a*exp(-(x-mu).^2/(2*Sigma^2))/(Sigma*sqrt(2*pi));
    plot(x,y(i,:),'LineWidth',2);
end
Y = sum(y);
plot(x,Y,'k--','LineWidth',2);
axis([120 140 0 0.3]);

% 混合高斯模型 k=3
MixNumber = 3;
GMModel = fitgmdist(mypixel_1,MixNumber);
figure;bar(pixelhist/120);hold on;
for i=1:MixNumber
    x=0:0.2:255;
    Sigma = GMModel.Sigma(i);
    Sigma = sqrt(Sigma);
    mu = GMModel.mu(i);
    a = GMModel.ComponentProportion(i);
    y(i,:) = a*exp(-(x-mu).^2/(2*Sigma^2))/(Sigma*sqrt(2*pi));
    plot(x,y(i,:),'LineWidth',2);
end
Y = sum(y);
plot(x,Y,'k--','LineWidth',2);
axis([120 140 0 0.3]);
