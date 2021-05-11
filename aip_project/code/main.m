%% Reading the video file (mp4)
close all; clc; clear;
vid = VideoReader('../data/mp4/miss.mp4');

N = 128;

%I = uint8(zeros([vid.Height, vid.Width, 3, vid.NumFrames]));
I = uint8(zeros([N, N, 3, vid.NumFrames]));

i=1;
while hasFrame(vid)
    Temp = readFrame(vid);
    I(:,:,:,i) = imresize(Temp, [N,N]);
    i = i+1;
end
numFrames= 5; % for testing
I2 = I(:,:,:,1:numFrames);
clear I;
I = I2;
clear I2;


% Adding noise
nFrames = size(I,4);
noiseRate = 0.1;
quantization_level_num = 10;

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

        % Poisson (photon shot) noise
        I(:,:,c,i) = imnoise(I(:,:,c,i),'poisson');

        % Impulsive (salt and pepper) noise 
        I(:,:,c,i) = imnoise(I(:,:,c,i),'salt & pepper',noiseRate);
    end
end 

% Median Filter and Block Matching
Img = I;
clear I;
dim = size(Img);
K = dim(4);
mb = 8;
frameStep = 1;


Reconstructed = zeros(size(Img),'uint32');
Scaling = Reconstructed;

% loop
for c=1:3
    
    I = reshape(Img(:,:,c,:), [dim(1),dim(2),dim(4)]); % Single channel image seq
    dim2 = size(I);
    I2 = zeros([N,N,K], 'uint8');
    Omega = zeros(dim2,'double');
    
    % Median Filter  
    thresh = 20;
    tic
    for k = 1:K
        [a, b] = AdaptiveMedianFilter(I(:,:,k)); % Adaptive Median filter
        I2(:,:,k) = b;
        Omega(:,:,k) = a;
        Omega2(:,:,k) = upOmega(I(:,:,k), thresh, Omega(:,:,k));
    end
    toc
    
    Omega = Omega2;
    
    
    clear I;
    I = I2;
    clear I2;

    % vec = zeros(N,N,K-1,2);

    dim2 = size(I);
    for k = 1:frameStep:K % check
        k
        % for k = 1:1 
        % For each frame at frameSIze gap

        %%%%%% Block Matching %%%%%
        Mappings = zeros([dim2(1),dim2(2),dim2(3),2],'uint8');
        % Block Mapping of frame k with all the frame
        for kk=1:K
            if (kk==k)
                continue
            end
%             r = blockMatching(I(:,:,k),I(:,:,kk),mb);
            Mappings(:,:,kk,:) = blockMatching(I(:,:,k),I(:,:,kk),mb);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        

        %%%%%% Denoise and Reconstruction %%%%%
        for i = 1:mb:N
            for j = 1:mb:N
%                 [i,j]
                P = zeros(mb*mb,K);
                omg = P;
                for kk=1:K
                    if (kk == k)
                        P(:,kk) = reshape(I(i:i+(mb-1), j:j+(mb-1), k), [mb*mb,1]);
                        % Forming patch matrix
                        omg(:,kk) = reshape(Omega(i:i+(mb-1), j:j+(mb-1), k), [mb*mb,1]);
                        % Forming initial omega matrix using median filter errors
                        continue
                    end
                    x = Mappings(i,j,kk,1);
                    y = Mappings(i,j,kk,2);
                    % patch similar to i,j  in kk_th frame
                    P(:,kk) = reshape(I(x:x+(mb-1), y:y+(mb-1), kk), [mb*mb, 1]);
                    % Forming patch matrix
                    omg(:,kk) = reshape(Omega(x:x+(mb-1), y:y+(mb-1), kk), [mb*mb, 1]);
                    % Forming initial omega matrix using median filter errors
                end
                
%                 omg = UpdateOmega(P,omg);                
                
                
                Q = denoise(omg,P);
%                 Q = P;

                

                for kk=1:K
                    if(kk==k)
                        Reconstructed(i:i+(mb-1), j:j+(mb-1), c, k) = Reconstructed(i:i+(mb-1), j:j+(mb-1), c, k) + uint32(reshape(Q(:,kk),[mb, mb]));
                        Scaling(i:i+(mb-1), j:j+(mb-1), c, k) = Scaling(i:i+(mb-1), j:j+(mb-1), c, k) + 1;
                        continue
                    end
                    x = Mappings(i,j,kk,1);
                    y = Mappings(i,j,kk,2);
                    Reconstructed(x:x+(mb-1), y:y+(mb-1), c, kk) = Reconstructed(x:x+(mb-1), y:y+(mb-1), c, kk) + uint32(reshape(Q(:,kk),[mb, mb]));
                    Scaling(x:x+(mb-1), y:y+(mb-1), c, kk) = Scaling(x:x+(mb-1), y:y+(mb-1), c, kk) + 1;
                    
%                     x = i;
%                     y = j;
%                     Reconstructed(x:x+(mb-1), y:y+(mb-1), c, k) = Reconstructed(x:x+(mb-1), y:y+(mb-1), c, k) + uint32(reshape(Q(:,kk),[mb, mb]));
%                     Scaling(x:x+(mb-1), y:y+(mb-1), c, k) = Scaling(x:x+(mb-1), y:y+(mb-1), c, k) + 1;
                end
            end
        end
    end
end
Reconstructed = Reconstructed./Scaling;
save("miss.mat");
%% imshow


for f = 1:nFrames
    frame = f;
    subplot(1,2,1);
    imshow(Img(:,:,:,frame),'InitialMagnification',500);
    subplot(1,2,2);
    imshow(uint8(Reconstructed(:,:,:,frame)),'InitialMagnification',500);
    pause();
end

close all;
