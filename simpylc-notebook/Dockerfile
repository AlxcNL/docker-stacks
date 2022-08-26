# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG ROOT_CONTAINER
ARG BASE_CONTAINER=${ROOT_CONTAINER}

FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    # for cython: https://cython.readthedocs.io/en/latest/src/quickstart/install.html
    build-essential \
    # for latex labels
    cm-super \
    dvipng \
    # for matplotlib anim
    ffmpeg \
    software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# # PPA third-party repository for Open Source AMD Radeon Drivers 
# RUN add-apt-repository ppa:oibaf/graphics-drivers

# Dependencies for glvnd and X11.
# https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1
RUN apt-get update && \
    apt-get install -y -qq \
    freeglut3-dev \
    libegl1 \
    libgl1 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libglvnd0 \
    libglx0 \
    libjpeg62 \
    libnuma-dev \
    libx11-6 \
    # python-imaging \
    #  libXext provides an X Window System client interface
    libxext6 \
    # LXTask is a GUI application for LXDE
    lxtask \
    x11-apps \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

USER ${NB_UID}

# Install Python 3 packages
RUN mamba install --yes \
    'beautifulsoup4' \
    'black' \
    'conda-forge::blas=*=openblas' \
    # lidar is a Python package for delineating the nested hierarchy 
    # of surface depressions in digital elevation models 
    'ipython' \
    'lidar' \
    'matplotlib-base' \
    'numpy' \
    'pandas' \
    'pylint' \
    'pyopengl' \
    'pytables' \
    'scikit-image' \
    'scikit-learn' \
    'selenium' \
    'tensorflow' \
    'widgetsnbextension'\
    'xlrd' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME="/home/${NB_USER}/.cache/"

RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_USER}

# Genereate simpylc examples
# https://pypi.org/project/SimPyLC/
RUN python -m pip install SimPyLC --ignore-installed --no-cache-dir --upgrade && \
    python -m simpylc -s

# Expose Jupyter port
EXPOSE 8888

# Set environment variables.

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

# Enable GUI
# ENV DISPLAY=host.docker.internal:0.0
ENV DISPLAY=:0 \
    DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=768

# print to stdout without buffering
ENV PYTHONUNBUFFERED=1 

# don't generate *.pyc files
ENV PYTHONDONTWRITEBYTECODE=1