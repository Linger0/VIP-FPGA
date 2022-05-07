/////////////////////////////////////////////////
// L20220426_background2.cpp :
//
// �˶�Ŀ���� ���� ������ģ  //////////////////////
//
/////////////////////////////////////////////////
#include <opencv2/opencv.hpp>

using namespace std;
using namespace cv;

///////////////////////////////////////////////
// 2. ������ģ ���� ƽ�������� ǰL֡��ƽ����Ϊ����ģ��
// ������ģ�ͽ����󲻸��£�
// ƽ�����������Ч����֡�Ч����
// �۲�ǰ���뱳���Ҷ�����ʱ©��
///////////////////////////////////////////////

int main()
{
	VideoCapture cap;
	int number_to_train_on;
	int frame_count;
	int key, waittime;
	Mat frame, FrameAccSum, SqAccSum, avgFrame, avgDiff, IBackground;
	Mat IhiF, IlowF;
	Mat mask, masktmp;
	Mat tmp;

	// Float, �����ͨ������
	vector<Mat> Igray(3);
	vector<Mat> Ilow(3);
	vector<Mat> Ihi(3);

	// ��ֵ
	float high_thresh;
	float low_thresh;

	///////////////////////////////////////////////////
	//  ������Ƶ  ////////////////////////////////
	// ��ʼ��
	if (!cap.open("data/visiontraffic.avi"))
	{
		std::cout << "����Ƶ�ļ�ʧ�ܣ�" << endl;
		return EXIT_FAILURE;
	}
	number_to_train_on = 50;
	waittime = 25;
	high_thresh = 10.0;
	low_thresh = 10.0;
	namedWindow("����", WINDOW_AUTOSIZE);
	moveWindow("����", 50, 401);
	namedWindow("��Ƶ", WINDOW_AUTOSIZE);
	moveWindow("��Ƶ", 50, 1);
	namedWindow("ǰ��Ŀ��", WINDOW_AUTOSIZE);
	moveWindow("ǰ��Ŀ��", 660, 1);

	//  ������ģ  /////
	frame_count = 0;
	cout << "�����ۻ�ǰ" << number_to_train_on << "֡..." << endl;

	cap >> frame;

	Size sz = frame.size();
	FrameAccSum = Mat::zeros(sz, CV_32FC3);
	SqAccSum = Mat::zeros(sz, CV_32FC3);
	accumulate(frame, FrameAccSum);
	accumulateSquare(frame, SqAccSum);
	frame_count++;

	while (1) {

		cap >> frame;
		imshow("��Ƶ", frame);

		if (!frame.data) exit(1);

		accumulate(frame, FrameAccSum);
		accumulateSquare(frame, SqAccSum);

		frame_count++;

		if ((key = waitKey(1)) == 27 || key == 'q' || key == 'Q' || frame_count >= number_to_train_on) break;
	}

	cout << "��ɣ�" << endl;
	cout << "���ڽ�������ģ��..." << endl;

	avgFrame = FrameAccSum / frame_count; // �����ֵ
	avgDiff = (SqAccSum / frame_count) -
		(FrameAccSum.mul(FrameAccSum) / frame_count / frame_count); // ���㷽��
	sqrt(avgDiff, avgDiff); // �����׼��

	IhiF = avgFrame + (avgDiff * high_thresh);
	split(IhiF, Ihi);
	IlowF = avgFrame - (avgDiff * low_thresh);
	split(IlowF, Ilow);

	avgFrame.convertTo(IBackground, CV_8UC3);
	imshow("����", IBackground);

	cout << "��ɱ�����ģ! ���������ʼ���ǰ��" << endl;
	waitKey(0);
	///////////////////////////////////////////////////

	///////////////////////////////////////////////////
	//  ǰ�����  ////////////////////////////////
	// �� esc �� q �� Q �˳����
	cout << "���ǰ���� ..." << endl;
	cout << "��esc �� q �� Q �˳���⣩" << endl;

	while ((key = waitKey(waittime)) != 27 || key == 'q' || key == 'Q')
	{
		cap >> frame;
		if (!frame.data) {
			cout << "����������esc �� q �� Q �˳���⣩" << endl;
			cap.release();
			waitKey(0);
			exit(0);
		}

		frame.convertTo(tmp, CV_32FC3);
		split(tmp, Igray);
		// �жϸ�ͨ�������Ƿ�Ϊ����
		// ͨ�� 1
		inRange(Igray[0], Ilow[0], Ihi[0], mask);
		// ͨ�� 2
		inRange(Igray[1], Ilow[1], Ihi[1], masktmp);
		mask = min(mask, masktmp);
		// ͨ�� 3
		inRange(Igray[2], Ilow[2], Ihi[2], masktmp);
		mask = min(mask, masktmp);
		// ����ȡ������ʶǰ��
		mask = 255 - mask;

		// ��ʾ��Ƶͼ�� �� ֡���
		stringstream ss;
		rectangle(frame, cv::Point(10, 2), cv::Point(100, 20),
			cv::Scalar(255, 255, 255), -1);
		ss << cap.get(CAP_PROP_POS_FRAMES);
		string frameNumberString = ss.str();
		putText(frame, frameNumberString.c_str(), cv::Point(15, 15),
			FONT_HERSHEY_SIMPLEX, 0.5, cv::Scalar(0, 0, 0));
		imshow("��Ƶ", frame);

		// ��ʾǰ����ֵͼ��
		imshow("ǰ��Ŀ��", mask);

		if (cap.get(CAP_PROP_POS_FRAMES) < 343 && cap.get(CAP_PROP_POS_FRAMES) > 341)
		{
			waitKey(0); // �۲�Ŀ���뱳����ɫ����ʱ©������
		}


	}
	cout << "��������˳�����" << endl;
	waitKey(0);
	cap.release();
	exit(0);
}


