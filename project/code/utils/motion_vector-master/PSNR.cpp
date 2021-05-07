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

double getPSNR(IplImage* frame1, IplImage* frame2)
{
	// Image size load
	int height = frame1->height;
	int width = frame1->width;

	int i, j;
	int k = 0; // color index

	int nIdx = frame1->widthStep; // y position increment -- transform space
	int mIdx = frame1->nChannels; // x position increment

	double PSNR;
	double MSE = 0;

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
				MSE += pow(int(f4 - f3),2)/(double)width; // MAD
			}
		}
	}

	MSE = MSE / (double)height;
	printf("%lf \n", MSE);
	PSNR = 10 * log10(65025.0 / MSE);
	return PSNR;
}