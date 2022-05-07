#include <opencv2/opencv.hpp>

using namespace cv;

Mat kernel_BHPF(cv::Size& kernel_size, const int D0, const int n);

int main()
{
	Mat img, padded_img, result; // 空间图像
	Mat H_kernel; // 频域滤波器
	Mat complex_kernel, DFT_img, DFT_modified; // 复数矩阵
	Mat temp;

	int addM, addN, M, N;
	int D0, n; // 截止频率、阶数

	// 读入图像
	img = imread("lenna_gray.jpg", IMREAD_GRAYSCALE);

	if (img.empty())
		return -1;

	imshow("原图", img);
	waitKey(0);

	// 填充图像，并转换为浮点数
	addM = getOptimalDFTSize(img.rows) - img.rows;
	addN = getOptimalDFTSize(img.cols) - img.cols;

	copyMakeBorder(img, padded_img, 0, addM, 0, addN, BORDER_CONSTANT, Scalar::all(0));
	padded_img.convertTo(padded_img, CV_32FC1);
	cv::Size filtersize = padded_img.size();
	// 布特沃斯高通滤波器
	D0 = 60, n = 2;
	H_kernel = kernel_BHPF(filtersize, D0, n);
	imshow("布特沃斯高通滤波器，D0=" + std::to_string(D0) + "，n=" + std::to_string(n), H_kernel);
	waitKey(0);
	// 转换成复数滤波器
	Mat temp_kernel[] = { H_kernel, Mat::zeros(H_kernel.size(), CV_32FC1) };
	merge(temp_kernel, 2, complex_kernel);

	// 傅里叶变换
	dft(padded_img, DFT_img, DFT_COMPLEX_OUTPUT);

	// DFT 移中
	M = padded_img.cols / 2;
	N = padded_img.rows / 2;

	Mat part1(DFT_img, Rect(0, 0, M, N));
	Mat part2(DFT_img, Rect(M, 0, M, N));
	Mat part3(DFT_img, Rect(0, N, M, N));
	Mat part4(DFT_img, Rect(M, N, M, N));

	part1.copyTo(temp);  // 左上、右下
	part4.copyTo(part1);
	temp.copyTo(part4);

	part2.copyTo(temp);  // 右上、左下
	part3.copyTo(part2);
	temp.copyTo(part3);

	/////////////////////////////////////////////////////
	///////     以下显示移中频谱图    ////////////////////
	/////////////////////////////////////////////////////

	Mat R_I[] = { Mat::zeros(padded_img.size(), CV_32FC1), Mat::zeros(padded_img.size(), CV_32FC1) };
	// 分开存放实部和虚部
	split(DFT_img, R_I);

	// 计算幅值
	magnitude(R_I[0], R_I[1], R_I[0]);

	// 对数变换
	R_I[0] += Scalar::all(1); // 加 1
	log(R_I[0], R_I[0]); // 计算对数
	normalize(R_I[0], R_I[0], 1, 0, NORM_MINMAX);  // 归一化

	imshow("频谱图（移中）", R_I[0]);
	waitKey(0);
	/////////////////////////////////////////////////////
	/////////////////////////////////////////////////////
	// 频域滤波（相乘）
	mulSpectrums(DFT_img, complex_kernel, DFT_modified, 0);

	// 频谱移回

	Mat modified_part1(DFT_modified, Rect(0, 0, M, N));
	Mat modified_part2(DFT_modified, Rect(M, 0, M, N));
	Mat modified_part3(DFT_modified, Rect(0, N, M, N));
	Mat modified_part4(DFT_modified, Rect(M, N, M, N));

	modified_part1.copyTo(temp);  // 左上、右下
	modified_part4.copyTo(modified_part1);
	temp.copyTo(modified_part4);

	modified_part2.copyTo(temp);  // 右上、左下
	modified_part3.copyTo(modified_part2);
	temp.copyTo(modified_part3);

	// 傅里叶反变换
	idft(DFT_modified, DFT_modified);
	// 分开存放实部和虚部
	split(DFT_modified, R_I);

	// 裁剪图像同原图大小
	result = R_I[0](cv::Rect(0, 0, img.cols, img.rows));

	// 归一化并显示结果
	normalize(result, result, 1, 0, NORM_MINMAX);
	imshow("布特沃斯高通滤波", result);
	waitKey(0);

	//result *= 255;
	//H_kernel *= 255;
	//imwrite("lenna_bhpf.jpg", result);
	//imwrite("BHPF.jpg", H_kernel);

	return 0;
}

////////////////////// 布特沃斯高通滤波器 ////////////////////////////////////
Mat kernel_BHPF(cv::Size& kernel_size, const int D0, const int n)
{
	Point kernel_center = Point(kernel_size.height / 2, kernel_size.width / 2);

	Mat kernel(kernel_size, CV_32FC1);

	for (int i = 0; i < kernel_size.height; i++) {
		for (int j = 0; j < kernel_size.width; j++) {
			double d2 = pow((i - kernel_center.x), 2) + pow((j - kernel_center.y), 2);
			double h = 1 / (1 + pow(D0*D0 / d2, n));
			kernel.at<float>(i, j) = h;
		}
	}

	return kernel;
}