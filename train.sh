########################################################
# Start trainning the model.
#
# Params:
#    - configuration file name
#########################################################

YELLOW='\033[1;33m'
NC='\033[0m'

CONFIG_FILE="ssd_mobilenet_v1_pets.config"

echo -e "${YELLOW}>>>${NC} Starting trainning process, ${CHECKPOINT_NUM}."
echo -e "${YELLOW}>>>${NC} Config file: ${CONFIG_FILE}"

cd models/research && \
export PYTHONPATH="$PYTHONPATH:`pwd`:`pwd`/slim" && \
cd object_detection && \
echo -e "${YELLOW}>>>${NC} PYTHONPATH set to: ${PYTHONPATH}" && \
python3 train.py \
  --logtostderr \
  --train_dir=training/ \
  --pipeline_config_path=training/$CONFIG_FILE
