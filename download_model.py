import os
import sys

from bs4 import BeautifulSoup
import requests


MODEL_NAME = sys.argv[1]
MODEL_ZOO = 'https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md'


r = requests.get(MODEL_ZOO)
soup = BeautifulSoup(r.text, 'lxml')
models = soup.find('table').findAll('a')
download_url =[model['href'] for model in models
               if model.text.strip() == MODEL_NAME][0]

print('Downloading model from {} ...'.format(download_url))
model_targz = requests.get(download_url).content
with open('model.tar.gz', 'wb') as f:
    f.write(model_targz)
