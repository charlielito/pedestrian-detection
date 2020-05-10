#!/bin/bash

INPUT_TYPE=image_tensor
# INPUT_TYPE=encoded_image_string_tensor
EXPORT_DIR=/code/data/export_models/ssd_mobilenet_v2_pedestrian
PIPELINE_CONFIG_PATH=/code/data/ssd_mobilenet_v2.config
TRAINED_CKPT_PREFIX=/code/data/train_data/model.ckpt-16283

cd /code/models/research
python object_detection/export_inference_graph.py \
    --input_type=${INPUT_TYPE} \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --trained_checkpoint_prefix=${TRAINED_CKPT_PREFIX} \
    --output_directory=${EXPORT_DIR}