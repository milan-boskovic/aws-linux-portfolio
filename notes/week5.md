# Week 5 - AWS IAM Advanced (Identity and Access management)

## Monday - 14.6.2026

**Topic:** IAM policy simulator

### What I learned
- IAM simulator is AWS tool that allows you to test what some policy allow or deny, before you execute it in production. Main thing is to test it before production, you can test aws managed policy too not just custom. 
- In real life we can use policy simulator to test some policy does it requires all staff that i need, does it allow or deny what i need in task and one important use case is when we have combined policies on user(one for group on directly attached) and we are not sure what is end result. Simulator says to us what policy gave us allow/deny, not just result.
- We get into policy simulator inside IAM dashboard on right side
- Flow is to select user, select service, select action and then run simulation after we get output is that action allowed or denied
- My policy denied GetObject on S3 because policy has that option but just one specific bucket, policy simulator by default do not specific any resource, takes all *
- We need to add specific resource if wanna test specific resource, by default simulator takes all resources
- Implicit deny is when action is not mentioned in policy, aws by default deny it 
- Explicit deny is when policy active says "effect":"Deny" for that action
- We need to know this differences between implicit and explicit deny to know if policy says one of this two what to find and remove or add allow

### Commands
- None, console-based task


## Tuesday - 14.6.2026

**Topic:** IAM Conditions

### What I learned
- IAM Condition is option block that adds condtition for which permission. Not enough just to have action allow, and condition must be satisfied
- Under resource we have condition line with : { and under it Bool line with { and condition under it with : "statement"
- Privilege escalation - attacker use IAM perimissions to give him higher level of access
- Much important to have MFA condition in policy is against attackers because if they take access keys and get CLI/API access they cannot do anything without MFA token, my device with mfa token
- Condition for MFA is "aws:MultiFactorAuthPresent"
- We must follow in policy how much we opened with { and have closed that number too


### Commands  
- None, console-based task

## Wednesday - 15.6.2026

**Topic:** Cross-account access

### What I learned
- Best practice for some company example A to use some bucket in company B is to get cross-account role, because if company B makes access keys and create IAM user you will not know if that access keys are exposed, maybe company wont give you noftication about that on right time + with cross-account role you have control, you can delete trust policy when you want and other company wont have access
- Cross-account role - gives temporary credentials, you have full control and audit trail(CloudTrail follows who assumed role)
- External ID is added security condition in trust policy, company A says to B company: "Trust to company B but just if while assuming role sends right External ID(thats hidden string that company made deal with)". Saves you from "confused deputy" problem
- Confused deputy is when some company(attacker) takes false identity, try to login with ARN from his account, doesn't have access but know ARN and from that external ID saves us, he doesn't know hidden string
- sts:AssumeRole role in policy means allow this this principal to request temporary credentials for this role from STS service, STS generate temporary access key, secret key and session token
- to assume role from CLI we need to know ARN, command is aws sts assume-role --role-arn "ARN" --role-session-name "session_name" --external-id "external id" --profile profile_name
- IAM-user must have permissions to sts assume role
- In error we see ID from user that is denied 
- Goal is to get temporary credentials for cross-account role and if someone get credentials they expire in some time so we are secure





### Commands
- None, console-based task


## Thursday - 16.6.2026

**Topic:** Managing IAM from CLI

### What I learned
- Flow for deleting resources in CLI IAM tasks:
- first remove user from group, then detach group policy, then delete group and on the end delete user
- flow is important because AWS dont allow you to delete user or group while they have active relations
- Scripting is based on CLI - you can write bash script that creates 50 users with same policies, what is not possible from console fast

### Commands
- aws configure - to configure default account on CLI
- aws iam create-user --user-name usernname_name - to create user
- aws iam create-group --group-name group_name - to create group
- aws iam attach-group-policy --group-name group_name --policy-arn policy_arn
- aws iam list-attached-group-policies --group-name group_name
- aws iam add-user-to-group --user-name user_name --group-name group_name
- aws iam get-group --group-name group_name
- aws iam list-users/group - to see users or groups

## Friday - 16.6.2026

**Topic:** IAM Credential Report + Security Best Practices review

### What I learned
- Credential Report is CSV report that AWS generates on request, with data of all IAM users on account: when is password last time used/changed, is MFA active, when are access keys created and last time used, are access keys active. 
- This tool we use as consultant, first step of every "IAM Security Audit", you dont click manual in console just get informations in table together
- First question we make when watch credentials is does this user needs to be created and why we created him?
- leftover test user needed to be find and flagged for remove
- access keys without mfa is problem because they can be exposed and then somebody can login in cli, when u have mfa nobody can use your account without mfa token 
- when access keys are not rotated a lot time(recommended rotate is on 90 days), thats case for audit and need to rotate
- best practice to watch credential report is : mfa, access keys activity, key age, password use
### Commands
- aws generate-credential-report - to generate credential report
- aws get-credential report(to download generated report, AWS give Base64-encoded) --query 'Content' --output text(from full JSON answer, return just line Content, that have Base64 string, and write it as clean text) | base64 -d(to decode base64) > credential-report.csv(save that decoded content in credential-report.csv file)

## Saturday - 16.6.2026

**Topic:** LAB - IAM Security Audit Report (real account)

### Process
- Generated IAM Credential Report via CLI (generate-credential-report + get-credential-report)
- Opened in LibreOffice Calc, used AutoFilter on mfa_active and access_key_1_last_rotated columns

### Findings
- iam-practice-user - doesn't have mfa active. Thats big problem because that account can be easy attacked when dont have MFA token, they can get access keys and use CLI without MFA barrier
- Milan-test - doesn't have mfa active, password last used 05.03.2026. For MFA same as iam-practice-user. From password we see that user is not active, thats leftover test user
- Milan - access keys last rotated 30.07.2025. Thats problem because access keys need to be rotated every 90 days for better security

### Recommendations
- iam-practice-user: Activate MFA device. If keys cannot be MFA-protected directly (CLI-only access), enforce MFA via Condition policy for sensitive actions.
- MilanTest: Delete this user to reduce unnecessary attack surface, since it's no longer in active use.
- Milan: Rotate access keys immediately and establish a recurring 90-day rotation schedule going forward.

### Report
- Documented findings as formal Security Audit Report, pushed to GitHub as week5.md
