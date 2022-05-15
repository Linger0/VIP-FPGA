#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/ximgproc.hpp>
#include <opencv2/xfeatures2d.hpp>
using namespace std;
using namespace cv;
using namespace cv::ximgproc;
using namespace cv::xfeatures2d;

int main() {
  Mat left_img, right_img;
  Mat dst;
  const double focal = 3740.0;
  Point2d principal_point;

  left_img = imread("view1.png", IMREAD_COLOR);
  right_img = imread("view5.png", IMREAD_COLOR);
  cout << left_img.size() << endl << right_img.size() << endl;

  principal_point.x = left_img.cols / 2.0;
  principal_point.y = left_img.rows / 2.0;
  Mat K = (Mat_<double>(3, 3) <<
    focal, 0, principal_point.x,
    0, focal, principal_point.y,
    0, 0, 1);
  Mat distCoeffs = Mat::zeros(4, 1, CV_64F);

  // 1: SIFT 检测
  int minHessian = 400;
  Ptr<SIFT> detector = SIFT::create(minHessian);
  vector<KeyPoint> keypoints1, keypoints2;
  Mat descriptors1, descriptors2;
  detector->detectAndCompute(left_img, noArray(), keypoints1, descriptors1);
  detector->detectAndCompute(right_img, noArray(), keypoints2, descriptors2);

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
  drawMatches( left_img, keypoints1, right_img, keypoints2, good_matches, img_matches, Scalar::all(-1),
                Scalar::all(-1), std::vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
  imshow("Matches", img_matches);

  // 3: 基础矩阵
  vector<Point2i> pts1, pts2;
  vector<uchar> inlier_mask;
  for (size_t i = 0; i < good_matches.size(); i++) {
    pts1.push_back(keypoints1[good_matches[i].queryIdx].pt);
    pts2.push_back(keypoints2[good_matches[i].trainIdx].pt);
  }
  vector<Point2f> inliers1;
  vector<Point2f> inliers2;
  Mat F = findFundamentalMat(pts1, pts2, inlier_mask, RANSAC);
  for (size_t i = 0; i < inlier_mask.size(); i++) {
    if (inlier_mask[i]) {
      inliers1.push_back(pts1[i]);
      inliers2.push_back(pts2[i]);
    }
  }

  Mat H1, H2;
  stereoRectifyUncalibrated(inliers1, inliers2, F, left_img.size(), H1, H2);

  warpPerspective(left_img, left_img, H1, left_img.size());
  warpPerspective(right_img, right_img, H2, right_img.size());

  vector<Mat> concat_imgs;
  concat_imgs.push_back(left_img);
  concat_imgs.push_back(right_img);
  hconcat(concat_imgs, dst);
  imwrite("rect.jpg", dst);
  waitKey(0);
}
