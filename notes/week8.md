# Week 8 - EC2 + Auto Scaling + Load Balancing

## Monday - 26.6.2026

**Topic:** EC2 instance types and families

### What I learned
- We have 4 instances types: general purpose, compute optimized, memory optimized, storage optimized
- General purpose is balance between cpu, ram and network. 
- Compute optimized is for CPU-heavy applications, like video encoding, machine learning training, all that has big numbers, heavy
- Memory optimized is for memory-heavy applications, store a lot of data in RAM, databases, Redis or Memcached(cache, in-memory), fast reading big data
- Storage optimized is for application that constantly reads and write big data from disk, data warehousing, log processing,...
- Families: t and m are for general purpose, c is for compute optimized, r is for memory optimize and i is for storage optimized
- T is cheaper then M, t has burst concept, in normal work takes a little cpu but collect credits, when you need more cpu he takes that credits, m instance give you constantly cpu without that system
- On-demand instances are on demand, run when you want, pay by hour
### Commands
- None, console-based task

# Tuesday - 27.6.2026

**Topic:** AMI + User data script

### What I learned
- AMI is snapshot for full instance(template), have OS, software and configuration. From that snapshot you run how you want instances, good for scaling
- Good when client has a lot instances and when you have auto scaling group, aws add new instances from AMI, thats how he know what OS example to install or software and how to configure, ami is source for auto scaling, without them aws dont know what instances to run
- You can copy AMI across regions, reason is disaster recovery(if one region fails, you have copy of ami in another region and can run instance instantly), high availability and global application if client wants
- User data script is bash script that is executing just first time when instance run
- We use that script for automatic installation software and configuration of instance without manual ssh
- AMI give you base and user data script add whats needed, example you dont make custom ami with software and configuration just amazon Linux ami
- Good for auto scaling, one script for a lot instances configurations
- AMI and user data script we can combine(custom ami), to create example ami with os and software and with data script do configuration, but better is to create custom ami with all that

## Wednesday - 27.6.2026

**Topic:** EBS volume

### What I learned
- EBS volume is persistent storage(disk) for EC2 instance, linked to AZ. 
- On laptop we have difference between disk and SSD, HDD is slower then SSD, SSD is slower then NVMe SSD and they costs different, same is with EBS, different applications need different performances and prices, not just size. Database on example need fast disk, archive doesn't
- gp3 disk is new and cheaper then gp2 and performances for gp3 are fixed, not matter on size, has limit on IOPS(16000 IOPS)
- gp2 has problem, performances are linked to disk size, small disk= small iops, you need more iops must make bigger disk
- io1/io2 give you provisioned iops - you say how much iops you want , aws guarantee you that number. gp3 has max 16000 iops, io2 go to 64000+
- gp2/gp3 and io1/io2 are SSD
- st1 and sc1 are HDD, we use them when doesn't matter how fast our disk is and thats cheaper option
- st1 is for throughput intensive workload - big data, log processing. sc1 is more cheaper, for cold data is - archive, backup
- EBS snapshot is snapshot(copy) from disk, we create snapshot to move disk to different AZ or region maybe, and good for backup
- If wanna create disk in another AZ we make snapshot select disk create for snapshot and then choose AZ
- If wanna create disk in another region we first move snapshot to another region and there we make disk
- AWS is intern storing snapshot in S3, we dont see that on console directly
- By deleting we have snapshot archive to store and recycle bin retention rule(create before delete)
- By EBS volume encryption we encrypt data that are at rest(stay) and data in transit, moving between instances and volumes
- If we make snapshot from encrypted volume that snapshot is automatic encrypted
- If we have snapshot that is not encrypted and wanna encrypt him we do that from copy, when we copy snapshot have option for turn on encryption, copy snapshot that is not encrypted check encryption and we get encrypted snapshot. From that encrypted snapshot we make encrypted volume
- Standard EBS we can attach on one instance, but we have multi-attach and thats for io1/io2 ssd disks, when more instances need to write and read same volume, application must be designed to do that, thats not for every example
- EBS is persistent, instance store is ephemeral hardware disk(lose data when stop or delete instance)
- We use instance store when have example where is speed more important then persistent, if you can lose data and thats not problem
- We choose by attaching on instance device name for EBS, how Linux see him and with that name we will manage him from Linux /dev/xvdf is standard name for added disk
- If we restart instance we lose mount, to permanent mount disk on instance we need to add in /etc/fstab
- For permanent attach we use UUID(disk identificatory) because device name can change by restart, UUID never, he is same every time
- To permanent add in fstab we open fstab with nano and then write line UUID=00443087-ccde-45b2-b6f9-6c53beccc8db  /mnt/ebs-lab(where is mounted)  ext4(filesystem format)  defaults(standard options of mounting)  0(dump, always 0)   0(by boot means do not check)


