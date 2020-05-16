# Pedestrian detection
Pedestrian detection using the object detection API of tensorflow finetuning a pretrained model for only pedestrian detection. Based on this [repo](https://github.com/thatbrguy/Pedestrian-Detection) but fixed some bugs in the processing of the data and containerized everything because the dependencies versions is a mess.

![alt text][s1] 


### Requirements
* Docker
* Docker-compose
* Nvidia-docker if you plan to use a machine with GPU

If you don't have a GPU, it is better to change the docker image from the [Dockerfile](Dockerfile) for the commented image that has no GPU support because it is smaller.


## Download and prepare the data
The dataset for the training is [the TownCentre](http://www.robots.ox.ac.uk/ActiveVision/Research/Projects/2009bbenfold_headpose/project.html#datasets) dataset. To download the dataset, split the dataset and convert it to TF records required for training run docker-compose:

```bash
docker-compose up create-dataset
```

This might take some time initially because it needs to build the Docker image.

## Download model for fine-tuning and configuration
We have to download a pre-trained model from the [tensorflow object detection model zoo](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md) form the `COCO-trained models` section. Choose the one that fits best for your problem's requirements (trade off between performance/speed). Copy the link of the model and run the following command:
```bash
bash scripts/download_model.sh <url_pretrained_tar_file>
```
For this repo, we have everything configured to train with `ssd_mobilenet_v2_coco` model. In that case the command:
```bash
bash scripts/download_model.sh http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_coco_2018_03_29.tar.gz
```

Inside `data` there is a configuration file ready for training `ssd_mobilenet_v2`, but if you choose another model, just copy the `model.config` from the folder of the downloaded pretrained model and change some parameters. For example the `train_input_reader` and `eval_input_reader` should look like this:
```
train_input_reader {
  label_map_path: "/code/annotations/label_map.pbtxt"
  shuffle: true
  tf_record_input_reader {
    input_path: "/code/data/train.record"
  }
}
eval_input_reader {
  label_map_path: "/code/annotations/label_map.pbtxt"
  shuffle: true
  num_readers: 1
  tf_record_input_reader {
    input_path: "/code/data/valid.record"
  }
}  
```
Also in `num_clases` must be changed. In this case to 1. Finally in the `train_config` section, look for the line with parameter `fine_tune_checkpoint` and change to the correct path. For the example of `ssd_mobilenet_v2` it looks likt the following:
```
fine_tune_checkpoint: "/code/data/models/ssd_mobilenet_v2_coco_2018_03_29/model.ckpt"
```


## Training
To train just run the train service
```
docker-compose up train
```

Inside  [scripts/train.sh](scripts/train.sh) there are some parameters you can change. For example `MODEL_DIR` that controls where the checkpoints of the trained model are going to be stored.

### Tensorboard monitoring
To explore how the training is doing you can launch the tensorboard service
```
docker-compose up tensorboard
```
Got to [localhost:6006](http://localhost:6006) to see the results

## Exporting model to saved model for serving and prediction
To export the trained model, execute:
```
docker-compose up export-model
```

You need to change some variables inside [scripts/export_model.sh](scripts/export_model.sh) for your case. The variables by default look like this:

```
INPUT_TYPE=image_tensor
EXPORT_DIR=/code/data/export_models/ssd_mobilenet_v2_pedestrian
PIPELINE_CONFIG_PATH=/code/data/ssd_mobilenet_v2.config
TRAINED_CKPT_PREFIX=/code/data/train_data/model.ckpt-16283
```

In case of using `ssd_mobilenet_v2`, the only change required is the `TRAINED_CKPT_PREFIX` variable for whatever checkpoint number you want to export. Also if you want your model to receive a image encoded string instead of the raw image matrix, use `INPUT_TYPE=encoded_image_string_tensor`

## Running inference
To run inference over the video of the dataset or a folder with a bunch of images run the following service:
```
docker-compose run run-inference
```
Modify inside `scripts/run_inference.py` the `source_path` variable for choosing a video file or a folder.

Enjoy!

### Training for another task

This can be a good starting point if you need a detector for another task. Just need to change the creating of the dataset and tf records, change the file [label map file](annotations/label_map.pbtxt) with the new label map, and change the configuration file with the new number of classes. That would be it!



[s1]: https://raw.githubusercontent.com/charlielito/pedestrian-detection/master/demo.gif "S"
