// 24, July, 2017 Digital Image Processing 5th week
// This program was made by Kim Dong Hyun for Studying
// Motion Vector Estimation based on Block Matching Algorithm

#pragma once
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <iostream>
#include <string>
#include <stack>

#define _USE_MATH_DEFINES
#include <math.h>
#include "motion_vector.h"

using namespace std;

#pragma warning(disable: 4819)

int main(int argc, char** argv)
{
	// load image
	IplImage* frame1 = cvLoadImage("FOREMAN072.tif", 0);
	IplImage* frame2 = cvLoadImage("FOREMAN069.tif", 0);

		if (frame1 == NULL)
		{
			printf(" could not find the image");
			return 0;
		}

		if (frame2 == NULL)
		{
			printf(" could not find the image");
			return 0;
		}

	
	cvNamedWindow("frame1", CV_WINDOW_AUTOSIZE);
	cvShowImage("frame1", frame1);
	display_img_info(frame1);

	cvNamedWindow("frame2", CV_WINDOW_AUTOSIZE);
	cvShowImage("frame2", frame2);
	display_img_info(frame2);

	while (1)
	{
		printf(" (1) Difference \n");
		printf(" (2) Block Matching \n");
		printf(" (3) Block Matching MSE \n");
		printf(" (4) Block Matching 3 Step \n");

		int num;
		scanf("%d", &num);

		switch (num)
		{
		case 1:
			printf(" Get diffrence \n");
			get_diff(frame1, frame2);
			break;

		case 2:
			printf(" Block Matching \n");
			blockMatching(frame1, frame2);

			break;

		case 3:
			printf(" Block Matching MSE \n");
			matchingMSE(frame1, frame2);

			break;

		case 4:
			printf(" Block Matching - 3Step \n");
			BMA3step(frame1, frame2);
			break;

		case 5:
			break;

		default:
			printf(" selected process does not exist\n");
			break;
		}
	}
	return 0;

	cvDestroyAllWindows();
}
