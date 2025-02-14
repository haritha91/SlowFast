FROM nvidia/cuda:11.1.1-base-ubuntu20.04

# Remove any third-party apt sources to avoid issues with expiring keys.
RUN rm -f /etc/apt/sources.list.d/*.list

# Setup timezone (for tzdata dependency install)
# Based on a few posts: https://stackoverflow.com/a/44333806, https://askubuntu.com/a/1013396
ENV TZ=Australia/Melbourne
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime

# Install some basic utilities and dependencies.
# * For OpenCV: libgl1 libsm6 libxext6 libglib2.0-0
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    libgl1 libsm6 libxext6 libglib2.0-0 \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory.
RUN mkdir /app
WORKDIR /app

# Create a non-root user and switch to it.
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /app
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory.
ENV HOME=/home/user
RUN chmod 777 /home/user

# Create data directory
RUN sudo mkdir /app/data && sudo chown user:user /app/data

# Create results directory
RUN sudo mkdir /app/results && sudo chown user:user /app/results


# Install Mambaforge and Python 3.8.
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/mambaforge/bin:$PATH
RUN curl -sLo ~/mambaforge.sh https://github.com/conda-forge/miniforge/releases/download/4.9.2-7/Mambaforge-4.9.2-7-Linux-x86_64.sh \
 && chmod +x ~/mambaforge.sh \
 && ~/mambaforge.sh -b -p ~/mambaforge \
 && rm ~/mambaforge.sh \
 && mamba clean -ya

# Install project requirements.
COPY --chown=user:user environment.yml /app/environment.yml
RUN mamba env update -n base -f environment.yml \
 && mamba clean -ya

# Install SlowFast project.
COPY --chown=user:user . /app
RUN python setup.py build develop --no-deps

#set data & results accessible
RUN chmod -R -f 777 /app/results
RUN chmod -R -f 777 /app/data

# # Set the default command to python3.
# CMD ["python3"]
