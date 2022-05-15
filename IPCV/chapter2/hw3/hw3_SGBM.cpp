#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/ximgproc.hpp>
using namespace std;
using namespace cv;
using namespace cv::ximgproc;

Mat left_img, right_img;
Mat left_disp, right_disp;
Mat left_filtered;
const char* window_name = "Left Disp";
int maxDisp = 256;
int blocksize = 11;
int uniquenessRatio = 10;
int speckleWindowSize = 200;
int speckleRange = 2;

static void GetDisp(int, void*) {
  Ptr<StereoSGBM> left_matcher = StereoSGBM::create(0, maxDisp,
    blocksize, 8*3*blocksize*blocksize, 32*3*blocksize*blocksize,
    0, 0, uniquenessRatio, speckleWindowSize,
    speckleRange , StereoSGBM::MODE_SGBM_3WAY);
  Ptr<DisparityWLSFilter> wls_filter = createDisparityWLSFilter(left_matcher);
  Ptr<StereoMatcher> right_matcher = createRightMatcher(left_matcher);

  left_matcher->compute(left_img, right_img, left_disp);
  right_matcher->compute(right_img, left_img, right_disp);

  wls_filter->filter(left_disp, left_img, left_filtered, right_disp);

  Mat left_disp_vis;
  Mat vis_cut;
  getDisparityVis(left_filtered, left_disp_vis);
  normalize(left_disp_vis, left_disp_vis, 255, 0, NORM_MINMAX);

  vis_cut = left_disp_vis(Rect(256, 0, left_img.cols-256, left_img.rows));
  imshow(window_name, vis_cut);
}

int main() {
  left_img = imread("view1.png", IMREAD_COLOR);
  right_img = imread("view5.png", IMREAD_COLOR);
  copyMakeBorder(left_img, left_img, 0, 0, 256, 0, BORDER_CONSTANT, Scalar(0,0,0));
  copyMakeBorder(right_img, right_img, 0, 0, 256, 0, BORDER_CONSTANT, Scalar(0,0,0));

  namedWindow(window_name, WINDOW_AUTOSIZE);
  createTrackbar("maxDisp", window_name, &maxDisp, 512, GetDisp);
  createTrackbar("blocksize", window_name, &blocksize, 11, GetDisp);
  createTrackbar("uniquenessRatio", window_name, &uniquenessRatio, 15, GetDisp);
  createTrackbar("speckleWindowSize", window_name, &speckleWindowSize, 200, GetDisp);
  createTrackbar("speckleRange", window_name, &speckleRange, 32, GetDisp);
  GetDisp(0, 0);

  waitKey(0);
  return 0;
}