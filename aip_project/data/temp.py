import cv2
from sys import argv

file = argv[1];

cap = cv2.VideoCapture(file)
length = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
print( length )
