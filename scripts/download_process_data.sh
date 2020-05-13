#!/bin/bash

echo "Downloading dataset"
cd data
wget http://www.robots.ox.ac.uk/ActiveVision/Research/Projects/2009bbenfold_headpose/Datasets/TownCentreXVID.avi
wget http://www.robots.ox.ac.uk/ActiveVision/Research/Projects/2009bbenfold_headpose/Datasets/TownCentre-groundtruth.top
cd ..

echo "Extracting images..."
python scripts/extract_dataset.py
echo "Extracting labels..."
python scripts/extract_labels.py
echo "Creating tf records..."
python scripts/create_tf_records.py
