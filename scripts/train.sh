#!/bin/bash
if [ -d /code/data/train_data ]; then
    rm -r /code/data/train_data/*
fi
if [ ! -d /code/data/train_data ]; then
    mkdir /code/data/train_data
fi
export PIPELINE_CONFIG_PATH=/code/data/ssd_mobilenet_v2.config
export MODEL_DIR=/code/data/train_data
export NUM_TRAIN_STEPS=50000
export SAMPLE_1_OF_N_EVAL_EXAMPLES=1
cd /code/models/research
python object_detection/model_main.py \
    --logtostderr \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --train_dir=${MODEL_DIR} \
    --num_train_steps=${NUM_TRAIN_STEPS} \
    --sample_1_of_n_eval_examples=$SAMPLE_1_OF_N_EVAL_EXAMPLES \
    --alsologtostderr