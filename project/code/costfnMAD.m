% Ref:
% New Technique of Three Step Search Algorithm used for Motion Estimation in Video Compression
% Mr. Rahul Bhandari, Mr. Ashutosh Vyas


function cost = costfnMAD(I1, I2, n)
	err=0;
    err = uint32(err);
	dim = size(I1);
	for i = 1:dim(1)
		for j = 1:dim(2)
			err = err + uint32(abs(I1(i,j) - I2(i,j)));
		end
    end
    n = uint32(n);
	cost = err / n*n;
