cd y4m
for f in *.y4m
do
	ffmpeg -i $f ../mp4/"${f%%.*}".mp4
done
