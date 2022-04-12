////////////////////////////////////////////////
// L20220331_filters.cpp : This file contains the 'main' function. Program execution begins and ends there.
//
// 学习使用如下函数：
// blur(), medianBlur()
// Laplacian(), Sobel()
// filter2D()
//
// 提高：
//GaussianBlur(), bilateralFilter()
//
//////////////////////////////////////////////

#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
int main()
{
	// Declare variables
	Mat src, dst;


	// Loads an image
	src = imread("../data/lenna_gray.jpg");
	if (src.empty())
	{
		printf(" Error opening image\n");
		return EXIT_FAILURE;
	}
	imshow("lenna", src);
	waitKey(0);

	//////////////////////////
	////  平滑滤波  ////////
	///////////////////////
	blur(src, dst, Size(11, 11), Point(-1, -1), BORDER_DEFAULT);
	imshow("11X11 blur", dst);
	waitKey(0);
	////////////////////////
	GaussianBlur(src, dst, Size(11, 11), 0, 0, BORDER_DEFAULT);
	imshow("GaussianBlur", dst);
	waitKey(0);
	////////////////////////
	bilateralFilter(src, dst, 11, 11 * 2, 11 / 2, BORDER_DEFAULT);
	imshow("bilateralFilter", dst);
	waitKey(0);
	////////////////////////
	medianBlur(src, dst, 11);
	imshow("11X11 medianBlur", dst);
	waitKey(0);
	//////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////
	/// 导数滤波，换一幅图像
	src = imread("../data/moon.tif");
	if (src.empty())
	{
		printf(" Error opening image\n");
		return EXIT_FAILURE;
	}
	imshow("moon", src);
	waitKey(0);

	////////////////////////
	//// laplacian滤波  ////
	///////////////////////
	Laplacian(src, dst, -1, 1, 1, 0, BORDER_DEFAULT);
	imshow("Laplacian", dst);
	waitKey(0);
	////////////////////////
	////////////////////////
	//// 梯度图像  ////
	///////////////////////
	Mat grad;
	Mat sobel_x, sobel_y;
	Mat abs_sobel_x, abs_sobel_y;

	src = imread("../data/circuit.tif");
	Sobel(src, sobel_x, CV_16S, 1, 0, 1, BORDER_DEFAULT);
	Sobel(src, sobel_y, CV_16S, 0, 1, 1, BORDER_DEFAULT);

	sobel_x = abs(sobel_x);
	sobel_y = abs(sobel_y);
	grad = sobel_x + sobel_y;
	sobel_x.convertTo(sobel_x, CV_8U);
	sobel_y.convertTo(sobel_y, CV_8U);
	grad.convertTo(grad, CV_8U);
	imshow("Sobel x", sobel_x);
	waitKey(0);
	imshow("Sobel y", sobel_y);
	waitKey(0);
	imshow("Sobel Grad", grad);
	waitKey(0);

	/////////////////////////
	//// 自定义线性滤波器/////
	////////////////////////
	Mat kernel;
	kernel = Mat::ones(11, 11, CV_32F) / (float)(11 * 11);
	filter2D(src, dst, -1, kernel, Point(-1, -1), 0, BORDER_DEFAULT);
	imshow("filter2D", dst);
	waitKey(0);
	////////////////////////
}
