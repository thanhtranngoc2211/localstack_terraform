import boto3

# Specify your AWS credentials (replace with your own values)
# aws_access_key_id = 'YOUR_ACCESS_KEY'
# aws_secret_access_key = 'YOUR_SECRET_KEY'
# region_name = 'us-east-1'  # Specify your desired AWS region

# Create an EC2 client
ec2 = boto3.client('ec2')

# aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key, region_name=region_name

# Specify the parameters for the new EC2 instance
instance_params = {
    'ImageId': 'ami-000a4d9c6067d5d0d',  # Specify a suitable AMI for your region
    'InstanceType': 't2.micro',
    # 'KeyName': 'YOUR_KEY_PAIR_NAME',  # Specify the key pair name
    'MinCount': 1,
    'MaxCount': 1,
}
def lambda_handler(event, context) {
    # Launch the EC2 instance
    response = ec2.run_instances(**instance_params)

    # Extract the instance ID from the response
    instance_id = response['Instances'][0]['InstanceId']

    # Wait for the instance to be in the 'running' state
    ec2.get_waiter('instance_running').wait(InstanceIds=[instance_id])

    print(f"EC2 instance {instance_id} created successfully.")

}
