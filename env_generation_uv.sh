#!/bin/bash
set -e
echo ""
echo "Hey, I will automate the following:"
echo -e "\t1. Creation of a new ML project with uv"
echo -e "\t2. Generation of the folder structure"
echo -e "\t3. Installation of dependencies"
echo -e "\t4. Setting up and installation of pre-commit hooks"
echo -e "\t5. Addition of the project to PYTHONPATH"
echo "***************************************************************"
echo "I will need your input for the following (and even later!):"
echo ""
read -p "What would you like to name your project?    " project_name
echo ""
echo "Thank you! The project setup will begin now."
echo ""
echo "################################################################"
echo "Creating the project titled '$project_name' with uv ..."
echo ""
uv init $project_name
cd $project_name
rm -f main.py
echo ""
echo "Project creation done."
echo "################################################################"
echo "Creating the folder structure for the project ..."
mkdir data models notebooks reports src tests
cd data
mkdir external interim processed raw
cd ..
cd src
mkdir data evaluate features report stages train utils
touch __init__.py
cd ..
echo ""
echo "Folder structure generation done."
echo "################################################################"
echo "Installing the necessary dependencies ..."
echo ""
uv add dvc dvclive fastai h5py numpy plotly polars pyyaml scikit-learn torch torchsummary torcheval torchvision
uv add --dev ipykernel jupyter jupyter_contrib_nbextensions pytest
echo ""
echo "Dependencies installation done."
echo "################################################################"
echo "Setting up pre-commit hooks ..."
echo ""
cat <<EOF > .pre-commit-config.yaml
default_install_hook_types:
  - pre-commit
  - pre-push
  - post-checkout
  - post-merge
  - post-rewrite
repos:
  - repo: https://github.com/iterative/dvc
    rev: 3.62.0
    hooks:
    - id: dvc-pre-commit
      additional_dependencies:
      - .[all]
      language_version: python3
      stages:
      - pre-commit
    - id: dvc-pre-push
      additional_dependencies:
      - .[all]
      language_version: python3
      stages:
      - pre-push
    - id: dvc-post-checkout
      additional_dependencies:
      - .[all]
      language_version: python3
      stages:
      - post-checkout
      always_run: true
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.12.9
    hooks:
      - id: ruff-check
        args: [ --fix ]
        stages:
          - pre-commit
      - id: ruff-format
        stages:
            - pre-commit
  - repo: https://github.com/pycqa/isort
    rev: 6.0.1
    hooks:
      - id: isort
        name: isort (python)
        args: ["--profile", "black"]
        stages:
          - pre-commit
  - repo: https://github.com/astral-sh/uv-pre-commit
    rev: 0.8.12
    hooks:
      - id: uv-lock
        stages:
            - pre-commit
      - id: uv-sync
        stages:
          - post-checkout
          - post-merge
          - post-rewrite
EOF
uvx pre-commit install
echo ""
echo "Pre-commit installed and initialized."
echo "################################################################"
echo ""
echo "Adding the project to PYTHONPATH ..."
project_dir=$PWD
echo "export PYTHONPATH="${PYTHONPATH}:$project_dir"" >> ~/.bashrc
echo "export PYTHONPATH="${PYTHONPATH}:$project_dir"" >> ~/.profile
source ~/.bashrc
echo ""
echo "Environment and folder structure setup complete!"
echo ""
echo "Happy building!" 
echo "################################################################"