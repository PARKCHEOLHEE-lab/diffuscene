#!/bin/bash

pip install -e . --config-settings editable_mode=compat
cd ChamferDistancePytorch/chamfer3D
python setup.py install

# download pretrained models and preprocessed datasets
# https://drive.google.com/drive/folders/1EhvyNCAWWto6vMt0vXWMKBoSdYR_9pC2

# 3d_front_processed.zip
gdown 1UNSFN0kULyOzUErDPVvkKYbmfzA-4MsG

# objautoencoder_pretrained.zip
gdown 1xuFa_Hh6BOZqfaAnlG-W_9mA1gilU6nI

# pretrained_diffusion.zip
gdown 1pk9AzGcBz_kRfmRzvFNDW5byk4MwbXEm

# 3D-FUTURE-model-processed.zip
gdown 16fz81Eh6B6pbZNGTMbe0FdfNwIuQicE1

apt-get update
apt-get install -y unzip

# construct directory structure
BASE_DIR='./scripts/_cluster/'
if [ ! -d "$BASE_DIR" ]; then
    mkdir "$BASE_DIR"
fi

BASE_DIR="$BASE_DIR/balrog/"
if [ ! -d "$BASE_DIR" ]; then
    mkdir "$BASE_DIR"
fi

BASE_DIR="$BASE_DIR/jtang/"
if [ ! -d "$BASE_DIR" ]; then
    mkdir "$BASE_DIR"
fi

# unzip the pretrained models and datasets 
unzip 3d_front_processed.zip -d $BASE_DIR
unzip 3D-FUTURE-model-processed.zip -d $BASE_DIR
unzip objautoencoder_pretrained.zip
unzip pretrained_diffusion.zip 

# construct directory structure
PRETRAINED_DIR="_pretrained"
mv pretrained_diffusion $PRETRAINED_DIR
mv objautoencoder_pretrained $PRETRAINED_DIR