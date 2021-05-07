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

using namespace std;

void display_img_info(IplImage* img);
double getPSNR(IplImage* frame1, IplImage* frame2);

void motion_vector(IplImage* frame1, IplImage* frame2);
void get_diff(IplImage* frame1, IplImage* frame2);
void blockMatching(IplImage* frame1, IplImage* frame2);
void bma_reconstruction(IplImage* frame1, IplImage* frame2);
void matchingMSE(IplImage* frame1, IplImage* frame2);
void BMA3step(IplImage* frame1, IplImage* frame2);

void cvDrawQuiver(IplImage* image, CvPoint pt1, CvPoint pt2, CvScalar Color, int Thickness, int Size);