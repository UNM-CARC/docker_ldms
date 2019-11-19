#!/bin/bash -l

USER=$(whoami)
cat /wheeler/scratch/qwofford/opt/ovis/4.2.3/configs/aggregator_csv.conf | sed "s/<USERNAME>/${USER}/" > /dev/shm/agg_${USER}.conf;
export LDMS_AUTH_FILE=/opt/ldms_wheeler/ldmsauth.conf;
ldmsd -a ovis -A conf=${LDMS_AUTH_FILE} -x sock:10002 -l aggd_csv_${USER}.log -s aggd_csv_${USER}.sock -r aggd_csv_${USER}.pid -c /dev/shm/agg_${USER}.conf -v DEBUG;
