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

void get_diff(IplImage* frame1, IplImage* frame2)
{
	// Image size load
	int height = frame1->height;
	int width = frame1->width;

	// Memory allocate 

	IplImage* difference = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* temp = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);

	int i, j;
	int k = 0; // color index

	int nIdx = frame1->widthStep; // y position increment -- transform space
	int mIdx = frame1->nChannels; // x position increment

	for (j = 0; j < height; j++)
	{
		for (i = 0; i < width; i++)
		{
			//for (k = 0; k < 3; k++)
			{
				char f1 = frame1->imageData[j*nIdx + i*mIdx + k];
				char f2 = frame2->imageData[j*nIdx + i*mIdx + k];
				unsigned char f3 = (unsigned char)f1;
				unsigned char f4 = (unsigned char)f2;
				difference->imageData[j*nIdx + i*mIdx + k] = (unsigned char)abs(f4-f3);
			}
		}
	}

	cvNamedWindow("difference", CV_WINDOW_AUTOSIZE);
	cvShowImage("difference", difference);
	cvSaveImage("difference.bmp", difference);
	printf("\n Saved Successfully \n\n");

	// display image information
	display_img_info(difference);
}