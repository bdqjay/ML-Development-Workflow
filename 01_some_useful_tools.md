# **Some Useful Tools for Data Science and Machine Learning Projects**

---

- [**Some Useful Tools for Data Science and Machine Learning Projects**](#some-useful-tools-for-data-science-and-machine-learning-projects)
  - [**Virtual Environment**](#virtual-environment)
    - [**conda**](#conda)
    - [**mamba**](#mamba)
    - [**micromamba**](#micromamba)
    - [**pyenv**](#pyenv)
  - [**Package Manager**](#package-manager)
  - [**A Faster Python Package and Project Manager: uv**](#a-faster-python-package-and-project-manager-uv)
  - [**Git Hooks**](#git-hooks)

Besides famous libraries and frameworks like numpy, pandas, TensorFlow, PyTorch etc., and tools like JupyterLab and Google Colab, there are several other tools out there that would make the analysis and development streamlined. Some of them are discussed here.

## <ins>**Virtual Environment**</ins>

- It is **highly recommended** to use virtual environments for development purposes.
- Each project may require different versions of Python (and package dependencies). In order to run them on your machine, you may have to resolve a lot of errors resulting from the version mismatch of Python. Virtual environments help avoid this.

There are 4 tools which I recommend for virtual environment management: `conda`, `mamba`, `micromamba` and `pyenv`.

### **conda**

- [conda](https://docs.conda.io/projects/conda/en/stable/index.html) is a tool for both **environment and dependency** management.
- From it's website's description -- for **environment management**: conda easily creates, saves, loads, and switches between environments on your local computer.

### **mamba**

- [mamba](https://mamba.readthedocs.io/en/latest/) too is a tool for **environment and dependency** management.
- It is meant to be a replacement for conda, and offers higher speed and better reliability.
- It is a Python based CLI.

### **micromamba**

- [micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html) is a smaller version of mamba.
- It supports a smaller subset of all mamba and conda commands, and implements a C++ based CLI from scratch.
- It is _especially_ useful in CI workflows.
- Unlike conda and mamba, it does not need a base environment and does not come with a default version of Python.

### **pyenv**

- [**pyenv**](https://github.com/pyenv/pyenv) is another great tool for environment management.
- **However,** pyenv builds Python from source, and thus there are several dependencies that need to be installed in order to use the Python environments seamlessly. This makes pyenv particularly difficult to work with if you have no rights to install dependencies -- like in cases where you do not have the `sudo` access on Linux systems.

## <ins>**Package Manager**</ins>

- To define a package manager in simple terms, Wikipedia mentions - _A package manager or package-management system is a collection of software tools that automates the process of installing, upgrading, configuring, and removing computer programs for a computer in a consistent manner._
- There are famous command tools like `apt`, `yum`, and `brew`.
- [**poetry**](https://python-poetry.org/docs/), a tool for dependency management and packaging in Python, is one of them.
- It allows you to declare the libraries your project depends on and it will manage (install/update) them for you.
- It offers a lockfile to ensure repeatable installs, and can build your project for distribution.

## <ins>**A Faster Python Package and Project Manager: uv**</ins>

- In the words of the creators, uv is a _A single tool to replace `pip`, `pip-tools`, `pipx`, `poetry`, `pyenv`, `twine`, `virtualenv`, and more._
- [**uv**](https://docs.astral.sh/uv/) provides fast, unified support for package management, virtual environments, Python versioning, and project workflows besides many other things.
- It helps manage dependencies, environments, scripts, and publishing—all in one tool.
- It's currently my preferred tool for Python development.

## <ins>**Git Hooks**</ins>

- Git hook scripts are a great tool for development purposes.
- They are a way to automate various tasks -- like identifying issues in code files, enforcing programming standards, triggering _one_ process when some _another_ process has been run etc.
- Once setup, they offer great convenience, especially for mundane and repetitive but critical tasks.
- The hook scripts can be for different stages like _pre-commit_, _pre-push_, _post-checkout_ etc.
- There are 4 pre-commit hooks that I really like: [black](https://black.readthedocs.io/en/stable/index.html#), [flake8](https://flake8.pycqa.org/en/latest/#), [mypy](https://mypy-lang.org/), [reorder-python-imports](https://pypi.org/project/reorder-python-imports/)
