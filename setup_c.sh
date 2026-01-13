#! /bin/bash

# Check if all required zip files exist before continuing
ZIP_FILES=("3d_front_processed.zip" "3D-FUTURE-model-processed.zip" "objautoencoder_pretrained.zip" "pretrained_diffusion.zip")

for ZF in "${ZIP_FILES[@]}"; do
    if [ ! -f "$ZF" ]; then
        echo "Error: Missing required file: $ZF"
        exit 1
    fi
done

apt-get update
apt-get install -y unzip

# construct directory structure
BASE_DIR='./scripts/cluster/'
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
PRETRAINED_DIR="pretrained"
mv pretrained_diffusion $PRETRAINED_DIR
mv objautoencoder_pretrained $PRETRAINED_DIR