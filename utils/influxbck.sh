#!/bin/bash

INFLUXDB_ID=`docker ps |grep influxdb|awk '{print $1}'`
INFLUXDB_CONTAINER_DIR=`docker inspect -f "{{ .Volumes }}" ${INFLUXDB_ID}|cut -d '[' -f 2|awk -F ':' '{print $1}'`
DATA_FILE_DIR=`docker inspect -f "{{ .Volumes }}" ${INFLUXDB_ID}|cut -d '[' -f 2|awk -F ':' '{print $2}'|sed 's/\]//g'`
INFLUXDB_CONFIG_FILE=`docker inspect -f "{{.Config.Cmd}}" ${INFLUXDB_ID}|cut -d= -f 2|sed 's/\]\}//g'`
BACKUP_FILE=$2

function check_backup_file {
  if [ -z "$BACKUP_FILE" ]; then
    echo "ERR: Please specify backup file..."
    exit 1
  fi
}
function check_influxdb_id {
  if [ -z "$INFLUXDB_ID" ]; then
    echo "ERR: No docker container found..."
    exit 1
  fi
}
function backup {
  docker exec $1 influxd backup $INFLUXDB_CONTAINER_DIR/$2
  # DEBUG echo "docker exec $1 influxd backup $INFLUXDB_CONTAINER_DIR/$2"
  echo "backup dropped in $DATA_FILE_DIR"
}
function restore {
  if [ -f $DATA_FILE_DIR/$2 ]
  then
    docker exec $1 influxd restore -config $INFLUXDB_CONFIG_FILE $INFLUXDB_CONTAINER_DIR/$2
    # DEBUG echo "docker exec $1 influxd restore -config $INFLUXDB_CONFIG_FILE $INFLUXDB_CONTAINER_DIR/$2"
  else
    echo "ERR: Backup file NOT found, please copy $2 to $DATA_FILE_DIR"
  fi
}

case "$1" in
  backup)
    echo "Backup started..."
    check_backup_file
    check_influxdb_id
    backup $INFLUXDB_ID $BACKUP_FILE
	;;
  restore)
    echo "Restore started..."
    check_backup_file
    check_influxdb_id
    restore $INFLUXDB_ID $BACKUP_FILE
	;;
  *)
	echo "Usage: $0 {backup|restore} BACKUPFILE"
	exit 1
  ;;
esac

exit 0
