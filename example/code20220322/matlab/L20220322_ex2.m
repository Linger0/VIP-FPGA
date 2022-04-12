%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% imresize
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% interpolation  %%%%%%%%%%%%
filename ='..\\data\\eye.jpg';
img = imread(filename);

img_bilinear=imresize(img,15,'bilinear');
figure;imshow(img_bilinear);title('bilinear');
