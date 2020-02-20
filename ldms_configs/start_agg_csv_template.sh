#!/bin/bash -l

USER=$(whoami)
cat /opt/ldms_wheeler/aggregator_csv.conf | sed "s/<USERNAME>/${USER}/" > /dev/shm/agg_${USER}.conf;
export LDMS_AUTH_FILE=/opt/ldms_wheeler/ldmsauth.conf;
ldmsd -a ovis -v INFO -m 10M -A conf=${LDMS_AUTH_FILE} -x sock:10002 -l ${LOG_OUTPUT_DIR}/aggd_csv_${USER}.log -s ${LOG_OUTPUT_DIR}/aggd_csv_${USER}.sock -r ${LOG_OUTPUT_DIR}/aggd_csv_${USER}.pid -c /dev/shm/agg_${USER}.conf;
