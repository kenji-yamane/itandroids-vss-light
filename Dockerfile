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

WORKDIR /binaries/

# Run the specified command within the container.
CMD ./agent -1s -noProj -f -noGUI
