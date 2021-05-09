% Ref:
% New Technique of Three Step Search Algorithm used for Motion Estimation in Video Compression
% Mr. Rahul Bhandari, Mr. Ashutosh Vyas


function cost = costfnSAD(I1, I2, n)
	err=0;
	for i = 1:n
		for j = 1:n
			err = err + abs(I1(i,j) - I2(i,j))
		end
	end
	cost = err;