#!/bin/bash
PIPELINE_CONFIG_PATH=/code/data/ssd_mobilenet_v2.config
MODEL_DIR=/code/data/train_data
NUM_TRAIN_STEPS=50000
SAMPLE_1_OF_N_EVAL_EXAMPLES=1


if [ -d $MODEL_DIR ]; then
    rm -r "$MODEL_DIR/*"
fi
if [ ! -d $MODEL_DIR ]; then
    mkdir $MODEL_DIR
fi

cd /code/models/research



python object_detection/model_main.py \
    --logtostderr \
    --pipeline_config_path=${PIPELINE_CONFIG_PATH} \
    --model_dir=${MODEL_DIR} \
    --num_train_steps=${NUM_TRAIN_STEPS} \
    --sample_1_of_n_eval_examples=$SAMPLE_1_OF_N_EVAL_EXAMPLES \
    --alsologtostderr