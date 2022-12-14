# EPAM Homework: AWS

[AWS task](TaskAWS_updated_links.pdf)

## Task

- [EC2](#ec2)
- [EBS](#ebs)
- [Lightsail](#lightsail)
- [S3](#s3)
- [ECS](#ecs)
- [Lambda](#lambda)
- [Static Website](#static_website)


## EC2 <a name="ec2"></a>

### Launch EC2 instance

Configuration process of launching __ec2 instance__ is pretty straight forward so I'll attach screenshot of launched instance. Basicly we nned to be sure that after launch instance is in __running__ state and all __status checks__ have passed.

![EC2 launch](screenshots/ec2_launch.png)

Snapshot of a running instance.

![Snapshot of intance](screenshots/ec2_snapshot.png)

### Connect to EC2 instance

In this step I use created earlier key pair to connect to instance via __ssh__. We need to be sure __Security Group__ does accept __ssh__ connection.

![EC2 connect](screenshots/ec2_connect.png)

### Terminate EC2 instance

![EC2 terminate](screenshots/ec2_terminate.png)

## EBS <a name="ebs"></a>

Created new volume Disk_D

![Disk_D](screenshots/ebs_create.png)

Attach Disk_D volume to running EC2 instance Web Server.

![Disk_D attach](screenshots/ebs_attach1.png)

![Disk_D attach success](screenshots/ebs_attach2.png)

After we attached new volume Disk_D to EC2 instance, we need to create a file system on this volume and mount it to the directory.

![Disk_D create FS 1](screenshots/diskd_mount1.png)

![Disk_D create FS 2](screenshots/diskd_mount2.png)

Now we can create some data that we need to store on volume Disk_D.

![Disk_D create data](screenshots/diskd_data.png)

To launch new instance from EBS volume snapshot we need to create image from snapshot.

![Web Server AMI 1](screenshots/ec2_ami1.png)

![Web Server AMI 2](screenshots/ec2_ami2.png)

Using this AMI we can launch our instance.

![Web Server snapshot launch](screenshots/ec2_snapshot_launch.png)

Now we can detach Disk_D volume from Web Server and attach it to Web Server 2 and mount it to diskd directory.

> To check if the EBS volume has mounted proparly I use ```lsblk -f``` to see if the volume has the desired mountpoint.

![Web Server 2 mount Disk_D](screenshots/diskd_mount3.png)

## Lightsail <a name="lightsail"></a>

![Lightsail launch instance](screenshots/lightsail1.png)

![Lightsail Wordpress web page](screenshots/lightsail2.png)

## S3 <a name="s3"></a>

### Management Console

First we need to create S3 bucket where objects will be stored.

![S3 create bucket](screenshots/s3_console1.png)

After we created S3 bucket we can upload objects.

![S3 upload image](screenshots/s3_console2.png)

To retrieve objects we need to choose desired and download it.

![S3 download image](screenshots/s3_console3.png)

### AWS CLI

After installing __AWS CLI__ on my local machine I configured AWS credentials with ```aws configure``` with access and secret key that I generated earlier for my IAM user.

![IAM user](screenshots/s3_cli1.png)

Create bucket

![AWS CLI create bucket](screenshots/s3_cli2.png)

Upload files

![AWS CLI upload files](screenshots/s3_cli3.png)

Download files

![AWS CLI download files](screenshots/s3_cli4.png)

Delete files

![AWS CLI delete files](screenshots/s3_cli5.png)

## ECS <a name="ecs"></a>

Successful ECS cluster created.

![ECS create cluster](screenshots/ecs1.png)

Go to web page via Load balanser DNS name.

![Target group](screenshots/ecs2.png)

![Load balanser](screenshots/ecs3.png)

![ECS web page](screenshots/ecs4.png)

## Lambda <a name="lambda"></a>

Created a Lambda function

![Lambda create function](screenshots/lambda1.png)

Created event

![Lambda create event](screenshots/lambda2.png)

Run function

![Lambda run function](screenshots/lambda3.png)


## Static website <a name="static_website"></a>

### [maxmlvk.cloud](https://maxmlvk.cloud)

Domain name I registered via [GoDaddy](https://www.godaddy.com).

### S3

![S3 buckets](screenshots/static_website1.png)

### ACM

![Certificate](screenshots/static_website2.png)

### Cloudfront

![Cloudfront distributions](screenshots/static_website3.png)

### Route53 Hosted Zone

![Route53 hosted zone](screenshots/static_website4.png)

 
