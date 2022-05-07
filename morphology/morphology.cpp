#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

int main()
{
	Mat src, dst0, dst1, dst;
	Mat element;
	Mat edge;

	if ((src = imread("data/text_image.tif", IMREAD_GRAYSCALE)).empty())
		return -1;

	imshow("原图", src);
	waitKey(0);

	threshold(src, dst0, 0, 255, THRESH_OTSU);
	imshow("Otsu 阈值分割", dst0);
	waitKey(0);

  int block_height = src.rows / 13.5, block_width = src.cols / 11; // 块大小
  dst1 = Mat::zeros(src.size(), src.type());
  for (int i = 0; i < src.rows; i += block_height) {
    for (int j = 0; j < src.cols; j += block_width) {
      // 分块
      int w = min(src.cols - j, block_width);
      int h = min(src.rows - i, block_height);
      Mat block_src(src, Rect(j, i, w, h));
      Mat block_dst(dst1, Rect(j, i, w, h));
      // Otsu 阈值
      threshold(block_src, block_dst, 0, 255, THRESH_OTSU);
    }
  }
  imshow("基于图像分块的 Otsu 阈值分割", dst1);
  waitKey(0);

	element = getStructuringElement(MORPH_ELLIPSE, Size(21, 21));
	morphologyEx(src, dst, MORPH_BLACKHAT, element);
	imshow("黑帽滤波后", dst);
	waitKey(0);

  threshold(dst, dst, 10, 255, THRESH_BINARY_INV);
  imshow("黑帽 + 全局阈值分割", dst);
  waitKey(0);

	return 0;
}
