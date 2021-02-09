T = 3; % no. of frames
videoFile = "../cars.avi";

[video, audio] = mmread(videoFile, T);

