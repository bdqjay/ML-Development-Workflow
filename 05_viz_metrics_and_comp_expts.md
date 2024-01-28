## **Metrics Tracking and Experiments Comparison with DVC and Studio**
---
- [**Metrics Tracking and Experiments Comparison with DVC and Studio**](#metrics-tracking-and-experiments-comparison-with-dvc-and-studio)
  - [**Metrics Tracking with DVC**](#metrics-tracking-with-dvc)
  - [**Exercise: Metrics Tracking**](#exercise-metrics-tracking)
  - [**Plots and Graphics with DVC**](#plots-and-graphics-with-dvc)
  - [**Exercise: Metrics Visualization**](#exercise-metrics-visualization)
  - [**DVC Live and Checkpoints**](#dvc-live-and-checkpoints)
  - [**DVC Studio Intro**](#dvc-studio-intro)
  - [**DVC commands in this document**](#dvc-commands-in-this-document)


### <ins>**Metrics Tracking with DVC**</ins>

1. Define metrics in the `dvc.yaml` file. We can set specific files that contains metrics and plots for our experiments.

    ```
    stages:
        train:
            cmd: python train.py --config=params.yaml
            deps:
            - features.csv
            outs:
            - model.pkl
            metrics:
            - metrics.json:
                cache: false
            plots:
            - auc.json:
                cache: false
    ```

Setting `cache: false`, we tell DVC not to track this file but instead keep this as a part of Git history. This decision is usually made depending on the size of the files.

**`dvc metrics show`**

DVC offers commands to work with metric files. `dvc metrics show` displays the content in terminal. Different flags can also be used to say, show a specific metric.

**`dvc metrics diff`**

This command displays the difference in metrics between different experiments. By default, it displays for the last 2 experiments but commit hashes can be used to fetch comparisons for any experiments.

(In the sample project 'test_dvc', the Git commit until this point is 'Check hooks')

### **Exercise: Metrics Tracking**

```
1. Save reports/metrics.json. (Probably doing until now)

2. Specifiy metrics section in dvc.yaml (until now it will be in 'outs' section of the file).

3. Run 'dvc metrics show'.

4. Run different experiments with 'dvc repro' and do 'dvc metrics diff'.
```

### <ins>**Plots and Graphics with DVC**</ins>

DVC has a feature of generating visualizations. DVC requires 2 things - the data for visualization and the json (plot) template in .dvc/plots. DVC takes in the data for visualization and the template, and merges them into a single json file which is passed to a javascript library that generates the visuals. This generated file is rendered in a static HTML page which can then be saved as svg or png file.

DVC can generate a number of visuals, which are defined as templates in `.dvc/plots` directory. We can define these templates ourselves, or use the available built-in ones.

- `default`: linear plot
- `scatter`
- `smooth`: linear plot with LOESS smoothing
- `confusion`


**``dvc plots show``**

 Say we have a metrics file called `logs.csv`.

```
epoch, accuracy, loss, val_accuracy, val_loss
0,..,..,..,..
1,..,..,..,..
2,..,..,..,..
```

`-x` and `-y` options can be used for plot axes. For example:

```
dvc plots show -y 'val_accuracy'
```

For choosing a particular template:
```
dvc plots show reports/confusion_matrix.csv --template confusion -x predicted -y y_true
```

**`dvc plots diff`**

To visually compare different experiments:
```
dvc plots diff --targets logs.csv --x-label x
```

### **Exercise: Metrics Visualization**

```
1. In 'src' folder, in 'evaluate.py', add content like:

def convert_to_labels(indexes, labels):
    result = []
    for i in indexes:
        result.append(labels[i])
    return result

def write_confusion_matrix_data(y_true, predicted, labels, filename):
    assert len(predicted) == len(y_true)
    predicted_labels = convert_to_labels(predicted, labels)
    true_labels = convert_to_labels(y_true, labels)
    cf = pd.DataFrame(list(zip(true_labels, predicted_labels)), columns=["y_true", "predicted"])
    cf.to_csv(filename, index=False)


def evaluate_model(config_path: Text) -> None:
    """Evaluate model.
    Args:
        config_path {Text}: path to config
    """

    with open(config_path) as conf_file:
        config = yaml.safe_load(conf_file)

    logger = get_logger('EVALUATE', log_level=config['base']['log_level'])

    logger.info('Load model')
    model_path = config['train']['model_path']
    model = joblib.load(model_path)

    logger.info('Load test dataset')
    test_df = pd.read_csv(config['data_split']['testset_path'])

    logger.info('Evaluate (build report)')
    target_column=config['featurize']['target_column']
    y_test = test_df.loc[:, target_column].values
    X_test = test_df.drop(target_column, axis=1).values

    prediction = model.predict(X_test)
    f1 = f1_score(y_true=y_test, y_pred=prediction, average='macro')

    labels = load_iris(as_frame=True).target_names.tolist()
    cm = confusion_matrix(y_test, prediction)

    report = {
        'f1': f1,
        'cm': cm,
        'actual': y_test,
        'predicted': prediction
    }

    logger.info('Save metrics')
    # save f1 metrics file
    reports_folder = Path(config['evaluate']['reports_dir'])
    metrics_path = reports_folder / config['evaluate']['metrics_file']

    json.dump(
        obj={'f1_score': report['f1']},
        fp=open(metrics_path, 'w')
    )

    logger.info(f'F1 metrics file saved to : {metrics_path}')

    logger.info('Save confusion matrix')
    # save confusion_matrix.png
    plt = plot_confusion_matrix(cm=report['cm'],
                                target_names=labels,
                                normalize=False)
    confusion_matrix_png_path = reports_folder / config['evaluate']['confusion_matrix_image']
    plt.savefig(confusion_matrix_png_path)
    logger.info(f'Confusion matrix saved to : {confusion_matrix_png_path}')

    confusion_matrix_data_path = reports_folder / config['evaluate']['confusion_matrix_data']
    write_confusion_matrix_data(y_test, prediction, labels=labels, filename=confusion_matrix_data_path)
    logger.info(f'Confusion matrix data saved to : {confusion_matrix_data_path}')


if __name__ == '__main__':
    args_parser = argparse.ArgumentParser()
    args_parser.add_argument('--config', dest='config', required=True)
    args = args_parser.parse_args()

    evaluate_model(config_path=args.config)

---

2. In dvc,yaml, add 'plots' section like:

plots:
    - reports/confusion_matrix_data.csv:
        template: confusion
        x: predicted
        y: y_true

3. Add the following to the 'evaluate' section in params.yaml:

confusion_matrix_data: 'confusion_matrix_data.csv'

```

Visualizing from raw data is always recommended. Otherwise, adding '- reports/confusion_matrix.png' to plots is also possible.

### <ins>**DVC Live and Checkpoints**</ins>

The .json thing can be clunky for bigger experiments. Tracking metrics and plots.

Checkpoints are to take snapshots of our model at a given point in time. They usually correspond to training epochs. DVC will save model weights at each checkpoint, and we can log all metrics and results. Code and data changes are also tracked, and a new commit is created for each checkpoint. We can for example, revert back to an optimal checkpoint, and continue our experimentation from there.

To register checkpoints, we use a library called `DVCLive`. It integrates with ML frameworks and lets us automatically store metrics through a callback.

1. Import library into training script and log the metrics.

    ```
    from dvclive import Live

    live = Live("training_metrics) # Name of file where metrics are logged

    for epoch in range(NUM_EPOCHS):
        train_model(...)
        metrics = evaluate_model(...)

        # live.log() prevents json.dump()

        for metric_name, value in metrics.items():
            live.log(metric_name, value)
        live.next_step()
    ```

2. Specify the file containing the logged metrics in dvc pipeline.

    ```
    stages:
        train:
            cmd: python train.py
            deps:
            - train.py
            outs:
            - model.pt:
                checkpoint: true
            live:
                results: # file name
                    summary: true
                    html: true

            # metrics and plots not required here
    ```

3. Visualize these metrics with `dvc plots`. An automatic HTML report can also be generated with `live.make_report()`

    ```
    from dvclive import Live

    live = Live("training metrics) # Name of file where metrics are logged

    for epoch in range(NUM_EPOCHS):
        train_model(...)
        metrics = evaluate_model(...)

        for metric_name, value in metrics.items():
            live.log(metric_name, value)
        live.make_report()
        live.next_step()
    ```

DVCLive will generate a `report.html` in the same directory as metrics file, and this file will be updated at the end of each epoch.

Results with `dvc exp show` will now show checkpoints too.

### <ins>**DVC Studio Intro**</ins>

An overview of all experiments and checkpoints including metrics and data files can be seen on Studio. This platform connects with your remote repository tool. It is also possible to change hyperparameters and run new experiments from the Studio itself. This will result in a new pull request and branch on your remote repo.

### <ins>**DVC commands in this document**</ins>

1. **`dvc metrics show`**

2. **`dvc metrics diff`**

3. **`dvc plots show`**

4. **`dvc plots diff`**

5. **`dvc exp show`**

6. **`dvc exp diff`**