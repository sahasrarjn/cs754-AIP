clc; clear; close();
addpath('MMread');
tic;

% To run change T, videofile accordingly

T = 5;
[video, ~] = mmread('../cars.avi', 1:T);

H = video.height;
W = video.width;

v = VideoReader('../cars.avi');
F = read(v,[1,T]);
C = double(randi([0,1],[H,W,T]));
Ft = zeros(H,W,T);
CSnaps = zeros(H,W,T);

I = zeros([H,W]);
for i = 1:T
    Ft(:,:,i) = rgb2gray(F(:,:,:,i));
    CSnaps(:,:,i) = Ft(:,:,i).*C(:,:,i);
    I = I + CSnaps(:,:,i);
end

I = I + 2*randn(H,W);
imshow(cast(I,'uint8'));
title('Coded Snapshot with noise');
saveas(gcf,'coded_snapshot.png', 'png');

epsilon = 48;
D = dctmtx(8);
DD = kron(D,D)';
psi = kron(eye(T),DD);
recons = zeros(H,W,T);
cnt = zeros(H,W,T);

toc

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
        theta = psi*omp(A,b,epsilon);
        
        for t=1:T
            l = 64*(t-1)+1;
            h = 64*t;
            tempTheta = reshape(theta(l:h,:),8,8);
            recons(i:i+7, j:j+7, t) = recons(i:i+7, j:j+7, t) + tempTheta';
            cnt(i:i+7, j:j+7, t) = cnt(i:i+7, j:j+7, t) + ones(8,8); % Sum (required for taking avg later)
        end
    end
end

wid = T*100;

figure('Position', [50 50 300 wid])

final = recons./cnt;
for i=1:T
    subplot(T,3,3*i-2);
    imshow(cast(CSnaps(:,:,i),'uint8'));
    title('Coded Snapshot')
    
    subplot(T,3,3*i-1);
    imshow(cast(Ft(:,:,i),'uint8'));
    title('Original')
    
    subplot(T,3,3*i);
    imshow(cast(final(:,:,i),'uint8'));
    title('Reconstructed')
end

saveas(gcf,'reconstruction.png', 'png');

rmse = rssq(rssq(rssq(final-Ft)))/rssq(rssq(rssq(Ft)));
fprintf('RMSE for T=%s is %s\n', num2str(T), num2str(rmse));