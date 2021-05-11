%% Generate image seqeunce from the reconsruction

clear; clc; close all;
name = "miss";
file = sprintf('%s.mat',name);
load(file);


for f = 1:nFrames
    frame = f;
    subplot(1,2,1);
    imshow(Img(:,:,:,frame),'InitialMagnification',500);
    subplot(1,2,2);
    imshow(uint8(Reconstructed(:,:,:,frame)),'InitialMagnification',500);
    str = sprintf('images/%s/%s_%d.png',name,name,f);
    saveas(gcf, str, 'png');
end

close all;