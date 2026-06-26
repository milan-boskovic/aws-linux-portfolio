# Week 7 - VPC Advanced

## Monday - 23.6.2026

**Topic:** VPC Endpoints

### What I learned
- VPC endpoints allow you to use AWS resources privately, without access to internet.
- One big important thing is security here, because we never go to the internet when use endpoint, all is private
- Second thing is that cost, NAT gateway(because private subnet go to the internet by NAT gateway, connect to NAT and then NAT connect to IGW and by internet access to service) charge you by GB, if you every day download files from S3 through NAT gateway, you can make big bill. VPC endpoint for S3 is free
- For cost optimization audit this is one of the first things, where client pays by usin S3 through NAT gateway, you add for that endpoint and saves them money
- We have Gateway endpoint, thats for DynamoDB and S3, free, just add in route table
- Second is Interface endpoint, for all other AWS services, we pay by hour, create ENI(elastic network interface) in subnet
- Elastic Network Interface is virtual network card inside subnet. When we make interface endpoint, AWS create ENI in subnet with private IP address and through that address traffic is going to AWS service, receive traffic and forward to service, everything is inside AWS 
- Flow:
1. Create VPC and private subnet
2. Create Gateway Endpoint(for S3)
3. Create public subnet and bastion instance in that subnet
4. Create private instance
5. Create IAM role for that instance
6. Test some bucket from instance in private subnet

### Commands
- None, console-based task

## Tuesday - 24.6.2026

**Topic:** VPC Flow Logs

### What I learned 
- Flow logs record network traffic that get in and out from VPC, subnet or ENI. Every package that go into VPC is recorded. 
- Thats very important for troubleshooting, because if client says i cannot access to server, you open flow logs and see what is problem, does traffic arrive to instance and is he accepted or rejected. So you know where is problem, in SG, NACL or somewhere else. 
- Second example is security, you see some unusual traffic, IP addresses that try connect on ports you didn't open, scanning. 
- Flow Logs are first thing then you turn on for client. 
- We need to know few things to properly read logs: srcaddr(where traffic coming from, thats after ENI place in log), dstaddr(where is traffic going, thats after srcaddr in log), dstport(which port) and on the end is traffic accepted or rejected
- We watch source ip what is in log, if source is my thats okay if is my ip destination ip then thats problem
- In cloudwatch logs we store logs for real-time monitoring and alerting, in S3 we store for long-term and analyze with Athena database

### Commands
- None, console-based task

## Wednesday - 24.6.2026

**Topic:** Troubleshooting scenarios

### What I learned
- If instance cannot ping 8.8.8.8 on example, we watch: for first does vpc has igw attached, then route tables(does it have 0.0.0.0/0 IGW rule), then NACL(does it block icmp outbound or inbound) and then security group(does it have icmp allow rule)
- If private EC2 cannot access to RDS in isolated subnet, we watch: are they in same subnet, route table(local route is automatic, but we can check), security groups on RDS(does it has 3306 port on source sg-ec2), security groups on ec2(does it has outbound for port 3306), and NACL(does it block traffic on subnet)
- If ALB has 502 Bad Gateway that means ALB receive request but doesn't get response from EC2. For that we check: target group health check(is ec2 healthy), security group on EC2(port 80 from ALB), web server on EC2(does it work, nginx or apache), NACL(does it block traffic)
- We first check network before instance, first igw and route tables and nacl, sg on the end
- Gateway Endpoint modify route table automatic(destination is that service you want use), interface endpoint create ENI

### Commands
- None, console-based task

## Thursday+Friday - 24.6.2026

**Topic:** Site-to-site vpn + Direct Connect + SAA-C03 questions

