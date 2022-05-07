// L20220419_restoration.cpp :
//
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

Mat kernel_atmospheric(Size& kernel_size, const float k);
Mat kernel_BLPF(Size& kernel_size, const int D0, const int n);

int main()
{
	Mat img, result; //空间图像
	Mat H_kernel, HP_kernel; // 频域滤波器
	Mat complex_kernel, DFT_G; // 复数矩阵
	Mat H_deconv, wiener, restoration;

	Size kernel_size;
	Mat temp;

	int addM, addN, M, N;

	///////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////
	// 读入退化图像
	img = imread("../data/aerial_blurred.bmp", IMREAD_GRAYSCALE);
	//img = imread("../data/aerial_blurred_noisy.bmp", IMREAD_GRAYSCALE);
	if (img.empty()) return -1;

	img.convertTo(img, CV_32FC1);
	normalize(img, img, 1, 0, NORM_MINMAX);
	imshow("退化图像", img);
	waitKey(0);

	// 填充图像
	addM = getOptimalDFTSize(img.rows) - img.rows;
	addN = getOptimalDFTSize(img.cols) - img.cols;
	copyMakeBorder(img, img, 0, addM, 0, addN, BORDER_CONSTANT, Scalar::all(0));
	// 傅里叶变换
	dft(img, DFT_G, DFT_COMPLEX_OUTPUT);
	// 频谱移中
	M = img.cols / 2;
	N = img.rows / 2;

	Mat part1(DFT_G, Rect(0, 0, M, N));
	Mat part2(DFT_G, Rect(M, 0, M, N));
	Mat part3(DFT_G, Rect(0, N, M, N));
	Mat part4(DFT_G, Rect(M, N, M, N));

	part1.copyTo(temp);  //左上、右下
	part4.copyTo(part1);
	temp.copyTo(part4);

	part2.copyTo(temp);  //右上、左下
	part3.copyTo(part2);
	temp.copyTo(part3);

	// 此时，得到退化图像的傅里叶变换： DFT_G，中心化，复数
	///////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////

	// 退化函数
	kernel_size = img.size();
	H_kernel = kernel_atmospheric(kernel_size, 0.001);

	//HP_kernel =1 - kernel_BLPF(kernel_size, 80,2);
	//H_kernel = (H_kernel +  HP_kernel);

	imshow("退化函数", H_kernel);
	waitKey(0);
	///////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////

	//逆滤波器 H_deconv
	H_deconv = 1. / (H_kernel);
	// 转换成复数逆滤波器 complex_kernel
	Mat temp_kernel[] = { H_deconv, Mat::zeros(H_deconv.size(), CV_32FC1) };
	merge(temp_kernel, 2, complex_kernel);
	// 逆滤波操作
	mulSpectrums(complex_kernel, DFT_G, restoration, 0);

	////维纳滤波
	//wiener = 1. / (H_kernel + 0.04);
	////// 转换成复数维纳滤波器 complex_kernel
	//Mat temp_kernel[] = { wiener, Mat::zeros(wiener.size(), CV_32FC1) };
	//merge(temp_kernel, 2, complex_kernel);
	////// 逆滤波操作
	//mulSpectrums(complex_kernel, DFT_G, restoration, 0);

	// 此时，得到复原图像的傅里叶变换：restoration
	// 中心化，复数
	///////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////
	// 频谱移回
	Mat modified_part11(restoration, Rect(0, 0, M, N));
	Mat modified_part22(restoration, Rect(M, 0, M, N));
	Mat modified_part33(restoration, Rect(0, N, M, N));
	Mat modified_part44(restoration, Rect(M, N, M, N));

	modified_part11.copyTo(temp);  //左上、右下
	modified_part44.copyTo(modified_part11);
	temp.copyTo(modified_part44);

	modified_part22.copyTo(temp);  //右上、左下
	modified_part33.copyTo(modified_part22);
	temp.copyTo(modified_part33);

	// 傅里叶反变换，取实部
	idft(restoration, restoration);
	Mat R_I[] = { Mat::zeros(img.size(), CV_32FC1), Mat::zeros(img.size(), CV_32FC1) };
	split(restoration, R_I);
	result = R_I[0];
	//归一化并显示结果
	normalize(result, result, 1, 0, NORM_MINMAX);
	imshow("复原图像", result);
	waitKey(0);

	return 0;
}

//////////////////////  大气湍流模型（频域）  ////////////////////////////////////
Mat kernel_atmospheric(Size& kernel_size, const float k)
{
	float f_temp;
	int u, v;

	Point kernel_center = Point(kernel_size.height / 2, kernel_size.width / 2);

	Mat kernel(kernel_size, CV_32FC1);// 32位浮点单通道

	for (u = 0; u < kernel_size.height; u++) {
		for (v = 0; v < kernel_size.width; v++) {
			f_temp = pow((u - kernel_center.x), 2) + pow((v - kernel_center.y), 2);
			f_temp = exp(-k * f_temp);
			f_temp = pow(f_temp, 5. / 6.);
			kernel.at<float>(u, v) = f_temp;
		}
	}
	return kernel;
}


//////////////////////布特沃斯低通滤波器////////////////////////////////////
Mat kernel_BLPF(Size& kernel_size, const int D0, const int n)
{
	float D_squre;
	Point kernel_center = Point(kernel_size.height / 2, kernel_size.width / 2);

	Mat kernel(kernel_size, CV_32FC1);// 32位浮点单通道

	for (int i = 0; i < kernel_size.height; i++) {
		for (int j = 0; j < kernel_size.width; j++) {
			D_squre = pow((i - kernel_center.x), 2) + pow((j - kernel_center.y), 2);
			kernel.at<float>(i, j) = 1 / (1 + pow(D_squre, n) / pow(D0, 2 * n));
		}
	}
	return kernel;
}
