#!/bin/bash

DST_DIR="data/models"

mkdir ${DST_DIR}  
wget -O "${DST_DIR}/model.tar.gz" $"$@"
cd ${DST_DIR}  
tar -xzvf model.tar.gz