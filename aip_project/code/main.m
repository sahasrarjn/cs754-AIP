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

Reconstructed = zeros(size(I));
Scaling = Reconstructed;

for c=1:3
    I = reshape(Img(:,:,c,:), [dim(1),dim(2),dim(4)]); % Single channel image seq

    % Median Filter
    for k = 1:K
        [Omega(:,:,k), I(:,:,k)] = AdaptiveMedianFilter(I(:,:,k)); % Adaptive Median filter
        I(:,:,k) = imresize(I(:,:,k),[N,N]);
    end

    % vec = zeros(N,N,K-1,2);


    for k = 1:frameStep:K % check
    % for k = 1:1 
        % For each frame at frameSIze gap

        %%%%%% Block Matching %%%%%
        Mappings = zeros([dim(1),dim(2),dim(3),2]);
        % Block Mapping of frame k with all the frame
        for kk=1:K
            if (kk==k)
                continue
            end
            Mappings(:,:,kk) = blockMatching(I(:,:,k),I(:,:,kk),mb);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%% Denoise and Reconstruction %%%%%
        for i = 1:mb:N
            for j = 1:mb:N
                P = zeros(mb**2,K);
                omg = P;
                for kk=1:K
                    if (kk == k)
                        P(:,kk) = reshape(I(i:i+mb-1, j:j+mb-1, k), [mb**2,1]);
                        % Forming patch matrix
                        omg(:,kk) = reshape(Omega(i:i+mb-1, j:j+mb-1, k), [mb**2,1])
                        % Forming initial omega matrix using median filter errors
                        continue
                    end
                    [x,y] = Mappings(i,j,kk);
                    % patch similar to i,j in kk_th framee
                    P(:,kk) = reshape(I(x:x+mb-1, j:j+mb-1, kk), [mb**2, 1]);
                    % Forming patch matrix
                    omg(:,kk) = reshape(Omega(x:x+mb-1, j:j+mb-1, kk), [mb**2, 1]);
                    % Forming initial omega matrix using median filter errors
                end
                omg = UpdateOmega(P,omg);
                % Updating Omega to somewhat include remaining errors of the patch
                Q = denoise(omg,P);
                for kk=1:K
                    if(kk==k)
                        Reconstructed(i:i+mb-1, j:j+mb-1, c, k) = Reconstructed(i:i+mb-1, j:j+mb-1, c, k) + reshape(Q(:,kk),[mb, mb]);
                        Scaling(i:i+mb-1, j:j+mb-1, c, k) = Scaling(i:i+mb-1, j:j+mb-1, c, k) + 1;
                    end
                        [x,y] = Mappings(i,j,kk);
                        Reconstructed(x:x+mb-1, y:y+mb-1, c, kk) = Reconstructed(x:x+mb-1, y:y+mb-1, c, kk) + reshape(Q(:,kk),[mb, mb]);
                        Scaling(x:x+mb-1, y:y+mb-1, c, k) = Scaling(x:x+mb-1, y:y+mb-1, c, k) + 1;
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

end


Reconstructed = Reconstructed./Scaling; 
% Reconstructed video
