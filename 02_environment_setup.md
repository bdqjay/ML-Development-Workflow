# **Environment Setup for Machine Learning Projects**
---
- [**Environment Setup for Machine Learning Projects**](#environment-setup-for-machine-learning-projects)
  - [**Installation of Virtual Environment Management Tools**](#installation-of-virtual-environment-management-tools)
    - [**`conda` installation**](#conda-installation)
    - [**`mamba` installation**](#mamba-installation)
    - [**`micromamba` installation**](#micromamba-installation)
    - [**`pyenv` installation**](#pyenv-installation)
  - [**Development Environment Setup**](#development-environment-setup)
    - [**With `conda`/`mamba`/`micromamba`**](#with-condamambamicromamba)
    - [**With `pyenv`**](#with-pyenv)


This document provides guidelines for setting up a new project, with a focus on Linux-based development environments (specifically Ubuntu). While I personally prefer to use Linux or MacOS for development purposes, Windows with [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install) enabled is a great choice too.

**Note:** 
1. In WSL, it sometimes may be the case that the installs with tools like `apt` do not work due to some internet connection error. In this case, open the file `resolv.conf` with `sudo nano /etc/resolv.conf` and change the `nameserver` value to `8.8.8.8`. 

2. It may also be sometimes necessary to install `bzip2` with `sudo apt install bzip2`.

As mentioned in [01_some_useful_tools.md](01_some_useful_tools.md), there are 4 tools viz. `conda`, `mamba`, `micromamba` and `pyenv` which I recommend for virtual environments' management and 1 tool for dependency/package management viz. `poetry`. 

<span style="color:red">**Important Points:**</span>.
1. `conda`, `mamba`, and `micromamba` have similar commands when it comes to managing virtual environments. So, if you know how to work with one of them, you can work seamlessly with the other two.

2. `micromamba` is the fastest option of the three but not necessarily the most powerful. However, for a great number of use-cases, it is a powerful enough tool, and thus I use it for most of my purposes.

## <ins>**Installation of Virtual Environment Management Tools**</ins>

Before proceeding, make sure you have `wget` and/or `curl` installed. If not, install them with

```
sudo apt update
sudo apt upgrade
sudo apt install wget curl
```

### <ins>**`conda` installation**</ins>
`Anaconda` is a distribution of `conda`. It contains several hundred Python packages used for data science and scientific computing purposes. It is, however, recommended that you manage the dependencies and their versions yourselves, and thus should install `miniconda` instead. It is a mini version of Anaconda that includes just `conda`, its dependencies, and Python besides other useful utilities like pip, zlib etc. 

Installation instructions for miniconda can be found [here](https://docs.anaconda.com/free/anaconda/install/). Since instructions for installation on WSL are not present in the documentation, they are provided below:

1. Download the latest version of miniconda with the following:
    ```
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    ```

2. Install miniconda. (When prompted _'Do you wish the installer to initialize Miniconda3
by running `conda` init? [yes|no]'_, enter _yes_)

    ```
    bash Miniconda3-latest-Linux-x86_64.sh
    ```

3. Restart WSL.

4. [Optional] If you prefer that `conda`'s base environment is not activated on shell startup, use the following:

    ```
    conda config --set auto_activate_base false
    ```

To see how to create and activate environments using `conda` skip to [Managing Environments with `conda`](#)

### <ins>**`mamba` installation**</ins>
The instructions for installing `mamba` on different platforms can be found [here](https://mamba.readthedocs.io/en/latest/installation.html).

For Linux, the instructions are as follows:

1. Download the installer.
    ```
    curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
    bash Mambaforge-$(uname)-$(uname -m).sh
    ```

2. Run the script.
    ```
    bash Mambaforge-$(uname)-$(uname -m).sh
    ```

3. Restart the shell.

### <ins>**`micromamba` installation**</ins>
To get the installation instructions for different platforms, visit [here](https://mamba.readthedocs.io/en/latest/installation.html).

For installation on Linux, run the following:
```
curl micro.mamba.pm/install.sh | bash
```

### <ins>**`pyenv` installation**</ins>
1. Download and Install pyenv with the following:
    ```
    sudo apt update

    sudo apt upgrade

    curl https://pyenv.run | bash
    ```

2. Add pyenv to PATH

    ```
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc

    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile

    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc

    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile

    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc

    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile

    echo 'export PATH="/home/user/.pyenv/bin:$PATH"' >> ~/.bashrc

    echo 'export PATH="/home/user/.pyenv/bin:$PATH"' >> ~/.profile

    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

    echo 'eval "$(pyenv init -)"' >> ~/.profile

    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile

    echo 'export PATH="/home/user/.pyenv/bin:$PATH"' >> ~/.bashrc

    echo 'export PATH="/home/user/.pyenv/bin:$PATH"' >> ~/.profile

    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

    echo 'eval "$(pyenv init -)"' >> ~/.profile

    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc

    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.profile
    ```

3. Restart the shell.

4. Before you install any particular version of Python and start using it, install the necessary dependencies with:

    ```
    sudo apt install \
    build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    ```
---
---

## <ins>**Development Environment Setup**</ins>

### <ins>**With `conda`/`mamba`/`micromamba`**</ins>
There are 2 main ways of creating virtual environments with `conda`/`mamba`/`micromamba`:

1. Using commands.
2. Using an `environment.yml` file.

Prefer using method number 2 as it allows you to have a centralized configuration file.

1. Create an `environment.yml` file. 
    ```
    name: my_project_env_pt
    channels:
        - pytorch
        - nvidia
        - conda-forge
        - nodefaults
    dependencies:
        - python=3.10.10
        - poetry
        - pip 
        - pytorch::pytorch
        - pytorch::torchaudio
        - pytorch::torchvision
        - pytorch::pytorch-cuda
    ```

2. Create the virtual environment.

    ```
    micromamba create -f environment.yml
    ```

3. Activate the virtual environment:

    ```
    micromamba activate my_project_env_pt
    ```

4. In the directory where you want to create your project, run 
    ```
    poetry new project_name
    ```

5. Install the necessary dependencies. They go in _tool.poetry.dependencies_ in the _poetry.toml_ file with their names and constraints. Poetry searches them on package repos or PyPI. Instead of manual additions to the file, it is advisable to do the following:

    ```
    poetry add dvc dvclive h5py ipykernel jupyter jupyter_contrib_nbextensions matplotlib numpy pandas pre-commit pylint pytest python-box pyyaml seaborn scikit-learn scipy torchsummary tqdm types-PyYAML
    ```

    For getting dvc with remote storage supported, install the dvc package with the storage you need enabled. For example, `dvc-s3` for working with Amazon S3. Also, you may have to manually edit the python version in pyproject.toml to ensure certain dependencies get installed.

6. Restart the terminal.

7. Create the following folder structure:
    ```
        Project-Name
        ├── README.md      
        ├── poetry.lock    
        ├── project_name 
        │   ├── __init__.py
        │   ├── data
        │   │   ├── external <- data from 3rd party sources
        │   │   ├── interim  <- intermediate data that has been transformed
        │   │   ├── processed <- final, canonical data for modeling
        │   │   └── raw <- original, immutable data dump     
        │   ├── models <- trained and serialized models and/or model summaries      
        │   ├── notebooks <- Jupyter notebooks
        │   ├── reports <- generated analysis as metrics.json, HTML, PDF, LaTeX etc.   
        │   └── src
        │       ├── __init__.py
        │       ├── data <- code for data download and generate data
        │       ├── evaluate <- code for model quality evaluation and metrics
        │       ├── features <- code for turning raw data into features for modeling
        │       ├── report <- code for visualization and plots
        │       ├── stages <- code for DVC stages
        │       ├── utils <- code for helpers (ex. logger)
        │       └── train <- code for training and hyperparameter tuning
        ├── pyproject.toml
        └── tests
            └── __init__.py
    ```

8. Setup the usage of Jupyter notebooks.

    ```
    jupyter notebook --generate-config
    jupyter notebook password

    jupyter contrib nbextension install --user
    jupyter nbextension enable toc2/main
    ```

9. Add the project to PYTHONPATH

    ```
    echo 'export PYTHONPATH="${PYTHONPATH}:path-to-project_name/project_name"' >> ~/.bashrc
    echo 'export PYTHONPATH="${PYTHONPATH}:path-to-project_name/project_name"' >> ~/.profile
    ```

    **Remember to clear .bashrc and .profile of previous projects!**

10. Initialize a Git repo with `git init`

11. Add a `.gitignore` file with the content (sample):

    ```
    # IDEs
    .idea
    .vscode

    # OS configs
    .DS_Store

    # Project
    project_build/data/*
    project_build/models/*
    project_build/reports/*

    # Python
    __pycache__
    .mypy_cache
    .ipynb_checkpoints

    # Venv
    dvc-venv
    .venv/
    .python-version
    ```

<span style="color:red">**Note:**</span> For convenience, the steps 2-9 from above can be automated. Both the `environment.yml` and the automation script `env_generator.sh` can be found [here](). Just place them both in the directory where you wish to have your project, and run the following:

```
chmod u+x env_generator.sh
./env_generator.sh
```

---
---

### <ins>**With `pyenv`**</ins>

1. Install a specific version of Python for pyenv. (It is possible to install multiple)

    ```
    pyenv install 3.9.16
    ```

2. Create a virtual environment. It can be named anything you like but the Python version should match the one(s) installed in pyenv.
    ```
    pyenv virtualenv 3.9.16 my_new_env
    ```

3. Activate the virtual environment
    ```
    pyenv activate my_new_env
    ```

4. Install _`poetry`_ inside the virtual enviroment with:
    ```
    pip install `poetry` 

    OR

    curl -sSL https://install.python-`poetry`.org | python3 -
    ```

5. Add _`poetry`_ to PATH
    ```
    echo 'export PATH="/home/patelj2/.local/bin:$PATH"' >> ~/.bashrc

    echo 'export PATH="/home/patelj2/.local/bin:$PATH"' >> ~/.profile

    exec "$SHELL"
    ```

6. Repeat the steps starting from step number 4 from the previous section.
