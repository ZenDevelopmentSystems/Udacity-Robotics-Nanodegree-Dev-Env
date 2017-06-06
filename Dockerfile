FROM centos:7
MAINTAINER  <yfe@protonmail.com>

RUN yum update -y
RUN yum upgrade -y

RUN yum install -y wget bzip2 make gcc* git

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV NB_USER unicorn
ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LD_LIBRARY_PATH=/usr/lib:$LD_LIBRARY_PATH

# Create unicorn user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
        chown $NB_USER $CONDA_DIR


USER unicorn
RUN mkdir /home/unicorn/work 

# Install conda as unicorn
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    # Install conda as unicorn
     cd /tmp && \
        mkdir -p $CONDA_DIR && \
	wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh \
	-O installer.sh && \
	/bin/bash installer.sh -f -b -p $CONDA_DIR && \
	rm installer.sh 



WORKDIR /home/unicorn/work


RUN git clone https://github.com/udacity/Robond-Python-StarterKit.git
RUN echo "PATH=$PATH:$CONDA_DIR/bin" >> ~/.bashrc
RUN source ~/.bashrc
RUN conda install nbformat
RUN cd Robond-Python-StarterKit  && conda env create -f environment.yml && conda clean -tp
#RUN cd ../ && rm -f installer.sh

