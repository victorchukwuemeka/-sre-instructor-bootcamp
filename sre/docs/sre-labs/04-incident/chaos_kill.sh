#!/usr/bin/env bash
sleep 300 &
PID=$!
echo "Started dummy process PID=$PID"
kill -9 "$PID"
echo "Killed PID=$PID"
