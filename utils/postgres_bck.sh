#!/bin/bash

POSTGRES_ID=`docker ps |grep postgres|awk '{print $1}'`
BACKUP_FILE=$2


function check_backup_file {
  if [ -z "$BACKUP_FILE" ]; then
    echo "ERR: Please specify backup file..."
    exit 1
  fi
}
function check_postgres_id {
  if [ -z "$POSTGRES_ID" ]; then
    echo "ERR: No docker container found..."
    exit 1
  fi
}
function backup {
  docker exec -u postgres $POSTGRES_ID pg_dump -c > $2
}
function restore {
    cat $BACKUP_FILE | docker exec -i $POSTGRES_ID psql -Upostgres
    if [ $? ]; then
      echo "Restore finished..."
    else
      echo "ERR: Restore failed..."
    fi
}
case "$1" in
  backup)
    echo "Backup started..."
    check_backup_file
    check_postgres_id
    backup $POSTGRES_ID $BACKUP_FILE
  ;;
  restore)
    echo "Restore started..."
    check_backup_file
    check_postgres_id
    restore $POSTGRES_ID $BACKUP_FILE
  ;;
  *)
  echo "Usage: $0 {backup|restore} BACKUPFILE"
  exit 1
  ;;
esac

exit 0