# 
# Copyright (C) 2021 NVIDIA Corporation.  All rights reserved.
# Licensed under the NVIDIA Source Code License.
# See LICENSE at https://github.com/nv-tlabs/ATISS.
# Authors: Despoina Paschalidou, Amlan Kar, Maria Shugrina, Karsten Kreis,
#          Andreas Geiger, Sanja Fidler
# 

"""Script for computing the FID score between real and synthesized scenes.
"""
import argparse
import os
import sys
import torch
import clip
import multiprocessing

from torchvision.models import inception_v3, Inception_V3_Weights
from torchvision import transforms

import numpy as np
from PIL import Image
from tqdm import tqdm
from tqdm.contrib.concurrent import process_map

from cleanfid import fid

import shutil

from scene_synthesis.datasets.splits_builder import CSVSplitsBuilder
from scene_synthesis.datasets.threed_front import CachedThreedFront


class ThreedFrontRenderDataset(object):
    def __init__(self, dataset):
        self.dataset = dataset

    def __len__(self):
        return len(self.dataset)

    def __getitem__(self, idx):
        image_path = self.dataset[idx].image_path
        img = Image.open(image_path)
        return img
    
    
# Dummy class
class DummyImage:
    def __init__(self, image_path):
        self.image_path = image_path

    def __repr__(self):
        return self.image_path
    
    def numpy(self):
        return np.array(self.pil())
    
    def pil(self):
        return Image.open(self.image_path)
    
    def rotate(self, angle: float):
        image = Image.open(self.image_path)
        rotated = image.rotate(angle)
        return rotated


def _rotate_multiprocessing(image: DummyImage):
    return [
        image.pil().convert("RGB"),
        image.rotate(90).convert("RGB"),
        image.rotate(180).convert("RGB"),
        image.rotate(270).convert("RGB"),
    ]

    
