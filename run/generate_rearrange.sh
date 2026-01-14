#!/bin/bash
cd ./scripts

python -m nltk.downloader cmudict

exp_dir="../pretrained"

generation_times=1

####'bedrooms'
config="../config/rearrange/diffusion_bedrooms_instancond_lat32_v_rearrange.yaml"
exp_name="bedrooms_rearrange"
weight_file=$exp_dir/$exp_name/model_17000
threed_future='./cluster/balrog/jtang/3d_front_processed/threed_future_model_bedroom.pkl'
# output_dir=./cluster/balrog/jtang/rearrange_with_validation_data_$generation_times/$exp_name/gen_top2down_notexture_nofloor
output_dir=./cluster/balrog/jtang/rearrange_with_train_val_data/$exp_name/gen_top2down_notexture_nofloor

xvfb-run -a python completion_rearrange.py \
    $config \
    $output_dir \
    $threed_future \
    --weight_file $weight_file \
    --without_screen \
    --n_rearrange_times $generation_times \
    --render_top2down \
    --no_texture \
    --without_floor \
    --save_mesh \
    --clip_denoised \
    --retrive_objfeats \
    --arrange_objects \
    --compute_intersec \
    --split='["train", "val"]' \
    --render_gt=true

####'livingrooms'
config="../config/rearrange/diffusion_livingrooms_instancond_lat32_v_rearrange.yaml"
exp_name="livingrooms_rearrange"
weight_file=$exp_dir/$exp_name/model_81000
threed_future='./cluster/balrog/jtang/3d_front_processed/threed_future_model_livingroom.pkl'
# output_dir=./cluster/balrog/jtang/rearrange_with_validation_data_$generation_times/$exp_name/gen_top2down_notexture_nofloor
output_dir=./cluster/balrog/jtang/rearrange_with_train_val_data/$exp_name/gen_top2down_notexture_nofloor

xvfb-run -a python completion_rearrange.py \
    $config \
    $output_dir \
    $threed_future \
    --weight_file $weight_file \
    --without_screen \
    --n_rearrange_times $generation_times \
    --render_top2down \
    --no_texture \
    --without_floor \
    --save_mesh \
    --clip_denoised \
    --retrive_objfeats \
    --arrange_objects \
    --compute_intersec \
    --split='["train", "val"]' \
    --render_gt=true
