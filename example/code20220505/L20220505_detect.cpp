// L20220505_detect.cpp :
//
///////////////////////////////////////////////////////////////////
// 本例学习调用OpenCV预训练的目标（人脸、眼睛）检测器 /////////////////
// 检测图像或视频/摄像头中的目标 ///////////////////////////////////////////
// 预训练的检测器文件在OpenCV文件夹内 ////////////////////////////////
// 查看OpenCV的文件夹...\opencv\sources\data 获取更多检测器信息 //////
// 通过注释或取消注释来编译运行下列3个示例程序 ////////////////////////
//
// 注意：
// 加载检测器的路径需要修改成本机保存检测器的路径   ///////////////////
//
///////////////////////////////////////////////////////////////////

#define E2
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

/////////////////////////////////////////////////////
// 示例1. 读一张图片并检测图片中的人脸，画出矩形框  /////
/////////////////////////////////////////////////////
#ifdef E1
int main()
{
	string image_file_name, cascade_file_name;
	Mat img;

	Ptr<CascadeClassifier> classifier;

	vector<Rect> objects;
	vector<Rect>::iterator r;
	Rect r_;
	int i;

	enum { BLUE, AQUA, CYAN, GREEN };
	static Scalar colors[] = {
		Scalar(0, 0, 255),
		Scalar(0, 128, 255),
		Scalar(0, 255, 255),
		Scalar(0, 255, 0)
	};

	// 读入图像
	image_file_name = string("data/Fig0427.tif");
	//
	img = imread(image_file_name);
	imshow("图像", img);
	waitKey(0);

	// 加载人脸检测器
	cascade_file_name = string("/usr/share/opencv4/haarcascades/haarcascade_frontalface_alt2.xml");

	classifier = new CascadeClassifier(cascade_file_name);

	// 检测人脸
	classifier->detectMultiScale(img, objects, 1.1, 3, 0);

	// 画目标外框
	i = 0;
	for (r = objects.begin();
		r != objects.end(); r++, ++i)
	{
		r_ = (*r);
		rectangle(img, r_, colors[0],3);
	}

	// 显示检测结果
	imshow("人脸检测结果", img);

	waitKey(0);
	//////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////
	destroyWindow("图像");
	destroyWindow("人脸检测结果");

	exit(0);
}
#endif
//////////////////////////////////////////////////////////////////
// 示例2. 读一张图片并检测图片中的人脸和眼睛，人脸画矩形框，眼睛画圆  //
//////////////////////////////////////////////////////////////////
#ifdef E2
int main()
{
	string image_file_name, cascade_file_face, cascade_file_eye;
	Mat img;

	Ptr<CascadeClassifier> faceclassifier;
	Ptr<CascadeClassifier> eyeclassifier;

	vector<Rect> objects;
	vector<Rect>::iterator r;
	Rect r_;
	int i;
	Point center;
	int radius;


	enum { BLUE, AQUA, CYAN, GREEN };
	static Scalar colors[] = {
		Scalar(0, 0, 255),
		Scalar(0, 128, 255),
		Scalar(0, 255, 255),
		Scalar(0, 255, 0)
	};

	// 读入图像
	image_file_name = string("data/Fig0427.tif");

	img = imread(image_file_name);
	imshow("图像", img);
	waitKey(0);

	// 加载检测器
	cascade_file_face = string("/usr/share/opencv4/haarcascades/haarcascade_frontalface_alt2.xml");
	cascade_file_eye = string("/usr/share/opencv4/haarcascades/haarcascade_eye.xml");
	faceclassifier = new CascadeClassifier(cascade_file_face);
	eyeclassifier = new CascadeClassifier(cascade_file_eye);

	// 检测人脸
	faceclassifier->detectMultiScale(img, objects, 1.1, 3, 0);

	// 画目标外框（矩形框）
	i = 0;
	for (r = objects.begin();
		r != objects.end(); r++, ++i)
	{
		r_ = (*r);
		rectangle(img, r_, colors[0], 3);
	}
	// 检测眼睛
	eyeclassifier->detectMultiScale(img, objects, 1.1, 3, 0);

	// 画目标外框（圆）
	i = 0;
	for (r = objects.begin();
		r != objects.end(); r++, ++i)
	{
		r_ = (*r);
		center.x = r_.x + r_.width / 2;
		center.y = r_.y + r_.height / 2;
		radius = max(r_.height, r_.width) / 2;
		circle(img, center, radius, colors[3], 3);
	}

	// 显示检测结果
	imshow("人脸检测结果", img);
	imwrite("data/face.jpg", img);

	waitKey(0);
	//////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////
	destroyWindow("图像");
	destroyWindow("人脸检测结果");

	exit(0);
}
#endif
/////////////////////////////////////////////////////
// 示例3.  检测视频/摄像头中的 人脸，并画出矩形框  //////
/////////////////////////////////////////////////////
#ifdef E3
int main()
{
	string video_file_name, cascade_file_name;
	Mat frame;

	Ptr<CascadeClassifier> classifier;

	vector<Rect> objects;
	vector<Rect>::iterator r;
	Rect r_;
	int i;

	VideoCapture capture("data/temp.mp4");

	enum { BLUE, AQUA, CYAN, GREEN };
	static Scalar colors[] = {
		Scalar(0, 0, 255),
		Scalar(0, 128, 255),
		Scalar(0, 255, 255),
		Scalar(0, 255, 0)
	};

	//// 加载摄像头
	//capture.open(0);


	// 加载人脸检测器
	cascade_file_name = string("/usr/share/opencv4/haarcascades/haarcascade_frontalface_alt2.xml");
	classifier = new CascadeClassifier(cascade_file_name);

	// 检测视频中的人脸
	namedWindow("video", WINDOW_AUTOSIZE);
	cout << "正在检测人脸，按任意键停止检测..." << endl;
	for (;;)
	{
		capture >> frame;
		if (frame.empty()) break;

		// 检测人脸
		classifier->detectMultiScale(frame, objects, 1.1, 3, 0);

		// 画外框
		i = 0;
		for (r = objects.begin(); r != objects.end(); r++, ++i)
		{
			r_ = (*r);
			rectangle(frame, r_, colors[2],3);
		}

		// 显示结果
		imshow("video", frame);

		if (waitKey(1) >= 0) break;
	}
	//////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////

	cout << "视频检测结束，按任意键退出" << endl;
	waitKey(0);

	destroyWindow("video");
	capture.release();
	exit(0);
}
#endif
