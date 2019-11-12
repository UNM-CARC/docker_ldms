#!/bin/bash -l
export MODULEPATH=/wheeler/scratch/qwofford/modulefiles
module load ovis/4.2.3

USER=$(whoami)
cat /wheeler/scratch/qwofford/opt/ovis/4.2.3/configs/aggregator_csv.conf | sed "s/<USERNAME>/${USER}/" > /dev/shm/agg_${USER}.conf
cp /wheeler/scratch/qwofford/opt/ovis/4.2.3/configs/ldmsauth_group_readable.conf /wheeler/scratch/${USER}/ldmsauth.conf
chmod go-r /wheeler/scratch/${USER}/ldmsauth.conf
LDMS_AUTH_FILE=/wheeler/scratch/${USER}/ldmsauth.conf
ldmsd -a ovis -A conf=${LDMS_AUTH_FILE} -x sock:10002 -l aggd_csv_${USER}.log -s aggd_csv_${USER}.sock -r aggd_csv_${USER}.pid -c /dev/shm/agg_${USER}.conf -v DEBUG
