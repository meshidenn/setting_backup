# `FROM nvidia/cuda:8.0-cudnn5-devel-ubuntu16.04` でベースにする CUDA 環境を選ぶことができる。
# 利用可能な CUDA 環境の一覧は https://hub.docker.com/r/nvidia/cuda/ にある。
FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# TensorFlow version is tightly coupled to CUDA and cuDNN so it should be selected carefully
ENV TENSORFLOW_VERSION=1.14.0
ENV PYTORCH_VERSION=1.2.0
ENV TORCHVISION_VERSION=0.4.0
ENV CUDNN_VERSION=7.6.0.64-1+cuda10.0
ENV NCCL_VERSION=2.4.7-1+cuda10.0
ENV MXNET_VERSION=1.5.0
# Python 2.7 or 3.6 is supported by Ubuntu Bionic out of the box
ARG python=3.6
ENV PYTHON_VERSION=${python}

# 自動アップグレード
ENV DEBIAN_FRONTEND "noninteractive"
RUN apt-get update -y
RUN apt-get -y \
    -o Dpkg::Options::="--force-confdef" \
    -o Dpkg::Options::="--force-confold" dist-upgrade

# 使いたいソフトウェアを入れる
SHELL ["/bin/bash", "-cu"]
RUN apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
    sudo ssh \
    build-essential \
    tmux cmake unzip git curl wget vim tree htop g++-4.8 \
    graphviz emacs \
    ca-certificates \
    libcudnn7=${CUDNN_VERSION} \
    libnccl2=${NCCL_VERSION} \
    libnccl-dev=${NCCL_VERSION} \
    libjpeg-dev \
    libpng-dev \
    python${PYTHON_VERSION} \
    python${PYTHON_VERSION}-dev \
    librdmacm1 \
    libibverbs1 \
    ibverbs-providers
    

# キャッシュを消してイメージを小さくする
RUN apt-get clean -y
RUN apt-get autoremove -y
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# ユーザ設定
# ユーザ ID をパラメータにすることでホストボリュームに対する操作をユーザ権限で実行するようにしている。
# `--userns-remap` の設定が面倒なときに使う。

ENV HOME /home
WORKDIR $HOME/

RUN if [[ "${PYTHON_VERSION}" == "3.6" ]]; then \
        apt-get install -y python${PYTHON_VERSION}-distutils; \
    fi
RUN ln -s /usr/bin/python${PYTHON_VERSION} /usr/bin/python

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install TensorFlow, Keras, PyTorch and MXNet
RUN pip install future typing
RUN pip install numpy \
        tensorflow-gpu==${TENSORFLOW_VERSION} \
        keras \
        h5py
RUN pip install https://download.pytorch.org/whl/cu100/torch-${PYTORCH_VERSION}-$(python -c "import wheel.pep425tags as w; print('-'.join(w.get_supported()[0][:-1]))")-manylinux1_x86_64.whl \
        https://download.pytorch.org/whl/cu100/torchvision-${TORCHVISION_VERSION}-$(python -c "import wheel.pep425tags as w; print('-'.join(w.get_supported()[0][:-1]))")-manylinux1_x86_64.whl
RUN pip install mxnet-cu100==${MXNET_VERSION}
RUN pip install sklearn \
                pandas 

# Install Open MPI
RUN mkdir /tmp/openmpi && \
    cd /tmp/openmpi && \
    wget https://www.open-mpi.org/software/ompi/v4.0/downloads/openmpi-4.0.0.tar.gz && \
    tar zxf openmpi-4.0.0.tar.gz && \
    cd openmpi-4.0.0 && \
    ./configure --enable-orterun-prefix-by-default && \
    make -j $(nproc) all && \
    make install && \
    ldconfig && \
    rm -rf /tmp/openmpi

# Install Horovod, temporarily using CUDA stubs
RUN ldconfig /usr/local/cuda/targets/x86_64-linux/lib/stubs && \
    HOROVOD_GPU_ALLREDUCE=NCCL HOROVOD_WITH_TENSORFLOW=1 HOROVOD_WITH_PYTORCH=1 HOROVOD_WITH_MXNET=1 \
         pip install --no-cache-dir horovod && \
    ldconfig

# Install OpenSSH for MPI to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

# Download examples
RUN apt-get install -y --no-install-recommends subversion && \
    svn checkout https://github.com/horovod/horovod/trunk/examples && \
    rm -rf /examples/.svn

# WORKDIR "/examples"

## tmuxの設定
RUN git clone git://github.com/meshidenn/setting_backup.git ${HOME}/setting_backup 
RUN cp ${HOME}/setting_backup/.tmux.conf ./

## emacsの設定
RUN curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
ENV PATH=$HOME/.cask/bin:$PATH
RUN cask upgrade
RUN cp -r ${HOME}/setting_backup/.emacs.d ./
RUN cd ~/.emacs.d && cask install
