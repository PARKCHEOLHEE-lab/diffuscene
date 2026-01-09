#!/bin/bash
cd ./scripts

echo "Computing FID scores for bedrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_validation_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_validation_data/bedrooms_rearrange/gen_top2down_notexture_nofloor/generated

echo "Computing FID scores for livingrooms rearrangement..."
python compute_fid_scores.py \
    ./cluster/balrog/jtang/rearrange_with_validation_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/groundtruth \
    ./cluster/balrog/jtang/rearrange_with_validation_data/livingrooms_rearrange/gen_top2down_notexture_nofloor/generated