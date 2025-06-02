#!/bin/bash
set -e
echo ""
echo "Hey, I will automate the following:"
echo -e "\t1. Creation of a virtual environment"
echo -e "\t2. Creation of a new poetry project"
echo -e "\t3. Installation of project dependencies"
echo -e "\t4. Generation of the folder structure"
echo -e "\t5. Setting up of Jupyter notebook - config & ToC widget"
echo -e "\t6. Addition of the project to PYTHONPATH"
echo "***************************************************************"
echo ""
echo "Please have the environment.yml file ready."
echo ""
echo "I will also need your input for the following (and even later!):"
echo ""
read -p "What is the name of the environment in environment.yml?    " env_name
echo ""
read -p "What would you like to name your project?    " project_name
echo ""
echo "Thank you! The environment setup will begin now."
echo ""
echo "################################################################"
echo "Creating the virtual envrionment $env_name from the environment.yml file ..."
echo ""
micromamba create -f environment.yml -y
echo ""
echo "Virtual environment creation done."
echo "################################################################"
echo "Activating the virtual environment ..."
echo ""
eval "$(micromamba shell hook --shell=bash)"
micromamba activate $env_name
echo ""
echo "You are now within the virtual environment - $env_name."
echo "################################################################"
echo "Initializing the poetry project $project_name ..."
echo ""
poetry new $project_name
echo ""
echo "Project initialization done."
echo "################################################################"
echo "Installing the necessary dependencies ..."
echo ""
cd $project_name
poetry add dvc dvclive h5py ipykernel jupyter jupyter_contrib_nbextensions matplotlib numpy pandas pre-commit pylint pytest python-box pyyaml seaborn scikit-learn torcheval torchsummary tqdm types-PyYAML
echo ""
echo "Dependencies installation done."
echo "################################################################"
echo ""
echo "Restarting the terminal and activating the environment again ..."
micromamba deactivate $env_name
micromamba activate $env_name
echo "Virtual environment activated again."
echo ""
echo "Creating the folder structure for the project ..."
cd $project_name
mkdir data models notebooks reports src
cd data
mkdir external interim processed raw
cd ..
cd src
mkdir data evaluate features report stages train utils
cd ..
echo ""
echo "Folder structure generation done."
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
echo "Activate the environment with 'micromamba activate $env_name'. Happy building!" 
echo "################################################################"