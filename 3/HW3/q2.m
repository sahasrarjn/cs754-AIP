clear; clc; close all;
addpath("l1_ls_matlab");
%% Loading figure and Radon transforms
k = 18;
theta1 = randsample(180, k) - 1;
theta2 = randsample(180, k) - 1;
theta3 = randsample(180, k) - 1;

lambda  = 0.001; % regularization parameter
rel_tol = 0.0001; % relative target duality gap
quiet = false;


Im1 = loadFig("slice_50.png");
Im2 = loadFig("slice_51.png");
Im3 = loadFig("slice_52.png");

imgSize = size(Im1,1);

[R1,~] = radon(Im1,theta1);
[R2,~] = radon(Im2,theta2);
[R3,~] = radon(Im3,theta3);

%% Part A: Reconstruction using FBP (Ram-Lak filter)

I0 = iradon(R1,theta1,'linear','Ram-Lak',1,imgSize);
I02 = iradon(R2,theta2,'linear','Ram-Lak',1,imgSize);

figure
subplot(2,2,1);
imshow(Im1);
title("Original Image");

subplot(2,2,3);
imshow(I0);
title("Recons. Image (FBP)");

subplot(2,2,2);
imshow(Im2);
title("Original Image");

subplot(2,2,4);
imshow(I02);
title("Recons. Image (FBP)");
saveas(gcf,'reconstruction0.png', 'png');


%% Part B: Reconstruction using CS (DCT2 basis, Single slice)
Rsize = size(R1,1);
A = classA(imgSize,theta1,Rsize);
At = A';
m = numel(R1);
n = imgSize*imgSize;
y = R1(:);

% These parameters are taken from the example file in l1_ls folder

[I1, ~] = l1_ls(A,At,m,n,y,lambda,rel_tol,quiet);
I1 = reshape(I1, imgSize, imgSize);
I1 = idct2(I1);

figure 
subplot(1,2,1);
imshow(Im1);
title("Original Image")

subplot(1,2,2);
imshow(I1);
title("Recons. Image (DCT, single slice)")
saveas(gcf,'reconstruction1.png', 'png');


%% Part C: Reconstruction using CS (DCT2 basis, two slices)

theta(:,:,1) = theta1;
theta(:,:,2) = theta2;
R(:,:,1) = R1;
R(:,:,2) = R2;

Rsize = size(R1,1);
A = classA2(imgSize,theta,Rsize);
At = A';

m = numel(R);
n = 2*imgSize^2;
y = R(:);

[I12, ~] = l1_ls(A,At,m,n,y,lambda,rel_tol,quiet);
I1 = I12(1:size(I12)/2);
I2 = I12(size(I12)/2+1:end);

I1 = reshape(I1, imgSize, imgSize);
I2 = reshape(I2, imgSize, imgSize);
I2 = I1 + I2;
I1 = idct2(I1);
I2 = idct2(I2);



figure 
subplot(2,2,1);
imshow(Im1);
title("Original Image 1")
subplot(2,2,2);
imshow(Im2);
title("Original Image 2")

subplot(2,2,3);
imshow(I1);
title("Recons. Image 1")

subplot(2,2,4);
imshow(I2);
title("Recons. Image 2")
saveas(gcf,'reconstruction2.png', 'png');



%% Part D: Reconstruction using CS (DCT2 basis, three slices)

theta(:,:,1) = theta1;
theta(:,:,2) = theta2;
theta(:,:,3) = theta3;
R(:,:,1) = R1;
R(:,:,2) = R2;
R(:,:,3) = R3;

Rsize = size(R1,1);
A = classA3(imgSize,theta,Rsize);
At = A';

m = numel(R);
n = 3*imgSize^2;
y = R(:);


[I, ~] = l1_ls(A,At,m,n,y,lambda,rel_tol,quiet);
I1 = I(1:size(I)/3);
I2 = I(size(I)/3+1:2*size(I)/3);
I3 = I(2*size(I)/3+1:end);

I1 = reshape(I1, imgSize, imgSize);
I2 = reshape(I2, imgSize, imgSize);
I3 = reshape(I3, imgSize, imgSize);
I2 = I1 + I2;
I3 = I2 + I3;
I1 = idct2(I1);
I2 = idct2(I2);
I3 = idct2(I3);


figure 
subplot(2,3,1);
imshow(Im1);
title("Original Image 1")
subplot(2,3,2);
imshow(Im2);
title("Original Image 2")
subplot(2,3,3);
imshow(Im3);
title("Original Image 3")

subplot(2,3,4);
imshow(I1);
title("Recons. Image 1")
subplot(2,3,5);
imshow(I2);
title("Recons. Image 2")
subplot(2,3,6);
imshow(I3);
title("Recons. Image 3")
saveas(gcf,'reconstruction3.png', 'png');


close all;
