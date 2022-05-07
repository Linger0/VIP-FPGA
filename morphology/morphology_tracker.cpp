#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

Mat src, dst;
int morph_elem = 0;
int morph_size = 0;
int morph_operator = 0;
int const max_operator = 4;
int const max_elem = 2;
int const max_kernel_size = 21;
const char* window_name = "Morphology Transformations Demo";
void Morphology_Operations( int, void* );

int main()
{
	//Mat src, dst0, dst1, dst;
	Mat element;
	Mat edge;

	if ((src = imread("data/text_image.tif", IMREAD_GRAYSCALE)).empty())
		return -1;

	imshow("原图", src);
	//waitKey(0);

	//threshold(src, dst0, 0, 255, THRESH_OTSU);
	//imshow("Otsu 阈值分割", dst0);
  //imwrite("data/Otsu_global.jpg", dst0);
	//waitKey(0);

  //int block_height = src.rows / 13.5, block_width = src.cols / 11; // 块大小
  //dst1 = Mat::zeros(src.size(), src.type());
  //for (int i = 0; i < src.rows; i += block_height) {
  //  for (int j = 0; j < src.cols; j += block_width) {
  //    // 分块
  //    int w = min(src.cols - j, block_width);
  //    int h = min(src.rows - i, block_height);
  //    Mat block_src(src, Rect(j, i, w, h));
  //    Mat block_dst(dst1, Rect(j, i, w, h));
  //    // Otsu 阈值
  //    threshold(block_src, block_dst, 0, 255, THRESH_OTSU);
  //  }
  //}
  //imshow("基于图像分块的 Otsu 阈值分割", dst1);
  //imwrite("data/Otsu_block.jpg", dst1);
  //waitKey(0);

  namedWindow( window_name, WINDOW_AUTOSIZE ); // Create window
  createTrackbar("Operator:\n 0: Opening - 1: Closing  \n 2: Gradient - 3: Top Hat \n 4: Black Hat", window_name, &morph_operator, max_operator, Morphology_Operations );
  createTrackbar( "Element:\n 0: Rect - 1: Cross - 2: Ellipse", window_name,
                  &morph_elem, max_elem,
                  Morphology_Operations );
  createTrackbar( "Kernel size:\n 2n +1", window_name,
                  &morph_size, max_kernel_size,
                  Morphology_Operations );
  Morphology_Operations( 0, 0 );

	//element = getStructuringElement(MORPH_ELLIPSE, Size(3, 3));
  //cout << element << endl;
	//morphologyEx(src, dst, MORPH_BLACKHAT, element);
	//imshow("滤波后", dst);
	waitKey(0);

	//threshold(dst, dst, 0, 255, THRESH_OTSU);
	//imshow("顶帽 + otsu", dst);
	//waitKey(0);

	//element = getStructuringElement(MORPH_RECT, Size(3, 3));
	//morphologyEx(dst, dst, MORPH_OPEN, element);
	//morphologyEx(dst, dst, MORPH_CLOSE, element);
	//imshow("顶帽 + otsu + 形态学滤波（开+闭）", dst);
	//waitKey(0);

	return 0;
}
void Morphology_Operations( int, void* )
{
  // Since MORPH_X : 2,3,4,5 and 6
  int operation = morph_operator + 2;
  Mat element = getStructuringElement( morph_elem, Size( 2*morph_size + 1, 2*morph_size+1 ), Point( morph_size, morph_size ) );
  morphologyEx( src, dst, operation, element );
  imshow( window_name, dst );
}
