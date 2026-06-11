# Week 1 - Linux Fundamentals

TUESDAY+WEDNESDAY PARTS: Create Amazon EC2, SSH and file system navigate:
Steps:
1. Create EC2 instance
2. Copy ssh private key from windows to Linux (WSL)
3. give 600 permissions to private key
4. SSH to instance
5. See where are system logs(var)
6. See how much space on disk
7. See what process are active

Practice steps week 1:
1. Create user with sudo useradd(sudo for privileges)
2. Create group with sudo groupadd (sudo for privileges)
3. Add user in group with sudo usermod -aG 
4. Check where is user with groups
5. Create directory with mkdir
6. Create file with touch 
7. Change file owner with chown
8. Check file owner with ls -la
9. Create bash script with variable and echo in vim editor
10. Give execute permission with chmod +x to script
11. Start script with ./



Lessons:
While creating EC2 change Linux 2 OS because its optimized for AWS servers
Every Linux AMI on AWS has default username, for Amazon Linux 2 is that same everytime and thats ec2-user
Must watch where is file, if is he on windows move to Linux
lastlog- command to see last logs
df- how much space on full disk, entire
df -h- human readable
ps aux- to see what process are active and when write it i get important columns(user-who started process, PID-id process and important so much because when i want to kill process i write kill <PID>, %CPU, %MEM-memory,COMMAND-what command or program is get activated)
du- how much space folders or files take on disk in KB



Thursday+Friday:chmod, chown, users and group on EC2 + creating and removing files and directories, Nano/VIM introduction + write first bash script(hello world + echo variables)

Steps:




Lessons: In chmod command you have user, group and other users(644- 6 is user, 4 group  and 4 others, 4+2+1= read,write,execute)
ls -la-detail of folder inside
-rw-r--r-- - first - is type of file, rw-(has read and write but not execute),group r--(just read),other users r--(just read)
chown- change file owner
Apache is web server software that give web pages, when install apache he automate create his user apache and work on that user(apache is name of user)
useradd- create user on instance
Permission denied means you dont have enough privilege to do smth
on Linux just root have privileges to create users and change owners of file
sudo- do command with root privileges
/etc/passwd- Linux there store informations about all users, username:x:UID:GID:description:home_dir:shell- that schema and most important is to see what shell are they using
groupadd- to create group on server
usermod -aG- to add some user in group, created user
groups testuser- to see in where all groups user(testuser is example here) is
vim is text editor which work in terminal, no mouse, everything is doing with keyboard. only way to edit files direct on server, because not graphic interface
:q! + enter- is to exit vim without recording but for normal exit without changes is :q
vim filename- open file with vim to edit, like nano, but vim is more in use
to write text in vim you must use insert mode(click I)
esc is quiting insert mode
:wq- save text in vim and quit
./- to execute script, first must add +x permission for execute

