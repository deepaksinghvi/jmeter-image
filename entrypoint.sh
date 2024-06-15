#!/bin/bash
entrypoint_params=$1
printf "==>[entrypoint.sh] %s\n" "entry_point_param is $entrypoint_params"

curl $entrypoint_params > script.jmx

jmeter -n -t ./script.jmx -l ./csvreport/reports.csv  -e -o ./htmlreport

echo "reports.csv generated in csvreport"
ls -lrt ./csvreport

echo "html report generated in htmlreport"
ls -lrt ./htmlreport

echo "Execution Completed"