# Week 4 - AWS IAM (Identity and Access Manager)

## Monday - 12.6.2026

**Topic:** IAM Introduction - users, groups, policies

### What i learned
- attach policy directly is not best practice for production, because thats not scaling when you have on example 50 users
- always add permissions over group, not direct to user
- when we do action with some user we need to type --profile profile_name, for Linux to know which user is doing action, but without --profile by default is default user to do actions
- deny wins allow in policy always, if don't have deny then policy is allowed

### Commands
- wsl -u root is to access root from windows CLI to WSL
- aws configure --profile name_profile - for configure profile
- aws s3 ls - list buckets from all account, not what is owned buy one user
- aws s3 cp file_name s3://bucket-name - to upload file in bucket

## Tuesday - 12.6.2026

**Topic:** IAM Roles - for EC2, Lambda and services

### What I learned
- user has hardcoded credentials(access keys)
- IAM role is set of permissions that something or somebody(service, example EC2 instance) takes temporary, after some time they are rotating, automatic changes for some time, don't need acces keys. Role has 2 parts: trust policy(who is assuming role) and permission policy(what role allow when assume) and session after assuming role is temporary session




### Commands

## Wednesday - 12.6.2026

**Topic:** IAM policy JSON - understanding sintax + custom policy that allow read just to targeted bucket

### What I learned
- IAM policy is JSON document with standard structure
- when in policy we have ListBucket thats just for bucket not for objects in him to do smth
- operation that executing on bucket just takes arn bucket name, but on objects takes bucket name + / and object name
### Commands
- GetObject- to read/download, you can just take it and read without actions and action is executing on object as resource directly, we type name bucket and afet / with objects
- ListBucket - to see just whats in bucket but cant do action, he is executing on bucket as resource and we type just bucket name, not object afet with /
- sintax always start with s3: and all is in "", thats for action and after action and " we have , 
- for resource syntax is "arn:aws:s3:::bucket_name or in second way bucket_name/object_name 
- we have , afet all and on the end } ] } and between statement we have }, {

## Thursday - 12.6.2026

**Topic:** MFA setup, password policy, account alias + AWS Organizations and SCPS- review

### What I learned 
- Alias is important for iam-users because easier is to write alias 
- To change password every 90 days is not good, thats bad to often make changes with password, because if you do it there is big chance that you will take some easier password, just change when its needed, better is strong password + MFA + change when need
- password policy is managing in account settings
- AWS organizations is service that allow to manage with more accounts from one central place(example root account or management). Thats good when we had separated accounts, one for dev one for prod example, all are in one "company"
- SCP(service control policy) is policy that is using on one organization or OU(Ogranizational Unit) inside organization. SCP is top threshold(guardrail) that IAM policy can allow - and admin too cannot vs SCP, SCP>IAM policy, if SCP deny something thats denied, policy cannot do anything

## Friday - 13.6.2026
**Topic:** IAM Access Analyzer + Least privilege principle 

### What I learned
- IAM Access Analyzer is service that follow when some service has much permissions, more then needed, does  some service have access across more accounts, public example, who can access that resource, external access that primary, resource that has example more permissions then needed and somebody can access him out of account
- Least privilege principle is one of the most important things in AWS, give somebody permissions that he really needs, not more, better is to give one mor permission if needed then give more permissions on start and make problems

### Commands
- None, console-based task

## Saturday - 13.6.2026

**Topic:** LAB - IAM scheme for fictional company (Admins, Dev, Read-Only)

### Structure desing
- Group: Admins - AdministratorAccess policy
- Group: Dev - AmazonEC2FullAccess and AmazonS3FullAccess policies
- Group: Read-Only - ViewOnlyAccess

### Desicions and Reasons
- Group Admins have AdministratorAccess policy because that group need to have access to all resources and services
- Group Dev have AmazonEC2FullAccess and AmazonS3FullAccess policies because they need to work with EC2 and S3(debug,deploy) so they need full access, but important thing is that in task line of text that say no IAM/Billing, i didn't block it in policy because IAM policy is implicit deny(all is denied if thats not explicit allowed), so we didn't have anything to block because didn't give permissions
- Group Read-Only have ViewAccessOnly policy because they need to read all services and resources
- Ran Access Analyzer (external access) after implementation - no findings related to the new groups/policies
- Found one pre-existing finding: [bucket-name] has public access - intentional, from earlier CLF-C02 static website hosting exercise

### Implementation
1. Created Admin group with AdministratorAccess policy
2. Created Dev group with AmazonEC2FullAccess and AmazonS3FullAccess policies
3. Created Read-Only group with ViewOnlyAccess policy






