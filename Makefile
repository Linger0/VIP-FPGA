CXX = g++
CXXFLAGS = -Wall
LIBS = -I/usr/include/opencv4 -lopencv_core -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs

TARGET = $(MAKECMDGOALS)

all:
	@echo -e "\033[31mUsage:\033[0m Specify a target name!"

$(TARGET): $(TARGET).cpp
	$(CXX) $(CXXFLAGS) -o $@.out $< $(LIBS)

.PHONY: all