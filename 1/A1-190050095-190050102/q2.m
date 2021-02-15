clc; close; clear;
addpath('MMread');
tic;

% To run change T, video file accordingly

T = 5;
[video, ~] = mmread('../cars.avi', 1:T);

HH = video.height;
WW = video.width;

H = 120;
W = 240;

F = cast(zeros([HH,WW,3,T]), 'uint8');

for i=1:T
    F(:,:,:,i) = video.frames(i).cdata;
end

C = double(randi([0,1],[H,W,T]));
Ft = zeros(H,W,T);
CSnaps = zeros(H,W,T);

I = double(zeros([H,W]));
for i = 1:T
    Ft(:,:,i) = rgb2gray(F(HH-H:HH-1,WW-W:WW-1,:,i));
    CSnaps(:,:,i) = Ft(:,:,i).*C(:,:,i);
    I = I + CSnaps(:,:,i);
end

I = I + 2*randn(H,W);
imshow(I/max(max(I)));
title('Coded Snapshot with noise');
saveas(gcf,'coded_snapshot.png', 'png');

epsilon = 2304; % m=64, sigma=2, epsilon >= 9 * 64 * 2 * 2 = 2304
D = dctmtx(8);
DD = kron(D,D)';
psi = kron(eye(T),DD);
recons = zeros(H,W,T);
cnt = zeros(H,W,T);

for i=1:H-7
    i %#ok<NOPTS>
    for j=1:W-7
        Cij = C(i:i+7, j:j+7, :);
        A = [];
        for t=1:T
            Ctemp = diag(reshape(Cij(:,:,t)',64,1))*DD;
            A = [A Ctemp];
        end
        
        patch = I(i:i+7,j:j+7);
        b = reshape(patch', 64, 1);
        theta = psi*omp(A,b,epsilon); % This is 64*T x 1 matrix
        
        for t=1:T
            tempTheta = reshape(theta(64*(t-1)+1:64*t,:),8,8);
            recons(i:i+7, j:j+7, t) = recons(i:i+7, j:j+7, t) + tempTheta';
            cnt(i:i+7, j:j+7, t) = cnt(i:i+7, j:j+7, t) + ones(8,8); % Sum (required for taking avg later)
        end
    end
end

save('data.mat')

wid = T*100;

figure('Position', [10 10 400 wid])

final = recons./cnt;
toc
for i=1:T
    subplot(T,2,2*i-1);
    imshow(cast(Ft(:,:,i),'uint8'));
    title('Original')
    
    subplot(T,2,2*i);
    imshow(cast(final(:,:,i),'uint8'));
    title('Reconstructed')
end

saveas(gcf,'reconstruction.png', 'png');

rmse = rssq(rssq(rssq(final-Ft)))/rssq(rssq(rssq(Ft)));
mse = rmse^2;
fprintf('Relative MSE for T=%s is %s\n', num2str(T), num2str(mse));