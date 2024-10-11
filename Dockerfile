FROM debian:12.5-slim as base
RUN sed -i '/Components: main/c\Components: main contrib non-free non-free-firmware' /etc/apt/sources.list.d/debian.sources
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt update 
RUN apt install libavcodec59 libavformat59 libswresample4 libswscale6 libtesseract5 libopenni2-0 libusb-1.0-0 libgdal32 libgdcm3.0 libjpeg62-turbo libgif7 libpython3-dev python3-pip -y
#RUN apt clean --dry-run 
#RUN apt autoclean

#RUN apt install cmake g++-11 make git libavcodec-dev libavformat-dev libswresample-dev libswscale-dev libeigen3-dev libtesseract-dev libopenni2-dev libopenni-dev libusb-1.0-0-dev libgdal-dev libgdcm-dev libpython3-dev python3-pip -y; 
RUN pip3 install numpy --break-system-packages

FROM base as builder

RUN apt install cmake g++-11 make git libavcodec-dev libavformat-dev libswresample-dev libswscale-dev libeigen3-dev libtesseract-dev libopenni2-dev libopenni-dev libusb-1.0-0-dev libgdal-dev libgdcm-dev libpython3-dev python3-pip -y; 

RUN mkdir /home/libs

WORKDIR /home/libs
RUN git clone https://github.com/davisking/dlib.git --branch v19.22 --single-branch; 
RUN mkdir /home/libs/dlib/build; 
WORKDIR /home/libs/dlib/build
RUN cmake /home/libs/dlib -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local -DCPACK_BINARY_DEB=ON -DCPACK_DEBIAN_PACKAGE_MAINTAINER=davisking;
RUN make -j 4 install

WORKDIR /home/libs
RUN git clone https://github.com/opencv/opencv.git --branch 4.8.0 --single-branch; 
RUN git clone https://github.com/opencv/opencv_contrib.git --branch 4.8.0 --single-branch; 
RUN mkdir /home/libs/opencv/build
WORKDIR /home/libs/opencv/build
RUN CXX=g++-11 CC=gcc-11 cmake /home/libs/opencv -DCMAKE_BUILD_TYPE=MinSizeRel -DWITH_CUDA=ON -DWITH_CUDNN=ON -DCUDA_ARCH_BIN=75 -DCUDA_ARCH_PTX=75 -DWITH_QT=ON -DWITH_OPENCL=ON -DWITH_FFMPEG=ON -DWITH_TESSERACT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON -DWITH_GDAL=ON -DWITH_GDCM=ON -DOPENCV_EXTRA_MODULES_PATH=/home/libs/opencv_contrib/modules -DOPENCV_DNN_OPENCL=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DOPENCV_ENABLE_NONFREE=ON -DPYTHON3_PACKAGES_PATH=/usr/local/lib/python3.11/dist-packages/
RUN make -j 4 install

FROM base as runner

WORKDIR /home

COPY --from=builder /usr/local /usr/local

ENTRYPOINT [ "/bin/bash" ]
