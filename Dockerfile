FROM ubuntu:20.04
RUN ln -snf /usr/share/zoneinfo/Brazil/East /etc/localtime && echo Brazil/East > /etc/timezone; apt update;DEBIAN_FRONTEND=noninteractive apt install cmake qt5-default libboost-all-dev build-essential libzbar-dev libssl-dev git libavc1394-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavresample-dev libavutil-dev libavresample-dev libswresample-dev libswscale-dev libeigen3-dev opencl-c-headers opencl-clhpp-headers opencl-headers ocl-icd-dev libtesseract-dev libzbar-dev libdmtx-dev libvtk7-qt-dev libopenni2-dev libopenni-dev libflann-dev libusb-1.0-0-dev libgdal-dev libgdcm-dev -y; mkdir /home/libs

WORKDIR /home/libs
RUN git clone https://github.com/opencv/opencv.git --branch 4.6.0 --single-branch; git clone https://github.com/opencv/opencv_contrib.git --branch 4.6.0 --single-branch; mkdir /home/libs/opencv/build; cd /home/libs/opencv/build; cmake .. -DWITH_QT=ON -DWITH_OPENCL=ON -DWITH_FFMPEG=ON -DWITH_TESSERACT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON -DWITH_GDAL=ON -DWITH_GDCM=ON -DOPENCV_EXTRA_MODULES_PATH=/home/libs/opencv_contrib/modules -DOPENCV_DNN_OPENCL=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DOPENCV_ENABLE_NONFREE=ON; make -j 1 install; cd ../..; rm -rf opencv opencv_contrib

WORKDIR /home/libs
RUN git clone https://github.com/PointCloudLibrary/pcl.git --branch pcl-1.12.1 --single-branch; mkdir /home/libs/pcl/build; cd /home/libs/pcl/build; cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_VTK=ON -DWITH_QT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON -DBUILD_global_tests=OFF -DBUILD_examples=OFF -DBUILD_apps=OFF -DBUILD_apps_3d_rec_framework=OFF -DBUILD_apps_cloud_composer=OFF -DBUILD_apps_in_hand_scanner=OFF -DBUILD_apps_modeler=OFF -DBUILD_apps_point_cloud_editor=OFF -DBUILD_benchmarks=OFF -DBUILD_tools=OFF;make -j 1 install; cd ../..; rm -rf pcl;

WORKDIR /home/libs
RUN git clone https://github.com/davisking/dlib.git --branch v19.22 --single-branch; mkdir /home/libs/dlib/build; cd /home/libs/dlib/build; cmake .. -DCMAKE_INSTALL_PREFIX=/usr/local; make -j 1 install; cd ../..; rm -rf dlib;

WORKDIR /home
RUN rm -rf /home/libs
ENTRYPOINT [ "/bin/bash" ]
