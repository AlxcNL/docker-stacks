# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/base-notebook:latest
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    # Install bpython
    bpython \
    # for cython: https://cython.readthedocs.io/en/latest/src/quickstart/install.html
    build-essential \
    # for latex labels
    cm-super \
    dvipng \
    # for matplotlib anim
    ffmpeg \
    software-properties-common \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# PPA third-party repository for Open Source AMD Radeon Drivers 
RUN add-apt-repository ppa:oibaf/graphics-drivers

# Dependencies for glvnd and X11.
# https://medium.com/@benjamin.botto/opengl-and-cuda-applications-in-docker-af0eece000f1
RUN apt-get update \
&& apt-get install -y -qq --no-install-recommends \
    featherpad \   
    freeglut3-dev \
    libegl1 \
    libgl1 \
    libgl1-mesa-dri \
    libglvnd0 \
    libglx0 \
    libnuma-dev \
    libx11-6 \
    libxext6 \
    lxtask \
    xterm \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

USER ${NB_UID}

# Install Python 3 packages
RUN mamba install --quiet --yes \
    # https://pillow.readthedocs.io
    'beautifulsoup4' \
    'conda-forge::blas=*=openblas' \
    # lidar is a Python package for delineating the nested hierarchy 
    # of surface depressions in digital elevation models 
    'lidar' \
    'matplotlib-base' \
    'numpy' \
    'pandas' \
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

USER ${NB_UID}

RUN python -m pip install simpylc

# Genereate simpylc examples
RUN python -m simpylc -s

WORKDIR "${HOME}"

ENV DISPLAY=host.docker.internal:0.0