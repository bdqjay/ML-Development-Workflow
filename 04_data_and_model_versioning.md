## **Data & Model Versioning**
---
- [**Data \& Model Versioning**](#data--model-versioning)
  - [**Versioning Data \& Models**](#versioning-data--models)
    - [**How Does Data \& Model Versioning Work?**](#how-does-data--model-versioning-work)
    - [**Version \& Share Data and Models**](#version--share-data-and-models)
    - [**Exercise: Remote Storage**](#exercise-remote-storage)
    - [**Tracking Changes and Switching Versions**](#tracking-changes-and-switching-versions)
    - [**Exercise: Tracking \& Switching**](#exercise-tracking--switching)
    - [**Data Access**](#data-access)
  - [**DVC commands in this document**](#dvc-commands-in-this-document)


### <ins>**Versioning Data & Models**</ins>

We can make DVC track specific files or folders with the command **`dvc add ... -v`** where `-v` is for verbose mode and is optional.

Sample command:
```
dvc add [filename/directory] -v
```

#### **How Does Data & Model Versioning Work?**

DVC first checks whether it has already created a metafile for the file we added for tracking. If `md5: 'None'`, then it is not the case. DVC then saves the data to the DVC cache before removing the original file. A reflink is then created to the newly cached file so that the filesystem can find the cached file. Lastly, all relevant information is saved to the DVC metafile. 

The metafile contains the MD5 hash for the file and the original file location. Sample metafile:
```
outs:
- md5: asdfgqwer
  path: data.xml
```
In this case, whenever DVC is instructed to retrieve the `data.xml` in the `data` directory, it will retrieve the file with the hash `asdfgqwer`.

Because the metafile is versioned by our Git history, DVC has tied data versions specific to code versions. A change to our dataset would constitute an updated DVC metafile and thus a new commit in our commit history.

**Also,** when we run a pipeline using `dvc repro`, DVC starts tracking the files automatically. All outputs in our pipeline are added to the DVC cache and versioned. (Always commit after `dvc add` or `dvc repro`)

#### **Version & Share Data and Models**

The DVC cache we have been dealing with thus far has been present on our local machine. However, more often than not, we have the need to version the data on the remote storage.

The `remote` is where DVC sends the data for persistent storage. It is analogous to a remote Git repo. There are a wide range of remote storages supported.

**`dvc remote add`**

A remote can be added with the command `dvc remote add` like follows:

```
mkdir -p /tmp/dvc
dvc remote add -d myremote /tmp/dvc
git commit .dvc/config -m "Configure local remote"
```

Here, we have created a directory to serve as a local remote. While it is located on the same machine, it is in a separated location from our DVC cache. Remember to commit this change in our DVC config to the Git history.

**Command equivalents**

Data can be synced between our local cache and remote just like we would for code using Git.

```
git add <-> dvc add
git commit <-> dvc commit
git pull <-> dvc pull
git push <-> dvc push
```

#### **Exercise: Remote Storage**

```
mkdir -p /tmp/dvc
dvc remote add -d myremote /tmp/dvc
git commit .dvc/config -m "Configure local remote"

dvc push -v

REMOVE the model.joblib file

dvc pull
```

#### **Tracking Changes and Switching Versions**
---

Use `dvc status` to check the status of the files tracked by DVC. A benefit of using DVC is that it adds a cache layer which makes it easy to switch between different versions of data without having to replace the entire dataset (e.g by downloading). 

Whenever we update an image dataset by adding more images, we will only retrieve the added images while keeping the older ones as they are. 

We can switch between versions with `dvc checkout`. First the required code is checked out and then the associated data. **The following is to be done in order:**

```
git checkout v1.0
dvc checkout
```

#### **Exercise: Tracking & Switching**

```
mkdir -p /tmp/dvc
dvc remote add -d myremote /tmp/dvc
git commit .dvc/config -m "Configure local remote"

CREATE a file.txt

dvc add file.txt

dvc push -v

REMOVE the file.txt

dvc pull

```

#### **Data Access**

When versioning data and models with DVC, we will need the access to them again. Common use cases include:

- Downloading the latest version of a model
- Donwloading a specific version of a model
- Reusing datasets across different projects
- Getting the features used to train a specific version of a model

When connecting to a remote, it may not be known what is present there. Using **`dvc list`** in combination with the URL to the remote and dataset's name, we can get overview of all tracked artifacts.

```
dvc list https://github.com/iterative/data-registry use-cases
```

Then, either `dvc get [URL] [dataset name]` or `dvc import [URL] [dataset name]` can be used. The first only downloads and does not track any changes, whereas the latter does. (Serving a model v/s updating it)

### <ins>**DVC commands in this document**</ins>

1. **`dvc add`**

2. **`dvc remote add`**

3. **`dvc commit`**

4. **`dvc push`**

5. **`dvc pull`**

6. **`dvc list`**

7. **`dvc get`**

8. **`dvc import`**