% Ref:
% New Technique of Three Step Search Algorithm used for Motion Estimation in Video Compression
% Mr. Rahul Bhandari, Mr. Ashutosh Vyas


function cost = costfnSAD(I1, I2, n)
	err=0;
	dim = size(I1);
	for i = 1:dim(1)
		for j = 1:dim(2)
			err = err + abs(I1(i,j) - I2(i,j))
		end
	end
	cost = err;