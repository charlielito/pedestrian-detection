# pedestrian-detection
Finetuning to pedestrian detection with tensorflow object detection api


https://github.com/thatbrguy/Pedestrian-Detection


docker-compose up create-dataset
bash scripts/download_model.sh http://download.tensorflow.org/models/object_detection/ssd_mobilenet_v2_coco_2018_03_29.tar.gz
docker-compose up train
docker-compose up export-model

enjoy!