#!/bin/bash

INPUT_TYPE=image_tensor
# INPUT_TYPE=encoded_image_string_tensor
OUTPUT_DIR=/code/data/export_models/ssd_mobilenet_v2_pedestrian

PIPELINE_CONFIG_PATH=/code/data/ssd_mobilenet_v2.config
CHECKPOINT=/code/data/train_data/model.ckpt-16283

# PIPELINE_CONFIG_PATH=data/ssd_mobilenet_v2.config
# CHECKPOINT=train_data/data/train_data/model.ckpt-16283

python /code/scripts/export_model.py \
    --input_type $INPUT_TYPE \
    --pipeline_config_path $PIPELINE_CONFIG_PATH  \
    --trained_checkpoint_prefix $CHECKPOINT \
    --output_directory $OUTPUT_DIR