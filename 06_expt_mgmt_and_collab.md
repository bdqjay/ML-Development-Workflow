## **Experiments Management and Collaboration**
---

- [**Experiments Management and Collaboration**](#experiments-management-and-collaboration)
  - [Experiment Management](#experiment-management)
    - [Changing parameters in experiments](#changing-parameters-in-experiments)
    - [Queuing experiments](#queuing-experiments)
    - [Evaluating experiment metrics](#evaluating-experiment-metrics)
    - [Persisting experiments](#persisting-experiments)
  - [**DVC commands in this document**](#dvc-commands-in-this-document)


### <ins>Experiment Management</ins>

**`dvc exp run`** is another command which can trigger a pipeline run. There are some features which are specific to experiments such as updating parameters from the CLI, queuing and comparing experiments, persisting experiments through individual Git branches, and sharing. 

#### Changing parameters in experiments
```
dvc exp run -S prepare.split=0.25 -S featurize.max_features=2000
```

DVC updates `params.yaml` automatically, so the results can be committed if you like them.

#### Queuing experiments
```
dvc exp run --queue -S featurize.max_features=200
dvc exp run --queue -S featurize.max_features=2000
dvc exp run --queue -S featurize.max_features=200000

dvc exp run --run-all --jobs 2 # Run 2 training in parallel
```

#### Evaluating experiment metrics

```
dvc exp show 

dvc exp show --only-changed
```

#### Persisting experiments

Once successful experiments are found, they can be persisted in our workspace. Say an experiment *exp-ea4532* yields the best results for auc. We can apply the changes to the parameters and hyperparameters used in this experiment to our workspace and create a Git commit.

```
dvc exp apply exp-ea4532
```

If we want to branch out of a certain experiment, 

```
dvc exp branch exp-ea4532 maxf-1500
```

We can then use this branch any way we would like to: sync to the remote, merge to main, or experiment further.

### <ins>**DVC commands in this document**</ins>

1. **`dvc exp run`**

2. **`dvc exp show`**

3. **`dvc exp apply`**

4. **`dvc exp branch`**