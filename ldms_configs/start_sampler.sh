#!/bin/bash -l
echo $(hostname) RUNNING: start_sampler.sh

source /home/docker/env.sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib/ovis-lib:/usr/local/lib/ovis-ldms
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
export PATH=$PATH:/usr/local/bin:/usr/local/sbin
export INCLUDE=$INCLUDE:/usr/local/include
export SHARE=$SHARE:/usr/local/share
export MANPATH=$MANPATH:/usr/local/share/man
export ZAP_LIBPATH=/usr/local/lib:/usr/local/lib/ovis-lib

export LDMS_AUTH_FILE=/opt/ldms_wheeler/ldmsauth.conf

sed "s/<hostname>/$(cat /etc/hostname)/g" < /opt/ldms_wheeler/sampler_template.conf > /dev/shm/sampler.conf

ldmsd -a ovis -A conf=${LDMS_AUTH_FILE} -m 10MB -x sock:10002 -l ${LOG_OUTPUT_DIR}/$(hostname)_sampled_$(whoami).log -s ${LOG_OUTPUT_DIR}/$(hostname)_sampled_$(whoami).sock -r ${LOG_OUTPUT_DIR}/$(hostname)_sampled_$(whoami).pid -c /dev/shm/sampler.conf -v DEBUG

echo ENDING: start_sampler.sh
