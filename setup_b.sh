#! /bin/bash

# download pretrained models and preprocessed datasets
# https://drive.google.com/drive/folders/1EhvyNCAWWto6vMt0vXWMKBoSdYR_9pC2

# 3d_front_processed.zip
gdown 1UNSFN0kULyOzUErDPVvkKYbmfzA-4MsG
if [ $? -ne 0 ]; then
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
    echo "Download failed."
    echo "Please DOWNLOAD this file MANUALLY from https://drive.usercontent.google.com/download?id=1UNSFN0kULyOzUErDPVvkKYbmfzA-4MsG&authuser=0"
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
fi

# objautoencoder_pretrained.zip
gdown 1xuFa_Hh6BOZqfaAnlG-W_9mA1gilU6nI
if [ $? -ne 0 ]; then
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
    echo "Download failed."
    echo "Please DOWNLOAD this file MANUALLY from https://drive.usercontent.google.com/download?id=1xuFa_Hh6BOZqfaAnlG-W_9mA1gilU6nI&authuser=0"
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
fi

# pretrained_diffusion.zip
gdown 1pk9AzGcBz_kRfmRzvFNDW5byk4MwbXEm
if [ $? -ne 0 ]; then
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
    echo "Download failed."
    echo "Please DOWNLOAD this file MANUALLY from https://drive.usercontent.google.com/download?id=1pk9AzGcBz_kRfmRzvFNDW5byk4MwbXEm&authuser=0"
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
fi

# 3D-FUTURE-model-processed.zip
gdown 16fz81Eh6B6pbZNGTMbe0FdfNwIuQicE1
if [ $? -ne 0 ]; then
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
    echo "Download failed."
    echo "Please DOWNLOAD this file MANUALLY from https://drive.usercontent.google.com/download?id=16fz81Eh6B6pbZNGTMbe0FdfNwIuQicE1&authuser=0"
    echo "---------------------------------------------------------------------------------------------------------------------------------------"
fi
