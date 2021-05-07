close all; clc; clear;

addpath('utils/Adaptive-Median-Filter');
addpath('utils/AdaptiveMedianFilter');
addpath('utils/BlockMatchingAlgoMPEG/BlockMatchingAlgoMPEG');
addpath('utils/addNoise');
addpath('utils');

% mov = yuv4mpeg2mov('../data/subset2-y4m/Kunts_04.y4m');
vid = VideoReader('../data/out.mp4');

I = uint8(zeros([vid.Height, vid.Width, 3, vid.NumFrames]));

tic
i=1;
while hasFrame(vid)
    I(:,:,:,i) = readFrame(vid);
%     imshow(I(:,:,:,i));
%     pause(1/vid.FrameRate);
    i = i+1;
end
close all;
toc

    
nFrames = size(I,4);
noiseRate = 0.15;
quantization_level_num = 10;

% Adding noise to the image sequence
for i = 1:10
    old = I(:,:,:,i);
    old2 = old;
    
    for c = 1:3
        % Quantization noise
        temp = old2(:,:,c);
        thresh = multithresh(temp,quantization_level_num);
        valuesMax = [thresh max(temp(:))];
        [I(:,:,c,i), index] = imquantize(temp,thresh,valuesMax);

        % Fixed pattern noise
        I(:,:,c,i) = imnoise(I(:,:,c,i),'gaussian',noiseRate);

        % Impulsive (salt and pepper) noise 
        I(:,:,c,i) = imnoise(I(:,:,c,i),'salt & pepper',noiseRate);

        % Poisson (photon shot) noise
        I(:,:,c,i) = imnoise(I(:,:,c,i),'poisson');

        % Amplifier noise
        % ????

        % Uniform noise (this is quantization noise!!)
        % I(:,:,i) = addnoise(I(:,:,i),noiseRate*100);
    end
end 

I1 = I(:,:,1,1);

[sigma, I2] = AdaptiveMedianFilter(I1);


imshowpair(I1,I2,'montage');





