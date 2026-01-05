FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV SKLEARN_ALLOW_DEPRECATED_SKLEARN_PACKAGE_INSTALL=True

# Python 및 기본 도구 설치
RUN apt-get update && apt-get install -y \
    python3.9 \
    python3-pip \
    build-essential \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgtk-3-dev \
    python3-tk \
    xvfb \
    git \
    curl \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN git config --global user.name "PARKCHEOLHEE-lab" && \
    git config --global user.email "qhqhahah@naver.com"

RUN mkdir -p ~/.ssh && \
    chmod 700 ~/.ssh && \
    ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null || true


# PyTorch 1.13.0 및 관련 패키지 설치
RUN python3 -m pip install --upgrade pip setuptools wheel
RUN pip install --no-cache-dir --upgrade importlib-metadata
RUN pip install --no-cache-dir \
    torch==1.13.0+cu116 \
    torchvision==0.14.0+cu116 \
    torchaudio==0.13.0+cu116 \
    --extra-index-url https://download.pytorch.org/whl/cu116

# 나머지 의존성 설치 (기존과 동일)
RUN pip install --no-cache-dir \
    torchtext==0.14.0 \
    scipy==1.8.1 \
    tqdm==4.64.1 \
    matplotlib==3.3.1 \
    kornia==0.6.9 \
    simple-3dviz \
    transformers==4.25.1 \
    clip==0.2.0 \
    pyvista==0.43.3 \
    trimesh==3.12.7 \
    wandb==0.18.0 \
    pillow \
    num2words \
    nltk \
    einops_exts \
    seaborn \
    clean-fid \
    unzip \
    gdown

RUN pip install --no-cache-dir open3d

RUN pip install --no-cache-dir \
    vessl \
    jupyterlab \
    jupyterlab-git \
    ipywidgets

# echo 'set -o emacs' >> ~/.bashrc
# echo 'bind "\C-f": forward-word' >> ~/.bashrc
# echo 'bind "\C-b": backward-word' >> ~/.bashrc
# source ~/.bashrc