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

void makeBlock(int m, int n, int blockSize, int* makeBlock, IplImage* frame1);

void motion_vector (IplImage* frame1, IplImage* frame2)
{
	// Image size load
	int height	= frame1->height;
	int width	= frame1->width;

	// Memory allocate
	
	IplImage* difference	= cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);
	IplImage* temp			= cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);

	int i, j;
	int k; // color index

	int nIdx = frame1->widthStep; // y position increment -- transform space
	int mIdx = frame1->nChannels; // x position increment

	// Input block size 
	int blockSize = 0;
	int searchRange = 0;

	printf(" Input Block Size : \n");
	scanf("%d", &blockSize);
	printf(" Input Search Range : \n");
	scanf("%d", &searchRange);

	int range;

	unsigned char* inputImage = new unsigned char[height * width];
	int* resultImage = new int[height*width];

	// Make Block & Search Area
	int* makeBlock = new int[blockSize*blockSize*mIdx];
	int* searchBlock = new int[blockSize*blockSize*mIdx];
	int* resultBlcok = new int[blockSize*blockSize*mIdx];

	int n = 0;
	int m = 0;

	int n_max = height / blockSize;
	int m_max = width / blockSize;

	// make each block

	for (j = 0; j < height; j++)
	{
		for (i = 0; i < width; i++)
		{
			for (k = 0; k < 3; k++)
			{
				int f1 = frame1->imageData[j*nIdx + i*mIdx + k];
				int f2 = frame2->imageData[j*nIdx + i*mIdx + k];
				difference->imageData[j*nIdx + i*mIdx + k] = (unsigned char)abs(f1 - f2);
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

void makeBlock(int m, int n, int blockSize, int* makeBlock, IplImage* frame1)
{
	int i, j;
	int k = 0 ;
	int height = frame1->height;
	int width = frame1->width;
	int mIdx = frame1->nChannels;
	int n;
	int m;

	int nIdx = frame1->widthStep; // y position increment
	int mIdx = frame1->nChannels; // x position increment

	for (j = 0; j < blockSize; j++)
	{
		for (i = 0; i < blockSize; i++)
		{
			makeBlock[j*blockSize*mIdx + i*mIdx + k] = frame1->imageData[(j+n*blockSize)*nIdx + (i+m*blockSize)*mIdx + k];
		}
	}
}

void makeSearchRange(int m, int n, int startHere, int blockSize, int* searchBlock, IplImage* frame2)
{

	int i, j;
	int k = 0;
	int height = frame2->height;
	int width = frame2->width;
	int mIdx = frame2->nChannels;
	int n;
	int m;

	int nIdx = frame2->widthStep; // y position increment
	int mIdx = frame2->nChannels; // x position increment

	for (j = 0; j < blockSize; j++)
	{
		for (i = 0; i < blockSize; i++)
		{
			searchBlock[j*blockSize*mIdx + i*mIdx + k] = frame2->imageData[(j + n*blockSize)*nIdx + (i + m*blockSize)*mIdx + k];
		}
	}
}

void search(int* makeblock, int* searchBlock, int* resultBlock, int blockSize, int searchRange, int *x, int* y, IplImage* frame2)
{
	int i, j;
	int k = 0;
	int height = frame2->height;
	int width = frame2->width;
	int mIdx = frame2->nChannels;
	int n;
	int m;
	int sum;

	unsigned int* temp = new unsigned int[];

	int nIdx = frame2->widthStep; // y position increment
	int mIdx = frame2->nChannels; // x position increment

	for (j = 0; j < searchRange; j++)
	{
		for (i = 0; i < searchRange; i++)
		{
			sum = 0;
			for (n = 0; n < blockSize; n++)
			{
				for (m = 0; m < blockSize; m++)
				{
					sum += abs((searchBlock[] - makeBlock[]));

				}
			}
			temp[] = sum;
			sum = 0;
		}
	}

	findPosition(temp, searchRange, x, y);

}

void findPosition(unsigned int* temp, int searchRange, int* x, int* y)
{
	unsigned int minimum = 2147483647;
	for (int i = 0; i<searchRange; i++)
	{
		for (int j = 0; j<searchRange; j++)
		{
			if (temp[j]  < minimum)
			{
				minimum = temp[j];
			}
		}
	}

	for (int i = 0; i<searchRange; i++)
	{
		for (int j = 0; j<searchRange; j++)
		{
			if (temp[j] == minimum)
			{
				*x = i;
				*y = j;
				return;
			}
		}
	}
}

