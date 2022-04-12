////////////////////////////////////////////////
// ConsoleApplication1.cpp /////////////////////
//
// ѧϰʹ�����º�����
// imread(), imwrite(), imshow()
// cvtColor(), applyColorMap()
// getRotationMatrix2D(), warpAffine()
// calcHist(), equalizeHist()
//
// ע�⣺ ��34�� �� ��121��122��
// imread(), imwrite()��������Ҫ��������ȷ�ļ�·��
// ��
// ������һ����
// 1. ��ǰ����·����E:\\code\\data
// 2. ��ͼƬ lena.jpg �������� data �ļ�����
// �������������޸Ĵ��룬����ͼƬ��ŵ���ȷ·��
//
////////////////////////////////////////////////

#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

int main()
{
	///////////  ��ʾ OpenCV �汾��  ////////////// 
	std::cout << "\n---------------------------------\n";
	std::cout << "OpenCV version: " << CV_VERSION << endl;
	std::cout << "\n---------------------------------\n";

	//////////////////////////////////// 
	// 1. ����һ��ͼ�� //////////////////
	Mat img = imread("E:\\code\\data\\lena.jpg");
	if (!img.empty()) {
		Size imgsize;
		imgsize = img.size();
		std::cout << "image size is: " << imgsize.height << "*" << imgsize.width << "\n";

		imshow("��ɫͼ��", img);
		cv::waitKey(0);

		// 2. ��ɫͼ��ת���ɻҶ�ͼ�� /////////////
		Mat gray;
		cvtColor(img, gray, COLOR_BGR2GRAY);
		imshow("�Ҷ�ͼ", gray);
		cv::waitKey(0);

		// 3. α��ɫ�任
		Mat cmImg;
		applyColorMap(gray, cmImg, COLORMAP_JET);
		imshow("α��ɫͼ��", cmImg);
		cv::waitKey(0);

		// 4. ����任������ת
		Mat affineImg;
		Mat M;
		M = getRotationMatrix2D(Point2f(0, 0), 45, 1);
		warpAffine(gray, affineImg, M, Size(imgsize.width, imgsize.height));
		imshow("����任����ת��", affineImg);
		cv::waitKey(0);

		//5. ����ֱ��ͼ
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
			intensity = cvRound(bin_val * hist_height / max_val);//�߶�
			rectangle(hist_img, Point(i * scale, hist_height - 1),
				Point((i + 1) * scale - 1, hist_height - intensity),
				CV_RGB(255, 255, 255));
		}
		imshow("�Ҷ�ͼ��ֱ��ͼ", hist_img);
		cv::waitKey(0);

		//6. ֱ��ͼ����
		equalizeHist(gray, dst);
		imshow("�Ҷ�ͼ�����", dst);
		waitKey(0);

		calcHist(&dst, 1, channels, Mat(),
			eqhist, 1, hist_size, ranges,
			true, false);

		minMaxLoc(eqhist, NULL, &max_val, NULL, NULL);
		eqhist_img = Mat::zeros(hist_height, bins * scale, CV_8UC3);
		for (i = 0; i < bins; i++)
		{
			bin_val = eqhist.at<float>(i);
			intensity = cvRound(bin_val * hist_height / max_val);//�߶�
			rectangle(eqhist_img, Point(i * scale, hist_height - 1),
				Point((i + 1) * scale - 1, hist_height - intensity),
				CV_RGB(255, 255, 255));
		}
		imshow("������ֱ��ͼ", eqhist_img);
		waitKey(0);

		// 7. ����ͼ�񵽴���
		imwrite("E:\\code\\data\\lenna_gray.jpg", gray);
		imwrite("E:\\code\\data\\lenna_histeq.jpg", dst);
	}
}