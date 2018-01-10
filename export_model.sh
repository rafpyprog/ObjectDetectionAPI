########################################################
# Exports the inference graph from a trainned model
#
# Params:
#    - checkpoint_num
#    - output directory
#########################################################

YELLOW='\033[1;33m'
NC='\033[0m'

CHECKPOINT_NUM=$1
OUTPUT_DIR=$2

echo -e "${YELLOW}>>>${NC} Exporting model from checkpoint number ${CHECKPOINT_NUM}."
echo -e "${YELLOW}>>>${NC} Output directory: ${OUTPUT_DIR}"

cd models/research && \
export PYTHONPATH="$PYTHONPATH:`pwd`:`pwd`/slim" && \
cd object_detection && \
echo -e "${YELLOW}>>>${NC} PYTHONPATH set to: ${PYTHONPATH}" && \
python3 export_inference_graph.py \
  --input_type image_tensor \
  --pipeline_config_path training/ssd_mobilenet_v1_pets.config \
  --trained_checkpoint_prefix training/model.ckpt-$CHECKPOINT_NUM \
  --output_directory $OUTPUT_DIR
