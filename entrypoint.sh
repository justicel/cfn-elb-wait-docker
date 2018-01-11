#!/bin/ash
set -e

instance_id=$(curl --connect-timeout 10 --max-time 10 --retry 3 --retry-delay 0 --retry-max-time 60 -s http://169.254.169.254/latest/meta-data/instance-id)

echo "--Begin waiting for instance to become healthy in ELB"

# Loop until given load-balancer shows as healthy
until [ "$state" == "\"InService\"" ]; do
  state=$(aws --region ${AWS_DEFAULT_REGION} elb describe-instance-health \
    --load-balancer-name ${ELB_NAME} \
    --instances ${instance_id} \
    --query InstanceStates[0].State)
  echo "Waiting for instance ${instance_id} to become healthy"
  sleep 10
done

echo "Marking instance as healthy!"

cfn-signal -e 0 -r "Instance setup finished" \
  --stack $CFN_STACK_NAME \
  --resource $CFN_NOTIFY_RESOURCE \
  --region $AWS_DEFAULT_REGION
