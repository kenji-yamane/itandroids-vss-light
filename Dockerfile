FROM ubuntu:18.04

# Primary packages
RUN apt-get update && apt-get install --no-install-recommends -y \
    sudo \
    git \
    wget \
    gcc-5 \
    g++-5 \
    cmake \
    unzip \
    build-essential \
    libboost-all-dev \
    libeigen3-dev \
    qt5-default \
    libgtk2.0-dev \
    pkg-config \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libglade2-0 \
    libglademm-2.4-1v5 \
    libgtkmm-2.4-1v5 \
    libatkmm-1.6-dev \
    libcairomm-1.0-dev \
    libglade2-dev \
    libglademm-2.4-dev \
    libglibmm-2.4-dev \
    libgtkglext1-dev \
    libgtkglextmm-x11-1.2-0v5 \
    libgtkglextmm-x11-1.2-dev \
    libgtkmm-2.4-dev \
    libpangomm-1.4-dev \
    libpangox-1.0-dev \
    libsigc++-2.0-dev \
    libois-dev \
    libraw1394-11 \
    libusb-1.0-0 \
    libzmq3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# ODE Package
RUN wget https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz --no-check-certificate -O ode-0.15.2.tar.gz \
    && tar -zxvf ode-0.15.2.tar.gz && rm ode-0.15.2.tar.gz

WORKDIR /ode-0.15.2/

# Make build ODE
RUN ./configure --enable-double-precision --with-demos CXXFLAGS="-fpic" \
    && make CC=gcc-5 CPP=g++-5 CXX=g++-5 LD=g++-5 -j 4 && make install

WORKDIR /

# Protobuf Package
RUN wget https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-cpp-3.5.1.tar.gz --no-check-certificate \
    && tar -xvf protobuf-cpp-3.5.1.tar.gz && rm protobuf-cpp-3.5.1.tar.gz 
    
WORKDIR /protobuf-3.5.1/

# Make build protobuf
RUN ./configure && make -j 4 \
    && make install \
    && ldconfig

WORKDIR /

# OpenCV Package
RUN sudo wget -c -N https://github.com/Itseez/opencv/archive/3.4.2.zip --no-check-certificate -O opencv-3.4.2.zip \
    && unzip opencv-3.4.2.zip

WORKDIR /opencv-3.4.2/build/

# Make build OpenCV
RUN cmake -G "Unix Makefiles" -D CMAKE_CXX_COMPILER=/usr/bin/g++ CMAKE_C_COMPILER=/usr/bin/gcc -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D BUILD_FAT_JAVA_LIB=ON -D INSTALL_TO_MANGLED_PATHS=ON -D INSTALL_CREATE_DISTRIB=ON -D INSTALL_TESTS=ON -D ENABLE_FAST_MATH=ON -D WITH_IMAGEIO=ON -D BUILD_SHARED_LIBS=OFF -D WITH_GSTREAMER=ON .. \
    && make all -j 4 && make install

WORKDIR /

# Kdtree package
RUN git config --global http.sslVerify false && sudo git clone https://github.com/jtsiomb/kdtree.git

WORKDIR /kdtree/

# Make build kdtree
RUN ./configure && make -j 4 && make install && ldconfig

# Copying configs, resources and binaries
COPY resources/ /resources/
RUN ls -la /resources/*

COPY configs/ /configs/
RUN ls -la /configs/*

COPY binaries/ /binaries/
RUN ls -la /binaries/*

WORKDIR /resources/flycapture/

RUN sudo dpkg -i libflycapture-2* \
    && sudo dpkg -i libflycapturegui-2* \
    && sudo dpkg -i libflycapture-c-2* \
    && sudo dpkg -i libflycapturegui-c-2* \
    && sudo dpkg -i libmultisync-2* \
    && sudo dpkg -i libmultisync-c-2* \
    && sudo dpkg -i flycap-2* \
    && sudo dpkg -i flycapture-doc-2* \
    && sudo dpkg -i updatorgui* 

WORKDIR /binaries/

# Run the specified command within the container.
CMD ./agent -1s -noProj -f -noGUI
