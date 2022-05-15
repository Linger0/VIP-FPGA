CXX = g++
CXXFLAGS = -Wall -g
LIBS = -I/usr/local/include/opencv4 -lopencv_core -lopencv_imgproc -lopencv_highgui \
	-lopencv_imgcodecs -lopencv_objdetect -lopencv_videoio -lopencv_video -lopencv_calib3d \
	-lopencv_stitching -lopencv_xfeatures2d -lopencv_features2d -lopencv_ximgproc

TARGET = $(MAKECMDGOALS)

all:
	@echo -e "\033[31mUsage:\033[0m Specify a target name!"

$(TARGET): $(TARGET).cpp
	$(CXX) $(CXXFLAGS) -o $@.out $< $(LIBS)

.PHONY: all