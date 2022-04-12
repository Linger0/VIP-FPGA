%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 学习使用如下函数：
% imtranslate : translates image A by the translation vector specified in translation
% imrotate : rotates image I by angle degrees in a counterclockwise direction around its center point.
% affine2d, imwarp, fitgeotrans
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;close all;clc;
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Img = imread('cameraman.tif');
figure;imshow(Img);title('input image');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate
Timg=imtranslate(Img,[50 100],'cubic');
figure;imshowpair(Img,Timg,'montage');title('translate');

% rotate
theta = 30;
Rimg = imrotate(Img,theta,'bilinear','crop');
figure;imshowpair(Img,Rimg,'montage');title('rotate');

%% %%%%%%%%%%%%%%%%%%%%%%%
% affine - rotate
theta = 30;
xform1 = [  cosd(theta)	-sind(theta)	0 ;
            sind(theta)	cosd(theta)     0 ;
            0           0               1 ];
tform = affine2d(xform1);

Rimg = imwarp(Img,tform,'linear');
figure;imshowpair(Img,Rimg,'montage');title('imwarp - rotate');

RA = imref2d(size(Img));
Rimg = imwarp(Img,tform,'linear','OutputView',RA);
figure;imshowpair(Img,Rimg,'montage');title('imwarp - rotate');


% affine - translate
xform2 = [	1	0	0
            0	1	0
            50	100	1 ]; 
tform = affine2d(xform2);

Timg = imwarp(Img,tform,'OutputView',RA);
figure;imshowpair(Img,Timg,'montage');title('imwarp - translate');


% affine - resize
xform3 = [  0.8	  0	    0 ;
            0	1.3     0 ;
            0    0      1 ];
tform = affine2d(xform3);

Simg = imwarp(Img,tform,'linear','OutputView',RA);
figure;imshowpair(Img,Simg,'montage');title('imwarp - resize');

% affine
xform = xform1*xform2*xform3;
tform = affine2d(xform);

Aimg = imwarp(Img,tform,'linear','OutputView',RA);
figure;imshowpair(Img,Aimg,'montage');title('imwarp - affine');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;clear;clc;

I = checkerboard(40);
J=imread('..\\data\\scan2.jpg');
figure;imshowpair(I,J,'montage');

fixedPoints = [41 41; 201 121; 161,281];
movingPoints = [44 19; 187 4; 223 212];

tform = fitgeotrans(movingPoints,fixedPoints,'affine');

Jregistered = imwarp(J,tform,'OutputView',imref2d(size(I)));
figure;imshow(Jregistered);
figure;imshowpair(I,Jregistered)

