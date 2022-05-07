// L20220421_Morph.cpp
// 学习调用如下函数(查看OpenCV文档)：
// threshold
// erode, dilate, getStructuringElement
// morphologyEx:（MORPH_ERODE, MORPH_DILATE,
// MORPH_OPEN, MORPH_CLOSE,
// MORPH_TOPHAT, MORPH_BLACKHAT, MORPH_GRADIENT）

#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main()
{
	Mat src, dst0, dst;
	Mat element;
	Mat edge;

	if ((src = imread("../data/rice.png", IMREAD_GRAYSCALE)).empty())
		return -1;

	imshow("原图", src);
	waitKey(0);

	threshold(src, dst0, 128, 255, THRESH_OTSU);
	imshow("otsu阈值分割", dst0);
	waitKey(0);

	element = getStructuringElement(MORPH_ELLIPSE, Size(21, 21));
	morphologyEx(src, dst, MORPH_TOPHAT, element);
	imshow("顶帽滤波后", dst);
	waitKey(0);

	threshold(dst, dst, 128, 255, THRESH_OTSU);
	imshow("顶帽 + otsu", dst);
	waitKey(0);

	element = getStructuringElement(MORPH_RECT, Size(3, 3));
	morphologyEx(dst, dst, MORPH_OPEN, element);
	morphologyEx(dst, dst, MORPH_CLOSE, element);
	imshow("顶帽 + otsu + 形态学滤波（开+闭）", dst);
	waitKey(0);

	return 0;
}
