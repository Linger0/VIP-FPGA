#include <iostream>
#include <opencv2/opencv.hpp>
using namespace cv;
using namespace std;

#define LINEAR_TUNE 0
int main() {
  Mat img = imread("data/elephant.jpg", IMREAD_GRAYSCALE);
  imshow("elephant", img);
  if (!img.empty()) {
    //* 1. Mean value, standard deviation
    Scalar meanVal, devVal;
    meanStdDev(img, meanVal, devVal);
    cout << "Mean value is " << meanVal[0] << endl;
    cout << "Standard deviation is " << devVal[0] << endl;

    //* 2. Histogram
    Mat hist;
    int histSize = 256;
    float range[] = {0, 256};
    const float* histRange[] = { range };
    calcHist(&img, 1, 0, Mat(), hist, 1,
      &histSize, histRange, true, false);

    int histW = 512, histH = 400;
    int binW = cvRound((double)histW / histSize);
    Mat histImg(histH, histW, CV_8UC3, Scalar(0,0,0));
    normalize(hist, hist, 0, histImg.rows, NORM_MINMAX, -1, Mat());
    for (int i = 0; i < histSize; i++) {
      rectangle( histImg, Point( binW*i, histH - 1 ),
        Point( binW*(i+1)-1, histH - cvRound(hist.at<float>(i)) ),
        Scalar(255, 255, 255) );
    }
    imshow("Histogram", histImg);
    waitKey();

    //* 3. Linear transform
    double alpha = 1.75, beta = 35.0;
    Mat linearImg = Mat::zeros(img.size(), img.type());
    img.convertTo(linearImg, -1, alpha, beta);
    imshow("Linear transform", linearImg);
#if LINEAR_TUNE == 1
    for (alpha = 1.4; alpha <= 1.7; alpha += 0.05) {
      for (beta = 40.0; beta <= 60.0; beta += 10.0) {
        img.convertTo(linearImg, -1, alpha, beta);
        string name = to_string(alpha) + "-" + to_string(beta);
        imshow(name, linearImg);
      }
    }
#endif
    waitKey();

    //* 4. Gamma transform
    double gamma = 0.5;
    Mat gammaImg = Mat::zeros(img.size(), img.type());
    Mat lookUpTable(1, 256, CV_8U);
    uchar* p = lookUpTable.ptr();
    for (int i = 0; i < 256; i++) {
      p[i] = saturate_cast<uchar>(pow(i / 255.0, gamma) * 255.0);
    }
    LUT(img, lookUpTable, gammaImg);
    imshow("Gamma transform", gammaImg);
    waitKey();

    //* 5. Histogram equalization
    Mat histEqImg;
    equalizeHist(img, histEqImg);
    imshow("Histogram equalization", histEqImg);

    Mat eqHist;
    Mat eqHistImg(histH, histW, CV_8UC3, Scalar(0,0,0));
    calcHist(&histEqImg, 1, 0, Mat(), eqHist, 1,
      &histSize, histRange, true, false);
    normalize(eqHist, eqHist, 0, eqHistImg.rows, NORM_MINMAX, -1, Mat());
    for (int i = 0; i < histSize; i++) {
      rectangle( eqHistImg, Point( binW*i, histH - 1 ),
        Point( binW*(i+1)-1, histH - cvRound(eqHist.at<float>(i)) ),
        Scalar(255, 255, 255) );
    }
    imshow("Histogram after equalization", eqHistImg);
    waitKey();

    //* Store
    imwrite("data/elephant_linear.jpg", linearImg);
    imwrite("data/elephant_gamma.jpg", gammaImg);
    imwrite("data/elephant_histeq.jpg", histEqImg);
    imwrite("data/ele_hist.jpg", histImg);
    imwrite("data/ele_eq_hist.jpg", eqHistImg);
  }
}