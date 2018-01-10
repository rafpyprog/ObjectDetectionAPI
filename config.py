# TODO Get num_classes and NUM_EVAL_EXAMPLES

import re
import sys

import pandas
from datasetinfo import get_number_of_classes, get_number_of_eval_samples

CONFIG_FILE_NAME = sys.argv[1]

CONFIGURATION_FILE = './training/' + CONFIG_FILE_NAME
MODEL_FOLDER = ''

NUM_CLASSES = get_number_of_classes()
NUM_EVAL_EXAMPLES = get_number_of_eval_samples()

PATHS_TO_BE_CONFIGURED = [
    'model/model.ckpt',  # fine tune checkpoint
    'data/train.record',  # train input path
    'data/object-detection.pbtxt',  # label map path
    'data/test.record',  # eval input path
    'training/object-detection.pbtxt']  # label map path


with open(CONFIGURATION_FILE) as f:
    configuration = f.read()


model_classes = re.search('num_classes: [0-9]*', configuration).group()
configuration = configuration.replace(model_classes, 'num_classes: {}'.format(NUM_CLASSES))

eval_examples = re.search('num_examples: [0-9]*', configuration).group()
configuration = configuration.replace(eval_examples, 'num_examples: {}'.format(NUM_EVAL_EXAMPLES))



for n, i in enumerate(re.finditer('"PATH_TO_BE_CONFIGURED.*?"', configuration), -1):
    if n >= 0:
        configuration = configuration.replace(i.group(), '"'+PATHS_TO_BE_CONFIGURED[n]+'"')


with open(CONFIGURATION_FILE, 'w') as f:
    f.write(configuration)
