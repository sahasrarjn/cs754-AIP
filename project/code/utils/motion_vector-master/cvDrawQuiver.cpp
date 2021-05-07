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

void cvDrawQuiver(IplImage* image, CvPoint pt1, CvPoint pt2, CvScalar Color, int Thickness, int Size)
{
	double Theta;
	double PI = 3.1416;
	if (pt2.x == 0)
		Theta = PI / 2;
	else
		Theta = atan2(double(pt2.y - pt1.y), (double)(pt2.x - pt1.x));
	cvLine(image, pt1, pt2, Color, Thickness, 8);
	Size = (int)(Size*0.707);
	double arrow_length = sqrt(pow((float)(pt1.y - pt2.y), 2) + pow((float)(pt1.x - pt2.x), 2));

	if (arrow_length > 2)
	{
		if (Theta == PI / 2 && pt1.y > pt2.y)
		{
			pt1.x = (int)(Size*cos(Theta) - Size*sin(Theta) + pt2.x);
			pt1.y = (int)(Size*sin(Theta) + Size*cos(Theta) + pt2.y);
			cvLine(image, pt1, pt2, Color, Thickness, 8);
			pt1.x = (int)(Size*cos(Theta) + Size*sin(Theta) + pt2.x);
			pt1.y = (int)(Size*sin(Theta) - Size*cos(Theta) + pt2.y);
			cvLine(image, pt1, pt2, Color, Thickness, 8);

		}
		else
		{
			pt1.x = (int)(-Size*cos(Theta) - Size*sin(Theta) + pt2.x);
			pt1.y = (int)(-Size*sin(Theta) + Size*cos(Theta) + pt2.y);
			cvLine(image, pt1, pt2, Color, Thickness, 8);
			pt1.x = (int)(-Size*cos(Theta) + Size*sin(Theta) + pt2.x);
			pt1.y = (int)(-Size*sin(Theta) - Size*cos(Theta) + pt2.y);
			cvLine(image, pt1, pt2, Color, Thickness, 8);
		}
	}
}