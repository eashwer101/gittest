#!/bin/bash

BUCKETNAME=rsp-logs

# change the prefix name for each module 

PREFIX=ekumar

FIREHOSEROLENAME=FirehosetoS3Role-ekumar

DELIVERYSTREAMNAME=rsp-dh-logs-delivery-stream-ekumar

CLOUDWATCHROLENAME=cloudwatchroleforkinesis

# loggroup name will change


LOGGROUPNAME=/aws/lambda/rsp-dh-api-dispatchhandler
             
FILTERNAME=ekumar




# Create an Amazon Simple Storage Service (Amazon S3) bucket

aws s3api create-bucket --bucket ${BUCKETNAME} --region us-east-1 

# attaching the bucket policy 

aws s3api put-bucket-policy --bucket ${BUCKETNAME} --policy file://bucketpolicy.json


# Create the IAM role that will grant Amazon Kinesis Data Firehose permission to put data into your Amazon S3 bucket

aws iam create-role --role-name ${FIREHOSEROLENAME} --assume-role-policy-document file://~/TrustPolicyForFirehose.json


# Associate the permissions policy with the role using the following put-role-policy command

aws iam put-role-policy --role-name ${FIREHOSEROLENAME} --policy-name Permissions-Policy-For-Firehose --policy-document file://~/PermissionsForFirehose.json


# Create a destination Kinesis Data Firehose delivery stream as follows

# aws firehose create-delivery-stream --delivery-stream-name '${DELIVERYSTREAMNAME}' --s3-destination-configuration RoleARN='arn:aws:iam::134955584916:role/$FIREHOSEROLENAME',BucketARN='arn:aws:s3:::$(BUCKETNAME)',Prefix='$(PREFIX)'


# aws firehose create-delivery-stream --delivery-stream-name 'rsp-dh-logs-delivery-stream' --s3-destination-configuration RoleARN='arn:aws:iam::134955584916:role/FirehosetoS3Role',BucketARN='arn:aws:s3:::rsp-dh-logs',Prefix='test'

aws firehose create-delivery-stream --delivery-stream-name $DELIVERYSTREAMNAME --s3-destination-configuration RoleARN='arn:aws:iam::134955584916:role/'$FIREHOSEROLENAME,BucketARN='arn:aws:s3:::'$BUCKETNAME,Prefix=$PREFIX


# aws firehose create-delivery-stream --delivery-stream-name 'rsp-dh-logs-delivery-stream' --s3-destination-configuration RoleARN='arn:aws:iam::134955584916:role/FirehosetoS3Role',BucketARN='arn:aws:s3:::rsp-dh-logs',Prefix='test'


#  describe-delivery-stream

aws firehose describe-delivery-stream --delivery-stream-name "${DELIVERYSTREAMNAME}"

# Create the IAM role that will grant CloudWatch Logs permission to put data into your Kinesis Data Firehose delivery stream

aws iam create-role --role-name ${CLOUDWATCHROLENAME} --assume-role-policy-document file://~/TrustPolicyForCWL.json

# Create a permissions policy to define what actions CloudWatch Logs can do on your account. First, use a text editor to create a permissions policy file

aws iam put-role-policy --role-name ${CLOUDWATCHROLENAME} --policy-name Permissions-Policy-For-CWL --policy-document file://~/PermissionsForCWL.json








# create the CloudWatch Logs subscription filter. The subscription filter immediately starts the flow of real-time log data from the chosen log group to your Amazon Kinesis Data Firehose delivery stream




aws logs put-subscription-filter --log-group-name "$LOGGROUPNAME" --filter-name "$FILTERNAME" --filter-pattern "" --destination-arn 'arn:aws:firehose:us-east-1:134955584916:deliverystream/'$DELIVERYSTREAMNAME --role-arn 'arn:aws:iam::134955584916:role/'$CLOUDWATCHROLENAME



# CloudWatch Logs will forward all the incoming log events that match the filter pattern to your Amazon Kinesis Data Firehose delivery stream. Your data will start appearing in your Amazon S3 based 







#!/bin/sh
# My first Script
echo "Hello World!"
echo "Test" >> test_file2.txt 
while IFS= read -r line;do
    echo -e "legendary" >> test_file2.txt
    echo "$line" >> test_file2.txt
done < "test_file1.txt"
echo "completed"








