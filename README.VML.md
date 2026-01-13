> [!NOTE] 
> This README was generated with the assistance of AI to provide accurate setup and usage instructions for DiffuScene. 


## Installation

### For Vessl
To reproduce the DiffuScene environment in Vessl, use the `docker.io/cjfl2343/diffuscene:0.0.6` Docker image, which is built from the [`Dockerfile.diffuscene`](Dockerfile.diffuscene) (see [Dockerfile.diffuscene](Dockerfile.diffuscene)).

<div align="center" >
    <img src="vessl-image.png">
    <br><br>
    <i>Type an image in 'Create a new workspace'</i>
    
</div>

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


## Data & Pretrained Models
The command below installs the preprocessed dataset and pretrained models, and then reorganizes the folder structure.

```
sh setup.sh
```


## Rearrangement

```
sh run/generate_rearrange.sh
```

## Computing FID

```
sh run/compute_fid_scores.sh
```