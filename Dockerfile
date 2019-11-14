# This Docker image provides LDMS sampling functionality.
# We use LDMS v4.2.3 with OpenMPI sampling capability, and RabbitMQ back end functionality.

# This Dockerfile is based off of https://github.com/UNM-CARC/bsp_prototype/blob/master/Dockerfile.

ARG DOCKER_TAG=carc-wheeler
ARG BASE_IMAGE=unmcarc/docker_base:${DOCKER_TAG}
FROM ${BASE_IMAGE}

# Because we use spack and a cleaned environment, the run commands here
# need to be login shells to get the appropriate spack initialiation.
SHELL ["/bin/bash", "-l", "-c"]

# Required for LDMS rabbitmq+OpenMPI sampler backend build
RUN yum -y install librabbitmq-devel wget 

# Manual LDMS build and install
RUN mkdir /opt/ldms; \
    mkdir /opt/ldms/src; \
    cd /opt/ldms/src/; \
    wget https://github.com/ovis-hpc/ovis/archive/OVIS-4.2.3.zip; \
    unzip OVIS-4.2.3.zip; \
    rm -f OVIS-4.2.3.zip; \
    cd ovis-OVIS-4.2.3/; \
    ./autogen.sh; \
    mkdir build; \
    cd build; \
    ../configure --enable-rabbitkw \
                 --enable-mpi_sampler \
                 --prefix=/usr/local; \
    make -j; \
    make -j install;

# Copy LDMS config and startup scripts to accessible location
RUN mkdir /opt/ldms_wheeler/;
COPY ldms_configs/* /opt/ldms_wheeler/

# Common workdir for all layers of reproducible infrastructure
WORKDIR /home/docker
# Entrypoint and commands script lefted from parent Docker image,
# extended for this image layer.
COPY entrypoint.sh commands.sh ./
RUN chmod +x /home/docker/entrypoint.sh /home/docker/commands.sh

ENTRYPOINT ["/bin/bash", "-l", "/home/docker/entrypoint.sh"]
CMD ["docker-shell"]
