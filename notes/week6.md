# Week 6 - VPC(Virtual Private Cloud)

## Monday + Tuesday - 19.6.2026

**Topic:** Custom VPC creating with public and private subnet + link VPC with internet and ping test on EC2

### What I learned
- When we crate VPC we create private network in cloud, like we rent some space in data center and makes changes and set it. 
- VPC is important because its private, if it wasn't be then everybody could use your data and connect to your instance
- Every VPC has CIDR block - range of IP addresses that you can use inside that network. Example 10.0.0.0/16
- IP address has 32 bits(every number is 8 bits)
- /16 means prefix length - how much bits are locked like piece of network, others are addresses for hosts. Smaller number after / means more addresses. 
- By subnets AWS reserves 5 ip addresses, so subnets with 256 addresses for you is available 251
- When we create subnet we cut part of that VPC CIDR block. 
- Subnets are linked for AZ, same AZ of course
- Internet gateway is AWS resource that is attaching on VPC and enable communication between VPC and internet. He is highly available and scalable automatic!
- Route table is table with rules that says to network traffic where to go
- Every subnet must be linked with route table, by default AWS create one main route table for every VPC with just one rule: traffic inside VPC stays local 
- To be public, subnet need to have in route table this rule: 0.0.0.0/0(traffic that is not local forward on internet), not local means traffic that is not in your CIDR, igw is 0.0.0.0/0
- Flow for VPC creating and public exposing:
- ICMP is protocol for ping
- 8.8.8.8 is google dns, when ping on that dns work then connection on internet work
1. Define VPC and give him CIDR block
2. Create public and private subnet
3. Create IGW
4. Attach IGW to VPC
5. Create Route Table
6. Give rule to Route table(0.0.0.0/0)
7. Associate table with Public subnet
8. Test with EC2(ping 8.8.8.8 testing for connection)

### Commands
- none, console-based task

## Wednesday 19.6.2026

**Topic:** Private subnet - access to the internet

### What I learned
- NAT Gateway is linking private subnet to the internet, he is in public subnet placed, because he need to have access to the internet, need 0.0.0.0/0 rule, IGW
- He can go to the internet but nobody can connect to the subnet, because some services need privacy and nobody can access to them, they just can go to the internet for some updates or smth
- NAT Gateway has elastic IP(static ip, always same)
- Private instance mustn't have public ip
- Bastion host - connect to private instance from public instance(from ec2 in public subnet to ec2 in private subnet), first we move ssh key to our public ec2 and direct from public ec2 connect to private 
- SG on private instance, we must have as source ip from bastion host
- For NAT Gateway so important is that he has elastic ip, thats because if he would have classic ip then firewall would block every time when ip changes, if we use firewall that allows just specific ip adresses
### Commands
- none, console-based task

## Thursday - 21.6.2026

**Topic:** NACL vs Security Groups

### What I learned
- NACL is firewall for subnet and security group is firewall for instance
- NACL has allow and deny rules, security group has just allow rules
- NACL is stateless, if you allow inbound you must allow and outbound too, thats not as default(outbound example for ephemeral ports, random client port for some connection)
- Security group is stateful, if you allow inbound traffic outbound is by default
- We have defense in depth - if one line of security fails second is here, more lines we have 
- In NACL we must watch what rule is first, first is what we watch, if first rule says allow then traffic is allowed, in security group we dont watch whats first or not
- To allow ephemeral ports on NACL outbound traffic is important because without it server cannot response to client

### Commands
- None, console-based task

## Friday - 21.6.2026

**Topic:** VPC Peering and Transit Gateway

### What I learned
- First example where we use vpc peering is cross account peering(connect vpcs from 2 accounts), second important example is when we have in one account one vpc for prod one for dev, 2 on one account, and one need resources from second
- VPC peering doesn't have transit routing, if vpc A and vpc B are connected and vpc B and vpc C then A and C are not by default, that so important to know
- One most important thing is that 2 vpcs to peering need to have different CIDR, first 2 numbers in IP, because if CIDR is same then AWS doesn't know whats destionation of one whats of second
- Transit gateway is central hub inside all vpcs are communicating, every vpc just connect on transit gateway and for example 10 vpcs we have 10 connections for that and transit gateway is complex and he is for big number of vpcs
- When we create peering we need to accept it in actions, after accept need to create routes with route table for vpc A to allow Peering Connection as target to destionation vpc B and same for vpc B, with route tables u say to them for x vpc go to peering connection target
- Transit gateways we use when we have 4+ vpcs, he is work on-premises too
- 

### Commands
- None, console-based task

## Saturday - 21.6.2026

**Topic:** LAB: Three-tier Architecture - public ALB, private EC2, isolated RDS in separated subnets

### Structure design 
1. Create VPC
2. Create 5 subnets(two public for ALB, one private for EC2, two private for RDS)
3. One subnet make public with 0.0.0.0/0 rule in route table- Internet gateway
4. Create security groups(3 sg, for every resource to communicate)
5. Create EC2 in private subnet
6. Create Aplication Load Balancer
7. Create RDS
8. Create NAT gateway for private EC2 
9. Install MySQL on private EC2
10. Test connections between EC2 and RDS 
11. Test does ALB and receive traffic

### Desicion and reasons 
- For first i created VPC to work private in my private network, thats best practice for resources
- 5 subnets are because ALB and RDS need to be high available, to have two or more availability zones, if one crash then second is there
- Security groups are before resources because we need to secure our resources and define their relations, ALB is communicating with clients, EC2 is communicating with ALB and RDS is communicating with EC2, as source we dont use IP we use SG from resource, better for security, SG is linked to resource but ip can change
- NAT gateway for private instance we create because NAT gateway allow subnet to go on internet, in this example we needed that way to install MYSQL package
- With MYSQL -h rds-endpoint -u admin -p we connect from private EC2 to our RDS, if that is successful our three-tier architecture works
- To connect to our EC2 private instance we need to use bastion, public instance and from public directly connect to private, because private instance has just private ip cannot connect by public

### Mistakes
- Subnets CIDR, i took 10.0.0.0/16 for subnets, but thats CIDR for vpc, for subnet is /24

### Implementation
1. Created VPC
2. Created 5 subnets(2 public for ALB, 1 private for EC2 private, 2 private for RDS)
3. Created Internet Gateway
4. Linked Internet Gateway to VPC
5. Created Route Table for public subnets with 0.0.0.0/0 - Internet Gateway
6. Created 3 security groups (every is for connection between resources, one for ALB, one for EC2 private and one for RDS)
7. Created 2 instances, bastion and EC2 private
8. Created target group for ALB with EC2 private
9. Created ALB
10. Created DBSG for RDS with 2 private subnets
11. Created RDS 
12. Connected to bastion EC2
13. Allowed in EC2 private security group ssh with sg from bastion
14. Connected to EC2 private from bastion
15. Created NAT gateway for EC2 private
16. Installed mariadb105 package on EC2 private
17. Connected to RDS from EC2 private
18. Checked connection with ALB DNS on browser
