# Use a CUDA base image from NVIDIA
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install essential packages and dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    lsb-release \
    gnupg \
    software-properties-common \
    tmux \
    git \
    unzip

# metavision dependencies
RUN apt -y install libcanberra-gtk-module mesa-utils ffmpeg
RUN apt -y install python3-pip
RUN apt -y install python3.10-dev

RUN python3 -m pip install pip --upgrade
RUN python3 -m pip install "opencv-python==4.5.5.64" "sk-video==1.1.10" "fire==0.4.0" "numpy==1.23.4" "h5py==3.7.0" pandas scipy
RUN python3 -m pip install matplotlib "ipywidgets==7.6.5"

RUN wget https://files.prophesee.ai/share/dists/public/sources_list/baiTh5si/jammy/metavision.list
RUN cp metavision.list /etc/apt/sources.list.d
RUN apt update
RUN apt -y install metavision-sdk
RUN apt -y install metavision-sdk-python3.10
RUN export HDF5_PLUGIN_PATH=$HDF5_PLUGIN_PATH:/usr/lib/x86_64-linux-gnu/hdf5/serial/plugins

RUN wget https://download.pytorch.org/libtorch/cu117/libtorch-cxx11-abi-shared-with-deps-1.13.1%2Bcu117.zip
ENV LIBTORCH_DIR_PATH=/libtorch
RUN unzip libtorch-cxx11-abi-shared-with-deps-1.13.1+cu117.zip

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

RUN pip3 install gdown
RUN gdown 19Zvq7pM-m6cxvj9qySvPGNeA2KghPOJS
RUN gdown 1Bw0PkE5G4lKYP_kMJFP5DQExSjzOw6pb
RUN unzip red_event_cube_05_2020.zip -d /model

WORKDIR /usr/share/metavision/sdk/ml/cpp_samples/metavision_detection_and_tracking_pipeline
RUN mkdir build && cd build && cmake .. -DCMAKE_PREFIX_PATH=/libtorch -DTorch_DIR=/libtorch -DCMAKE_BUILD_TYPE=Release && cmake --build . --config Release

# Bash settings
RUN echo "export HISTFILE=/root/.bash_history" >> /root/.bashrc && \
    echo "export HISTSIZE=" >> /root/.bashrc && \
    echo "export HISTFILESIZE=" >> /root/.bashrc && \
    echo "export HISTCONTROL=ignoredups:ignorespace" >> /root/.bashrc && \
    echo "export HISTIGNORE='ls:ps:history'" >> /root/.bashrc

# Inputrc settings
RUN echo '"\e[A": history-search-backward' > /root/.inputrc && \
    echo '"\e[B": history-search-forward' >> /root/.inputrc && \
    echo 'set completion-ignore-case on' >> /root/.inputrc && \
    echo 'set show-all-if-ambiguous on' >> /root/.inputrc && \
    echo 'set enable-keypad on' >> /root/.inputrc

# Default command
CMD ["/bin/bash"]