### Commands
- lsblk - to see all disks
- sudo file -s disk_path - to see does disk has filesystem
- sudo mkfs -t ext4 disk_path - to create filesystem
- sudo mount - to mount disk on directory that you created
- sudo tee - reads with stdin and writes on screen in same time
- sudo blkid disk_path - to see UUID(identifier) of disk
- sudo mount -a - to check fstab

## Thursday - 27.6.2026

**Topic:** Auto Scaling

### What I learned
- Auto scaling group scaling instances, you set desired capacity, minimum and maximum by adding or removing instances
- ASG scales by launch template, you define there AMI, instance type, VPC, everything for ASG to know by scaling
- Scale base on CPU and RAM metrics, follows it with cloudwatch service
- We have some scaling policies: Simple(When cpu is x% add x instances), step(have more scales, more steps), target tracking(follows target, hold it example on cpu 70%), scheduled scaling(in x time add x instances) and predictive scaling(scale based on earlier reports)
- For client we dont have some basic scaling policies, need to see situation, follow and then take action
- ASG is automatic take instances in few az for high availability
- ASG doing health checks, tests does instance is alive, does have cpu, ram, is hardware alive
-
### Commands
- None, console-based task

## Friday - 30.6.2026

**Topic:** Load Balancer

### What I learned
- Load Balancer manage with traffic balance, send traffic to instances
- Load balancer is frontend layer, receive traffic from internet, ASG is backend, communicate with ALB, private
- We have Application load balancer, network load balancer and gateway load balancer
- Application load balancer see context of traffic, network load balancer follows ip and port, where traffic is going by connection
- NLB we use when need some fast and hard requests, like gaming, real-time things
- Target group is instance or ASG that is linked to load balancer
- Listener listen on port, which port is traffic receiving, listener rules says where to forward traffic by path, that path-base routing, listener receives traffic on some port and then forward it by rules on servers, by path
- Health check send HTTP request on /health path and wait 200 ok response. If doesn't get 200, instance is unhealthy
- We use different endpoint(/health) because central page can be linked to database, cache, extern services. If database fails central page return mistake but application is technicaly alive. /health checks is application solo responsible, not with other things

### Commands
- yum - for install software, package manager for Amazon Linux 
- yum install -y nginx - to install nginx and automatic yes
- systemctl start nginx - to start nginx
- systemctl enable nginx - to enable nginx in future, if restart instance on example

### Saturday - 30.6.2026

**Topic:** LAB: HA web app- ALB + ASG + custom AMI

### Structure desing
1. Create instance
2. SSH on instance
3. Change default nginx page
4. Create AMI from that instance
5. Create launch template for ASG with that AMI
6. Create empty target group for Application load balancer
7. Create Application load balancer with that empty target group
8. Create ASG

### Decisions and reasons
- Created instance first to configure that instance with OS and software
- Did SSH to change index.html page on /usr/share/nginx/html/index.html path, changed h1 in body, default nginx page, because we create everything in this lab by custom AMI
- We used AMI not user data because AMI is better for scaling, when ASG add new instances you cannot write user data for every instance, you can but thats x time taking, AMI is easier, set template with OS and software for every new instance
- Created custom AMI from that instance, our base for other compute things in lab
- Created launch template for ASG with that custom AMI, thats point, ASG need to set up instances by our configuration from AMI
- Empty target group we created because when create ASG we integrate it with that empty tg, because after that tg will register that ASG and instances he scales
- On the end checked ASG and checked tg, our integration was working properly

### Implementation
1. Created instance
2. Did SSH on instance
3. Changed default nginx page
4. Created AMI from that instance
5. Created launch template for ASG with that AMI
6. Create empty target group for Application load balancer
7. Created Application load balancer with that empty target group
8. Created ASG


