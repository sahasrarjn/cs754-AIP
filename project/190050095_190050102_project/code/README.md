## Instructions to run

#### Files:

- **main.m**: Main script

- **AdaptiveMedianFilter.m**: Median Filter

- **blockMatching.m**: Matching algorithm

- **denoise.m**: Fixed point iteration algo 

- **costfnMAD.m**: Cost function for Block Matching

- **genImageSeq.m**: Generate image sequence

- **upOmega.m**: Utility fn for main code



#### How to run:


1. Change the variable "name" in the `main.m` script to read the .mp4 video in the mp4 directory, add noise and compute the reconstructed image.

2. Change the variable "name" in the script `getImageSeq.m` to read the saved data and generate the image sequence.

```matlab
name = "miss";
```




#### Directories: 

- Data : `data`
- Original video: `mp4`
- Generated output: `images`