## **Pipeline Development Steps**

---

- [**Pipeline Development Steps**](#pipeline-development-steps)
  - [**Overview**](#overview)
  - [**1. Developing the first prototype**](#1-developing-the-first-prototype)
  - [**2. Creating config file(s)**](#2-creating-config-files)
  - [**3. Moving the reusable code to .py modules**](#3-moving-the-reusable-code-to-py-modules)
  - [**4. Rewriting and porting the remaining code in the notebook to .py modules**](#4-rewriting-and-porting-the-remaining-code-in-the-notebook-to-py-modules)
  - [**5. Automating the pipeline with DVC**](#5-automating-the-pipeline-with-dvc)

### <ins>**Overview**</ins>

There are 5 broad steps in a software workflow involving a machine learning component:

1. Data Management & Analysis (Data Science/ML component)
2. Model Building & Experimentation (Data Science/ML component)
3. Development of Full Solution & Testing (Software Development)
4. Solution Deployment & Serving (DevOps/MLOps)
5. Monitoring & Maintenance (DevOps/MLOps)

The steps 1. and 2. are iterative in nature owing to the general iterative nature of the process of model development. There is also a feedback from step 5. to step 1. which helps in the model and consequently the project improvement.

To give you an overview, the steps for developing a pipeline look like follows:

After the environment and the folder structure have been setup like suggested in [02_envrionment_setup.md](/ml_dev_tips/02_environment_setup.md),

1. **Develop the first prototype** in a **Jupyter notebook**. This does not need to be very complex.
2. **Create a single (or in some cases multiple) configuration file(s)** (like `params.yaml`) to work with the prototype in step 1.
3. **Move all the reusable code to .py modules** within the appropriate folders in the `src` directory, and use them as imports in the Jupyter notebook from step 2.
4. **Re-write and port** all the remaining code in the notebook to appropriate `.py` files in the `stages` folder present within `src`. **Check that the pipeline stages work fine** by sequentially calling them in the Jupyter notebook.
5. **Automate the pipeline with DVC.** Write the `dvc.yaml` file containing the pipeline stages.

### <ins>**1. Developing the first prototype**</ins>

In this stage, develop a full prototype in a Jupyter notebook. Data is to be stored in the `data` folder either according to its origin or the processing step (raw, processed, interim, external). Report figures (like confusion matrix) and metrics (like f1, accuracy etc.) are to be stored within the `reports` folder. Optionally, ensure that the ToC (Table of Contents) extension is on.

### <ins>**2. Creating config file(s)**</ins>

At the end of step 1, there would be a lot of hardcoded values present - for example, **paths** and **hyperparameters**. In this step, move these to a configuration file (say `params.yaml`) which is present in the `project_name/project_name` directory. `yaml` library is a useful tool here.

Sample params.yaml file:

```
base:
  random_state: 42

data:
  dataset_csv: 'data/raw/iris.csv'
  features_path: 'data/processed/featured_iris.csv'
  test_size: 0.2
  trainset_path: 'data/processed/train_iris.csv'
  testset_path: 'data/processed/test_iris.csv'


train:
  clf_params:
    'C': 0.001
    'solver': 'lbfgs'
    'multi_class': 'multinomial'
    'max_iter': 100
  model_path: 'models/model.joblib'

reports:
  metrics_file: 'reports/metrics.json'
  confusion_matrix_image: 'reports/confusion_matrix.png'
```

The hardcoded values can be replaced like follows:

```
import yaml

with open('params.yaml') as config_file:
    config = yaml.safe_load(config_file)

dataset.to_csv(config['data']['dataset_csv'], index=False)
```

### <ins>**3. Moving the reusable code to .py modules**</ins>

From step 2, you may realize that there are certain sections of the code developed to be reused (like functions and classes), or there is section which can be chunked toegther based on the utility. In this step, move the code to .py modules within the appropriate folders in the `src` directory. These .py modules essentially contain code wrapped up as functions or classes, and it is these modules which are then imported into the Jupyter notebook to make the notebook cleaner.

For example, there is this code from step 2:

```
def plot_confusion_matrix(cm,
                          target_names,
                          title='Confusion matrix',
                          cmap=None,
                          normalize=True):
    """
    given a sklearn confusion matrix (cm), make a nice plot

    Arguments
    ---------
    cm:           confusion matrix from sklearn.metrics.confusion_matrix

    target_names: given classification classes such as [0, 1, 2]
                  the class names, for example: ['high', 'medium', 'low']

    title:        the text to display at the top of the matrix

    cmap:         the gradient of the values displayed from matplotlib.pyplot.cm
                  see http://matplotlib.org/examples/color/colormaps_reference.html
                  plt.get_cmap('jet') or plt.cm.Blues

    normalize:    If False, plot the raw numbers
                  If True, plot the proportions

    Usage
    -----
    plot_confusion_matrix(cm           = cm,                  # confusion matrix created by
                                                              # sklearn.metrics.confusion_matrix
                          normalize    = True,                # show proportions
                          target_names = y_labels_vals,       # list of names of the classes
                          title        = best_estimator_name) # title of graph

    Citiation
    ---------
    http://scikit-learn.org/stable/auto_examples/model_selection/plot_confusion_matrix.html

    """

    accuracy = np.trace(cm) / float(np.sum(cm))
    misclass = 1 - accuracy

    if cmap is None:
        cmap = plt.get_cmap('Blues')

    plt.figure(figsize=(8, 6))
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()

    if target_names is not None:
        tick_marks = np.arange(len(target_names))
        plt.xticks(tick_marks, target_names, rotation=45)
        plt.yticks(tick_marks, target_names)

    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]

    thresh = cm.max() / 1.5 if normalize else cm.max() / 2
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        if normalize:
            plt.text(j, i, "{:0.4f}".format(cm[i, j]),
                     horizontalalignment="center",
                     color="white" if cm[i, j] > thresh else "black")
        else:
            plt.text(j, i, "{:,}".format(cm[i, j]),
                     horizontalalignment="center",
                     color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label\naccuracy={:0.4f}; misclass={:0.4f}'.format(accuracy, misclass))

    return plt.gcf()
```

Move this code into `src/report/visualize.py`, ensuring that the function has the necessary libraries imported within the file. Then, this module can be used within the Jupyter notebook by importing it as follow:

```
from src.report.visualize import plot_confusion_matrix
```

### <ins>**4. Rewriting and porting the remaining code in the notebook to .py modules**</ins>

This step involves building individual stages of the pipeline. In order to carry out this step, group the code depending on the **stage** it carries out (like data_load, featurize, data_split, train, evaluate). The goal is to make sure that each .py module runs from both the CLI as well as the Jupyter notebook. The **eventual outputs** of the pipeline are the model and artefacts such as predictions, metrics, plots etc.

A module for each stage is created as follows:

```
import yaml
import argparse
from typing import Text

def data_load(config_path: Text) -> None:
  config = yaml.safe_load(config_path)
  raw_data_path = config['data_load]['raw_data_path]
  ...
  data.to_csv(config['dataset_processed_path'])

if __name__ == 'main':
  args_parser = argparse.ArgumentParser()
  args_parser.add_argument('--config', dest='config', require=True)
  args = args_parser.parse_args()

  data_load(config_path=args.config)
```

Note that the `params.yaml` file changes substantially like:

```
base:
  random_state: 42
  log_level: INFO


data_load:
  dataset_csv: 'data/raw/iris.csv'


featurize:
  features_path: 'data/processed/featured_iris.csv'
  target_column: target


data_split:
  test_size: 0.2
  trainset_path: 'data/processed/train_iris.csv'
  testset_path: 'data/processed/test_iris.csv'


train:

  cv: 3
  estimator_name: logreg
  estimators:
    logreg: # sklearn.linear_model.LogisticRegression
      param_grid: # params of GridSearchCV constructor
        C: [0.001]
        max_iter: [100]
        solver: ['lbfgs']
        multi_class: ['multinomial']
    svm: # sklearn.svm.SVC
      param_grid:
        C: [0.1, 1.0]
        kernel: ['rbf', 'linear']
        gamma: ['scale']
        degree: [3, 5]
  model_path: models/model.joblib


evaluate:
  reports_dir: reports
  metrics_file: 'metrics.json'
  confusion_matrix_image: 'confusion_matrix.png'
```

The following can then be run from the CLI. (All the stages need to be run sequentially):

```
python data_load.py --config=params.yaml
```

Also, the Jupyter notebook now is essentially just the stages run sequentially like:

```
!python src/stages/train.py --config=params.yaml
```

### <ins>**5. Automating the pipeline with DVC**</ins>

This step is where DVC comes in. Ensure that DVC is already initialized and the state has been committed to Git. In this stage, you organize different stages into DVC pipeline steps. This can either be done with `dvc stage add --run ...` command or by adding the stages manually in the `dvc.yaml` file which is supposed to be present in `project_name/project_name`. DVC derives a Directed Acyclic Graph (DAG) from the sequence of stages. Once this DAG is setup, the whole pipeline can be run with `dvc repro`. There is another command `dvc exp run` but it is explored later. The DAG can be viewed with `dvc dag`. DVC only runs the parts of the pipeline that have changed (All the stages downstream from a changed stage are run).

The steps are as follows:

1. Initialize DVC and commit the project status.

   ```
   dvc init
   git add .
   git commit -m "INITIALIZE DVC"
   ```

2. Create a `dvc.yaml` file like

   ```
   stages:
     data_load:
       cmd: python src/stages/data_load.py --config=params.yaml
       deps:
       - src/stages/data_load.py
       params:
       - base
       - data_load
       outs:
       - data/raw/iris.csv
     featurize:
       cmd: python src/stages/featurize.py --config=params.yaml
       deps:
       - data/raw/iris.csv
       - src/stages/featurize.py
       params:
       - base
       - data_load
       - featurize
       outs:
       - data/processed/featured_iris.csv
     data_split:
       cmd: python src/stages/data_split.py --config=params.yaml
       deps:
       - data/processed/featured_iris.csv
       - src/stages/data_split.py
       params:
       - base
       - data_load
       - featurize
       outs:
       - data/processed/train_iris.csv
       - data/processed/test_iris.csv
     train:
       cmd: python src/stages/train.py --config=params.yaml
       deps:
       - data/processed/train_iris.csv
       - src/stages/train.py
       params:
       - base
       - train
       outs:
       - models/model.joblib
     evaluate:
       cmd: python src/stages/evaluate.py --config=params.yaml
       deps:
       - data/processed/test_iris.csv
       - src/stages/evaluate.py
       - models/model.joblib
       params:
       - base
       - data_load
       - train
       - featurize
       - evaluate
       outs:
       - reports/metrics.json
       - reports/confusion_matrix.png
   ```

3. Create a file `.pre-commit-config.yaml` with the following content (Git hooks):

   ```
   repos:
       - repo: https://github.com/psf/black
         rev: 23.3.0
         hooks:
           - id: black
             language_version: python3.10
       - repo: https://github.com/PyCQA/flake8
         rev: 6.0.0
         hooks:
           - id: flake8
       - repo: https://github.com/pre-commit/mirrors-mypy
         rev: v1.1.1
         hooks:
           - id: mypy
             args: [--disallow-untyped-defs, --disallow-incomplete-defs, --disallow-untyped-calls, --ignore-missing-imports]
             additional_dependencies: [types-requests, types-PyYAML]
       - repo: https://github.com/asottile/reorder_python_imports
         rev: v3.9.0
         hooks:
           - id: reorder-python-imports
       - repo: https://github.com/iterative/dvc
         rev: main
         hooks:
           - id: dvc-pre-commit
             additional_dependencies: ['.[all]']
             language_version: python3
             stages:
               - commit
           - id: dvc-pre-push
             additional_dependencies: ['.[all]']
             language_version: python3
             stages:
               - push
           - id: dvc-post-checkout
             additional_dependencies: ['.[all]']
             language_version: python3
             stages:
               - post-checkout
             always_run: true
   ```

4. Install the hooks.

   ```
   pre-commit install --hook-type pre-push --hook-type post-checkout --hook-type pre-commit
   ```

5. Commit the current project's status.

   ```
   git add .
   git commit -m "ADD Git hooks file"
   ```

6. Run `dvc repro`.
