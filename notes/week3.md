# Week 3 - Linux Advanced + Security Hardening

Monday: SSH key-based auth, disable root login + Firewall introduction-iptables/firewalld
disable root login is important because he has unlimited privileges, if bot or somebody get access its big problem
ssh configuration is in file /etc/ssh/sshd_config
prohibit-password means root login is allowed but just with SSH key, not password
PermitRootLogin is line where we see how login, for best security practice is to be no(denied, no pass no ssh key), to disable root login for permissions
to access differences u make you must restart service
# in lines means comment, when line has that that means line is ignoring, must delete #
firewalld- service that manage firewall permissions 
firewall-cmd- command for manage firewall
dhcpv6-client- service for getting ip-address automate for network router
mdns- service for finding service on local network
firewall-cmd --add-service=http --permanent- for add http on server
firewall-cmd --reload- for reload
firewalld know when u add service for what port is that, you must add port to expose in ports --add-port=80 example, but thats for ports that are not often!
AWS security groups control traffic that can go in server, aws control it before traffic comes to server, but firewalld is inside server- control traffic inside server, Linux control it when traffic is INSIDE server, for server to work you must set BOTH, cant one block and one not then server wont work

TUESDAY: Environment variables, .bashrc, bash_profile + symlinks, hard links, mount points
Environment variables are special variables that Linux saves and they are accessible for all programs and scripts on system (example is environment variable $PATH- says to Linux where to find commands that you type)
env- command to see environment variables on system
bash see when u type example $HOME, change it in command and then give output, thats environment variable
.bashrc is starting everytime when you open new terminal, list of settings that loading automatic. There you add environment variables and alias-es
.bash_profile- start just when you login(SSH)
to add variable in .bashrc: export name_variable="value"
.bash_profile start .bashrc!!!
source ~/ is executing files in terminal that terminal where you are, like you manual start commands from .bashrc, because .bashrc is starting when u open new terminal but with that you start it for now
for environment variables Linux takes that value you added for $ and then for all script and program its available in that terminal
symlink is shortcut, like shortcut on windows, you dont type full path you make symlink for file, but symlink is just pointer in NAME, guide Linux to original path dont make copy of file so if you delete file then symlink doesn't work
syntax for symlink is ln -s original_file name_symlink
lrwxrwxrwx. 1 ec2-user ec2-user    5 Jun  7 13:38 s3.ss -> s3.sh - l on start means thats symlink made
hard link is direct copy of file, if you delete original file u have copy
syntax for hard link: ln original_file name hardlink_name (same as symlink but without -s)
-rwxr-xr-x. 2 ec2-user ec2-user    86 Jun  4 21:17 s3.hl- number 2 means that 2 files has same name
mount point is place where you mount disk or storage on Linux file systems, like USB on windows: appear new disk,on Linux thats not letters (E,D,..), disk is mounting on folder /mnt/my_disk, catch it on path
when you get new ebs on EC2 , he appears like /dev/xvdb, but he is not mounted, to use him you must mount on folder(mnt)

Wednesday: disk usage: df, du, lsblk-monitoring space + add EBS and mount on EC2 instance

lessons: 
lsblk(list block devices)- shows all disk and partitions on system. Partition is part of disk, like more mini disks.
to create disk and mount on EC2 instance must on console or AWS CLI, after mounting on scene is going Linux(formatting,using,..)
for formatting disk: mkfs(make file system, makes filesystem on disk).ext4(.ext4 is type of file system, standard for Linux, like NTFS for windows) /dev/xvdb(path for disk that we are formatting)
without formatting new disk is like empty USB, you can't write on him while format it
we need to know on which folder will we mount that new disk, we are creating new folder always for mounting disk because if u mount him on folder with files then you cant use that files while disk is mounted, so you create new folder and always inside/mnt, because thats recommended, you can mount where you want but thats always in /mnt
mount- command for mounting disks
you are using sudo when make changes on system, like installation, creating files out of home directory, mounting disks, edit system files, manage services(in head does this command changes something OUT OF home directory or makes changes on system)
we are writing in that folder that we mounted our disk, not direct on disk because  on block device Linux dont know how to organize file, so thats why we make filesystem
lost+found is system folder that Linux created when formatted with mkfs.ext4. Its for recovery if system crash or disk has problem
umount-for unmount disk
Linux is not saving mounted disk after reseting ssh or instance, umount automatic

