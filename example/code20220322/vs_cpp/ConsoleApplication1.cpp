////////////////////////////////////////////////
// ConsoleApplication1.cpp /////////////////////
//
// 学习使用如下函数：
// imread(), imwrite(), imshow()
// cvtColor(), applyColorMap()
// getRotationMatrix2D(), warpAffine()
// calcHist(), equalizeHist()
//
// 注意： 第34行 和 第121、122行
// imread(), imwrite()两个函数要给出的正确文件路径
// 即
// （方案一）：
// 1. 提前创建路径：E:\\code\\data
// 2. 将图片 lena.jpg 放在上述 data 文件夹内
// （方案二）：修改代码，给出图片存放的正确路径
//
////////////////////////////////////////////////

#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main()
{
	///////////  显示 OpenCV 版本号  ////////////// 
	std::cout << "\n---------------------------------\n";
	std::cout << "OpenCV version: " << CV_VERSION << endl;
	std::cout << "\n---------------------------------\n";

	//////////////////////////////////// 
	// 1. 读入一幅图像 //////////////////
	Mat img = imread("E:\\code\\data\\lena.jpg");
	if (!img.empty()) {
		Size imgsize;
		imgsize = img.size();
		std::cout << "image size is: " << imgsize.height << "*" << imgsize.width << "\n";

		imshow("彩色图像", img);
		cv::waitKey(0);

		// 2. 彩色图像转换成灰度图像 /////////////
		Mat gray;
		cvtColor(img, gray, COLOR_BGR2GRAY);
		imshow("灰度图", gray);
		cv::waitKey(0);

		// 3. 伪彩色变换
		Mat cmImg;
		applyColorMap(gray, cmImg, COLORMAP_JET);
		imshow("伪彩色图像", cmImg);
		cv::waitKey(0);

		// 4. 仿射变换——旋转
		Mat affineImg;
		Mat M;
		M = getRotationMatrix2D(Point2f(0, 0), 45, 1);
		warpAffine(gray, affineImg, M, Size(imgsize.width, imgsize.height));
		imshow("仿射变换后（旋转）", affineImg);
		cv::waitKey(0);

		//5. 计算直方图
		Mat hist, eqhist;
		Mat hist_img, eqhist_img;
		Mat dst;

		int bins = 256;
		int hist_size[] = { bins };
		float range[] = { 0, 256 };
		const float* ranges[] = { range };
		int channels[] = { 0 };

		int scale = 2;
		int hist_height = 256;
		double max_val;
		int intensity;
		float bin_val;
		int i;

		calcHist(&gray, 1, channels, Mat(),
			hist, 1, hist_size, ranges,
			true, false);

		minMaxLoc(hist, NULL, &max_val, NULL, NULL);
		hist_img = Mat::zeros(hist_height, bins * scale, CV_8UC3);
		for (i = 0; i < bins; i++)
		{
			bin_val = hist.at<float>(i);
			intensity = cvRound(bin_val * hist_height / max_val);//高度
			rectangle(hist_img, Point(i * scale, hist_height - 1),
				Point((i + 1) * scale - 1, hist_height - intensity),
				CV_RGB(255, 255, 255));
		}
		imshow("灰度图的直方图", hist_img);
		cv::waitKey(0);

		//6. 直方图均衡
		equalizeHist(gray, dst);
		imshow("灰度图均衡后", dst);
		waitKey(0);

		calcHist(&dst, 1, channels, Mat(),
			eqhist, 1, hist_size, ranges,
			true, false);

		minMaxLoc(eqhist, NULL, &max_val, NULL, NULL);
		eqhist_img = Mat::zeros(hist_height, bins * scale, CV_8UC3);
		for (i = 0; i < bins; i++)
		{
			bin_val = eqhist.at<float>(i);
			intensity = cvRound(bin_val * hist_height / max_val);//高度
			rectangle(eqhist_img, Point(i * scale, hist_height - 1),
				Point((i + 1) * scale - 1, hist_height - intensity),
				CV_RGB(255, 255, 255));
		}
		imshow("均衡后的直方图", eqhist_img);
		waitKey(0);

		// 7. 保存图像到磁盘
		imwrite("E:\\code\\data\\lenna_gray.jpg", gray);
		imwrite("E:\\code\\data\\lenna_histeq.jpg", dst);
	}
}