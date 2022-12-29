DEBIAN_FRONTEND=noninteractive

ln -snf /usr/share/zoneinfo/Brazil/East /etc/localtime && echo Brazil/East >/etc/timezone

apt update

apt install cmake g++ make git libavcodec-dev libavformat-dev libavresample-dev libswscale-dev libeigen3-dev libtesseract-dev libopenni2-dev libopenni-dev libusb-1.0-0-dev libgdal-dev libgdcm-dev libpython3-dev python3-pip -y

apt-get -y install g++ cmake cmake-gui doxygen mpi-default-dev openmpi-bin openmpi-common
apt-get -y install libusb-1.0-0-dev libqhull* libusb-dev libgtest-dev
apt-get -y install git-core pkg-config build-essential libxmu-dev libxi-dev
apt-get -y install libphonon-dev libphonon-dev phonon-backend-gstreamer
apt-get -y install phonon-backend-vlc graphviz mono-complete
apt-get -y install qtbase5-dev qt5-qmake
apt-get -y install freeglut3-dev

apt-get -y install libflann1.9 libflann-dev
apt-get -y install libboost-all-dev
apt-get -y install libeigen3-dev

apt clean --dry-run
apt autoclean

pip3 install numpy

#wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_460.32.03_linux.run
#
#sh cuda_11.2.2_460.32.03_linux.run
#
#wget https://developer.download.nvidia.com/compute/machine-learning/cudnn/secure/8.1.1.33/11.2_20210301/cudnn-11.2-linux-x64-v8.1.1.33.tgz
#

mkdir /home/libs

cd /home/libs

git clone https://github.com/davisking/dlib.git --branch v19.22 --single-branch

mkdir /home/libs/dlib/build

cd /home/libs/dlib/build

cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local

make -j 10 install

cd ../..

git clone https://github.com/opencv/opencv.git --branch 4.6.0 --single-branch

git clone https://github.com/opencv/opencv_contrib.git --branch 4.6.0 --single-branch

mkdir /home/libs/opencv/build

cd /home/libs/opencv/build

#-DWITH_CUDA=ON

cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel \
  -DCUDA_TOOLKIT_ROOT_DIR=/usr/lib/cuda \
  -DOpenCL_LIBRARY=/usr/lib/cuda/lib64/libOpenCL.so \
  -DOpenCL_INCLUDE_DIR=/usr/lib/cuda/include/ \
  -DWITH_CUBLAS=ON -DWITH_CUDA=ON -DWITH_CUDA=ON -DWITH_CUDNN=ON -DOPENCV_DNN_CUDA=ON \
  -DWITH_QT=ON -DWITH_OPENCL=ON -DWITH_FFMPEG=ON -DWITH_TESSERACT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON -DWITH_GDAL=ON -DWITH_GDCM=ON -DOPENCV_EXTRA_MODULES_PATH=/home/libs/opencv_contrib/modules -DOPENCV_DNN_OPENCL=ON -DBUILD_TESTS=OFF -DBUILD_PERF_TESTS=OFF -DOPENCV_ENABLE_NONFREE=ON -DPYTHON3_PACKAGES_PATH=/usr/local/lib/python3.8/dist-packages/

make -j 10 install

cd ../..

git clone https://github.com/PointCloudLibrary/pcl.git --branch pcl-1.12.1 --single-branch

mkdir /home/libs/pcl/build

cd /home/libs/pcl/build

cmake .. -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_INSTALL_PREFIX=/usr/local -DWITH_VTK=ON -DWITH_QT=ON -DWITH_OPENNI=ON -DWITH_OPENNI2=ON -DBUILD_global_tests=OFF -DBUILD_examples=OFF -DBUILD_apps=OFF -DBUILD_apps_3d_rec_framework=OFF -DBUILD_apps_cloud_composer=OFF -DBUILD_apps_in_hand_scanner=OFF -DBUILD_apps_modeler=OFF -DBUILD_apps_point_cloud_editor=OFF -DBUILD_benchmarks=OFF -DBUILD_tools=OFF

make -j 10 install

ldconfig

cd ../..
