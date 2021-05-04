mkdir $1_mp4
cd $1
for f in *.y4m
do
    echo processing...
	ffmpeg -i $f ../$1_mp4/"${f%%.*}".mp4
	# echo ../$1_mp4/"${f%%.*}".mp4
done
