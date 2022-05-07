%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% ��������MATLAB�ĵ���ʾ������ %%%%%%%%%%
%%% ��MATLAB�ĵ����� 
%%% �ɻ�ȡ����ϸ��Ϣ  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% �Լ�ѵ��һ������� %%%%%%%%%%%%%%%%%
%%% ѵ��������������ͼƬ������MATLAB��װĿ¼�� %%
%%%%% ѵ���õļ���������ڵ�ǰ����Ŀ¼�� %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load positive samples.
load('stopSignsAndCars.mat');
% Train a Cascade Object Detector
% Select the bounding boxes for stop signs from the table.
positiveInstances = stopSignsAndCars(:,1:2);

% �ṩһ��������ͼ��ͼ����ָ��Ҫ�����������ĸ���Ȥ����
% ����ʹ��ͼ���ǩ��APP��Image Labeler���ñ߿��Ǹ���Ȥ�Ķ���
% Ҳ���Դ�ͼ���вü�������Ȥ�Ķ��󣬽��䱣��Ϊ������ͼ��
% ��ʱ����Ȥ����ָ��Ϊ����ͼ��
% Add the image folder to the MATLAB path.
imDir = fullfile(matlabroot,'toolbox','vision','visiondata',...
    'stopSignImages');
addpath(imDir);

% �ṩһ�鸺����ͼ�񣬸������ɺ����Զ���ͼ�����ɡ�
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
%%%% �����Լ�ѵ���ķ����� %%%%%%%%%%%%%%%%%%%%%%%
%%%% �����Ը÷����� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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