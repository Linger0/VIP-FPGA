/////////////////////////////////////////////////
// L20220426_background2.cpp :
//
// 运动目标检测 —— 背景建模  //////////////////////
//
/////////////////////////////////////////////////
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

///////////////////////////////////////////////
// 2. 背景建模 —— 平均背景法 前L帧的平均作为背景模型
// （背景模型建立后不更新）
// 平均背景法检测效果比帧差法效果好
// 观察前景与背景灰度相似时漏检
///////////////////////////////////////////////

int main()
{
	VideoCapture cap;
	int number_to_train_on;
	int frame_count;
	int key, waittime;
	Mat frame, FrameAccSum, SqAccSum, avgFrame, avgDiff, IBackground;
	Mat IhiF, IlowF;
	Mat mask, masktmp;
	Mat tmp;

	// Float, 多个单通道矩阵
	vector<Mat> Igray(3);
	vector<Mat> Ilow(3);
	vector<Mat> Ihi(3);

	// 阈值
	float high_thresh;
	float low_thresh;

	///////////////////////////////////////////////////
	//  导入视频  ////////////////////////////////
	// 初始化
	if (!cap.open("data/visiontraffic.avi"))
	{
		std::cout << "打开视频文件失败！" << endl;
		return EXIT_FAILURE;
	}
	number_to_train_on = 50;
	waittime = 25;
	high_thresh = 10.0;
	low_thresh = 10.0;
	namedWindow("背景", WINDOW_AUTOSIZE);
	moveWindow("背景", 50, 401);
	namedWindow("视频", WINDOW_AUTOSIZE);
	moveWindow("视频", 50, 1);
	namedWindow("前景目标", WINDOW_AUTOSIZE);
	moveWindow("前景目标", 660, 1);

	//  背景建模  /////
	frame_count = 0;
	cout << "正在累积前" << number_to_train_on << "帧..." << endl;

	cap >> frame;

	Size sz = frame.size();
	FrameAccSum = Mat::zeros(sz, CV_32FC3);
	SqAccSum = Mat::zeros(sz, CV_32FC3);
	accumulate(frame, FrameAccSum);
	accumulateSquare(frame, SqAccSum);
	frame_count++;

	while (1) {

		cap >> frame;
		imshow("视频", frame);

		if (!frame.data) exit(1);

		accumulate(frame, FrameAccSum);
		accumulateSquare(frame, SqAccSum);

		frame_count++;

		if ((key = waitKey(1)) == 27 || key == 'q' || key == 'Q' || frame_count >= number_to_train_on) break;
	}

	cout << "完成！" << endl;
	cout << "正在建立背景模型..." << endl;

	avgFrame = FrameAccSum / frame_count; // 计算均值
	avgDiff = (SqAccSum / frame_count) -
		(FrameAccSum.mul(FrameAccSum) / frame_count / frame_count); // 计算方差
	sqrt(avgDiff, avgDiff); // 计算标准差

	IhiF = avgFrame + (avgDiff * high_thresh);
	split(IhiF, Ihi);
	IlowF = avgFrame - (avgDiff * low_thresh);
	split(IlowF, Ilow);

	avgFrame.convertTo(IBackground, CV_8UC3);
	imshow("背景", IBackground);

	cout << "完成背景建模! 按任意键开始检测前景" << endl;
	waitKey(0);
	///////////////////////////////////////////////////

	///////////////////////////////////////////////////
	//  前景检测  ////////////////////////////////
	// 按 esc 或 q 或 Q 退出检测
	cout << "检测前景中 ..." << endl;
	cout << "（esc 或 q 或 Q 退出检测）" << endl;

	while ((key = waitKey(waittime)) != 27 || key == 'q' || key == 'Q')
	{
		cap >> frame;
		if (!frame.data) {
			cout << "检测结束！（esc 或 q 或 Q 退出检测）" << endl;
			cap.release();
			waitKey(0);
			exit(0);
		}

		frame.convertTo(tmp, CV_32FC3);
		split(tmp, Igray);
		// 判断各通道像素是否为背景
		// 通道 1
		inRange(Igray[0], Ilow[0], Ihi[0], mask);
		// 通道 2
		inRange(Igray[1], Ilow[1], Ihi[1], masktmp);
		mask = min(mask, masktmp);
		// 通道 3
		inRange(Igray[2], Ilow[2], Ihi[2], masktmp);
		mask = min(mask, masktmp);
		// 背景取反，标识前景
		mask = 255 - mask;

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

		if (cap.get(CAP_PROP_POS_FRAMES) < 343 && cap.get(CAP_PROP_POS_FRAMES) > 341)
		{
			waitKey(0); // 观察目标与背景颜色相似时漏检区域
		}


	}
	cout << "按任意键退出程序" << endl;
	waitKey(0);
	cap.release();
	exit(0);
}


