#!/usr/bin/env bash

#Mount Adls gen2
mount_adls_gen2() {

   abfs_uri="${1}"

   mount_point="{$2}"

   mkdir -p ${mount_point}

   /usr/bin/hadoop-fuse-dfs ${abfs_uri} ${mount_point}

}

mount_adls_gen2 ${ABFS_URI} ${AIRFLOW_HOME}

case "$1" in
  webserver)
    airflow initdb
    exec airflow webserver
    ;;
  worker|scheduler)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow "$@"
    ;;
  flower)
    sleep 10
    exec airflow "$@"
    ;;
  version)
    exec airflow "$@"
    ;;
  *)
    # The command is something like bash, not an airflow subcommand. Just run it in the right environment.
    exec "$@"
    ;;
esac