### What I learned
- When company want to use their resource privately then they can move resources in cloud by site-to-site vpn or direct connect
- Site-to-site vpn is public moving, from internet and thats encrypted, thats lower cost and so much faster then direct connect, for smaller data packages 
- Direct Connect is physical connection, for big data packages, weeks and months you need to move data
- For site-to-site vpn on aws side you have vgw(virtual private gateway), that attach on vpc, on customer side we have customer gateway, on-premises router in AWS console, we give him public ip from physical router
- Flow logs just record network traffic on server in vpc, source ip, destination ip, port, protocol, accept or reject.

### Commands
- None, console-based task

## Saturday - 25.6.2026

**Topic:** LAB - Three-tier architecture + VPC Endpoints for S3 + VPC Flow logs

### Structure desing
1. Create VPC
2. Create 5 subnets (2 public for ALB, 1 private for EC2, 2 isolated for RDS)
3. Create internet gateway
4. Create route table and give rule 0.0.0.0/0 IGW + add public subnets to associations
5. Turn on and create VPC flow logs with log storing into CloudWatch Logs
6. Create 3 sg (one for ALB, one for EC2, one for RDS)
7. Create Bastion instance
8. Create EC2 private instance and allow in inbound rules SSH from SG from bastion instance
9. Create Target group with private instance for ALB
10. Create ALB
11. Create DB subnet group for RDS
12. Create RDS
13. Create NAT gateway for private EC2
14. Test connection between EC2 and RDS
15. Create VPC Gateway Endpoint for S3
16. Give IAM role for Instance in private subnet to use S3
17. Test S3 in EC2 private

### Decisions and reasons
- We create VPC to use resources and services privacy, in our network. Subnets are parts of that network, linked for availability zone, in this example we have 2 public for ALB because ALB need to be high available, private subnet is for private server without internet route, 2 isolated subnets are because RDS need to be high available
- SG are for resources inside VPC, we create them first to secure them and their communication properly, ALB communicate with users and need http on port 80 from 0.0.0.0/0 sg, ec2 is private and communicate with alb and need http port 80 from SGALB destination, and RDS need 3306 MYSQL traffic from EC2SG
- Bastion instance we create to connect on our private instance, because private instance doesn't have public ip address, have private, we give to private instance inbound rule ssh from bastion security group and direct ssh from bastion to private instance
- Target group we create before because in process of creating ALB we have step target group, instance that is linked to that alb and alb do health checks to that instance
- ALB is frontend layer, receive traffic from users and forward to EC2 private instance
- DB subnet group is subnet group for RDS, we choose subnets and vpc there, our 2 isolated subnets
- RDS is our database
- NAT gateway needed to create because my private instance had to download mariadb105 package, to use MySQL -h RDS_ENDPOINT -u admin -p command for connecting on RDS
- Connection between EC2 and RDS we try to see does our architecture works, if we connect with RDS then it works properly
- VPC flow logs is to monitor network traffic, to see who is trying to login our private instance, from what port and is that rejected or accepted
- Endpoint we create to use AWS resources(in this example S3) privately, by Gateway endpoint thats free and doesn't go through NAT gateway, private full
- IAM role we create and attach on private instance to give instance permission to use S3, in this example i gave full access, to do what i want on S3 service
- Tested S3 and everywhere before and all works!

### Implementation
1. Created VPC
2. Created 5 subnets (2 public for ALB, 1 private for EC2, 2 isolated for RDS)
3. Created internet gateway
4. Created route table and gave rule 0.0.0.0/0 IGW + add public subnets to associations
5. Turned on and created VPC flow logs with log storing into CloudWatch Logs
6. Created 3 sg (one for ALB, one for EC2, one for RDS)
7. Created Bastion instance
8. Created EC2 private instance and allowed in inbound rules SSH from SG from bastion instance
9. Created Target group with private instance for ALB
10. Created ALB
11. Created DB subnet group for RDS
12. Created RDS
13. Created NAT gateway for private EC2
14. Tested connection between EC2 and RDS
15. Created VPC Gateway Endpoint for S3
16. Gave IAM role for Instance in private subnet to use S3
17. Tested S3 in EC2 private
