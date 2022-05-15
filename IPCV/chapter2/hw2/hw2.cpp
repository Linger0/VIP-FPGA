#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/xfeatures2d.hpp>
using namespace std;
using namespace cv;
using namespace cv::xfeatures2d;

int main() {
  Mat src1, src2;
  Mat dst;
  src1 = imread("building_02.jpg", IMREAD_COLOR);
  src2 = imread("building_03.jpg", IMREAD_COLOR);

  // 1: SURF 检测
  int minHessian = 400;
  Ptr<SURF> detector = SURF::create(minHessian);
  vector<KeyPoint> keypoints1, keypoints2;
  Mat descriptors1, descriptors2;
  detector->detectAndCompute(src1, noArray(), keypoints1, descriptors1);
  detector->detectAndCompute(src2, noArray(), keypoints2, descriptors2);

  // 2: 特征匹配
  Ptr<DescriptorMatcher> matcher = DescriptorMatcher::create(DescriptorMatcher::FLANNBASED);
  vector<vector<DMatch>> knn_matches;
  matcher->knnMatch(descriptors1, descriptors2, knn_matches, 2);

  const float ratio_thresh = 0.7f;
  vector<DMatch> good_matches;
  for (size_t i = 0; i < knn_matches.size(); i++) {
    if (knn_matches[i][0].distance < ratio_thresh * knn_matches[i][1].distance) {
      good_matches.push_back(knn_matches[i][0]);
    }
  }
  // Show image.
  Mat img_matches;
  drawMatches(src1, keypoints1, src2, keypoints2, good_matches, img_matches, Scalar::all(-1),
                Scalar::all(-1), std::vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
  imwrite("Matches.jpg", img_matches);

  // 3: 单应变换
  vector<Point2f> pts1;
  vector<Point2f> pts2;
  Mat tdst;
  for (size_t i = 0; i < good_matches.size(); i++) {
    pts1.push_back(keypoints1[good_matches[i].queryIdx].pt);
    pts2.push_back(keypoints2[good_matches[i].trainIdx].pt);
  }
  Mat H = findHomography(pts2, pts1, RANSAC);
  warpPerspective(src2, tdst, H, Size(src1.cols + src2.cols, src1.rows));
  tdst.copyTo(dst);
  src1.copyTo(dst(Rect(0, 0, src1.cols, src1.rows)));
  imwrite("Transform.jpg", tdst);

  // 4: 接缝融合
  vector<Point2f> src2_corners, src2_dst_corners;
  int x_min, x_max = src1.cols;
  src2_corners.push_back(Point2f(0, 0));
  src2_corners.push_back(Point2f(0, src2.rows));
  perspectiveTransform(src2_corners, src2_dst_corners, H);
  x_min = min(src2_dst_corners[0].x, src2_dst_corners[1].x);
  for (int i = x_min; i < x_max; i++) {
    int begin = 0;
    for (int j = 0; j < src1.rows; j++) {
      float alpha = (float)(i - x_min) / (x_max - x_min);
      vector<float> px1(3), px2(3);
      for (int k = 0; k < 3; k++) {
        px1[k] = (float)src1.ptr<uchar>(j, i)[k];
        px2[k] = (float)tdst.ptr<uchar>(j, i)[k];
      }
      if (sum(px1)[0] > 0 && sum(px2)[0] > 0) {
        if (j == 0) { begin = 1; }
        if (begin < 1) { begin++; continue; }
        for (int k = 0; k < 3; k++) {
          // 加权融合
          dst.at<Vec3b>(j, i)[k] = (1-alpha) * px1[k] + alpha * px2[k];
        }
      }
    }
  }
  imshow("Result 1", dst);

  // 裁剪
  int x_cut;
  for (int i = 0; i < dst.cols; i++) {
    if (sum(dst.at<Vec3b>(0, i))[0] == 0 || sum(dst.at<Vec3b>(dst.rows-1, i))[0] == 0) {
      x_cut = i;
      break;
    }
  }
  dst = dst(Rect(0, 0, x_cut, dst.rows));

  imshow("Result 2", dst);
  imwrite("Result.jpg", dst);

  while (waitKey(0) != 'x') {}
  return 0;
}