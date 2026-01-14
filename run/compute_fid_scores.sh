#!/bin/bash
cd ./scripts

echo "Computing FID scores with clip and global rotation checking for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=true

echo -e "\nComputing FID scores with clip and without global rotation checking for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=false

echo -e "\nComputing FID scores with inception and global rotation checking for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=inception \
    --check_global_rotation=true

echo -e "\nComputing FID scores with inception and without global rotation checking for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=inception \
    --check_global_rotation=false

echo ""

echo "Computing FID scores with clip and global rotation checking for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=true

echo -e "\nComputing FID scores with clip and without global rotation checking for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=false

echo -e "\nComputing FID scores with inception and global rotation checking for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=inception \
    --check_global_rotation=true

echo -e "\nComputing FID scores with inception and without global rotation checking for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_train_val_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=inception \
    --check_global_rotation=false