def main(argv):
    parser = argparse.ArgumentParser(
        description=("Compute the FID scores between the real and the "
                     "synthetic images")
    )
    parser.add_argument(
        "path_to_real_renderings",
        help="Path to the folder containing the real renderings"
    )
    parser.add_argument(
        "path_to_synthesized_renderings",
        help="Path to the folder containing the synthesized"
    )
    parser.add_argument(
        "--feature_extractor",
        default="clip",
        help="Choose the feature extractor to compute the FID score (clip or inception)"  
    )
    parser.add_argument(
        "--check_global_rotation",
        default="false",
    )
    # parser.add_argument(
    #     "path_to_annotations",
    #     help="Path to the folder containing the annotations"
    # )
    # parser.add_argument(
    #     "path_to_train_stats",
    #     help="Path to the train stats"
    # )
    # parser.add_argument(
    #     "--compare_all",
    #     action="store_true",
    #     help="if compare all"
    # )

    args = parser.parse_args(argv)

    # Create Real datasets
    # config = dict(
    #     train_stats=args.path_to_train_stats,
    #     room_layout_size="256,256"
    # )
    
    # splits_builder = CSVSplitsBuilder(args.path_to_annotations)
    # if args.compare_all:
    #     test_real = ThreedFrontRenderDataset(CachedThreedFront(
    #         args.path_to_real_renderings,
    #         config=config,
    #         scene_ids=splits_builder.get_splits(["train", "val", "test"]),
    #     ))
    # else:
    #     test_real = ThreedFrontRenderDataset(CachedThreedFront(
    #         args.path_to_real_renderings,
    #         config=config,
    #         scene_ids=splits_builder.get_splits(["train", "val"]),
    #     ))
    
    assert args.check_global_rotation in ("true", "false")
    args.check_global_rotation = args.check_global_rotation == "true"
    
    assert args.feature_extractor in ("clip", "inception")
    args.feature_extractor = "clip_vit_b_32" if args.feature_extractor == "clip" else "inception_v3"
    
    # groundtruth
    test_real_dataset = [
        DummyImage(image_path=os.path.join(args.path_to_real_renderings, real)) 
        for real in os.listdir(args.path_to_real_renderings) 
        if real.endswith(".png")
    ]
    
    # sort groudtruth images by basename to match the synthesized images order
    test_real_dataset = sorted(test_real_dataset, key=lambda x: os.path.basename(x.image_path))

    test_real = ThreedFrontRenderDataset(
        dataset=test_real_dataset
    )
    
    print("Generating temporary a folder with test_real images...")
    base_path = "./cluster/balrog/jtang/ATISS_exps"
    
    if os.path.exists(base_path):
        path_index = 1
        base_path = base_path + f"_{path_index}"
        while True:
            
            if not os.path.exists(base_path):
                break
            
            base_path = base_path.replace(f"_{path_index}", "")
            path_index += 1
            base_path = base_path + f"_{path_index}"

    path_to_test_real = os.path.join(base_path, "test_real") # /tmp/test_real
    if not os.path.exists(path_to_test_real):
        os.makedirs(path_to_test_real)
    for i, di in enumerate(test_real):
        di.save(os.path.join(path_to_test_real, f"{i:05d}.png"))
    # Number of images to be copied
    N = len(test_real)
    print('number of real images :', len(test_real))

    print("Generating temporary a folder with test_fake images...")
    path_to_test_fake = os.path.join(base_path, "test_fake") #/tmp/test_fake/
    if not os.path.exists(path_to_test_fake):
        os.makedirs(path_to_test_fake)

    synthesized_images = [
        DummyImage(image_path=os.path.join(args.path_to_synthesized_renderings, oi)) 
        for oi in os.listdir(args.path_to_synthesized_renderings) 
        if oi.endswith(".png")
    ]
    print('number of synthesized images :', len(synthesized_images))
    
    # sort synthesized images by basename to match the groudtruth images order
    synthesized_images = sorted(synthesized_images, key=lambda x: os.path.basename(x.image_path))
    
    device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    
    if args.check_global_rotation:
        
        if "inception" in args.feature_extractor:
            feature_extractor = inception_v3(weights=Inception_V3_Weights.DEFAULT)
            feature_extractor = feature_extractor.to(device)
            feature_extractor.eval()
            
            preprocessor = transforms.Compose(
                [
                    transforms.ToTensor(),
                    transforms.Resize([299, 299]),
                    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),  # ImageNet normalization
                ]
            )
            
        elif "clip" in args.feature_extractor:
            feature_extractor, preprocessor = clip.load("ViT-B/32", device=device)
            feature_extractor = feature_extractor.to(device)
            feature_extractor.eval()
        
        # multiprocessing
        synthesized_images_all_pil = process_map(
            _rotate_multiprocessing, 
            synthesized_images, 
            max_workers=multiprocessing.cpu_count(), 
            chunksize=32,
        )

        synthesized_images_all_pil = [im for group in synthesized_images_all_pil for im in group]
        
        real_images_all_pil = [real_image.pil().convert("RGB") for real_image in test_real_dataset for _ in range(4)]
        
        assert len(real_images_all_pil) == len(synthesized_images_all_pil)
        
        save_index = 0
        for i in tqdm(range(0, len(synthesized_images_all_pil), 4), total=len(synthesized_images_all_pil) // 4):
                        
            real_image_basename = os.path.basename(test_real_dataset[i // 4].image_path).replace("_render", "")
            synthesized_image_basename = os.path.basename(synthesized_images[i // 4].image_path)

            # check if the basename is the same
            assert real_image_basename == synthesized_image_basename

            real_image = preprocessor(real_images_all_pil[i]).to(device)
            synthesized_images_rotated = [preprocessor(im) for im in synthesized_images_all_pil[i : i + 4]]
            synthesized_images_rotated = torch.stack(synthesized_images_rotated, dim=0).to(device)
            
            with torch.no_grad():
                if "inception" in args.feature_extractor:
                    real_features = feature_extractor(real_image.unsqueeze(0))
                    synthesized_features = feature_extractor(synthesized_images_rotated)

                elif "clip" in args.feature_extractor:
                    real_features = feature_extractor.encode_image(real_image.unsqueeze(0))
                    synthesized_features = feature_extractor.encode_image(synthesized_images_rotated)
            
            feature_distances = torch.norm(real_features - synthesized_features, dim=1)
            pixel_distances = torch.mean(torch.abs(synthesized_images_rotated - real_image.unsqueeze(0)), dim=[1, 2, 3])
            
            score = feature_distances * pixel_distances
            
            min_distance_index = torch.argmin(score)
            min_distance_image = synthesized_images_all_pil[i + min_distance_index]
            min_distance_image.save(f"{path_to_test_fake}/{save_index:05d}.png")
            
            save_index += 1
            
            torch.cuda.empty_cache()
            del real_image
            del synthesized_images_rotated
            
    else:
        for sii, (real_image, synthesized_image) in enumerate(zip(test_real_dataset, synthesized_images)):
            basename_real = os.path.basename(real_image.image_path).replace("_render", "")
            basename_synthesized = os.path.basename(synthesized_image.image_path)

            # check if the basename is the same
            assert basename_real == basename_synthesized

            synthesized_image.pil().save(f"{path_to_test_fake}/{sii:05d}.png")
        
    # Compute the FID score
    fid_score = fid.compute_fid(path_to_test_real, path_to_test_fake, device=device, model_name=args.feature_extractor)
    print('fid score:', fid_score)
    # kid_score = fid.compute_kid(path_to_test_real, path_to_test_fake, device=torch.device("cpu"))
    # print('kid score:', kid_score)``
    os.system(f'rm -r {base_path}')


if __name__ == "__main__":
    main(sys.argv[1:])