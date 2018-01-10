import pandas as pd

def get_number_of_classes():
    train = pd.read_csv('./data/train_labels.csv')
    test = pd.read_csv('./data/test_labels.csv')
    dataset = pd.concat([train, test])
    return dataset['class'].nunique()


def get_number_of_eval_samples():
    test = pd.read_csv('./data/test_labels.csv')
    return len(test)
