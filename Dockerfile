# FROM tensorflow/tensorflow:1.15.0-py3
FROM tensorflow/tensorflow:1.15.0-gpu-py3

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
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/* 

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN pip install pycocotools


# Clone object detection tensorflow/models repository
WORKDIR /code
RUN git clone https://github.com/tensorflow/models.git
# tested commit from 15 may 2020
RUN cd models/ && git checkout e5c9661aadbcb90cb4fd3ef76066f6d1dab116ff


WORKDIR /code/models/research
RUN protoc object_detection/protos/*.proto --python_out=.
ENV PYTHONPATH=$PYTHONPATH:/code/models/research:/code/models/research/slim