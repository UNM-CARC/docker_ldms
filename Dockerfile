# This Docker image provides LDMS sampling functionality.
# We use LDMS v4.2.3 with OpenMPI sampling capability, and RabbitMQ back end functionality.

# This Dockerfile is based off of https://github.com/UNM-CARC/bsp_prototype/blob/master/Dockerfile.

ARG DOCKER_TAG=carc-wheeler
ARG BASE_IMAGE=unmcarc/docker_base:${DOCKER_TAG}
FROM ${BASE_IMAGE} as carc-wheeler_base

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
COPY ldms_configs/aggregator_csv.conf /opt/ldms_wheeler/
COPY ldms_configs/ldmsauth.conf /opt/ldms_wheeler/
COPY ldms_configs/sampler_template.conf /opt/ldms_wheeler/
COPY ldms_configs/start_agg_csv_template.sh /opt/ldms_wheeler/
COPY ldms_configs/start_sampler.sh /opt/ldms_wheeler/

ENTRYPOINT ["/bin/bash", "-l", "/home/docker/entrypoint.sh"]
CMD ["docker-shell"]
