FROM ubuntu:20.04
RUN ln -snf /usr/share/zoneinfo/Brazil/East /etc/localtime && echo Brazil/East > /etc/timezone; 
RUN apt update;DEBIAN_FRONTEND=noninteractive apt install cmake build-essential git -y; apt clean --dry-run; apt autoclean;

WORKDIR /home
RUN git clone https://github.com/davisking/dlib.git --branch v19.22 --single-branch; mkdir /home/libs/build; cd /home/dlib/build; cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local; make -j 1 install; cd ../..; rm -rf dlib; ldconfig
RUN git clone https://github.com/opencv/opencv.git --branch 4.6.0 --single-branch; git clone https://github.com/opencv/opencv_contrib.git --branch 4.6.0 --single-branch; mkdir /home/opencv/build; cd /home/opencv/build; cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel -DWITH_OPENCL=ON -DWITH_FFMPEG=ON -DOPENCV_EXTRA_MODULES_PATH=/home/libs/opencv_contrib/modules -DOPENCV_DNN_OPENCL=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DOPENCV_ENABLE_NONFREE=ON -DPYTHON3_PACKAGES_PATH=lib/python3.8/dist-packages; make -j 1 install; cd ../..; rm -rf opencv opencv_contrib; ldconfig
RUN git clone https://github.com/PointCloudLibrary/pcl.git --branch pcl-1.12.1 --single-branch; mkdir /home/pcl/build; cd /home/pcl/build; cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_global_tests=OFF -DBUILD_examples=OFF -DBUILD_apps=OFF -DBUILD_apps_3d_rec_framework=OFF -DBUILD_apps_cloud_composer=OFF -DBUILD_apps_in_hand_scanner=OFF -DBUILD_apps_modeler=OFF -DBUILD_apps_point_cloud_editor=OFF -DBUILD_benchmarks=OFF -DBUILD_tools=OFF;make -j 1 install; cd ../..; rm -rf pcl; ldconfig

WORKDIR /home
RUN rm -rf /home/libs
ENTRYPOINT [ "/bin/bash" ]
