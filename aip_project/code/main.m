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

%% Adding noise
nFrames = size(I,4);
noiseRate = 0.2;
quantization_level_num = 10;
N = 256;

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

%% Median Filter and Block Matching
Img = I;
dim = size(I);
Omega = zeros(dim);
K = dim(4);
mb = 8;
frameStep = K;

for c=1:3
    I = reshape(Img(:,:,c,:), [dim(1),dim(2),dim(4)]); % Single channel image seq

    % Median Filter
    for k = 1:K
        [Omega(:,:,k), I(:,:,k)] = AdaptiveMedianFilter(I(:,:,k)); % Adaptive Median filter
        I(:,:,k) = imresize(I(:,:,k),[N,N]);
    end

    % vec = zeros(N,N,K-1,2);
    P = zeros(N/mb,N/md,K,K/frameStep,mb,mb);


    for k = 1:frameStep:K % check
    % for k = 1:1 
        % For each frame at frameSIze gap
        for i = 1:mb:N
            for j = 1:mb:N
                for kk=1:K
                    if (kk == k)
                        P(i,j,k,k) = I(i:i+mb-1, j:j+mb-1,k);
                        continue
                    end
                    
                    % kk in [2:k] to find all similar patches
                    vec = blockMatching(I(:,:,k),I(:,:,kk),mb);
                    P(i,j,kk,k) = I(vec(i,j,1), vec(i,j,2), kk);
                end
            end
        end
    end

    size(P)

    %%%%%% Denoise %%%%%





    %%%%%%%%%%%%%%%%%%%%

    for k = 1:frameStep:K % check
    % for k = 1:1
        for i = 1:mb:N
            for j = 1:mb:N
                for kk = 1:K
                    I(i:i+mb-1, j:j+mb-1,1,kk) = P(i,j,kk,k);
                end
            end
        end
    end

end



