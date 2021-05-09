function mapping = blockMatching(I1, I2, mb)
	% mb: size of block

	% mapping(x,y) will return x',y' of the similar patch in I2
	% (x,y) in I1 and (x',y') in I2 are similar


	[row, col] = size(I2);

	if (mod(row,mb) ~= 0 || mod(col,mb) ~= 0)
		printf("Invalid mb value")
		return 
	end 

	mapping = zeros(row,col,2);

	pos = [0 -1 0 1 0; -1 0 0 0 1];
	cnt = 0

	for i = 1 : mb : row-mb+1
		for j = 1 : mb : col-mb+1

			S = min(row,col)/2; % step size

			% ox = size(I1,1)/2;
			% oy = size(I1,2)/2;
			ox = i;
			oy = j;

			while S>1
				minSAD = intmax('double');
				minX = 0;
				minY = 0;

				% Can be further optimised if we store the SAD value of origin from the previous run
				for t = 1:5
					x = ox + pos(1,t)*S;
					y = oy + pos(2,t)*S;

					if(x < 1 || x+mb-1 > row || y < 1 || y+mb-1 > col)
						continue;
					end
					
					% compute SAD
					sad = costfnSAD(I1(i:i+mb-1, j:j+mb-1), ... 
						I2(x:x+mb-1, y:y+mb-1), n);

					if sad < minSAD 
						minSAD = sad;
						minX = x;
						minY = y;
					end
				end

				ox = minX;
				oy = minY;
				S = S/2;
			end 

			minSAD = intmax('double');

			for ii=-1:1
				for jj=-1:1
					x = ox + ii;
					y = oy + jj;

					sad = costfnSAD(I1(i:i+mb-1, j:j+mb-1), ... 
						I2(x:x+mb-1, y:y+mb-1), n);

					if sad < minSAD 
						minSAD = sad;
						minX = x;
						minY = y;
					end
				end
			end

			for ii=1:row
				for jj=1:col
					mapping(ii,jj,1) = minX;
					mapping(ii,jj,2) = minY;
				end
			end
		end
	end 



