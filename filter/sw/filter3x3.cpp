#include <iostream>
#include <opencv2/opencv.hpp>
using namespace std;
using namespace cv;

cv::Mat medianFilter3x3(cv::Mat& img);
void sort3(uint8_t data0, uint8_t data1, uint8_t data2,
           uint8_t* max, uint8_t* med, uint8_t* min);
cv::Mat meanFilter3x3(cv::Mat& img);

int main() {
  Mat img, post_img;
  img = imread("data/lenna_noise.jpg", IMREAD_GRAYSCALE);
  if (img.empty()) return -1;
  imshow("原图", img);
  waitKey();

  post_img = medianFilter3x3(img);
  imshow("中值滤波", post_img);
  imwrite("data/lenna_median.jpg", post_img);
  waitKey();

  post_img = meanFilter3x3(img);
  imshow("均值滤波", post_img);
  imwrite("data/lenna_mean.jpg", post_img);
  waitKey();
}

void sort3(uint8_t data0, uint8_t data1, uint8_t data2,
           uint8_t* max, uint8_t* med, uint8_t* min) {
  // get the max value
  if (data0 >= data1 && data0 >= data2)
    { if (max > 0) *max = data0; }
  else if (data1 >= data0 && data1 >= data2)
    { if (max > 0) *max = data1; }
  else // (data2 >= data0 && data2 >= data1)
    { if (max > 0) *max = data2; }

  // get the mid value
  if ((data0 >= data1 && data0 <= data2) || (data0 >= data2 && data0 <= data1))
    { if (med > 0) *med = data0; }
  else if ((data1 >= data0 && data1 <= data2) || (data1 >= data2 && data1 <= data0))
    { if (med > 0) *med = data1; }
  else // ((data2 >= data0 && data2 <= data1) || (data2 >= data1 && data2 <= data0))
    { if (med > 0) *med = data2; }

  // get the min value
  if (data0 <= data1 && data0 <= data2)
    { if (min > 0) *min = data0; }
  else if (data1 <= data0 && data1 <= data2)
    { if (min > 0) *min = data1; }
  else // (data2 <= data0 && data2 <= data1)
    { if (min > 0) *min = data2; }
}

cv::Mat medianFilter3x3(cv::Mat& img) {
  // 镜像填充：上下左右各填充一个像素
  Mat pad_img, med_img;
  copyMakeBorder(img, pad_img, 1, 1, 1, 1, BORDER_REFLECT);
  img.copyTo(med_img);

  for (int i = 1; i < pad_img.rows - 1; i++) {
    for (int j = 1; j < pad_img.cols - 1; j++) {
      // 找到九个像素的中值
      uint8_t max0, med0, min0, max1, med1, min1, max2, med2, min2;
      uint8_t min_max, med_med, max_min, out;
      sort3(pad_img.at<uint8_t>(i-1, j-1), pad_img.at<uint8_t>(i-1, j),
            pad_img.at<uint8_t>(i-1, j+1),
            &max0, &med0, &min0);
      sort3(pad_img.at<uint8_t>(i, j-1), pad_img.at<uint8_t>(i, j),
            pad_img.at<uint8_t>(i, j+1),
            &max1, &med1, &min1);
      sort3(pad_img.at<uint8_t>(i+1, j-1), pad_img.at<uint8_t>(i+1, j),
            pad_img.at<uint8_t>(i+1, j+1),
            &max2, &med2, &min2);
      sort3(max0, max1, max2, 0, 0, &min_max);
      sort3(med0, med1, med2, 0, &med_med, 0);
      sort3(min0, min1, min2, &max_min, 0, 0);
      sort3(min_max, med_med, max_min, 0, &out, 0);
      med_img.at<uint8_t>(i-1, j-1) = out;
    }
  }
  return med_img;
}

cv::Mat meanFilter3x3(cv::Mat& img) {
  // 镜像填充：上下左右各填充一个像素
  Mat pad_img, mean_img;
  copyMakeBorder(img, pad_img, 1, 1, 1, 1, BORDER_REFLECT);
  img.copyTo(mean_img);

  for (int i = 1; i < pad_img.rows - 1; i++) {
    for (int j = 1; j < pad_img.cols - 1; j++) {
      // 求九个像素的均值
      uint32_t out;
      out = (pad_img.at<uint8_t>(i-1, j-1) +
             pad_img.at<uint8_t>(i-1, j)   +
             pad_img.at<uint8_t>(i-1, j+1) +
             pad_img.at<uint8_t>(i, j-1)   +
             pad_img.at<uint8_t>(i, j)     +
             pad_img.at<uint8_t>(i, j+1)   +
             pad_img.at<uint8_t>(i+1, j-1) +
             pad_img.at<uint8_t>(i+1, j)   +
             pad_img.at<uint8_t>(i+1, j+1)) / 9;
      mean_img.at<uint8_t>(i-1, j-1) = out;
    }
  }
  return mean_img;
}