=== Thursday - 8.6.2026 ===
Topic: Bash script for system monitoring 
What I learned:
free -h and top -bn1 are commands that shows you memory and CPU, they are executing one time and get out
id line in CPU is for % CPU that is free, if id is <20 then CPU is overloaded
when you write scripts there are some important things:
when you want just to show something one time, then use ECHO
when you want to repeat something, have more actions, then use FOR loop
when you have some condition, then you IF, when action depends on value
loop + condition is when we have more things and have to choose for every
hardcoded means when u manual type some variable on example and that number in variable is always same, never change
'{}' is must for awk, but just that cannot () or smth else
Commands:
free -h - to see memory
top -bn1 | grep "Cpu" - to see Cpu 
awk- takes some column
-gt - means greater than
tr -d "%"- to delete %(% is just example)
Mistakes I made:

Scripts:
for executing script must give +x permission with chmod command!!
monitoring.sh- script that for system monitoring, CPU, Memory and Disk, used commands top -bn1 | grep "Cpu" for CPU, free -h for Memory, df -h for Disk
disk_alert.sh - script that checks does disk is > 80%
df -h | grep "/$" - filtrate just root disk (/)
df -h | grep "/$" | awk '{print $5}' - take just 5th column (use%)
tr -d "%" - removes % to check just number
DISK=$(command) - dynamic variable, takes value every time, not hardcoded
-gt - means greater than, if number is gt 80
cron: 
0 * * * * - every hour start script, and u need full PATH like always, thats must!

=== Friday - 9.6.2026 ===
Topic: tmux introduction, work with sessions + set swap space on EC2

What i learned: 
tmux is terminal multiplexer: he give you access to more terminals into one SSH session. That session is active and when you disconnect, if you lose SSH connection tmux is working in background. When you connect again then just take action where you were.
you must install tmux first.
we see in green line status bar when open tmux
when we create swap file(fake RAM for part of disk when need to not crash), we need to give him permissions for security(600, root), permissions are because thats RAM and must be safe, format that file(mkswap) and activate swap(swapon)




Commands:
tmux- command for terminal multiplexer
ctrl + b - base for Linux commands, first that and then letter
ctrl + b + number(1,2) - is to change screen, with * in  green line u see what screen you are using
ctrl + b + c - to get one more screen
ctrl + b + % - to see both screens
ctrl + b + x - to kill one screen(panel)
ctrl + b + d - to detach from session, you leave session but session is active in background
tmux attach - to get back after detach
tmux ls - to see active sessions
sudo dd if=/dev/zero of=/swapfile bs=128M count=8 - dd is for creating files some size, if is input file of is output file, bs is size of one block and count is how much is that repeating(in this example do it 8 times)

=== Saturday - 10.6.2026 ====

Topic: EC2 automated script

What I learned:
Nginx is software like Apache, server that receives HTTP request and return HTML page. He is modern and static faster then Apache.
Vim is interactive editor so user must write commands, for that when we write scripts we use sed command, stream editor that changes text without interaction, for automate changes
sed uses / as delimiter(separator), so we must use | in text because sed dont know what is part of text what is separator if we use /, so we must use | for part we change if we have PATH example for some file after, to guide him correctly

Commands:
sudo yum install -y - thats when for bash to not ask for conditions, when write in scripts, to automate do -y if ask bash
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config - -i is for change file directly, in '' are lines before and after, .* is to find line no matter what will be later, all variety are in with that 


Script:
EC2_automated.sh - script is automate doing:
install nginx with sudo yum install -y nginx - -y is for automate say yes if ask
create user with sudo useradd test_user
configure SSH with sudo sed -i 's|#PermitRootLogin.*|PermitRootLogin no|' /etc/ssh/sshd_config - here I made mistake, i used / first not | and then sed didn't know what to separate because command has file PATH, changed / with | and now works and we use sed command not vim because vim is interactive editor, need user to write
start nginx with systemctl start nginx

=== Sunday - 10.6.2026 ===

Topic: GitHub setup and portfolio

What I learned:
1. Create repo on GitHub
2. Create folder on local host and then get in folder
3. Write git init to start watch changes in that folder and follows
4. Create main branch
5. Rename this branch
6. Copy .pem on Linux folder(because when we log from desktop doesn't have enough permissions so we copy it and give permissions, ssh is standard Linux folder for SSH keys, there we store it)
7. copy files from EC2 instance to local machine with scp
8. configuration username and email
9. add files in folder
10. create commit(commit records state of files in git history, like snapshot)
11. move files to GitHub
12. get token in console on GitHub







Commands:
git init - watch changes and follows
git config --global init.defaultBranch main - git config changes git configuration, --global execute it on all repos on host, not just one, init.defaultBranch main - means whenever we do git init, default branch is main
git branch -m main - git branch manage with branches, -m renames, main is new name, we rename this branch where we are
rm - for remove files
git add - add files in folder


