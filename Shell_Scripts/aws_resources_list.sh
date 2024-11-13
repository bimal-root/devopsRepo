#!/bin/bash

#############################################################################

# Author: Bimal Sharma
# Version: v0.0.1
# Script to automate the process of listing all AWS Resources in AWS account
# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. SNS
# 12. SQS
# 13. DynamoDB
# 14. VPC
# 15. EBS

# This script will prompt for 2 arguments AWS Region and AWS Service
# usage: ./aws_resources_list.sh <aws_region> <aws_service>
# example: ./aws_resource_list.sh us-east-1 ec2

# Pre-requisites:
# 1. Install AWS CLI on system
# 2. Configure IAM User Secret and Access keys using aws configure command

# Note: we could have used curl to authenticate and connect to AWS API, 
# but best approach is to use it through AWS CLI

#############################################################################

# Validate the number of arguments passed is correct
if [ $# -ne 2 ]; then
echo "number of arguments passed are incorrect... follow below "
echo "usage: ./aws_resource_list.sh <aws_region> <aws_service>"
echo "example: ./aws_resource_list.sh us-east-2 s3"
exit 1
fi

# validate if AWS CLI is installed
if [ ! command -v aws &> dev/null] ; then
echo "Install AWS CLI first"
exit 1
fi

# validate if AWS CLI is configured
if [ ! -d ~/.aws ]; then
echo "AWS CLI is not configure. Please configure AWS CLI first"
exit 1
fi

# assigning variables
aws_region=$1
aws_service=$2
aws_service=$(echo "$2" | tr '[:upper:]' '[:lower:]')

# List all AWS resources based on service provided
case $aws_service in
ec2)
    echo "Listing all ec2 instances under $aws_region"
    aws ec2 describe-instances --region $aws_region
    ;;
rds)
    echo "Listing all rds instances under $aws_region"
    aws rds describe-db-instances --region $aws_region
    ;;
s3)
    echo "Listing S3 Buckets in $aws_region"
    aws s3api list-buckets --region $aws_region
    ;;
cloudfront)
    echo "Listing CloudFront Distributions in $aws_region"
    aws cloudfront list-distributions --region $aws_region
    ;;
vpc)
    echo "Listing VPCs in $aws_region"
    aws ec2 describe-vpcs --region $aws_region
    ;;
iam)
    echo "Listing IAM Users in $aws_region"
    aws iam list-users --region $aws_region
    ;;
route5)
    echo "Listing Route53 Hosted Zones in $aws_region"
    aws route53 list-hosted-zones --region $aws_region
    ;;
cloudwatch)
    echo "Listing CloudWatch Alarms in $aws_region"
    aws cloudwatch describe-alarms --region $aws_region
    ;;
cloudformation)
    echo "Listing CloudFormation Stacks in $aws_region"
    aws cloudformation describe-stacks --region $aws_region
    ;;
lambda)
    echo "Listing Lambda Functions in $aws_region"
    aws lambda list-functions --region $aws_region
    ;;
sns)
    echo "Listing SNS Topics in $aws_region"
    aws sns list-topics --region $aws_region
    ;;
sqs)
    echo "Listing SQS Queues in $aws_region"
    aws sqs list-queues --region $aws_region
    ;;
dynamodb)
    echo "Listing DynamoDB Tables in $aws_region"
    aws dynamodb list-tables --region $aws_region
    ;;
ebs)
    echo "Listing EBS Volumes in $aws_region"
    aws ec2 describe-volumes --region $aws_region
    ;;
*)
    echo "Invalid service provided. Please enter valid AWS service"
    exit 1
    ;;
esac

