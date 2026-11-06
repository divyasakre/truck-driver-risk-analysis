#!/usr/bin/env bash
# Step 1 - copy the raw CSVs from the local file system into HDFS
# Environment: Cloudera CDH 5.4 training VM (Hadoop, Hive, Pig 0.12)
set -e
HDFS_DIR=/user/cloudera/riskfactor

hdfs dfs -mkdir -p $HDFS_DIR
hdfs dfs -put data/geolocation.csv $HDFS_DIR/
hdfs dfs -put data/trucks.csv      $HDFS_DIR/
hdfs dfs -put data/trucks_mg.csv   $HDFS_DIR/
hdfs dfs -ls $HDFS_DIR
