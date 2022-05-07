%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ����ѧϰ����MATLABԤѵ���ļ���� %
%%%% ���ͼ�����Ƶ�е�Ŀ�겢��ǳ��� %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear;close all;

% % Read an image.
img = imread('..\\data\\Fig0427.tif');
figure;imshow(img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 1. ���ͼƬ�е�����  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a cascade detector object.
faceDetector1 = vision.CascadeObjectDetector();

% % run the detector.
bbox1 = step(faceDetector1, img);
imgOut = insertObjectAnnotation(img,'rectangle',bbox1,'Face');
imshow(imgOut);title('Detected face');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 2. ���ͼƬ�е�˫��  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a cascade detector object.
faceDetector1 = vision.CascadeObjectDetector(...
    'ClassificationModel','EyePairBig');

% % run the detector.
bbox1 = step(faceDetector1, img);
imgOut = insertObjectAnnotation(img,'rectangle',bbox1,'EyePair');
figure, imshow(imgOut), title('Detected EyePair');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 3. �����Ƶ�е�����  %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create a cascade detector object.
faceDetector = vision.CascadeObjectDetector();

% Read a video frame and run the detector.
videoFileReader = vision.VideoFileReader('visionface.avi');
videoFrame      = step(videoFileReader);
bbox            = step(faceDetector, videoFrame);

% Create a video player object for displaying video frames.
videoInfo    = info(videoFileReader);
videoPlayer  = vision.VideoPlayer(...
    'Position',[150 150 videoInfo.VideoSize+30]);

% Detect the face over successive video frames until the video is finished.
while ~isDone(videoFileReader)
    % Extract the next video frame
    videoFrame = step(videoFileReader);

    % Detect 
    bbox = step(faceDetector, videoFrame);

    % Insert a bounding box around the faces being detected
    videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox,'Face');

    % Display the annotated video frame using the video player object
    step(videoPlayer, videoOut);

end

% Release resources
release(videoFileReader);
release(videoPlayer);