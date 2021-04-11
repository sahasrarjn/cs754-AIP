import sys
import y4m
import matplotlib.pyplot as plt


def process_frame(frame):
    # do something with the frame
    print(frame)


if __name__ == '__main__':

    parser = y4m.Reader(process_frame, verbose=True)
    # simulate chunk of data
    infd = sys.stdin
    if sys.hexversion >= 0x03000000: # Python >= 3
        infd = sys.stdin.buffer
    # infd = open("../data/subset2-y4m/Baruch.y4m",'rb')

    with infd as f:
    	while True:
    		data = f.read(1024)
    		if not data:
    			break;
    		parser.decode(data)
