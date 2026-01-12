#!/bin/bash
cd ./scripts

echo "Computing FID scores with global rotation checking for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=true

echo "Computing FID scores without global rotation checking for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=false

echo ""

echo "Computing FID scores with global rotation checking for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=true

echo "Computing FID scores without global rotation checking for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_validation_data_1/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated \
    --feature_extractor=clip \
    --check_global_rotation=false