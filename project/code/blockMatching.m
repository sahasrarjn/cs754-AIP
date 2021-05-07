R=10;N=8;
for x = 1:N:height-N
	for y = 1:N:width-N
		MAD_min = 256;
		mvx = 0;
		mvy = 0;
		for k = -R:1:R
			for l = -R:1:R
				MAD = 0;
				for u = x:x+N-1
					for v = y:y+N-1
						if ((u+k > 0)&&(u+k < height + 1)&&(v+l > 0)&&(v+l < width + 1))
							MAD = MAD + abs(f1(u,v)-f2(u+k,v+l));
						end
					end
				end
				MAD = MAD/(N*N);
				if (MAD<MAD_min)
					MAD_min = MAD;
					dy = k;
					dx = l;
				end
			end
		end
		xblk = floor((x-1)/(N+1))+1;
		yblk = floor((y-1)/(N+1))+1;
		mvx(xblk,yblk) = dx;
		mvy(xblk,yblk) = dy;
	end
end