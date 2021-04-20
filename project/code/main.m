close all; clc; clear;

addpath('helper/Adaptive-Median-Filter');
addpath('helper/BlockMatchingAlgoMPEG/BlockMatchingAlgoMPEG');
addpath('helper/addNoise');

mov = yuv4mpeg2mov('../data/subset2-y4m/Kunts_04.y4m');

I = mov.cdata;
    
nFrames = size(I,3);
noiseRate = 0.2;
quantization_level_num = 10;


for i = 1:nFrames
    old = I(:,:,i);
    old2 = old;
    
    % Quantization noise
    thresh = multithresh(old2,quantization_level_num);
    valuesMax = [thresh max(old2(:))];
    [I(:,:,i), index] = imquantize(old2,thresh,valuesMax);
    
    % Fixed pattern noise
    I(:,:,i) = imnoise(I(:,:,i),'gaussian',noiseRate);
    
    % Impulsive (salt and pepper) noise 
    I(:,:,i) = imnoise(I(:,:,i),'salt & pepper',noiseRate);

    % Poisson (photon shot) noise
    I(:,:,i) = imnoise(I(:,:,i),'poisson');
    
    % Amplifier noise
    % ????
    
    % Uniform noise (this is quantization noise!!)
	% I(:,:,i) = addnoise(I(:,:,i),noiseRate*100);
    
    imshowpair(old,I(:,:,i),'montage') 
    pause();
    clear old old2
end 






close all;



