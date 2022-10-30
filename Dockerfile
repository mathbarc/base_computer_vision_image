FROM ubuntu:20.04
RUN ln -snf /usr/share/zoneinfo/Brazil/East /etc/localtime && echo Brazil/East > /etc/timezone; 
RUN apt update;DEBIAN_FRONTEND=noninteractive apt install cmake g++ make git -y; apt clean --dry-run; apt autoclean

WORKDIR /home
RUN git clone https://github.com/opencv/opencv.git --branch 4.6.0 --single-branch; git clone https://github.com/opencv/opencv_contrib.git --branch 4.6.0 --single-branch; mkdir /home/opencv/build; cd /home/opencv/build; cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel -DWITH_OPENCL=ON -DWITH_FFMPEG=ON -DOPENCV_EXTRA_MODULES_PATH=/home/opencv_contrib/modules -DOPENCV_DNN_OPENCL=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DOPENCV_ENABLE_NONFREE=ON -DPYTHON3_PACKAGES_PATH=lib/python3.8/dist-packages; make -j 1 install; cd ../..; rm -rf opencv opencv_contrib; ldconfig

WORKDIR /home
RUN rm -rf /home/libs
ENTRYPOINT [ "/bin/bash" ]
