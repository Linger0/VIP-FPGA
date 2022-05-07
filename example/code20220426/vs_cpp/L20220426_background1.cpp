/////////////////////////////////////////////////
// L20220426_background1.cpp :
//
// 运动目标检测 —— 背景建模  //////////////////////
//
/////////////////////////////////////////////////
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

/////////////////////////////////////////////////
//// 1. 背景建模 —— 相邻帧差法 —— visiontraffic.avi
////  观察帧差法产生的伪影和空洞
/////////////////////////////////////////////////

int main()
{
	VideoCapture cap;
	Size sz;

	Mat frame, i_Background;
	Mat diffFrame, f_Background, currFrame;
	Mat mask, masktmp;

	int key, waittime;
	float thresh, updaterate;
	vector<Mat> Igray(3);// Float, 3个单通道矩阵，分别用于对R、G、B通道进行形态学处理

	// 初始化
	if (!cap.open("data/visiontraffic.avi"))
	{
		std::cout << "打开视频文件失败！" << endl;
		return EXIT_FAILURE;
	}
	thresh = 50;//帧差阈值
	waittime = 25;//每帧播放间隔时长ms，不含处理时长；（依据视频的帧率调整）
	updaterate = 0.01;//背景更新率, 0.0-1.0
	namedWindow("视频", WINDOW_AUTOSIZE);
	moveWindow("视频", 20, 0);
	namedWindow("背景", WINDOW_AUTOSIZE);
	moveWindow("背景", 20, 400);
	namedWindow("前景目标", WINDOW_AUTOSIZE);
	moveWindow("前景目标", 670, 0);

	///////////////////////////////////////////////////
	// 初始化内存  ////////////////////////////////////
	cap >> frame;// 读取一帧

	sz = frame.size();
	i_Background = Mat::zeros(sz, CV_8UC3); // 整型，用于显示
	f_Background = Mat::zeros(sz, CV_32FC3); // 浮点，用于计算
	diffFrame = Mat::zeros(sz, CV_32FC3);
	currFrame = Mat::zeros(sz, CV_32FC3);

	// 初始化 背景  ////////////////////////////////////
	imshow("视频", frame);
	frame.copyTo(i_Background); // 用第一帧初始化背景
	imshow("背景", i_Background);
	i_Background.convertTo(f_Background, CV_32FC3);
	cout << "按任意键开始检测前景目标" << endl;
	waitKey(0);
	///////////////////////////////////////////////////

	///////////////////////////////////////////////////
	//  前景检测  ////////////////////////////////
	// 按 esc 或 q 或 Q 退出检测
	cout << "检测前景中 ..." << endl;
	cout << "（按Esc键退出检测）" << endl;

	while ((key = waitKey(waittime)) != 27)
	{
		cap >> frame;
		if (!frame.data)
		{
			cout << "视频结束" << endl;
			cout << "按任意键退出程序..." << endl;
			cap.release();
			waitKey(0);
			exit(0);
		}
		frame.convertTo(currFrame, CV_32FC3);

		// 检测当前帧的前景目标  ///////////////////////////////
		diffFrame = abs(currFrame - f_Background);
		split(diffFrame, Igray); // 帧差分成3个单通道矩阵，用于后续计算

		// 判断各通道像素是否为背景
		// 通道 1
		mask = Igray[0] < thresh;
		// 通道 2
		masktmp = Igray[1] < thresh;
		mask = min(mask, masktmp);
		// 通道 3
		masktmp = Igray[2] < thresh;
		mask = min(mask, masktmp);
		// 背景取反，标识前景
		mask = 255 - mask;

		//  显示结果  ////////////////////////////
		// 显示视频图像 、 帧序号
		stringstream ss;
		rectangle(frame, cv::Point(10, 2), cv::Point(100, 20),
			cv::Scalar(255, 255, 255), -1);
		ss << cap.get(CAP_PROP_POS_FRAMES);
		string frameNumberString = ss.str();
		putText(frame, frameNumberString.c_str(), cv::Point(15, 15),
			FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 0));
		imshow("视频", frame);
		// 显示前景二值图像
		imshow("前景目标", mask);
		// 显示背景图像
		imshow("背景", i_Background);

		// 更新背景  ///////////////////////////////
		currFrame.copyTo(f_Background); // 当前帧降级为背景; 注意：这里不能直接令矩阵相等
		//f_Background = (1.0 - updaterate) * f_Background + updaterate * currFrame;
		f_Background.convertTo(i_Background, CV_8UC3);

		///////////////////////////////////
		if (cap.get(CAP_PROP_POS_FRAMES) < 151 && cap.get(CAP_PROP_POS_FRAMES) > 149)
		{
			waitKey(0); // 观察此时产生的伪影和空洞
		}
		if (cap.get(CAP_PROP_POS_FRAMES) < 170 && cap.get(CAP_PROP_POS_FRAMES) > 168)
		{
			waitKey(0); // 观察此时产生的伪影和空洞
		}
		if (cap.get(CAP_PROP_POS_FRAMES) > 327)
		{
			waitKey(0);
			cap.release();
			exit(0);
		}
	}
	cout << "按任意键退出程序" << endl;
	waitKey(0);
	cap.release();
	exit(0);
}
