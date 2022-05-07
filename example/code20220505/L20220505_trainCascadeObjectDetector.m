%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% 本例来自MATLAB文档的示例程序 %%%%%%%%%%
%%% 在MATLAB文档搜索 
%%% 可获取更详细信息  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% 自己训练一个检测器 %%%%%%%%%%%%%%%%%
%%% 训练、测试样本（图片）均在MATLAB安装目录下 %%
%%%%% 训练好的检测器保存在当前工作目录下 %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load positive samples.
load('stopSignsAndCars.mat');
% Train a Cascade Object Detector
% Select the bounding boxes for stop signs from the table.
positiveInstances = stopSignsAndCars(:,1:2);

% 提供一组正样本图像，图像中指定要用作正样本的感兴趣区域，
% 可以使用图像标签器APP“Image Labeler”用边框标记感兴趣的对象。
% 也可以从图像中裁剪出感兴趣的对象，将其保存为单独的图像，
% 此时感兴趣区域指定为整个图像。
% Add the image folder to the MATLAB path.
imDir = fullfile(matlabroot,'toolbox','vision','visiondata',...
    'stopSignImages');
addpath(imDir);

% 提供一组负样本图像，负样本由函数自动从图中生成。
% Specify the folder for negative images.
negativeFolder = fullfile(matlabroot,'toolbox','vision','visiondata',...
    'nonStopSigns');
% Create an imageDatastore object containing negative images.
negativeImages = imageDatastore(negativeFolder);

% Train a cascade object detector called 'stopSignDetector.xml'
% using HOG features.( Haar | LBP )
% NOTE: The command can take several minutes to run.
trainCascadeObjectDetector('stopSignDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5,...
    'FeatureType','HOG');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 加载自己训练的分类器 %%%%%%%%%%%%%%%%%%%%%%%
%%%% 并测试该分类器 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use the newly trained classifier to detect a stop sign in an image.
detector = vision.CascadeObjectDetector('stopSignDetector.xml');

% Read the test image.
img = imread('stopSignTest.jpg');

% Detect a stop sign.
bbox = detector(img);

% Insert bounding box rectangles and return the marked image.
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');

% Display the detected stop sign.
figure; imshow(detectedImg);

% Remove the image directory from the path.
rmpath(imDir);