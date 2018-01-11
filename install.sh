# Tensorflow Object Detection API installer
# Author: Rafael Alves Ribeiro


# General script settings (no need to change this)
YELLOW='\033[1;33m'
NC='\033[0m'
SCRIPT="${YELLOW}>>>${NC}"


# Model Configuration
# Choose your model at Tensorflow Model Zoo (https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md)
MODEL="ssd_mobilenet_v1_coco"

# Accorging to your model choose your configuration file at
#(https://github.com/tensorflow/models/tree/master/research/object_detection/samples/configs)
CONFIGURATION_FILE="ssd_mobilenet_v1_pets.config"


# Requirements
echo -e $SCRIPT "Installing dependencies."
sudo apt-get install protobuf-compiler
sudo pip3 install -r requirements.txt


echo -e $SCRIPT "Cloning Tensorflow Models repository."
git clone https://github.com/tensorflow/models.git


echo -e $SCRIPT "Compiling protocol buffers."
cd models/research && \
  protoc object_detection/protos/*.proto --python_out=.


echo -e $SCRIPT "Installing the Object Detection library."
export PYTHONPATH="$PYTHONPATH:`pwd`:`pwd`/slim" && \
  python3 setup.py install && \
  cd ../..


echo -e $SCRIPT "Installing labeled data."
mkdir  ./models/research/object_detection/images/
cp -a ./images/. ./models/research/object_detection/images/


echo -e $SCRIPT "Installing suport scripts."
cp config.py ./models/research/object_detection/config.py
cp datasetinfo.py ./models/research/object_detection/datasetinfo.py
cp xml_to_csv.py ./models/research/object_detection/xml_to_csv.py
cp generate_tfrecord.py ./models/research/object_detection/generate_tfrecord.py
cp download_model.py ./models/research/object_detection/download_model.py


# enter the object detection dir to process the labels
cd ./models/research/object_detection/

echo -e $SCRIPT "Generating .csv dataset from labeled data"
python3 xml_to_csv.py

echo -e $SCRIPT "Generating TfRecord train and test datasets."
# must configure labels
python3 generate_tfrecord.py --csv_input=data/train_labels.csv --output_path=data/train.record
python3 generate_tfrecord.py --csv_input=data/test_labels.csv --output_path=data/test.record


echo -e $SCRIPT "Downloading model."
python3 download_model.py $MODEL
mkdir model
tar -xzf model.tar.gz -C model --strip-components 1


echo -e $SCRIPT "Moving config file."
mkdir training
cp ./samples/configs/ssd_mobilenet_v1_pets.config ./training/$CONFIGURATION_FILE
python3 config.py $CONFIGURATION_FILE
