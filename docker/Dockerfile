#
# Jupyterhub/RStudio setup for BioInfoSummer RNA-Seq workshop 2018
#
##########   IMPORTANT   #############
# To work properly, git clone https://github.com/JasonJWilliamsNY/docker_jupyterhub_config
# use the following command to start the container
# docker run --restart always -p 8000:8000 -p 8787:8787 --cpus="4" --name single-cell -d -v /docker-persistant:/docker-persistant jasonjwilliamsny/single-cell-training:dev4
#
# Based on Ubuntu
FROM ubuntu:bionic-20180710
#
#
# Maintained by
MAINTAINER Jason Williams "williams@cshl.edu"
#
#
# Install some required tools
RUN apt update -y
RUN apt upgrade -y
RUN apt-get update
RUN apt-get install -y\
 apt-utils\
 dialog\
 software-properties-common\
 build-essential gcc\
 libssl1.0-dev \
 openssl\
 npm nodejs\
 nodejs\
 wget\
 unzip\
 zip\
 git\
 bzip2\
 tmux
#
#
#
# Get back some Ubuntu goodies that make this more suited for teaching Linux/bash
RUN apt-get update && apt-get upgrade -y && (echo y | DEBIAN_FRONTEND=noninteractive sh -x /usr/local/sbin/unminimize)
#
#
# Install python related tools and packages
RUN apt-get install -y --fix-missing \
 python3.6 \
 python3-pip \
 python3-venv \
 libglib2.0-0 \
 libxext6 \
 libsm6 \
 libxrender1
#
#
# Install and configure required npm stuff
RUN npm config set registry="http://registry.npmjs.org/"
RUN npm install -g configurable-http-proxy
#
#
# Use python to install hub and related hub items and nice packages
RUN python3 -m pip install\
 notebook\
 ipykernel \
 jupyterhub\
 sudospawner\
 numpy\
 scipy\
 matplotlib\
 pandas\
 biopython\
 'plotnine[all]'\
 jupyter_contrib_nbextensions\
 jupyter_nbextensions_configurator\
 ipywidgets\
 bash_kernel
#
#
# Activate and configure python/hub addins
RUN jupyter contrib nbextension install --system
RUN jupyter nbextensions_configurator enable --system
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN python3 -m bash_kernel.install
RUN python3 -m ipykernel.kernelspec
#
#
# Use python to install sciency packages for single-cell analysis
RUN apt-get update &&\
  python3 -m pip install\
  magic-impute\
  sklearn\
  phate\
  umi-tools
#
#
# Install iCommands
RUN wget -qO - https://packages.irods.org/irods-signing-key.asc | apt-key add - \
    && apt-get install -y lsb gnupg apt-transport-https python-requests curl

RUN echo "deb [arch=amd64] https://packages.irods.org/apt/ xenial main" | sudo tee /etc/apt/sources.list.d/renci-irods.list\
    && apt-get update \
    && apt-get install -y irods-icommands \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/*
#
#
# Install Conda
RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh -O Anaconda3-5.3.1-Linux-x86_64.sh && \
    /bin/bash Anaconda3-5.3.1-Linux-x86_64.sh -b -p /opt/conda && \
    rm Anaconda3-5.3.1-Linux-x86_64.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
#
#
# Configure conda
RUN /opt/conda/bin/conda config --add channels defaults
RUN /opt/conda/bin/conda config --add channels bioconda
RUN /opt/conda/bin/conda config --add channels conda-forge
#
#
# Install bioconda packages
RUN /opt/conda/bin/conda install -y -q kallisto=0.45.0
RUN /opt/conda/bin/conda install -y -q fastp=0.19.3
RUN /opt/conda/bin/conda install -y -q fastqc=0.11.8
#
#
# Install R and packages
RUN  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
    && sh -c 'echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" >> /etc/apt/sources.list'

RUN apt-get update \
    && apt-get upgrade -y -q \
    && apt-get install -y --no-install-recommends \
           libapparmor1 \
           r-recommended \
           r-base \
           r-base-dev \
           littler \
           r-cran-littler \
           libxml2-dev \
           libxt-dev \
           libssl-dev \
           libcurl4-openssl-dev \
           imagemagick \
	         build-essential \
           libfreetype6-dev \
           libzmq3-dev \
           pkg-config \
           htop\
           libhdf5-dev

RUN R -e "install.packages('devtools')"
RUN R -e "install.packages('BiocManager')"
RUN R -e "install.packages('XML')"
RUN R -e "install.packages('tidyverse')"
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('cowplot')"
RUN R -e "install.packages('knitr')"
RUN R -e "install.packages('rmarkdown')"
RUN R -e "install.packages('packrat')"
RUN R -e "install.packages('onlinePCA')"
RUN R -e "install.packages('RcppArmadillo')"
RUN R -e "BiocManager::install('rhdf5', version = '3.8')"
RUN R -e "devtools::install_github('pachterlab/sleuth')"
RUN R -e "BiocManager::install('simpleSingleCell', version = '3.8')"
RUN R -e "BiocManager::install('scran', version = '3.8')"
RUN R -e "BiocManager::install('biomaRt', version = '3.8')"
RUN R -e "BiocManager::install('monocle', version = '3.8')"
RUN R -e "devtools::install_github(repo = 'hhoeflin/hdf5r')"
RUN R -e "devtools::install_github(repo = 'mojaveazure/loomR', ref = 'develop')"
RUN R -e "devtools::install_github(repo = 'satijalab/seurat', ref = 'loom')"
RUN R -e "devtools::install_github('nteetor/zeallot')"
#
#
# install virtualenv
RUN python3 -m pip install virtualenv
#
#
# Install RStudio Server
ADD https://s3.amazonaws.com/rstudio-server/current.ver /tmp/ver
ENV CRAN_URL https://cloud.r-project.org/

RUN apt-get update \
    && apt-get upgrade -y -q \
    && apt-get install -y --no-install-recommends \
           gdebi

RUN set -e \
    && ln -s /dev/stdout /var/log/syslog \
    && curl -S -o /tmp/rstudio.deb \
       http://download2.rstudio.org/rstudio-server-$(cat /tmp/ver)-amd64.deb \
    && gdebi -n /tmp/rstudio.deb \
    && rm -rf /tmp/rstudio.deb /tmp/ver
#
#
# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
#
#
# Get and compile bustools
RUN apt-get install -y --no-install-recommends \
    cmake-curses-gui
RUN git clone https://github.com/BUStools/bustools.git \
    && cd bustools/src \
    && cmake . \
    && make \
    && mv bustools /bin \
    && chmod +x /bin/bustools
#
#
# Link conda executables to bin and attempt to fix any missing libraries
RUN ln -s /opt/conda/pkgs/*/bin/* /bin; exit 0
RUN ln -s /opt/conda/pkgs/*/lib/* /usr/lib; exit 0
#
#
# Expose port 8000, 8787
EXPOSE 8000
EXPOSE 8787
#
# Start the container - will create users in username.txt if they do
# not already exist and start the hub.
CMD ["docker-persistant/initiate.sh"]
