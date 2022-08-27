# Default base image
ARG OWNER=jupyter
ARG ROOT_CONTAINER
ARG BASE_CONTAINER=${ROOT_CONTAINER}

FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# Use custom base image
FROM $BASE_CONTAINER

LABEL MAINTAINER="Jeroen Boogaard <j.a.boogaard@hr.nl>"

# Install python dependencies
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

RUN mkdir ${HOME}/ptpython
COPY config.py ${HOME}/ptpython/
# COPY interactive_startup_file.py ${HOME}/ptpython/
# ENV PYTHONSTARTUP="${HOME}/ptpython/interactive_startup_file.py"

# Copy custom scripts
COPY run_script.sh /usr/local/bin/run_script

USER ${NB_USER}

RUN mkdir -p /home/student/notebooks \
    && mkdir -p /home/${NB_USER}/pics \
    && mkdir -p /home/student/projects \
    && mkdir -p /home/student/scripts

# ptipython

WORKDIR /home/${NB_USER}
