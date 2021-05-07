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

void matchingPSNR(IplImage* frame1, IplImage* frame2)
{
	// Image size load
	int height = frame1->height;
	int width = frame1->width;

	// Memory allocate

	IplImage* difference = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* temp = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* flow = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* reconstruction = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);


	int i, j;
	int k; // color index
	k = 0;

	int nIdx = frame1->widthStep; // y position increment -- transform space
	int mIdx = frame1->nChannels; // x position increment


	for (j = 0; j < height; j++)
	{
		for (i = 0; i < width; i++)
		{
			reconstruction->imageData[j*nIdx + i*mIdx + k] = frame1->imageData[j*nIdx + i*mIdx + k];
		}
	}

	// Input block size 
	int blockSize = 0;
	int searchRange = 0;

	printf(" Input Block Size : \n");
	scanf("%d", &blockSize);
	printf(" Image has been parted with %d x %d blocks", width / blockSize, height / blockSize);
	printf(" Input Search Range : \n");
	scanf("%d", &searchRange);

	unsigned char* inputImage = new unsigned char[height * width];
	int* resultImage = new int[height*width];

	//int searchArea = blockSize + searchRange;

	// Make Block & Search Area
	int* makeBlock = new int[blockSize*blockSize];
	int* searchBlock = new int[blockSize*blockSize];
	int* resultBlock = new int[(2 * searchRange + 1)*(2 * searchRange + 1)];

	int n = 0;
	int m = 0;

	int n_ref = height / blockSize;
	int m_ref = width / blockSize;

	int p = 0, q = 0;

	// load each block

	// Start : block Sweep
	for (n = 0; n < n_ref; n++)
	{
		for (m = 0; m < m_ref; m++)
		{
			for (j = 0; j < blockSize; j++)
			{
				for (i = 0; i < blockSize; i++)
				{
					makeBlock[j*blockSize + i] = (int)frame1->imageData[(j + n*blockSize)*width + (i + m*blockSize)];
					//printf("%d \n", makeBlock[j + i]);
				}
			}

			int sum = 0;
			int result = 0;

			// Start : searchBlock Sweep
			for (q = -searchRange; q <= searchRange; q++)
			{
				for (p = -searchRange; p <= searchRange; p++)
				{
					sum = 0;
					for (j = 0; j < blockSize; j++)
					{
						for (i = 0; i < blockSize; i++)
						{
							if (((j + q + n*blockSize)*width) <= 0 || (i + p + m*blockSize) <= 0) continue; // edge exception
							searchBlock[j*blockSize + i] = (int)frame2->imageData[(j + q + n*blockSize)*width + (i + p + m*blockSize)];

							sum += pow((makeBlock[j*blockSize + i] - searchBlock[j*blockSize + i]), 2);

							//printf(" [p,q : %d, %d] [i,j : %d, %d] frame 1 : %d, frame 2 : %d, diff : %d, sum : %d  \n",p,q,i,j, makeBlock[j + i], searchBlock[j + i], abs( makeBlock[j + i] - searchBlock[j + i]), sum);
							result = sum;
						}
					}
					resultBlock[(searchRange + q)*(2 * searchRange + 1) + (searchRange + p)] = result;
					k++;
					//printf("[%d][m:%d][n:%d] [p:%d][q:%d] sum : %d\n", k, m, n, p, q, result);
					sum = 0;
				}
			}
			// End : searchBlock Sweep 

			int minimum = 9999999;
			int value = 0;

			int motion_x = 0;
			int motion_y = 0;

			// Start : find the minimum value
			for (q = -searchRange; q <= searchRange; q++)
			{
				for (p = -searchRange; p <= searchRange; p++)
				{
					value = resultBlock[(searchRange + q)*(2 * searchRange + 1) + (searchRange + p)];
					if (value < minimum)
						minimum = value;
				}
			}

			//printf(" minimum value : %d \n", minimum);
			for (q = -searchRange; q <= searchRange; q++)
			{
				for (p = -searchRange; p <= searchRange; p++)
				{
					if (resultBlock[(searchRange + q)*(2 * searchRange + 1) + (searchRange + p)] == minimum)
					{
						motion_x = p;
						motion_y = q;
						//printf(" block : [%d, %d] motion vector : [%d, %d] \n", m, n, motion_x, motion_y);
						goto here;
					}
					if (resultBlock[(searchRange + q)*(2 * searchRange + 1) + (searchRange + p)] == 0)
					{
						motion_x = 0;
						motion_y = 0;
					}
				}
				//if (resultBlock[(searchRange + q)*(2 * searchRange + 1) + (searchRange + p)] == minimum)
				//{
				//	break;
				//}


			}

			// End : find the minimum value
		here:
			// Start : Save the Result
			{
				printf(" block : [%d, %d] motion vector : [%d, %d] \n", m, n, motion_x, motion_y);
			}
			// End : Save the Result 

			cvDrawQuiver(flow, cvPoint(m*blockSize + 0.5*blockSize, n*blockSize + 0.5*blockSize), cvPoint(m*blockSize + 0.5*blockSize + motion_x, n*blockSize + 0.5*blockSize + motion_y), CV_RGB(0, 255, 0), 1, 3);

			for (j = 0; j < blockSize; j++)
			{
				for (i = 0; i < blockSize; i++)
				{
					reconstruction->imageData[(j + n*blockSize + motion_y)*width + (i + m*blockSize + motion_x)] = frame1->imageData[(j + n*blockSize)*width + (i + m*blockSize)];
				}
			}
			//makeBlock[j*blockSize + i] = (int)frame1->imageData[(j + n*blockSize)*width + (i + m*blockSize)];

			//printf("%d \n", makeBlock[j + i]);
		} // End : block Sweep
	}

	cvNamedWindow("flow", CV_WINDOW_AUTOSIZE);
	cvShowImage("flow", flow);
	cvSaveImage("flowMSE.bmp", flow);
	display_img_info(flow);

	cvNamedWindow("reconstruction", CV_WINDOW_AUTOSIZE);
	cvShowImage("reconstruction", reconstruction);
	cvSaveImage("reconstructionMSE.bmp", reconstruction);
	display_img_info(reconstruction);
}