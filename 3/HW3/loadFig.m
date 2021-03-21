function img = loadFig(file)
	% Load figure and pad it to make a square image of size 218 x 218
    img = imread(file);
    img = padarray(img, [19, 0], 0, 'pre');
    img = padarray(img, [18, 0], 0, 'post');
    img = padarray(img, [0,1], 0, 'pre');
    img= double(img*1.0)/255;
end