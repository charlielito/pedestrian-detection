FROM tensorflow/tensorflow:1.15.0-py3
# FROM tensorflow/tensorflow:1.15.0-gpu-py3
#FROM nvidia/cuda:10.0-cudnn7-runtime

# set timezone for tzdata installation (used in python-tk)
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN apt-get update && \
    apt-get install -y \
    wget \
    git \
    unzip \
    curl \
    libsm6 \
    libxext6 \
    libxrender-dev \
    netbase \
    nano \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*


# Install object detection training dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y protobuf-compiler \
    # python3-pil \
    # python3-lxml \
    # python3-tk \
    # python3-setuptools \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/* 

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install pycocotools


# Clone object detection tensorflow/models repository
WORKDIR /code
# RUN /bin/bash -c "git clone https://github.com/tensorflow/models.git; cd /code/models; git checkout f7e99c0"
RUN git clone https://github.com/tensorflow/models.git

RUN mkdir -p /code/{CSV,output,train,annotations}


WORKDIR /code/models/research
RUN protoc object_detection/protos/*.proto --python_out=.
ENV PYTHONPATH=$PYTHONPATH:/code/models/research:/code/models/research/slim

# Copy annotations and script to transform csv to tf
COPY annotations /code/annotations
COPY data /code/data
# COPY csv_a_tf.py /code/

ENV PIPELINE_CONFIG_PATH=/code/data/models/mobilenetv1/ssd_mobilenet_v1_coco.config
ENV MODEL_DIR=/code/data/train_data
ENV NUM_TRAIN_STEPS=5000
ENV SAMPLE_1_OF_N_EVAL_EXAMPLES=1