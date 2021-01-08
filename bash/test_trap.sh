#!/bin/bash

set -e

ARN=$1

function on_error() {
    echo "Error; Manually Configure with  "
    LB_NAME=`echo $ARN | sed -e 's/^.*\/app\/\(.*\)\/.*$/\1/g'`
    LB_ID=`echo $ARN | sed -e 's/^.*\/app\/.*\/\(.*\)$/\1/g'`
    LIST_ID=`echo $LISTENER_ARN | sed -e 's/^.*\/\(.*\)$/\1/g'`
    echo "  https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#ELBRules:type=app;loadBalancerName=$LB_NAME;loadBalancerId=$LB_ID;listenerId=$LIST_ID"
}

trap on_error ERR

./no-file
echo 'after error'
