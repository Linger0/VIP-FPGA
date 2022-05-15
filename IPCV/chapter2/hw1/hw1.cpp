#include <iostream>
#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

Mat src, src_gray;
Mat dst;
Mat detected_edges;
Mat bdst;
Mat H;
Mat hdst;
vector<Vec2f> lines;
vector<Point> pts;

const char* window_name = "Tuning";
int blurSize = 5;
int cannyLowThreshold = 52;
int houghThreshold = 170;

// 滤除多余直线
vector<Vec2f> FilterLines(vector<Vec2f>& lines) {
  vector<vector<Vec2f>> part(4);
  vector<Vec2f> ret(4);
  for (size_t i = 0; i < lines.size(); i++) { // 分成左、上、右、下
    float rho = lines[i][0], theta = lines[i][1];
    if (abs(sin(theta)) < 0.5) {
      if (abs(rho) < src.cols/2) {
        part[0].push_back(lines[i]);
      } else {
        part[2].push_back(lines[i]);
      }
    } else {
      if (abs(rho) < src.rows/2) {
        part[1].push_back(lines[i]);
      } else {
        part[3].push_back(lines[i]);
      }
    }
  }
  for (int i = 0; i < 2; i++) { // 左、上：找 rho 最大的
    if (part[i].empty()) { return lines; }
    ret[i] = part[i][0];
    for (size_t j = 1; j < part[i].size(); j++) {
      float rho = part[i][j][0];
      if (abs(rho) > abs(ret[i][0])) {
        ret[i] = part[i][j];
      }
    }
  }
  for (int i = 2; i < 4; i++) { // 右、下：找 rho 最小的
    if (part[i].empty()) { return lines; }
    ret[i] = part[i][0];
    for (size_t j = 1; j < part[i].size(); j++) {
      float rho = part[i][j][0];
      if (abs(rho) < abs(ret[i][0])) {
        ret[i] = part[i][j];
      }
    }
  }
  return ret;
}

// 获取直线的四个交点
vector<Point> Intersect(vector<Vec2f>& lines) {
  vector<Point> ret;

  for (size_t i = 0; i < lines.size(); i++) {
    int j = (i < 3) ? i + 1 : 0;
    float rhoi = lines[i][0], thetai = lines[i][1];
    float rhoj = lines[j][0], thetaj = lines[j][1];

    Mat A(2, 2, CV_64F);
    Mat b(2, 1, CV_64F);
    Mat X(b);
    A.at<double>(0, 0) = cos(thetai);
    A.at<double>(0, 1) = sin(thetai);
    A.at<double>(1, 0) = cos(thetaj);
    A.at<double>(1, 1) = sin(thetaj);
    b.at<double>(0, 0) = rhoi;
    b.at<double>(1, 0) = rhoj;
    solve(A, b, X, DECOMP_LU);
    ret.push_back(Point(X.at<double>(0, 0), X.at<double>(1, 0)));
  }

  return ret;
}

static void TuningThreshold(int, void*) {
  blur(src_gray, bdst, Size(blurSize,blurSize));
  Canny(bdst, detected_edges, cannyLowThreshold, cannyLowThreshold*3, 3);
  imshow("Canny 边缘检测", detected_edges);

  HoughLines(detected_edges, lines, 1, CV_PI/180, houghThreshold, 0, 0);

  Mat ldst = src.clone();
  for (size_t i = 0; i < lines.size(); i++) {
    float rho = lines[i][0], theta = lines[i][1];
    Point pt1, pt2;
    double a = cos(theta), b = sin(theta);
    double x0 = a*rho, y0 = b*rho;
    pt1.x = cvRound(x0 + 1000*(-b));
    pt1.y = cvRound(y0 + 1000*(a));
    pt2.x = cvRound(x0 - 1000*(-b));
    pt2.y = cvRound(y0 - 1000*(a));
    line(ldst, pt1, pt2, Scalar(0,0,255), 3, LINE_AA);
  }
  imshow("Hough 直线", ldst);

  lines = FilterLines(lines);
  pts = Intersect(lines);

  // Draw the lines and points
  Mat cdst = src.clone();
  putText(cdst, to_string( lines.size() ), Point(10,40),
    FONT_HERSHEY_SIMPLEX, 1, Scalar(255,0,0));
  for (size_t i = 0; i < lines.size(); i++) {
    float rho = lines[i][0], theta = lines[i][1];
    Point pt1, pt2;
    double a = cos(theta), b = sin(theta);
    double x0 = a*rho, y0 = b*rho;
    pt1.x = cvRound(x0 + 1000*(-b));
    pt1.y = cvRound(y0 + 1000*(a));
    pt2.x = cvRound(x0 - 1000*(-b));
    pt2.y = cvRound(y0 - 1000*(a));
    line(cdst, pt1, pt2, Scalar(0,0,255), 3, LINE_AA);
  }
  for (size_t i = 0; i < pts.size(); i++) {
    circle(cdst, pts[i], 5, Scalar(0,255,0), -1);
  }
  imshow("交点", cdst);

#ifndef TUNE
  dst.create(src.cols*3/4, src.cols, src.type());
  vector<Point> dst_corner = {Point(0, 0), Point(dst.cols-1, 0),
    Point(dst.cols-1, dst.rows-1), Point(0, dst.rows-1)};
  H = findHomography(pts, dst_corner, RANSAC);
  warpPerspective(src, dst, H, dst.size());
  imshow("单应变换", dst);

  imwrite("edge.jpg", detected_edges);
  imwrite("lines.jpg", ldst);
  imwrite("points.jpg", cdst);
  imwrite("transform.jpg", dst);
#endif
}

int main(int argc, char** argv) {
  src = imread(argv[1], IMREAD_COLOR);
  if (src.empty()) {
    cout << "Could not open or find the image!" << endl;
    return -1;
  }

  cvtColor(src, src_gray, COLOR_BGR2GRAY);

  //namedWindow(window_name, WINDOW_AUTOSIZE);
  //createTrackbar("Blur:", window_name, &blurSize, 20, TuningThreshold);
  //createTrackbar("Min Threshold:", window_name, &cannyLowThreshold, 100, TuningThreshold);
  //createTrackbar("Threshold:", window_name, &houghThreshold, 500, TuningThreshold);
  //TuningThreshold(0, 0);

  //// 1: Blur & Canny
  blur(src_gray, bdst, Size(blurSize,blurSize));
  Canny(bdst, detected_edges, cannyLowThreshold, cannyLowThreshold*3, 3);
  // 2: Hough & Intersections
  HoughLines(detected_edges, lines, 1, CV_PI/180, houghThreshold, 0, 0);
  lines = FilterLines(lines);
  pts = Intersect(lines);
  // 3: Homography transform
  dst.create(src.cols*3/4, src.cols, src.type());  // 创建长宽比为 4:3 结果图像
  vector<Point> dst_corner = {Point(0, 0), Point(dst.cols-1, 0),
    Point(dst.cols-1, dst.rows-1), Point(0, dst.rows-1)};
  H = findHomography(pts, dst_corner, RANSAC);
  warpPerspective(src, dst, H, dst.size());
  imshow("单应变换", dst);

  waitKey(0);
  return 0;
}