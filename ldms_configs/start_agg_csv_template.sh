#!/bin/bash -l

source /home/docker/env.sh

USER=$(whoami)
cat /opt/ldms_wheeler/aggregator_csv.conf | sed "s/<USERNAME>/${USER}/" > /tmp/agg_${USER}.conf;
cat /tmp/agg_${USER}.conf | sed "s/<LDMS_PORT>/${LDMS_PORT}/" > tmp_agg; cat tmp_agg > /tmp/agg_${USER}.conf; rm tmp_agg;
export LDMS_AUTH_FILE=/opt/ldms_wheeler/ldmsauth.conf;
ldmsd -a ovis -v INFO -m 10M -A conf=${LDMS_AUTH_FILE} -x sock:${LDMS_PORT} -l ${LOG_OUTPUT_DIR}/aggd_csv_${USER}.log -s ${LOG_OUTPUT_DIR}/aggd_csv_${USER}.sock -r ${LOG_OUTPUT_DIR}/aggd_csv_${USER}.pid -c /tmp/agg_${USER}.conf;
