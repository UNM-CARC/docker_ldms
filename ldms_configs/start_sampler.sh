#!/bin/bash -l
echo RUNNING: start_sampler.sh

echo Lets check permissions
ls -altr /opt/ldms_wheeler/ldmsauth.conf
echo Done checking permissions

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/usr/local/lib/ovis-lib:/usr/local/lib/ovis-ldms
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
export PATH=$PATH:/usr/local/bin:/usr/local/sbin
export INCLUDE=$INCLUDE:/usr/local/include
export SHARE=$SHARE:/usr/local/share
export MANPATH=$MANPATH:/usr/local/share/man
export ZAP_LIBPATH=/usr/local/lib:/usr/local/lib/ovis-lib

export LDMS_AUTH_FILE=/opt/ldms_wheeler/ldmsauth.conf

sed "s/<hostname>/$(hostname)/g" < /opt/ldms_wheeler/sampler_template.conf > /dev/shm/sampler.conf

ldmsd -a ovis -A conf=${LDMS_AUTH_FILE} -m 1MB -x sock:10002 -l sampled_$(whoami).log -s sampled_$(whoami).sock -r sampled_$(whoami).pid -c /dev/shm/sampler.conf -v DEBUG

echo ENDING: start_sampler.sh
