#!/bin/bash
#SBATCH --job-name=road_sign
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=gpu
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --gres=gpu:2
#SBATCH -o ./slurm_log/output_%j.txt
#SBATCH --mail-type=end,fail
#SBATCH --mail-user=lntruong@cpp.edu

eval "$(conda shell.bash hook)"
conda activate py37

echo "=========================================="
echo "SLURM_JOB_ID: $SLURM_JOB_ID"
echo "SLURM_NODELIST: $SLURM_NODELIST"
echo "SLURM_NODELIST: $SLURM_JOB_GPUS"
echo "=========================================="

<<MULTILINE-COMMENTS
    Backbone model:
        - "COCO-InstanceSegmentation/mask_rcnn_R_50_C4_1x.yaml"
        - "COCO-InstanceSegmentation/mask_rcnn_R_50_DC5_1x.yaml"
        - "COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_1x.yaml"

        - "COCO-InstanceSegmentation/mask_rcnn_R_50_C4_3x.yaml"--> new only
        - "COCO-InstanceSegmentation/mask_rcnn_R_50_DC5_3x.yaml"
        - "COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"--> both (not yet)
            
        - "COCO-InstanceSegmentation/mask_rcnn_R_101_C4_3x.yaml"
        - "COCO-InstanceSegmentation/mask_rcnn_R_101_DC5_3x.yaml"
        - "COCO-InstanceSegmentation/mask_rcnn_R_101_FPN_3x.yaml"--> both
        - "COCO-InstanceSegmentation/mask_rcnn_X_101_32x8d_FPN_3x.yaml" 
MULTILINE-COMMENTS

srun python3 train.py --num-gpus 2 --training-dataset=$1 --backbone=$2
