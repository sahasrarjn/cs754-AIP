close all; clc; clear;

addpath('utils/Adaptive-Median-Filter');
addpath('utils/AdaptiveMedianFilter');
addpath('utils/addNoise');
addpath('utils');

%% Reading the video file (mp4)
vid = VideoReader('../data/out.mp4');

I = uint8(zeros([vid.Height, vid.Width, 3, vid.NumFrames]));

i=1;
while hasFrame(vid)
    I(:,:,:,i) = readFrame(vid);
    i = i+1;
end
test_videoframes = 3; % for testing
I2 = I(:,:,:,1:test_videoframes);
clear I;
I = I2;
clear I2;
size(I)


%% Adding noise
nFrames = size(I,4);
noiseRate = 0.2;
quantization_level_num = 10;
N = 128;

% Adding noise to the image sequence
for i = 1:nFrames
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

%% Median Filter and Block Matching
Img = I;
clear I;
dim = size(Img);
K = dim(4);
mb = 8;
frameStep = K;

for c=1:3
    I = reshape(Img(:,:,c,:), [dim(1),dim(2),dim(4)]); % Single channel image seq
    dim2 = size(I);
    Im = zeros(dim2);
    I2 = zeros([N,N,K]);
    Omega = zeros(dim2);

    % Median Filter
    tic
    for k = 1:K
%         [a, b] = AdaptiveMedianFilter(I(:,:,k)); % Adaptive Median filter
        [Omega(:,:,k), Im(:,:,k)] = AdaptiveMedianFilter(I(:,:,k)); % Adaptive Median filter
        x = imresize(Im(:,:,k),[N,N]);
        I2(:,:,k) = x;
    end
    toc
    
    clear I;
    I = I2;
    clear Im;
    clear I2;

    % vec = zeros(N,N,K-1,2);
    P = zeros(N/mb,N/mb,K,K/frameStep,mb,mb);
    size(P)
    size(I)
    
    % Block mathcing
    tic
    for k = 1:frameStep:K % check
    % for k = 1:1 
        % For each frame at frameSIze gap
        for i2 = 1:N/mb
            for j2 = 1:N/mb
                i = (i2-1)*mb+1;
                j = (j2-1)*mb+1;
                
                fprintf("i,j: %d %d\n", i, j);
                for kk=1:K
                    if (kk == k)
                        P(i2,j2,k,kk,:,:) = I(i:i+mb-1, j:j+mb-1,k);
                        continue
                    end
                    
                    % kk in [2:k] to find all similar patches
                    vec = blockMatching(I(:,:,k),I(:,:,kk),mb);
                    xt = vec(i,j,1);
                    yt = vec(i,j,2);
                    P(i2,j2,kk,k,:,:) = I(xt:xt+mb-1, yt:yt+mb-1, kk);
                end
            end
        end
    end
    toc

    size(P)
    size(I)

    %%%%%% Denoise %%%%%





    %%%%%%%%%%%%%%%%%%%%

    for k = 1:frameStep:K % check
    % for k = 1:1
        for i2 = 1:N/mb
            for j2 = 1:N/mb
                i = (i2-1)*mb+1;
                j = (j2-1)*mb+1;
                fprintf("i,j: %d %d\n", i, j);
                for kk = 1:K
                    I(i:i+mb-1, j:j+mb-1,kk) = P(i2,j2,kk,k);
                end
            end
        end
    end
end



