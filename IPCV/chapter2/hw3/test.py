import numpy as np
import cv2 as cv
img1 = cv.imread('view1.png', cv.IMREAD_COLOR)
img2 = cv.imread('view5.png', cv.IMREAD_COLOR)
sift = cv.SIFT_create(nfeatures=400)
# find the keypoints and descriptors with SIFT
kp1, des1 = sift.detectAndCompute(img1, None)
kp2, des2 = sift.detectAndCompute(img2, None)
# FLANN parameters
matcher = cv.DescriptorMatcher_create(cv.DescriptorMatcher_FLANNBASED)
knn_matches = matcher.knnMatch(des1, des2, 2)
pts1 = []
pts2 = []
good_matches = []
# ratio test as per Lowe's paper
for m, n in knn_matches:
  if m.distance < 0.8 * n.distance:
    good_matches.append(m)
    pts2.append(kp2[m.trainIdx].pt)
    pts1.append(kp1[m.queryIdx].pt)
img_matches = np.empty( (img1.shape[0], img1.shape[1]+img2.shape[1], 3), dtype=np.uint8 )
cv.drawMatches(img1, kp1, img2, kp2, good_matches, img_matches, flags=cv.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)
cv.imshow("Good", img_matches)

pts1 = np.int32(pts1)
pts2 = np.int32(pts2)
F, mask = cv.findFundamentalMat(pts1, pts2, cv.RANSAC)
# We select only inlier points
pts1 = pts1[mask.ravel()==1]
pts2 = pts2[mask.ravel()==1]

def drawlines(img1, img2, lines, pts1, pts2):
  ''' img1 - image on which we draw the epilines for the points in img2
      lines - corresponding epilines '''
  r, c, _ = img1.shape
  for r, pt1, pt2 in zip(lines, pts1, pts2):
    color = tuple(np.random.randint(0,255,3).tolist())
    x0, y0 = map(int, [0, -r[2]/r[1] ])
    x1, y1 = map(int, [c, -(r[2]+r[0]*c)/r[1] ])
    img1 = cv.line(img1, (x0,y0), (x1,y1), color, 1)
    img1 = cv.circle(img1, tuple(pt1), 5, color, -1)
    img2 = cv.circle(img2, tuple(pt2), 5, color, -1)
  return img1, img2

# Find epilines corresponding to points in right image (second image) and
# drawing its lines on left image
lines1 = cv.computeCorrespondEpilines(pts2.reshape(-1,1,2), 2, F)
lines1 = lines1.reshape(-1, 3)
img5, img6 = drawlines(img1, img2, lines1, pts1, pts2)
# Find epilines corresponding to points in left image (first image) and
# drawing its lines on right image
lines2 = cv.computeCorrespondEpilines(pts1.reshape(-1,1,2), 1, F)
lines2 = lines2.reshape(-1, 3)
img3, img4 = drawlines(img2, img1, lines2, pts2, pts1)
dst = cv.hconcat([img5, img3])
cv.imshow("Line", dst)
cv.imwrite("lines.jpg", dst)

h, w, _ = img1.shape
_, H1, H2 = cv.stereoRectifyUncalibrated(
  np.float32(pts1), np.float32(pts2), F, imgSize=(h, w)
)
img1_rectified = cv.warpPerspective(img1, H1, (h, w))
img2_rectified = cv.warpPerspective(img2, H2, (h, w))
cv.imshow("Rect 1", img1_rectified)
cv.imshow("Rect 2", img2_rectified)

while (cv.waitKey(0) != 122): pass