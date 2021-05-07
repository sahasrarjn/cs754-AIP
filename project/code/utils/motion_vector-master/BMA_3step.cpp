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
#include <time.h>
#include <math.h>
#include "motion_vector.h"

using namespace std;

#pragma warning(disable: 4819)

void BMA3step(IplImage* frame1, IplImage* frame2)
{
	// Image size load
	int height = frame1->height;
	int width = frame1->width;

	FILE* stream;
	stream = fopen("motion_BMA3step.txt", "w");
	// Memory allocate

	IplImage* difference = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* temp = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* flow = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);
	IplImage* reconstruction = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 1);
	IplImage* flowanchor = cvCreateImage(cvSize(width, height), IPL_DEPTH_8U, 3);

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

	for (j = 0; j < height; j++)
	{
		for (i = 0; i < width; i++)
		{
			for (k = 0; k < 3; k++)
			{
				flow->imageData[j*nIdx * 3 + i*mIdx * 3 + k] = 0;
				flowanchor->imageData[j*nIdx * 3 + i*mIdx * 3 + k] = frame1->imageData[j*nIdx + i*mIdx];
			}
		}
	}
	// Input block size 
	int blockSize = 0;
	int searchRange = 0;
	int ref_stepSize = 0;

	printf(" Input Block Size : \n");
	scanf("%d", &blockSize);
	printf(" Image has been parted with %d x %d blocks", width / blockSize, height / blockSize);

	printf(" Input Step Size : \n");
	scanf("%d", &ref_stepSize);
	
	// Make Block & Search Area
	int* makeBlock = new int[blockSize*blockSize];
	
	int* step3Block = new int[9] ;
	int* stepBlock = new int[9];

	int n = 0;
	int m = 0;

	int n_ref = height / blockSize;
	int m_ref = width / blockSize;

	// load each block

	clock_t before;
	double result;
	before = clock();


	// Start : block Sweep
	for (n = 0; n < n_ref; n++)
	{
		for (m = 0; m < m_ref; m++)
		{
			int sum = 0;
			int result = 0;
			
			int tempX = m*blockSize + 0.5*blockSize;
			int tempY = n*blockSize + 0.5*blockSize;
			int blockCalib = 0.5*blockSize;
			int initX = tempX;
			int initY = tempY;
			// Start : searchBlock Sweep
			int s = 0;

			int minimum = 0;
			int motion_x = 0;
			int motion_y = 0;

			int stepSize = ref_stepSize;

			// initialize the step3Block
			for (s = 0; s < 9; s++)
			{
				step3Block[s] = 0;
			}

			int refBlock = 0;

			for (j = 0; j < blockSize; j++)
			{
				for (i = 0; i < blockSize; i++)
				{
					makeBlock[j*blockSize + i] = (int)frame1->imageData[(n*blockSize + j)*width + m*blockSize + i];
				}
			}

			printf("[refBlock] %d\n", refBlock);

			while (stepSize != 0)
			{
				for (s = 0; s < 9; s++) // initialization
				{
					step3Block[s] = 0;
					stepBlock[s] = 0;
				}

				for (j = 0; j < blockSize; j++)
				{
					if ((tempY - stepSize + j - blockCalib <= 0) || (tempX - stepSize + i - blockCalib) <= 0) continue;
					for (i = 0; i < blockSize; i++)
					{
						if ((tempY - stepSize + j - blockCalib <= 0) || (tempX - stepSize + i - blockCalib) <= 0 ) continue;

						int tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY - stepSize + j - blockCalib)*width + tempX - stepSize + i - blockCalib];
						int tempframe2 = abs(tempframe);
						step3Block[0] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY - stepSize + j - blockCalib)*width + tempX + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[1] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY - stepSize + j - blockCalib)*width + tempX + stepSize + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[2] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY + j - blockCalib)*width + tempX - stepSize + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[3] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY + j - blockCalib)*width + tempX + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[4] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY + j - blockCalib)*width + tempX + stepSize + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[5] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY + stepSize + j - blockCalib)*width + tempX - stepSize + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[6] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY + stepSize + j - blockCalib)*width + tempX + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[7] += tempframe2;

						tempframe = makeBlock[j*blockSize + i] - (int)frame2->imageData[(tempY + stepSize + j - blockCalib)*width + tempX + stepSize + i - blockCalib];
						tempframe2 = abs(tempframe);
						step3Block[8] += tempframe2;
					}
				}
				// find the minimum value
				for (s = 0; s < 9; s++)
				{
					int result = step3Block[s]; // MSE
					stepBlock[s] = result;
					//printf(" %d - %d = %d \n", refBlock, step3Block[s], stepBlock[s]);
				}

				minimum = 999999999;

				for (s = 0; s < 9; s++)
				{
					if (stepBlock[s] <= minimum)
						minimum = stepBlock[s];
				}

				for (s = 0; s < 9; s++)
				{
					if (stepBlock[s] == minimum)
						break;
				}

				printf("[s] : %d ", s);
				switch (s)
				{
				case 0:
					tempX = tempX - stepSize;
					tempY = tempY - stepSize;
					break;

				case 1:
					tempX = tempX;
					tempY = tempY - stepSize;
					break;

				case 2:
					tempX = tempX + stepSize;
					tempY = tempY - stepSize;
					break;

				case 3:
					tempX = tempX - stepSize;
					tempY = tempY ;
					break;

				case 4:
					tempX = tempX;
					tempY = tempY;
					break;

				case 5:
					tempX = tempX + stepSize;
					tempY = tempY;
					break;

				case 6:
					tempX = tempX - stepSize;
					tempY = tempY + stepSize;
					break;

				case 7:
					tempX = tempX ;
					tempY = tempY + stepSize;
					break;

				case 8:
					tempX = tempX + stepSize;
					tempY = tempY + stepSize;
					break; 

				default :
					break;
				}

				motion_x = tempX-initX;
				motion_y = tempY-initY;
				
				stepSize = 0.5*stepSize;
			}
			// End : searchBlock Sweep 

			if (minimum <= blockSize*blockSize*5)
			{
				motion_x = 0;
				motion_y = 0;
			}

			// Start : Save the Result
			{
				int tempm = m*blockSize + 0.5*blockSize;
				int tempn = n*blockSize + 0.5*blockSize;
				printf(" block : [%d, %d] motion vector : [%d, %d] \n", m, n, motion_x, motion_y);
				fprintf(stream, "%d %d %d %d \n", tempm, tempn, motion_x, motion_y);
			}
			// End : Save the Result 

			cvDrawQuiver(flow, cvPoint(m*blockSize + 0.5*blockSize, n*blockSize + 0.5*blockSize), cvPoint(m*blockSize + 0.5*blockSize + motion_x, n*blockSize + 0.5*blockSize + motion_y), CV_RGB(0, 255, 0), 1, 3);
			cvDrawQuiver(flowanchor, cvPoint(m*blockSize + 0.5*blockSize, n*blockSize + 0.5*blockSize), cvPoint(m*blockSize + 0.5*blockSize + motion_x, n*blockSize + 0.5*blockSize + motion_y), CV_RGB(0, 255, 0), 1, 3);

			for (j = 0; j < blockSize; j++)
			{
				for (i = 0; i < blockSize; i++)
				{
					if ((j + n*blockSize + motion_y)*width <= 0 || (i + m*blockSize + motion_x) <= 0) continue;
					reconstruction->imageData[(j + n*blockSize + motion_y)*width + (i + m*blockSize + motion_x)] = frame1->imageData[(j + n*blockSize)*width + (i + m*blockSize)];
				}
			}
		} // End : block Sweep
	}

	


	fclose(stream);

	printf("PSNR is %lf \n", getPSNR(frame2, reconstruction));

	result = (double)(clock() - before) / CLOCKS_PER_SEC;
	printf(" Time elapsed : %lf s \n", result);
	

	cvNamedWindow("flow3Step", CV_WINDOW_AUTOSIZE);
	cvShowImage("flow3Step", flow);
	cvSaveImage("flow3Step.bmp", flow);
	display_img_info(flow);

	cvNamedWindow("reconstruction3Step", CV_WINDOW_AUTOSIZE);
	cvShowImage("reconstruction3Step", reconstruction);
	cvSaveImage("reconstruction3Step.bmp", reconstruction);
	display_img_info(reconstruction);

	cvNamedWindow("flowanchor3Step", CV_WINDOW_AUTOSIZE);
	cvShowImage("flowanchor3Step", flowanchor);
	cvSaveImage("flowanchor3Step.bmp", flowanchor);
	display_img_info(reconstruction);
}