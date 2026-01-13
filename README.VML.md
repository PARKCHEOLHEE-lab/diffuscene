> [!NOTE] 
> This README was generated with the assistance of AI to provide accurate setup and usage instructions for DiffuScene. 
> This repository is based on https://github.com/tangjiapeng/DiffuScene

<br>


## Installation

### For Vessl
To reproduce the DiffuScene environment in Vessl, use the `docker.io/cjfl2343/diffuscene:0.0.7` Docker image, which is built from the [`Dockerfile.diffuscene`](Dockerfile.diffuscene).

<div align="center" >
    <img src="./media/vessl-image.png">
    <br><br>
    <i>Type an image in 'Create a new workspace'</i>
    
</div>

<br>

### For Local
To reproduce the DiffuScene environment in local, use the devcontainer.

1. Ensure you have Docker and Visual Studio Code with the Remote - Containers extension installed.
2. Clone the repository.

    ```
    git clone https://github.com/???.git
    ```

3. Open the project with VS Code.

4. When prompted at the bottom left in VS Code, click `Reopen in Container` or use the command palette (F1) and select `Remote-Containers: Reopen in Container`.

5. VS Code will build the Docker container and set up the environment. All required dependencies (torch, trimesh, tqdm, numpy) are automatically installed during the container build process.

6. Once the container is built and running, you're ready to start working with the project.

<br>

## Set Up Preprocessed Data & Pretrained Models

To set up the preprocessed data and pretrained models, run the following scripts in order:

1. Install Python dependencies and Chamfer Distance:

   ```
   bash setup_a.sh
   ```

<br>

2. Download all required zip files (preprocessed datasets and pretrained models). If download fails, follow the provided message to manually download and place the zip file in the project root:

   ```
   bash setup_b.sh
   ```

<br>

3. Unzip and organize the files into the proper directories. Before running this step, ensure that the following zip files (`3d_front_processed.zip`, `3D-FUTURE-model-processed.zip`, `objautoencoder_pretrained.zip`, `pretrained_diffusion.zip`) are present in the root directory.

   ```
   bash setup_c.sh
   ```

<br>


## Rearranged Scene Generation

```
bash run/generate_rearrange.sh
```

<br>

## FID Computation

Before computing the FID score, make sure you have generated synthesized scenes by running `bash run/generate_rearrange.sh`

Only after this step should you proceed to calculate the FID.

```
bash run/compute_fid_scores.sh
```

### FID with Global Rotation Matching

When computing FID, the script can automatically check which global rotation (0°, 90°, 180°, or 270°) of each generated scene aligns best with the ground-truth scene. This helps avoid penalizing for global orientation mismatches between generated and real layouts, especially in rearrangement tasks.

You can enable this option by passing `--check_global_rotation true` to the script (this may take much more time to compute compared to `--check_global_rotation false`):

```bash
python scripts/compute_fid_scores.py \
    PATH_TO_GROUNDTRUTH_SCENES \
    PATH_TO_GENERATED_SCENES \
    --feature_extractor clip \
    --check_global_rotation true
```

For each generated scene, the script tests all four global rotations and selects the one with the smallest feature and pixel distance to the corresponding ground truth before calculating the FID.
See `rearranged.png` below for a visualization of this process:

<div align="center" display="flex">
    <img src="./media/rearranged (1).png" width="22%"/>
    <img src="./media/rearranged (2).png" width="22%"/>
    <img src="./media/rearranged (3).png" width="22%"/>
    <img src="./media/rearranged (4).png" width="22%"/>
    <br>
    <i>Global rotation matching for rearranged scene FID computation.<br>
    The minimum is selected among four rotations.</i>
</div>


### FID without Global Rotation Matching

If you omit the flag or set `--check_global_rotation false`, the FID will be calculated directly using the original orientation of each scene, without applying or testing any global rotations.

```bash
python scripts/compute_fid_scores.py \
    PATH_TO_GROUNDTRUTH_SCENES \
    PATH_TO_GENERATED_SCENES \
    --feature_extractor clip \
    --check_global_rotation false
```

In this case, the generated scenes and ground-truth scenes are compared directly in their original orientation.


### Feature Extractor
- The script supports both `clip` and `inception` feature extractors for FID computation (see the `--feature_extractor` argument).
- Both image lists are sorted by filename to ensure a one-to-one correspondence before comparison.

<br>

## Note
The paper evaluates scene generation quality in three categories (bedrooms, living rooms, and dining rooms), but the provided pretrained models do not include a model for dining rooms. I asked how I can obtain the model checkpoint (https://github.com/tangjiapeng/DiffuScene/issues/64).