close all; clc; clear;

addpath('utils/Adaptive-Median-Filter');
addpath('utils/AdaptiveMedianFilter');
addpath('utils/addNoise');
addpath('utils');

vid = VideoReader('../data/out.mp4');

I = uint8(zeros([vid.Height, vid.Width, 3, vid.NumFrames]));

i=1;
while hasFrame(vid)
    I(:,:,:,i) = readFrame(vid);
    i = i+1;
end

    
nFrames = size(I,4);
noiseRate = 0.2;
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
    end
end 


size(I);


% I2 = I(:,:,:,1);
% 
% for i = 1:3
%     I1 = I(:,:,i,1);
%     [omega, I2(:,:,i,1)] = AdaptiveMedianFilter(I1);
% %     I2(:,:,i,1) = AdaptiveFilter(I1,140);
% %     I2(:,:,i,1) = medfilt2(I1);
% end
% 
% I2 = denoise(omega,I2);
% 
% imshowpair(I(:,:,:,1),I2,'montage');
% 




