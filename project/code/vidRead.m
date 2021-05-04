clear; close all; clc;

vid = VideoReader('../data/out.mp4');

while hasFrame(vid)
    vidFrame = readFrame(vid);
    imshow(vidFrame)
    pause(1/vid.FrameRate);
end