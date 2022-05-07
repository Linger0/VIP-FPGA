/////////////////////////////////////////////////
// L20220426_background3.cpp :
//
// 运动目标检测 —— 背景建模  //////////////////////
//
/////////////////////////////////////////////////
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

///////////////////////////////////////////////
// 3. 背景建模 —— 高斯混合模型
// 调用OpenCV封装的算法：BackgroundSubtractorMOG2
// 参考OpenCV代码：
// bgfg_gaussmix2.cpp
///////////////////////////////////////////////

int main()
{
	Mat frame, IBackground;
	Mat fgMaskMOG2, outframe;
	Ptr<BackgroundSubtractorMOG2> pMOG2;
	int key, waittime;
	long number_to_train_on;
	float updaterate;
	double threshold;
	string videoFilename;

	videoFilename = "data/visiontraffic.avi";
	number_to_train_on = 50;
	updaterate = 0.05;
	threshold = 40;
	waittime = 25;
	namedWindow("视频", WINDOW_AUTOSIZE);
	moveWindow("视频", 50, 1);
	namedWindow("背景（MOG2）", WINDOW_AUTOSIZE);
	moveWindow("背景（MOG2）", 50, 401);
	namedWindow("前景（MOG2）", WINDOW_AUTOSIZE);
	moveWindow("前景（MOG2）", 660, 1);

	pMOG2 = createBackgroundSubtractorMOG2(number_to_train_on, threshold, false);
	/////////////////////////////////////////////////////////////
	//  导入视频     ////////////////////////////
	VideoCapture cap(videoFilename);
	if (!cap.isOpened())
	{
		cout << "无法打开视频: " << videoFilename << endl;
		exit(EXIT_FAILURE);
	}

	cap >> frame;
	if (!frame.data)
	{
		cout << "视频结束" << endl;
		cout << "按任意键退出程序..." << endl;
		waitKey(0);
		exit(0);
	}

	/////////////////////////////////////////////////////////////
	//  建立（更新）混合高斯背景模型  ////////////////////////////
	/////  前景检测   /////////////////////////////////////////
	cout << "正在检测前景目标..." << endl;
	cout << "（模型持续更新，更新率： " << updaterate << "）" << endl;
	while ((key = waitKey(waittime)) != 27 || key == 'q' || key == 'Q')
	{

		cap >> frame;
		if (!frame.data)
		{
			cout << "检测结束" << endl;
			cout << "按任意键退出程序..." << endl;
			cap.release();
			waitKey(0);
			exit(0);
		}

		pMOG2->apply(frame, fgMaskMOG2, updaterate);
		pMOG2->getBackgroundImage(IBackground);

		//显示 视频 和 帧序号
		stringstream ss;
		rectangle(frame, cv::Point(10, 2), cv::Point(100, 20),
			cv::Scalar(255, 255, 255), -1);
		ss << cap.get(CAP_PROP_POS_FRAMES);
		string frameNumberString = ss.str();
		putText(frame, frameNumberString.c_str(), cv::Point(15, 15),
			FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 0));
		imshow("视频", frame);
		imshow("背景（MOG2）", IBackground);
		imshow("前景（MOG2）", fgMaskMOG2);

	}
	cout << "按任意键退出程序" << endl;
	waitKey(0);
	cap.release();
	exit(0);
}