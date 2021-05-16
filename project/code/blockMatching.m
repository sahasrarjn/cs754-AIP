% Ref:
% New Technique of Three Step Search Algorithm used for Motion Estimation in Video Compression
% Mr. Rahul Bhandari, Mr. Ashutosh Vyas


function mapping = blockMatching(I1, I2, mb, stride)
	% mb: size of stride
	% mapping(x,y) will return x',y' of the similar patch in I2
	% (x,y) in I1 and (x',y') in I2 are similar


    mb = uint8(mb);

	[row, col] = size(I2);
    mapping = uint8(zeros(row,col,2));
    
    if (I1 == I2)
        for i=1:row
            for j=1:col
                mapping(i,j,1) = uint8((i-1 - mod(i-1,mb)) + 1);
                mapping(i,j,1) = uint8((j-1 - mod(j-1,mb)) + 1);

            end
        end
    end


	if (mod(row,mb) ~= 0 || mod(col,mb) ~= 0)
		printf("Invalid mb value")
		return 
    end
	

	pos = [0 -1 0 1 0; -1 0 0 0 1];

	for i = 1 : mb : (row-mb)+1
		for j = 1 : mb : (col-mb)+1
            

			S = 2*mb-1; % step size

			ox = i;
			oy = j;

			while S>1
                S = uint8(S);
				minSAD = intmax('uint32');
				minX = ox;
				minY = oy;

				for t = 1:5
					x = ox + pos(1,t)*S;
					y = oy + pos(2,t)*S;

					if(x < 1 || x+(mb-1) > row || y < 1 || y+(mb-1) > col)
						continue;
					end
					
					% compute MAD            
					sad = costfnMAD(I1(i:i+(mb-1), j:j+(mb-1)), I2(x:x+(mb-1), y:y+(mb-1)), mb);

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

			minSAD = intmax('uint32');

			for ii=-1:1
				for jj=-1:1
					x = ox + ii;
					y = oy + jj;
                    
                    if(x < 1 || x+(mb-1) > row || y < 1 || y+(mb-1) > col)
						continue;
					end

					sad = costfnMAD(I1(i:i+(mb-1), j:j+(mb-1)), I2(x:x+(mb-1), y:y+(mb-1)), mb);

					if sad < minSAD 
						minSAD = sad;
						minX = x;
						minY = y;
					end
				end
			end

			for ii=i:i+(mb-1)
				for jj=j:j+(mb-1)
					mapping(ii,jj,1) = uint8((minX-1 - mod(minX-1,mb)) + 1);
					mapping(ii,jj,2) = uint8((minY-1 - mod(minY-1,mb)) + 1);
                end
            end
		end
	end 
end

