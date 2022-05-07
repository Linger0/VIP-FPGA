// L20220419_degradation.cpp :
//

#include <opencv2/opencv.hpp>
using namespace cv;
Mat kernel_atmospheric(Size& kernel_size, const float k);

int main()
{
	Mat img, blurred, blurred_noisy; //空间图像
	Mat H_kernel; // 频域滤波器
	Mat complex_kernel, DFT_img, DFT_blurred; // 复数矩阵
	Mat temp;

	Size kernel_size;

	int addM, addN, M, N;

	//////////////////////////////////////////
	//////////////////////////////////////////
	// 读入图像
	img = imread("../data/aerial_view.tif", IMREAD_GRAYSCALE);
	img.convertTo(img, CV_32FC1);
	normalize(img, img, 1, 0, NORM_MINMAX);
	imshow("原图", img);
	waitKey(0);
	// 填充图像
	addM = getOptimalDFTSize(img.rows) - img.rows;
	addN = getOptimalDFTSize(img.cols) - img.cols;
	copyMakeBorder(img, img, 0, addM, 0, addN, BORDER_CONSTANT, Scalar::all(0));
	// 傅里叶变换
	dft(img, DFT_img, DFT_COMPLEX_OUTPUT);

	// 频谱移中
	M = img.cols / 2;
	N = img.rows / 2;

	Mat part1(DFT_img, Rect(0, 0, M, N));
	Mat part2(DFT_img, Rect(M, 0, M, N));
	Mat part3(DFT_img, Rect(0, N, M, N));
	Mat part4(DFT_img, Rect(M, N, M, N));

	part1.copyTo(temp);  //左上、右下
	part4.copyTo(part1);
	temp.copyTo(part4);

	part2.copyTo(temp);  //右上、左下
	part3.copyTo(part2);
	temp.copyTo(part3);

	//////////////////////////////////////////
	//////////////////////////////////////////
	// 退化函数
	kernel_size = img.size();
	H_kernel = kernel_atmospheric(kernel_size, 0.001);
	imshow("退化函数", H_kernel);
	waitKey(0);
	// 转换成复数退化函数
	Mat temp_kernel[] = { H_kernel, Mat::zeros(H_kernel.size(), CV_32FC1) };
	merge(temp_kernel, 2, complex_kernel);

	//////////////////////////////////////////
	//////////////////////////////////////////

	//频域滤波（ 图像退化 ）
	mulSpectrums(DFT_img, complex_kernel, DFT_blurred, 0);

	//////////////////////////////////////////
	//////////////////////////////////////////
	// 频谱移回

	Mat modified_part1(DFT_blurred, Rect(0, 0, M, N));
	Mat modified_part2(DFT_blurred, Rect(M, 0, M, N));
	Mat modified_part3(DFT_blurred, Rect(0, N, M, N));
	Mat modified_part4(DFT_blurred, Rect(M, N, M, N));

	modified_part1.copyTo(temp);  //左上、右下
	modified_part4.copyTo(modified_part1);
	temp.copyTo(modified_part4);

	modified_part2.copyTo(temp);  //右上、左下
	modified_part3.copyTo(modified_part2);
	temp.copyTo(modified_part3);

	// 傅里叶反变换
	idft(DFT_blurred, DFT_blurred);
	//分开存放实部和虚部
	Mat R_I[] = { Mat::zeros(img.size(), CV_32FC1), Mat::zeros(img.size(), CV_32FC1) };
	split(DFT_blurred, R_I);

	// 裁剪图像同原图大小
	blurred = R_I[0](cv::Rect(0, 0, img.cols, img.rows));
	//归一化并显示结果
	normalize(blurred, blurred, 255, 0, NORM_MINMAX);
	imwrite("../data/aerial_blurred.bmp", blurred);
	normalize(blurred, blurred, 1, 0, NORM_MINMAX);
	imshow("退化图像", blurred);
	waitKey(0);

	// 添加高斯噪声
	Mat noise(img.rows, img.cols, CV_32FC1);
	randn(noise, Scalar::all(0), Scalar::all(0.001));
	blurred_noisy = blurred + noise;
	imshow("噪声退化图像", blurred_noisy);
	waitKey(0);
	normalize(blurred_noisy, blurred_noisy, 255, 0, NORM_MINMAX);
	imwrite("../data/aerial_blurred_noisy.bmp", blurred_noisy);
	return 0;

}

//////////  大气湍流模型（频域）  //////////
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
